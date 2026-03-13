import 'package:openpocket/backend/schema/conversation.dart';
import 'package:openpocket/backend/schema/memory.dart';

class MixpanelManager {
  static final MixpanelManager _instance = MixpanelManager._internal();

  static Future<void> init() async {}

  factory MixpanelManager() {
    return _instance;
  }

  MixpanelManager._internal();

  setPeopleValues() {}

  setUserProperty(String key, dynamic value) {}

  void optInTracking() {}

  void optOutTracking() {}

  void identify() {}

  void migrateUser(String newUid) {}

  void setNameAndEmail() {}

  void track(String eventName, {Map<String, dynamic>? properties}) {}

  void startTimingEvent(String eventName) {}

  Map<String, dynamic> _getTranscriptProperties(String transcript) => {};

  Map<String, dynamic> getConversationEventProperties(ServerConversation convo) => {};

  void onboardingDeviceConnected() {}
  void onboardingCompleted() {}
  void onboardingStepCompleted(String step) {}
  void onboardingUserAcquisitionSource(String source) {}

  void settingsSaved({
    bool hasGivenName = false,
    bool hasChangedLanguage = false,
    bool hasSetRecordingsStorage = false,
    bool hasWebhookConversationCreated = false,
    bool hasWebhookTranscriptReceived = false,
  }) {}

  void pageOpened(String name) {}

  void appEnabled(String appId) {}
  void appPurchaseStarted(String appId) {}
  void appPurchaseCompleted(String appId) {}
  void privateAppSubmitted(Map<String, dynamic> properties) {}
  void publicAppSubmitted(Map<String, dynamic> properties) {}
  void appDisabled(String appId) {}
  void appRated(String appId, double rating) {}

  void phoneMicRecordingStarted() {}
  void phoneMicRecordingStopped() {}
  void phoneCallPageOpened() {}
  void phoneCallVerificationStarted() {}
  void phoneCallVerificationCompleted() {}
  void phoneCallStarted({String? contactName}) {}
  void phoneCallConnected() {}
  void phoneCallEnded({required int durationSeconds}) {}
  void phoneCallFailed({String? error}) {}
  void phoneCallUpsellShown({required String source}) {}
  void phoneCallUpsellUpgradeTapped() {}
  void phoneCallUpsellDismissed() {}

  void appResultExpanded(ServerConversation conversation, String appId) {}

  void languageChanged(String language) {}
  void recordingLanguageChanged(String language) {}

  void calendarEnabled() {}
  void calendarDisabled() {}
  void calendarModePressed(String mode) {}
  void calendarTypeChanged(String type) {}
  void calendarSelected() {}

  void bottomNavigationTabClicked(String tab) {}

  void deviceConnected() {}
  void deviceDisconnected() {}

  void memoriesPageCategoryOpened(MemoryCategory category) {}
  void memoriesPageDeletedMemory(Memory memory) {}
  void memoriesPageEditedMemory() {}
  void memoriesPageCreateMemoryBtn() {}
  void memoriesPageCreatedMemory(MemoryCategory category) {}

  void memorySearched(String query, int resultsCount) {}
  void memorySearchCleared(int totalFactsCount) {}
  void memoryListItemClicked(Memory memory) {}
  void memoryVisibilityChanged(Memory memory, MemoryVisibility newVisibility) {}
  void memoriesAllVisibilityChanged(MemoryVisibility newVisibility, int count) {}
  void memoriesAllDeleted(int countBeforeDeletion) {}
  void memoriesFiltered(String filter) {}
  void memoriesManagementSheetOpened() {}

  void conversationCreated(ServerConversation conversation) {}
  void conversationListItemClicked(ServerConversation conversation, int idx) {}
  void conversationShareButtonClick(ServerConversation conversation) {}
  void conversationDeleted(ServerConversation conversation) {}

  void chatMessageSent({
    required String message,
    required bool includesFiles,
    required int numberOfFiles,
    required String chatTargetId,
    required bool isPersonaChat,
    required bool isVoiceInput,
  }) {}

  void chatVoiceInputUsed({required String chatTargetId, required bool isPersonaChat}) {}

  void speechProfileCapturePageClicked() {}

