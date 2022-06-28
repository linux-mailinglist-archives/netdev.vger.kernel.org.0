Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8937A55D802
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245600AbiF1JrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 05:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344312AbiF1Jqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 05:46:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0BB25C7C;
        Tue, 28 Jun 2022 02:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2123D617FB;
        Tue, 28 Jun 2022 09:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D74AC341D0;
        Tue, 28 Jun 2022 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656409590;
        bh=xHKhJmmG6pOtTNRxB35U3omdaLpNm3R0DbSnh9czaGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UW40VbnEsQCyVuLWDjzMPJKYEaZPLkuBmqtpWuafag+7UevJxyBBZ5Cc8SHZ8hdXg
         r5IwdOynhIafXdmOMo2EOjrV6wsFBDFlLpkJcDGLZJrRqLtOXiSNlrUmVOIpK31jKf
         prT4obQtUZwaFg61yt7uf13T0KE9hW+pcSl61qqHMTfwD2UPUBVSJpn8R6xJulT2fR
         sgy0XyO/zb2Wn9jWflQ3rgeuy5/1YzXp31pSKhboa1hEAi3mXpnL1AswXnZ2rMfl0m
         jqwUZrwZCfcG45680QBxbFGYlS6rh4MQROP4aN7cn686mV+FsCaPT+5IZINYhcBnss
         bjVSz1juAz5Dw==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o67nf-005HEm-KU;
        Tue, 28 Jun 2022 10:46:27 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 01/22] net: cfg80211: fix kernel-doc warnings all over the file
Date:   Tue, 28 Jun 2022 10:46:05 +0100
Message-Id: <f6f522cdc716a01744bb0eae2186f4592976222b.1656409369.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656409369.git.mchehab@kernel.org>
References: <cover.1656409369.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently 17 kernel-doc warnings on this file:
	include/net/cfg80211.h:391: warning: Function parameter or member 'bw' not described in 'ieee80211_eht_mcs_nss_supp'
	include/net/cfg80211.h:437: warning: Function parameter or member 'eht_cap' not described in 'ieee80211_sband_iftype_data'
	include/net/cfg80211.h:507: warning: Function parameter or member 's1g' not described in 'ieee80211_sta_s1g_cap'
	include/net/cfg80211.h:1390: warning: Function parameter or member 'counter_offset_beacon' not described in 'cfg80211_color_change_settings'
	include/net/cfg80211.h:1390: warning: Function parameter or member 'counter_offset_presp' not described in 'cfg80211_color_change_settings'
	include/net/cfg80211.h:1430: warning: Enum value 'STATION_PARAM_APPLY_STA_TXPOWER' not described in enum 'station_parameters_apply_mask'
	include/net/cfg80211.h:2195: warning: Function parameter or member 'dot11MeshConnectedToAuthServer' not described in 'mesh_config'
	include/net/cfg80211.h:2341: warning: Function parameter or member 'short_ssid' not described in 'cfg80211_scan_6ghz_params'
	include/net/cfg80211.h:3328: warning: Function parameter or member 'kck_len' not described in 'cfg80211_gtk_rekey_data'
	include/net/cfg80211.h:3698: warning: Function parameter or member 'ftm' not described in 'cfg80211_pmsr_result'
	include/net/cfg80211.h:3828: warning: Function parameter or member 'global_mcast_stypes' not described in 'mgmt_frame_regs'
	include/net/cfg80211.h:4977: warning: Function parameter or member 'ftm' not described in 'cfg80211_pmsr_capabilities'
	include/net/cfg80211.h:5742: warning: Function parameter or member 'u' not described in 'wireless_dev'
	include/net/cfg80211.h:5742: warning: Function parameter or member 'links' not described in 'wireless_dev'
	include/net/cfg80211.h:5742: warning: Function parameter or member 'valid_links' not described in 'wireless_dev'
	include/net/cfg80211.h:6076: warning: Function parameter or member 'is_amsdu' not described in 'ieee80211_data_to_8023_exthdr'
	include/net/cfg80211.h:6949: warning: Function parameter or member 'sig_dbm' not described in 'cfg80211_notify_new_peer_candidate'

