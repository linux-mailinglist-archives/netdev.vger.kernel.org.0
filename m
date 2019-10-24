Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42A9E3E4D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfJXVg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:36:59 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:60010 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbfJXVg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:36:58 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 26CCA891A9;
        Fri, 25 Oct 2019 10:36:55 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1571953015;
        bh=ORxhwEJ9gRBpr0JBIptG2U2pQaqdGpfhtNuFcfek5AU=;
        h=From:To:Cc:Subject:Date;
        b=zTEfMP4bfWP16xDZmgfTngjMzVJrENoiky94CunRzhG52m15zrJnzMyZCEjvizkeW
         3Y0Okuq0OQ7cOzDZnyz3KFQbdTLBaqabOY+bwDliTwJH4DgUpzpyiVrNxwJQNiLTVA
         n5RVESI3drXgxbgyKO+yrcvkYZZzaGXbNW68Juru2Sg7U0OupsYlIiQM1WDnvrx0LK
         ZsWVEd28RFNh7VfNjmeaG+8cvqRefg5Iw0X5gUmWx0dYuW7nn/Z0nZaqULUSN1X0zg
         u8i20VZUAcTdr+WaYhnY5r37sjVYiTzAwGRhBiyoEMy/8ViW6+2t7IHlD7I/81Tdxi
         PG2zB1tfO1p/g==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5db219750000>; Fri, 25 Oct 2019 10:36:53 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 0CD7213EEEB;
        Fri, 25 Oct 2019 10:36:59 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id CA83F28005C; Fri, 25 Oct 2019 10:36:54 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     johannes@sipsolutions.net, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        trivial@kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] mac80211: typo fixes in kerneldoc comments
Date:   Fri, 25 Oct 2019 10:36:47 +1300
Message-Id: <20191024213647.5507-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct some trivial typos in kerneldoc comments.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

Notes:
    Changes in v2:
    - one more reasurement -> measurement

 include/net/mac80211.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 523c6a09e1c8..46f28c6620b9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -312,7 +312,7 @@ struct ieee80211_vif_chanctx_switch {
  * @BSS_CHANGED_KEEP_ALIVE: keep alive options (idle period or protected
  *	keep alive) changed.
  * @BSS_CHANGED_MCAST_RATE: Multicast Rate setting changed for this inte=
rface
- * @BSS_CHANGED_FTM_RESPONDER: fime timing reasurement request responder
+ * @BSS_CHANGED_FTM_RESPONDER: fine timing measurement request responder
  *	functionality changed for this BSS (AP mode).
  * @BSS_CHANGED_TWT: TWT status changed
  * @BSS_CHANGED_HE_OBSS_PD: OBSS Packet Detection status changed.
@@ -1059,7 +1059,7 @@ struct ieee80211_tx_info {
 };
=20
 /**
- * struct ieee80211_tx_status - extended tx staus info for rate control
+ * struct ieee80211_tx_status - extended tx status info for rate control
  *
  * @sta: Station that the packet was transmitted for
  * @info: Basic tx status information
@@ -1702,7 +1702,7 @@ struct wireless_dev *ieee80211_vif_to_wdev(struct i=
eee80211_vif *vif);
  *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
  * @IEEE80211_KEY_FLAG_GENERATE_IV_MGMT: This flag should be set by the
  *	driver for a CCMP/GCMP key to indicate that is requires IV generation
- *	only for managment frames (MFP).
+ *	only for management frames (MFP).
  * @IEEE80211_KEY_FLAG_RESERVE_TAILROOM: This flag should be set by the
  *	driver for a key to indicate that sufficient tailroom must always
  *	be reserved for ICV or MIC, even when HW encryption is enabled.
@@ -1998,7 +1998,7 @@ struct ieee80211_sta {
 	 *
 	 * * If the skb is transmitted as part of a BA agreement, the
 	 *   A-MSDU maximal size is min(max_amsdu_len, 4065) bytes.
-	 * * If the skb is not part of a BA aggreement, the A-MSDU maximal
+	 * * If the skb is not part of a BA agreement, the A-MSDU maximal
 	 *   size is min(max_amsdu_len, 7935) bytes.
 	 *
 	 * Both additional HT limits must be enforced by the low level
@@ -3183,13 +3183,13 @@ enum ieee80211_rate_control_changed {
  *
  * With the support for multi channel contexts and multi channel operati=
ons,
  * remain on channel operations might be limited/deferred/aborted by oth=
er
- * flows/operations which have higher priority (and vise versa).
+ * flows/operations which have higher priority (and vice versa).
  * Specifying the ROC type can be used by devices to prioritize the ROC
  * operations compared to other operations/flows.
  *
  * @IEEE80211_ROC_TYPE_NORMAL: There are no special requirements for thi=
s ROC.
  * @IEEE80211_ROC_TYPE_MGMT_TX: The remain on channel request is require=
d
- *	for sending managment frames offchannel.
+ *	for sending management frames offchannel.
  */
 enum ieee80211_roc_type {
 	IEEE80211_ROC_TYPE_NORMAL =3D 0,
@@ -5609,7 +5609,7 @@ void ieee80211_iter_keys_rcu(struct ieee80211_hw *h=
w,
=20
 /**
  * ieee80211_iter_chan_contexts_atomic - iterate channel contexts
- * @hw: pointre obtained from ieee80211_alloc_hw().
+ * @hw: pointer obtained from ieee80211_alloc_hw().
  * @iter: iterator function
  * @iter_data: data passed to iterator function
  *
@@ -6357,7 +6357,7 @@ ieee80211_return_txq(struct ieee80211_hw *hw, struc=
t ieee80211_txq *txq,
  * again.
  *
  * The API ieee80211_txq_may_transmit() also ensures that TXQ list will =
be
- * aligned aginst driver's own round-robin scheduler list. i.e it rotate=
s
+ * aligned against driver's own round-robin scheduler list. i.e it rotat=
es
  * the TXQ list till it makes the requested node becomes the first entry
  * in TXQ list. Thus both the TXQ list and driver's list are in sync. If=
 this
  * function returns %true, the driver is expected to schedule packets
--=20
2.23.0