  void showDiscardedMemoriesToggled(bool showDiscarded) {}
  void conversationDisplaySettingsOpened() {}
  void showShortConversationsToggled(bool showShort) {}
  void showDiscardedConversationsToggled(bool showDiscarded) {}
  void shortConversationThresholdChanged(int thresholdSeconds) {}

  void conversationMergeSelectionModeEntered() {}
  void conversationMergeSelectionModeExited() {}
  void conversationSelectedForMerge(String conversationId, int totalSelected) {}
  void conversationMergeInitiated(List<String> conversationIds) {}
  void conversationMergeCompleted(String mergedConversationId, List<String> removedConversationIds) {}
  void conversationMergeFailed(List<String> conversationIds) {}

  void importantConversationNotificationReceived(String conversationId) {}
  void shareToContactsSheetOpened(String conversationId) {}
  void shareToContactsSelected(String conversationId, int contactCount) {}
  void shareToContactsSmsOpened(String conversationId, int contactCount) {}

  void chatMessageConversationClicked(ServerConversation conversation) {}
  void addManualConversationClicked() {}
  void manualConversationCreated(ServerConversation conversation) {}

  void setUserProperties(String whatDoYouDo, String whereDoYouPlanToUseYourFriend, String ageRange) {}

  void reProcessConversation(ServerConversation conversation) {}

  void developerModeEnabled() {}
  void developerModeDisabled() {}

  void userIDCopied() {}
  void exportMemories() {}
  void importMemories() {}
  void importedMemories() {}

  void supportContacted() {}

  void copiedConversationDetails(ServerConversation conversation, {String source = ''}) {}
  void checkedActionItem(ServerConversation conversation, int idx) {}
  void uncheckedActionItem(ServerConversation conversation, int idx) {}
  void deletedActionItem(ServerConversation conversation) {}

  void paywallOpened(String source) {}
  void upgradePlanSelected({required String plan, required String source}) {}
  void upgradeSucceeded() {}
  void upgradeCancelled() {}
  void upgradeModalDismissed() {}
  void upgradeModalClicked() {}

  void getFriendClicked() {}
  void connectFriendClicked() {}
  void disconnectFriendClicked() {}
  void batteryIndicatorClicked() {}

  void useWithoutDeviceOnboardingWelcome() {}
  void useWithoutDeviceOnboardingFindDevices() {}

  void addedPerson() {}
  void removedPerson() {}
  void tagSheetOpened() {}
  void taggedSegment(String assignType) {}
  void untaggedSegment() {}
  void editSegmentTextStarted() {}
  void editSegmentTextSaved() {}
  void editSegmentTextCancelled() {}

  void deleteAccountClicked() {}
  void deleteAccountConfirmed() {}
  void deleteAccountCancelled() {}
  void deleteUser() {}

  void appsFilterOpened() {}
  void appsFilterApplied() {}
  void appsCategoryFilter(String category, bool isSelected) {}
  void appsTypeFilter(String type, bool isSelected) {}
  void appsSortFilter(String sortBy, bool isSelected) {}
  void appsRatingFilter(String rating, bool isSelected) {}
  void appsCapabilityFilter(String capability, bool isSelected) {}
  void appsClearFilters() {}

  void personaProfileViewed({String? personaId, required String source}) {}
  void personaCreateStarted() {}
  void personaCreateImagePicked() {}
  void personaCreated({
    required String personaId,
    required bool isPublic,
    List<String>? connectedAccounts,
    bool? hasOmiConnection,
    bool? hasTwitterConnection,
  }) {}
  void personaCreateFailed({String? errorMessage}) {}
  void personaUpdateStarted({required String personaId}) {}
  void personaUpdateImagePicked({required String personaId}) {}
  void personaUpdated({
    required String personaId,
    List<String>? updatedFields,
    required bool isPublic,
    List<String>? connectedAccounts,
    bool? hasOmiConnection,
    bool? hasTwitterConnection,
  }) {}
  void personaUpdateFailed({required String personaId, String? errorMessage}) {}
  void personaPublicToggled({required String personaId, required bool isPublic}) {}
  void personaOmiConnectionToggled({required String personaId, required bool omiConnected}) {}
  void personaTwitterConnectionToggled({required String personaId, required bool twitterConnected}) {}
  void personaTwitterProfileFetched({required String twitterHandle, required bool fetchSuccessful}) {}
  void personaTwitterOwnershipVerified({
    String? personaId,
    required String twitterHandle,
    required bool verificationSuccessful,
  }) {}
  void personaShared({required String? personaId, required String? personaUsername}) {}
  void personaUsernameCheck({required String username, required bool isTaken}) {}
  void personaEnabled({required String personaId}) {}
  void personaEnableFailed({required String personaId, String? errorMessage}) {}

