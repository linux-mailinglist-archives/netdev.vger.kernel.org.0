Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F147E24CF35
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgHUHXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgHUHQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:16:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9A6C061348
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a15so986055wrh.10
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ua8TlHsoK9E4ad2qRqbugqtvcliFNwbmlPPlMKuGe5M=;
        b=Zp0UNxq8bzN0TCpNf+2yzWBPUJaZth7Q4B6tm7kHDiiHZMmlDYi4brfMXWONZZf4Oj
         EIes62+PECtkNTG/YkhChcvPJrE+8zAgB1CV81KrqiGLujeUfFDBXY02QhM/pYoptGX/
         45NahC8b2uZ0p+jXA0a6f0P8moyaK0Yz7NkFqnFupo8Wg+Cp2t+ejgT369iOmTHmqwzA
         TbWIK0nXNC7ussEnIdJNsn20hMN631Ss+iOpi1Hwpi8+ZTNQPCr2Vz9/mL2BNt2asVw8
         iB4VNsz11Q3dEUgMxJXAJdCZSGGYDr4xaIGU+yrwUaDxG2WWfhGJhyezHTX5x47uV9NC
         YDSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ua8TlHsoK9E4ad2qRqbugqtvcliFNwbmlPPlMKuGe5M=;
        b=TZRJdHUO5BCs992vYM1p9wTdJn9W4uae1suBQUys/9/6sbY2FCUtB8lmV3HpX8dj52
         908+2vHpWYrtu7zD1PLBhr3PYHivNVfFglZgvvI7nJfXwwCn//fqz6uH4/+uHGTirg6c
         G6wFaJrkICB7jc1OyA2OaqD/LkT+0CuXRyP6aJj0XyvywtWQ2qVOp4KcpJKsNkWWWyV7
         epl288N3dVScULSWZ87GryF8u6FXUqGRS+v/6fkfsylnr/zJfYxqW3Cke875t0R7Xbra
         pESD7COll4QaOrDe+Cf0dKnENDwtv1BIVZjUg5/bQ8qyS7KCRhHIfWhm7ofYAgGf6ITD
         VzGw==
X-Gm-Message-State: AOAM530RW/uet/d5ImCopCX1zQgLqCtbzYF+nNB20lSHeB/CUafcLtzB
        Z1d2KWavc/OXLVImcSGx+upGBw==
X-Google-Smtp-Source: ABdhPJyIuWCDl/5PRU/Zc5TRVNouD2OGGFAivVyaM36GjXZfxEDBQaEOEfVyUeG09dcntKKvBF+Obw==
X-Received: by 2002:adf:ea4f:: with SMTP id j15mr1386024wrn.253.1597994214612;
        Fri, 21 Aug 2020 00:16:54 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:16:54 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 05/32] wireless: broadcom: brcm80211: brcmfmac: p2p: Fix a bunch of function docs
