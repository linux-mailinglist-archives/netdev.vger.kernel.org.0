Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9055E009
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344319AbiF1Jqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 05:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343913AbiF1Jqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 05:46:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF1325C73;
        Tue, 28 Jun 2022 02:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69785617BB;
        Tue, 28 Jun 2022 09:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326AEC341CE;
        Tue, 28 Jun 2022 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656409590;
        bh=/pVDv47pHcbB0gI2Mal+afS7TWigkjO6bV5Qn+g/Q90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfzyXVXg2vrOXJT2eg0g+QkyLyfSUpuP0oKskeI1VnHoHc1lfzPAK2EmbaHXxKPcL
         K5PcUfjEh3LC6cQBJjxi9xRimB4MWdkeThC60+oeht7mvJ18tNRBW+pZwNKtE0QwsQ
         OM472nkjtd8L62ZOwqtuEbri7Ys1aGEHReh2HSj+foCjvQX6mz2ZBERG8bsXgluBrm
         +30MTfAX7f4HeLhFCHzhp9J9uf+St2Dazah1E3hvS3tC3nQ8MKkAikpOsk9ogdrdg6
         zTEJDNkuqjN+vGBCP4DJNlElMQ2iWPLYmRJ5topmkzzRxAz+gBTwL81zUZoFZ7RFvz
         4xJxSqL3t4hew==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o67nf-005HEp-LB;
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
Subject: [PATCH 02/22] net: mac80211: add a missing comma at kernel-doc markup
Date:   Tue, 28 Jun 2022 10:46:06 +0100
Message-Id: <11c1bdb861d89c93058fcfe312749b482851cbdb.1656409369.git.mchehab@kernel.org>
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

The lack of the comma makes it to not parse the function parameter:
	include/net/mac80211.h:6250: warning: Function parameter or member 'vif' not described in 'ieee80211_channel_switch_disconnect'

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 00/22] at: https://lore.kernel.org/all/cover.1656409369.git.mchehab@kernel.org/

 include/net/mac80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 27f24ac0426d..c0557142343f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6238,7 +6238,7 @@ void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success);
 
 /**
  * ieee80211_channel_switch_disconnect - disconnect due to channel switch error
- * @vif &struct ieee80211_vif pointer from the add_interface callback.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @block_tx: if %true, do not send deauth frame.
  *
  * Instruct mac80211 to disconnect due to a channel switch error. The channel
-- 
2.36.1