  void brainMapOpened() {}
  void brainMapNodeClicked(String nodeId, String label, String type) {}
  void brainMapShareClicked() {}
  void brainMapRebuilt() {}

  void summarizedAppSheetViewed({
    required String conversationId,
    String? currentSummarizedAppId,
  }) {}
  void summarizedAppSelected({
    required String conversationId,
    required String selectedAppId,
    String? previousAppId,
  }) {}
  void summarizedAppEnableAppsClicked({required String conversationId}) {}
  void summarizedAppCreateTemplateClicked({required String conversationId}) {}
  void quickTemplateCreated({
    required String conversationId,
    required String appName,
    required bool isPublic,
  }) {}

  void actionItemsPageOpened() {}
  void actionItemsViewToggled(bool isGroupedView) {}
  void actionItemToggledCompletionOnActionItemsPage({
    required String actionItemId,
    required bool completed,
    required String conversationId,
  }) {}
  void actionItemTappedForEditOnActionItemsPage({
    required String actionItemId,
    required String conversationId,
  }) {}
  void actionItemsDateFilterApplied(String filterType) {}
  void actionItemsDateFilterCleared() {}
  void actionItemTabChanged(String tabName) {}
  void actionItemCompleted({required String fromTab}) {}

  void trainingDataOptInSubmitted() {}
  void trainingDataOptInApproved() {}

  void recordingMuteToggled({required bool isMuted, required String recordingType}) {}

  void deletedConversationsFilterToggled(bool showDeleted) {}
  void calendarFilterApplied(DateTime selectedDate) {}
  void calendarFilterCleared() {}
  void searchBarFocused() {}
  void searchQueryEntered(String query, int resultsCount) {}
  void searchQueryCleared() {}

  void conversationOpenedFromSearch({
    required ServerConversation conversation,
    required String searchQuery,
    required int conversationIndexInResults,
  }) {}

  void liveTranscriptCardClicked({
    required bool hasSegments,
    required bool hasPhotos,
    required int segmentCount,
    required int photoCount,
  }) {}

  void deviceInfoButtonClicked({String? deviceId, String? deviceName, int? batteryLevel}) {}

  void conversationListItemClickedWithTimeDifference({
    required ServerConversation conversation,
    required int conversationIndex,
    required int hoursSinceConversation,
  }) {}

  void conversationSwipedToDelete(ServerConversation conversation) {}

  void conversationDetailTabChanged(String tabName) {}

  void speakerEdited({
    required String conversationId,
    required int oldSpeakerCount,
    required int newSpeakerCount,
  }) {}

  void conversationDetailSearchClicked({required String conversationId}) {}

  void conversationDetailSearchQueryEntered({
    required String conversationId,
    required String query,
    required int resultsCount,
    required String activeTab,
  }) {}

  void conversationReprocessedWithApp({
    required String conversationId,
    required String appId,
    required String appName,
  }) {}

  void conversationShared({
    required ServerConversation conversation,
    required String shareMethod,
  }) {}

  void conversationThreeDotsMenuOpened({required String conversationId}) {}

  void conversationThreeDotsMenuActionSelected({
    required String conversationId,
    required String action,
  }) {}

  void actionItemChecked({
    required String conversationId,
    required String actionItemDescription,
    required int index,
  }) {}

  void exportTasksBannerClicked() {}

  void taskIntegrationEnabled({
    required String appName,
    required bool success,
  }) {}

  void taskIntegrationAuthFailed({
    required String appName,
  }) {}