Date:   Fri, 21 Aug 2020 08:16:17 +0100
Message-Id: <20200821071644.109970-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some formatting issues, some missing and some extra descriptions.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:162: warning: Function parameter or member 'oui' not described in 'brcmf_p2p_pub_act_frame'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:162: warning: Function parameter or member 'elts' not described in 'brcmf_p2p_pub_act_frame'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:181: warning: Function parameter or member 'oui' not described in 'brcmf_p2p_action_frame'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:181: warning: Function parameter or member 'elts' not described in 'brcmf_p2p_action_frame'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:196: warning: Function parameter or member 'query_data' not described in 'brcmf_p2psd_gas_pub_act_frame'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:210: warning: Function parameter or member 'extra_listen' not described in 'brcmf_config_af_params'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:776: warning: Function parameter or member 'ifp' not described in 'brcmf_p2p_run_escan'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:776: warning: Excess function parameter 'ndev' description in 'brcmf_p2p_run_escan'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:776: warning: Excess function parameter 'action' description in 'brcmf_p2p_run_escan'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:977: warning: Function parameter or member 'wdev' not described in 'brcmf_p2p_remain_on_channel'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:977: warning: Function parameter or member 'cookie' not described in 'brcmf_p2p_remain_on_channel'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1063: warning: Function parameter or member 'channel' not described in 'brcmf_p2p_act_frm_search'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1337: warning: Function parameter or member 'mac' not described in 'brcmf_p2p_gon_req_collision'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:2046: warning: Function parameter or member 'cfg' not described in 'brcmf_p2p_ifchange'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:2046: warning: Function parameter or member 'if_type' not described in 'brcmf_p2p_ifchange'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:2046: warning: Excess function parameter 'mac' description in 'brcmf_p2p_ifchange'

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../broadcom/brcm80211/brcmfmac/p2p.c         | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 7f681a25ab525..dc0bc1f6c8023 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -145,11 +145,11 @@ struct brcmf_p2p_scan_le {
  *
  * @category: P2P_PUB_AF_CATEGORY
  * @action: P2P_PUB_AF_ACTION
- * @oui[3]: P2P_OUI
+ * @oui: P2P_OUI
  * @oui_type: OUI type - P2P_VER
  * @subtype: OUI subtype - P2P_TYPE_*
  * @dialog_token: nonzero, identifies req/rsp transaction
- * @elts[1]: Variable length information elements.
+ * @elts: Variable length information elements.
  */
 struct brcmf_p2p_pub_act_frame {
 	u8	category;
@@ -165,11 +165,11 @@ struct brcmf_p2p_pub_act_frame {
  * struct brcmf_p2p_action_frame - WiFi P2P Action Frame
  *
  * @category: P2P_AF_CATEGORY
- * @OUI[3]: OUI - P2P_OUI
+ * @oui: OUI - P2P_OUI
  * @type: OUI Type - P2P_VER
  * @subtype: OUI Subtype - P2P_AF_*
  * @dialog_token: nonzero, identifies req/resp tranaction
- * @elts[1]: Variable length information elements.
+ * @elts: Variable length information elements.
  */
 struct brcmf_p2p_action_frame {
 	u8	category;
@@ -186,7 +186,7 @@ struct brcmf_p2p_action_frame {
  * @category: 0x04 Public Action Frame
  * @action: 0x6c Advertisement Protocol
  * @dialog_token: nonzero, identifies req/rsp transaction
- * @query_data[1]: Query Data. SD gas ireq SD gas iresp
+ * @query_data: Query Data. SD gas ireq SD gas iresp
  */
 struct brcmf_p2psd_gas_pub_act_frame {
 	u8	category;
@@ -201,7 +201,7 @@ struct brcmf_p2psd_gas_pub_act_frame {
  * @mpc_onoff: To make sure to send successfully action frame, we have to
  *             turn off mpc  0: off, 1: on,  (-1): do nothing
  * @search_channel: 1: search peer's channel to send af
- * extra_listen: keep the dwell time to get af response frame.
+ * @extra_listen: keep the dwell time to get af response frame.
  */
 struct brcmf_config_af_params {
 	s32 mpc_onoff;
@@ -763,9 +763,8 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
  * brcmf_p2p_run_escan() - escan callback for peer-to-peer.
  *
  * @cfg: driver private data for cfg80211 interface.
- * @ndev: net device for which scan is requested.
+ * @ifp: interface control.
  * @request: scan request from cfg80211.
- * @action: scan action.
  *
  * Determines the P2P discovery state based to scan request parameters and
  * validates the channels in the request.
@@ -967,9 +966,10 @@ brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p, u16 channel, u32 duration)
  * brcmf_p2p_remain_on_channel() - put device on channel and stay there.
  *
  * @wiphy: wiphy device.
+ * @wiphy: wireless device.
  * @channel: channel to stay on.
  * @duration: time in ms to remain on channel.
- *
+ * @cookie: cookie.
  */
 int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 				struct ieee80211_channel *channel,
@@ -1054,7 +1054,7 @@ void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp)
  * brcmf_p2p_act_frm_search() - search function for action frame.
  *
  * @p2p: p2p device.
- * channel: channel on which action frame is to be trasmitted.
+ * @channel: channel on which action frame is to be trasmitted.
  *
  * search function to reach at common channel to send action frame. When
  * channel is 0 then all social channels will be used to send af
@@ -1329,6 +1329,7 @@ brcmf_p2p_stop_wait_next_action_frame(struct brcmf_cfg80211_info *cfg)
  * brcmf_p2p_gon_req_collision() - Check if go negotiaton collission
  *
  * @p2p: p2p device info struct.
+ * @mac: MAC address.
  *
  * return true if recevied action frame is to be dropped.
  */
@@ -2039,6 +2040,7 @@ static void brcmf_p2p_get_current_chanspec(struct brcmf_p2p_info *p2p,
  * Change a P2P Role.
  * Parameters:
  * @mac: MAC address of the BSS to change a role
+ * @if_type: interface type.
  * Returns 0 if success.
  */
 int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
-- 
2.25.1

