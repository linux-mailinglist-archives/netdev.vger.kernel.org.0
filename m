Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0B328CD17
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 13:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgJML4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 07:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727661AbgJMLyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 07:54:49 -0400
Received: from mail.kernel.org (ip5f5ad5b2.dynamic.kabel-deutschland.de [95.90.213.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BADD224F9;
        Tue, 13 Oct 2020 11:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602590081;
        bh=4jUtq2N1mAMGZHT12614phVdDlgelGbPttSeVtkD628=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7yruQANg9u2iMYZDtpo9GgHA/iUA6tHEI2+5nMYivGWJu8DhD+aMGh/Ls0I831XN
         w/D0hB2yNt+S4VK8Dd4K+aeh1sjj1wQzhRw7NefDahP7ThF4vROSK2VVSklFoHOOie
         8GLCiWmyEDndW50PZo6U81xpKk69Wiv4UZf579GA=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kSIt5-006CWQ-Mq; Tue, 13 Oct 2020 13:54:39 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Pedersen <thomas@adapt-ip.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v6 68/80] nl80211: docs: add a description for s1g_cap parameter
Date:   Tue, 13 Oct 2020 13:54:23 +0200
Message-Id: <9633ea7d9b0cb2f997d784df86ba92e67659f29b.1602589096.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1602589096.git.mchehab+huawei@kernel.org>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset df78a0c0b67d ("nl80211: S1G band and channel definitions")
added a new parameter, but didn't add the corresponding kernel-doc
markup, as repoted when doing "make htmldocs":

	./include/net/cfg80211.h:471: warning: Function parameter or member 's1g_cap' not described in 'ieee80211_supported_band'

Add a documentation for it.

Fixes: df78a0c0b67d ("nl80211: S1G band and channel definitions")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/net/cfg80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d9e6b9fbd95b..fb6aece00549 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -449,6 +449,7 @@ struct ieee80211_sta_s1g_cap {
  * @n_bitrates: Number of bitrates in @bitrates
  * @ht_cap: HT capabilities in this band
  * @vht_cap: VHT capabilities in this band
+ * @s1g_cap: S1G capabilities in this band
  * @edmg_cap: EDMG capabilities in this band
  * @n_iftype_data: number of iftype data entries
  * @iftype_data: interface type data entries.  Note that the bits in
-- 
2.26.2