  void taskIntegrationSettingsOpened({
    required String appName,
  }) {}

  void transcriptionSourceSelected({
    required String source,
  }) {}

  void transcriptionProviderSelected({
    required String provider,
  }) {}

  void audioPlaybackStarted({
    required String conversationId,
    int? durationSeconds,
  }) {}

  void audioPlaybackPaused({
    required String conversationId,
    required int positionSeconds,
    int? durationSeconds,
  }) {}

  void audioPlaybackSeeked({
    required String conversationId,
    required int toPositionSeconds,
  }) {}

  void transcriptSegmentTapped({
    required String conversationId,
    required double segmentStartSeconds,
    required double seekPositionSeconds,
  }) {}

  void audioShareStarted({
    required String conversationId,
    required int audioFileCount,
  }) {}

  void audioShareCompleted({
    required String conversationId,
    required int audioFileCount,
    required bool wasCombined,
    required int durationSeconds,
  }) {}

  void audioShareFailed({
    required String conversationId,
    String? errorMessage,
  }) {}

  void audioShareCancelled({
    required String conversationId,
  }) {}

  void actionItemExported({
    required String integrationName,
    required String actionItemDescription,
    required String conversationId,
  }) {}

  void actionItemManuallyAdded({
    required String conversationId,
    required String description,
  }) {}

  void actionItemEdited({
    required String conversationId,
    required String actionItemId,
    required String oldDescription,
    required String newDescription,
  }) {}

  void settingsPageOpened({
    required String section,
  }) {}

  void usageTabChanged({
    required String tabName,
    required String source,
  }) {}

  void appsSearched({
    required String searchTerm,
    required int resultCount,
  }) {}

  void appsFilterMyApps({
    required bool enabled,
  }) {}

  void appsFilterInstalled({
    required bool enabled,
  }) {}

  void appsFilterRating({
    required int rating,
  }) {}

  void appsFilterCategory({
    required String category,
  }) {}

  void appsSortChanged({
    required String sortOption,
  }) {}

  void appsFilterCapability({
    required String capability,
  }) {}

  void appsCategoryPageOpened({
    required String category,
    required int appCount,
  }) {}

  void appDetailViewed({
    required String appId,
    required String appName,
    String? category,
    double? rating,
    int? installs,
    bool? isInstalled,
  }) {}

  void appDetailSectionViewed({
    required String appId,
    required String section,
  }) {}

  void appDetailShared({
    required String appId,
    required String appName,
  }) {}

  void appDetailReviewsOpened({
    required String appId,
    required int reviewCount,
  }) {}

  void appDetailReviewAdded({
    required String appId,
    required int rating,
    required bool hasComment,
  }) {}

  void appDetailSettingsOpened({
    required String appId,
  }) {}

  void appDetailSubscribeClicked({
    required String appId,
    required String appName,
    double? price,
  }) {}

  void appDetailSubscriptionCancelled({
    required String appId,
    required String appName,
  }) {}

  void appDetailPreviewImageViewed({
    required String appId,
    required int imageIndex,
  }) {}

  void appDetailChatClicked({
    required String appId,
    required String appName,
  }) {}

  void folderCreated({
    required String folderId,
    required String folderName,
    required String icon,
    required String color,
  }) {}

  void folderUpdated({
    required String folderId,
    required String folderName,
  }) {}

  void folderDeleted({
    required String folderId,
    required String folderName,
    required int conversationCount,
    String? moveToFolderId,
  }) {}

  void folderSelected({
    String? folderId,
    String? folderName,
  }) {}

  void folderContextMenuOpened({
    required String folderId,
    required String folderName,
  }) {}

  void createFolderButtonClicked() {}

  void conversationDetailFolderChipClicked({
    required String conversationId,
    String? currentFolderId,
  }) {}

  void conversationMovedToFolder({
    required String conversationId,
    String? fromFolderId,
    String? toFolderId,
    required String source,
  }) {}

  void conversationVisibilityChanged({
    required String conversationId,
    required String fromVisibility,
    required String toVisibility,
  }) {}

  void starredFilterToggled({
    required bool enabled,
    String? selectedFolderId,
  }) {}

