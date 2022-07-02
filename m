Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7319563F98
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 13:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiGBLHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 07:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbiGBLHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 07:07:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A366C15A2A;
        Sat,  2 Jul 2022 04:07:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C7ECB820D7;
        Sat,  2 Jul 2022 11:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E648C341D0;
        Sat,  2 Jul 2022 11:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656760068;
        bh=2qqxIF8Unf8YQpcXVpRiAsjzATxAeYvcZlNIZEmxF/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8oYQ3l/Zu5P+SXkP1c6k5aspl/F6rVt/oGfwMBGKyGAk6zkti5aLJDrFKVtS34MM
         1n9v8Gt2a0vn52r6j5XwhwVtu39uvxZA4ywO5wgo0BBTkE4VXSjUFWUzmo4zD9QdwZ
         8+sTp0llwq+IvA1VBGw4nZhpzltWjY+ktdqa+JNJPgLzFx3MtMgm5H8WcuNf1YBQqA
         jUYSy7gqTJCDkgtRp9DRs5qXZE+zkqsL1zdwc8AB+oVXkc+RQzFYGcYGB3caw6dfpb
         +/rNA+DqhxvfrJzNrMfk6W2nEPSWwRsN0eIUIqJqay4M0yftU3JyFHedfEl/UFvr7n
         mhIuwp7JPRlIA==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o7ayX-007gsF-PZ;
        Sat, 02 Jul 2022 12:07:45 +0100
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
Subject: [PATCH 09/12] net: mac80211: fix a kernel-doc markup
Date:   Sat,  2 Jul 2022 12:07:41 +0100
Message-Id: <cee2e80b47939ce2ea9784368e136eb883eea98b.1656759989.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656759988.git.mchehab@kernel.org>
References: <cover.1656759988.git.mchehab@kernel.org>
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

The markup to reference a var should be just @foo, and not @foo[].
Using the later causes a kernel-doc warning:

	Documentation/driver-api/80211/mac80211:32: ./include/net/mac80211.h:4045: WARNING: Inline strong start-string without end-string.

Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 00/12] at: https://lore.kernel.org/all/cover.1656759988.git.mchehab@kernel.org/

 include/net/mac80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9d8b5b0ee1cb..3e19b0001b41 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4045,7 +4045,7 @@ struct ieee80211_prep_tx_info {
  *	removing the old link information is still valid (link_conf pointer),
  *	but may immediately disappear after the function returns. The old or
  *	new links bitmaps may be 0 if going from/to a non-MLO situation.
- *	The @old[] array contains pointers to the old bss_conf structures
+ *	The @old array contains pointers to the old bss_conf structures
  *	that were already removed, in case they're needed.
  *	This callback can sleep.
  * @change_sta_links: Change the valid links of a station, similar to
-- 
2.36.1

