# ExpenseTracker

A SwiftUI application for tracking expenses with categories and amounts. The primary goal of this application was to implement user input validation for amount without the need to create complex extensions, achieved using regular expressions directly in the ViewModel.

## Features

- Create, read, update, and delete expense tracks
- Real-time input validation with visual feedback (approved/error states)
- Amount input validation using locale-aware decimal separator without complex extensions
- Category-based organization (Personal, Hobby, Transport, Food, Insurance, Savings)
- Optional date tracking for each entry
- SwiftData persistence for local data storage
- Swipe actions for quick edit and delete operations
- Character limit enforcement (15 characters for title)
- Focus management for smooth keyboard interactions
- Form validation preventing invalid data submission
- Clean and modern UI with SwiftUI

## Architecture

The project demonstrates modern SwiftUI patterns and MVVM architecture with SwiftData persistence:

### Model

**Track** - SwiftData model representing a single expense entry
- Decorated with `@Model` macro for SwiftData persistence
- Properties: `title` (String), `amount` (Decimal), `category` (TrackCategory), `date` (Date?)
- Uses `Decimal` type for precise monetary calculations
- Includes optional date for flexible tracking

**TrackCategory** - Enum defining available categories
- Conforms to `String`, `Codable`, and `CaseIterable`
- Provides six predefined categories: Personal, Hobby, Transport, Food, Insurance, Savings
- Raw values provide human-readable display names

### ViewModel

**TrackViewModel** - Manages form state and input validation logic
- Uses `@Observable` macro for reactive UI updates
- `@MainActor` for thread-safe UI operations
- Input validation without complex extensions using regex patterns
- Real-time decimal input validation with locale-aware decimal separator
- Custom `decimalSeparator(newValue:oldValue:)` method using regex to validate amount format
- Supports locale-specific decimal separators (comma or dot)
- Pattern validation: `^\d+[separator]?\d?\d?$` for up to 2 decimal places
- Form validation methods checking title and amount validity
- `formattedAmount()` returns NumberFormatter for decimal parsing
- Title trimming for clean data storage
- Loading state management for pre-populating update form

### Views

**TrackMainView** - Main list view displaying all tracked entries
- Uses SwiftData's `@Query` for reactive data fetching
- NavigationStack for navigation structure
- List with custom styling and gray background
- Displays title, formatted amount (currency), date, and category
- Swipe actions: pencil icon for edit (trailing), trash for delete (leading)
- Toolbar with plus button to add new tracks
- Sheet presentation for track updates
- Real-time updates when data changes

**AddTrackView** - Form view for creating new tracks
- Form with sections for Title, Amount, Category, and Date
- TextField with character limit (15 chars) using Combine's `Just` publisher
- Real-time validation feedback in section footers (red error/green approved)
- Amount field with `.decimalPad` keyboard
- `onChange` modifier applying validation on each keystroke
- Category picker with menu style
- Optional date toggle with conditional DatePicker
- Focus management with `@FocusState` and custom `FocusField` enum
- Save button disabled until form is valid
- Dismisses automatically after successful save

**TrackUpdateView** - Form view for editing existing tracks
- Similar structure to AddTrackView with pre-populated data
- `onAppear` loads existing track data into ViewModel
- Special `isLoadingAmountValues` flag to prevent validation during initial load
- Updates existing Track model instead of creating new one
- Update button disabled until form is valid
- Dismisses after successful update

### Extensions

**NumberFormatter+Extensions** - Simple currency formatter
- Static computed property for currency formatting
- Used in list view to display amounts in currency format
- Minimal extension approach keeping formatting logic simple

### Helpers

**FocusField** - Enum for managing keyboard focus
- Two cases: `.string` (title field) and `.decimal` (amount field)
- Used with `@FocusState` for programmatic focus control
- Enables dismissing keyboard by tapping outside fields

## State Management

- `@Environment(\.modelContext)` for SwiftData context access
- `@Query` for reactive database queries
- `@State` for local view state (ViewModel instance, focus, sheet presentation)
- `@FocusState` for keyboard focus management
- `@Observable` macro for ViewModel reactivity
- SwiftData automatic persistence and change tracking

## Input Validation Approach

The application demonstrates clean input validation without complex extensions:

**Amount Validation** - Implemented directly in ViewModel using regex
- Locale-aware decimal separator detection using `Locale.current.decimalSeparator`
- Regex pattern dynamically constructed with escaped separator
- Validates format: digits + optional separator + up to 2 decimal places
- Real-time validation in `onChange` modifier
- Returns old value if new input is invalid (inline correction)
- No need for complex TextField or Binding extensions

**Title Validation** - Simple character count limiting
- Combine's `Just` publisher monitors character count
- Removes last character if exceeding limit
- Trimming whitespace for final validation

## Technologies

- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Apple's latest persistence framework with model macro
- **@Observable** - New observation system replacing ObservableObject
- **NavigationStack** - Modern navigation architecture
- **Form & Sections** - Structured input layout
- **Focus Management** - @FocusState for keyboard control
- **Swipe Actions** - Gesture-based edit/delete operations
- **Combine** - For reactive character count limiting (Just publisher)
- **Regular Expressions** - Locale-aware input validation
- **Decimal** - Precise decimal arithmetic for monetary values
- **Sheet Presentation** - Modal update view
- **Toolbar** - Navigation bar customization

## Requirements

- iOS 26.0+
- Xcode 26.0+
- Swift 6+