  void conversationStarToggled({
    required ServerConversation conversation,
    required bool starred,
    required String source,
  }) {}

  void omiDoubleTap({
    required String feature,
    Map<String, dynamic>? additionalProperties,
  }) {}

  void wrappedPageOpened() {}
  void wrappedBannerClicked() {}
  void wrappedGenerationStarted() {}
  void wrappedGenerationCompleted({
    required int totalConversations,
    required int totalMinutes,
    required int daysActive,
  }) {}
  void wrappedGenerationFailed({String? error}) {}
  void wrappedCardViewed({
    required String cardName,
    required int cardIndex,
  }) {}
  void wrappedShareButtonClicked({
    required String cardName,
    required int cardIndex,
  }) {}
  void wrappedSharedSuccessfully({
    required String cardName,
    required int cardIndex,
    int? fileSizeBytes,
  }) {}
  void wrappedShareFailed({
    required String cardName,
    required int cardIndex,
    String? error,
  }) {}

  void dailySummarySettingsOpened() {}
  void dailySummaryToggled({required bool enabled}) {}
  void dailySummaryTimeChanged({required int hour}) {}
  void dailySummaryDetailViewed({
    required String summaryId,
    required String date,
    String? source,
  }) {}
  void dailySummaryTestGenerated({required String date}) {}
  void dailySummaryTestGenerationFailed({required String date, String? error}) {}

  void recapTabOpened() {}
  void recapSummaryCardClicked({
    required String summaryId,
    required String date,
    required int cardIndex,
  }) {}

  void dailySummaryNotificationReceived({
    required String summaryId,
    required String date,
  }) {}

  void dailySummaryNotificationOpened({
    required String summaryId,
    required String date,
  }) {}

  void dailySummaryConversationClicked({
    required String summaryId,
    required String conversationId,
    required String source,
  }) {}

  void dailySummarySectionViewed({
    required String summaryId,
    required String date,
    required String section,
  }) {}

  void announcementShown({
    required String announcementId,
    required String type,
    String? trigger,
    int? priority,
  }) {}

  void announcementDismissed({
    required String announcementId,
    required String type,
    required bool ctaClicked,
  }) {}

  void changelogShown({
    required int changelogCount,
    required String fromVersion,
    required String toVersion,
  }) {}

  void changelogDismissed({
    required int changelogCount,
  }) {}

  void whatsNewOpened() {}

  void goalAddButtonTapped({required String source}) {}
  void goalCreated(
      {required String goalId, required int titleLength, required double targetValue, required String source}) {}
  void goalUpdated({required String goalId, required String source}) {}
  void goalDeleted({required String goalId, required String source, required String method}) {}
  void goalItemTappedForEdit({required String goalId, required String source}) {}
  void goalEmojiSelected({required String emoji}) {}
  void goalProgressChanged({
    required String goalId,
    required double oldValue,
    required double newValue,
    required double targetValue,
  }) {}
  void taskDraggedToGoal({required String taskId, required String goalId}) {}
  void dailyScoreCtaTapped({required String ctaType}) {}
  void dailyScoreHelpTapped() {}

  void integrationsPageOpened() {}
  void integrationConnectAttempted({required String integrationName}) {}
  void integrationConnectSucceeded({required String integrationName}) {}
  void integrationConnectFailed({required String integrationName}) {}
  void integrationDisconnected({required String integrationName}) {}

  void paymentsPageOpened() {}
  void paymentMethodSelected({required String methodName}) {}

  void connectDevicePageOpened() {}
  void connectionGuideOpened() {}
  void connectionGuideDismissed(String deviceId) {}
  void connectionGuideDeviceTapped(String deviceId) {}
  void connectionGuideReportIssue(String deviceId) {}

  void dataPrivacyPageOpened() {}

  void aiAppGeneratorPageOpened() {}
  void aiAppGeneratorPromptSubmitted({required int promptLength}) {}
  void aiAppGeneratorAppGenerated({required bool success}) {}

  void importHistoryPageOpened() {}
  void importStarted({required String source}) {}

  void notificationFrequencyChanged({required int oldFrequency, required int newFrequency}) {}

  void dailyReflectionToggled({required bool enabled}) {}
}
