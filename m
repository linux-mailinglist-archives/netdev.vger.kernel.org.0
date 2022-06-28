Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5349255DF76
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344288AbiF1Jqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 05:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344151AbiF1Jqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 05:46:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4791F25C69;
        Tue, 28 Jun 2022 02:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB414617B3;
        Tue, 28 Jun 2022 09:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F00C341CB;
        Tue, 28 Jun 2022 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656409590;
        bh=aNsBjoam9FomQGP0KLpmbiHeL/xAsgah34KubXmo/7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cV5jmYDejNl2eM22Og0AgzjAq1KUDXy9YVpy90dvsGq8t/J9oBSRJNZghpgru6e0Y
         JYBCsSth17DmDu3kVrH+RNB93KNImGfVfHSmW47GIW8Tl05c5Ut4hDUtDobfYxEsRf
         mxqamINcbsAdtUplbsQvMHKxMsq09w28pP/gwXI2t8siWGQUBxxVOdqcTP4Fpynqkb
         wVdayItZkl0b80YceJnP0ZniXQPtKvQF4PtE0Z0sHF9sBORrn/D/XUIuNOWybdTeSO
         be7YmggGzSrSKeLWWtotW1sUshOjPdtnsByqEJLAEeoCznotST7ObjBOVgcbiecHwB
         kwDMrHjS7TACg==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o67nf-005HEs-Lu;
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
Subject: [PATCH 03/22] net: mac80211: sta_info: fix a missing kernel-doc struct element
Date:   Tue, 28 Jun 2022 10:46:07 +0100
Message-Id: <37d898634bb30776442a33833c48cbb21c90ecc6.1656409369.git.mchehab@kernel.org>
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

struct link_sta_info has now a cur_max_bandwidth data:

	net/mac80211/sta_info.h:569: warning: Function parameter or member 'cur_max_bandwidth' not described in 'link_sta_info'

Copy the meaning from struct sta_info, documenting it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 00/22] at: https://lore.kernel.org/all/cover.1656409369.git.mchehab@kernel.org/

 net/mac80211/sta_info.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 218430790660..4e0b969891de 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -517,6 +517,8 @@ struct ieee80211_fragment_cache {
  * @status_stats.last_ack_signal: last ACK signal
  * @status_stats.ack_signal_filled: last ACK signal validity
  * @status_stats.avg_ack_signal: average ACK signal
+ * @cur_max_bandwidth: maximum bandwidth to use for TX to the station,
+ *	taken from HT/VHT capabilities or VHT operating mode notification
  * @pub: public (driver visible) link STA data
  * TODO Move other link params from sta_info as required for MLD operation
  */
-- 
2.36.1