Address them, in order to build a better documentation from this
header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 00/22] at: https://lore.kernel.org/all/cover.1656409369.git.mchehab@kernel.org/

 include/net/cfg80211.h | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 996782c44838..c7e641071eff 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -374,6 +374,7 @@ struct ieee80211_sta_he_cap {
  * and NSS Set field"
  *
  * @only_20mhz: MCS/NSS support for 20 MHz-only STA.
+ * @bw: MCS/NSS support for 80, 160 and 320 MHz
  * @bw._80: MCS/NSS support for BW <= 80 MHz
  * @bw._160: MCS/NSS support for BW = 160 MHz
  * @bw._320: MCS/NSS support for BW = 320 MHz
@@ -420,6 +421,7 @@ struct ieee80211_sta_eht_cap {
  * @he_cap: holds the HE capabilities
  * @he_6ghz_capa: HE 6 GHz capabilities, must be filled in for a
  *	6 GHz band channel (and 0 may be valid value).
+ * @eht_cap: STA's EHT capabilities
  * @vendor_elems: vendor element(s) to advertise
  * @vendor_elems.data: vendor element(s) data
  * @vendor_elems.len: vendor element(s) length
@@ -495,7 +497,7 @@ struct ieee80211_edmg {
  * This structure describes most essential parameters needed
  * to describe 802.11ah S1G capabilities for a STA.
  *
- * @s1g_supported: is STA an S1G STA
+ * @s1g: is STA an S1G STA
  * @cap: S1G capabilities information
  * @nss_mcs: Supported NSS MCS set
  */
@@ -1373,8 +1375,8 @@ struct cfg80211_csa_settings {
  * Used for bss color change
  *
  * @beacon_color_change: beacon data while performing the color countdown
- * @counter_offsets_beacon: offsets of the counters within the beacon (tail)
- * @counter_offsets_presp: offsets of the counters within the probe response
+ * @counter_offset_beacon: offsets of the counters within the beacon (tail)
+ * @counter_offset_presp: offsets of the counters within the probe response
  * @beacon_next: beacon data to be used after the color change
  * @count: number of beacons until the color change
  * @color: the color used after the change
@@ -1417,6 +1419,7 @@ struct iface_combination_params {
  * @STATION_PARAM_APPLY_UAPSD: apply new uAPSD parameters (uapsd_queues, max_sp)
  * @STATION_PARAM_APPLY_CAPABILITY: apply new capability
  * @STATION_PARAM_APPLY_PLINK_STATE: apply new plink state
+ * @STATION_PARAM_APPLY_STA_TXPOWER: apply tx power for STA
  *
  * Not all station parameters have in-band "no change" signalling,
  * for those that don't these flags will are used.
@@ -2149,6 +2152,9 @@ struct bss_parameters {
  * @plink_timeout: If no tx activity is seen from a STA we've established
  *	peering with for longer than this time (in seconds), then remove it
  *	from the STA's list of peers.  Default is 30 minutes.
+ * @dot11MeshConnectedToAuthServer: if set to true then this mesh STA
+ *	will advertise that it is connected to a authentication server
+ *	in the mesh formation field.
  * @dot11MeshConnectedToMeshGate: if set to true, advertise that this STA is
  *      connected to a mesh gate in mesh formation info.  If false, the
  *      value in mesh formation is determined by the presence of root paths
@@ -2321,12 +2327,12 @@ struct cfg80211_scan_info {
 /**
  * struct cfg80211_scan_6ghz_params - relevant for 6 GHz only
  *
- * @short_bssid: short ssid to scan for
+ * @short_ssid: short ssid to scan for
  * @bssid: bssid to scan for
  * @channel_idx: idx of the channel in the channel array in the scan request
  *	 which the above info relvant to
  * @unsolicited_probe: the AP transmits unsolicited probe response every 20 TU
- * @short_ssid_valid: short_ssid is valid and can be used
+ * @short_ssid_valid: @short_ssid is valid and can be used
  * @psc_no_listen: when set, and the channel is a PSC channel, no need to wait
  *       20 TUs before starting to send probe requests.
  */
@@ -3317,7 +3323,7 @@ struct cfg80211_wowlan_wakeup {
  * @kck: key confirmation key (@kck_len bytes)
  * @replay_ctr: replay counter (NL80211_REPLAY_CTR_LEN bytes)
  * @kek_len: length of kek
- * @kck_len length of kck
+ * @kck_len: length of kck
  * @akm: akm (oui, id)
  */
 struct cfg80211_gtk_rekey_data {
@@ -3679,6 +3685,7 @@ struct cfg80211_pmsr_ftm_result {
  * @type: type of the measurement reported, note that we only support reporting
  *	one type at a time, but you can report multiple results separately and
  *	they're all aggregated for userspace.
+ * @ftm: FTM result
  */
 struct cfg80211_pmsr_result {
 	u64 host_time, ap_tsf;
@@ -3817,7 +3824,7 @@ struct cfg80211_update_owe_info {
  *	for the entire device
  * @interface_stypes: bitmap of management frame subtypes registered
  *	for the given interface
- * @global_mcast_rx: mcast RX is needed globally for these subtypes
+ * @global_mcast_stypes: mcast RX is needed globally for these subtypes
  * @interface_mcast_stypes: mcast RX is needed on this interface
  *	for these subtypes
  */
@@ -4940,6 +4947,7 @@ struct wiphy_iftype_ext_capab {
  * @max_peers: maximum number of peers in a single measurement
  * @report_ap_tsf: can report assoc AP's TSF for radio resource measurement
  * @randomize_mac_addr: can randomize MAC address for measurement
+ * @ftm: FTM measurement data
  * @ftm.supported: FTM measurement is supported
  * @ftm.asap: ASAP-mode is supported
  * @ftm.non_asap: non-ASAP-mode is supported
@@ -5563,6 +5571,7 @@ static inline void wiphy_unlock(struct wiphy *wiphy)
  * @netdev: (private) Used to reference back to the netdev, may be %NULL
  * @identifier: (private) Identifier used in nl80211 to identify this
  *	wireless device if it has no netdev
+ * @u: union containing data specific to @iftype
  * @connected_addr: (private) BSSID or AP MLD address if connected
  * @connected: indicates if connected or not (STA mode)
  * @current_bss: (private) Used by the internal configuration code
@@ -5624,6 +5633,9 @@ static inline void wiphy_unlock(struct wiphy *wiphy)
  * @pmsr_free_wk: (private) peer measurements cleanup work
  * @unprot_beacon_reported: (private) timestamp of last
  *	unprotected beacon report
+ * @links: array of %IEEE80211_MLD_MAX_NUM_LINKS elements containing @addr
+ *	@ap and @client for each link
+ * @valid_links: bitmap describing what elements of @links are valid
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -6068,6 +6080,7 @@ unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
  * @addr: the device MAC address
  * @iftype: the virtual interface type
  * @data_offset: offset of payload after the 802.11 header
+ * @is_amsdu: true if the 802.11 header is A-MSDU
  * Return: 0 on success. Non-zero on error.
  */
 int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
@@ -6937,6 +6950,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * @macaddr: the MAC address of the new candidate
  * @ie: information elements advertised by the peer candidate
  * @ie_len: length of the information elements buffer
+ * @sig_dbm: signal level in dBm
  * @gfp: allocation flags
  *
  * This function notifies cfg80211 that the mesh peer candidate has been
-- 
2.36.1

