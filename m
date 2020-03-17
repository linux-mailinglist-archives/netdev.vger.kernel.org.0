Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558CF188851
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgCQOzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbgCQOyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 10:54:31 -0400
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC16720770;
        Tue, 17 Mar 2020 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584456870;
        bh=a90DwMKBkhqWFXJx7xwLKL3fi3ijaowB1BCH5a8wJKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLFSnKP1Gc9mIiuWPX4lKatvUO8G4hANJRdMhxsQguWD9Wa7t35Ly/5mCoG9EbLOq
         bkDtNpBPYPTXi93x5ny6sUGohQJBLOWv6Lhf+fe7Rk0qBRyU1xh3ttsr89Dl3CLdtd
         yThOkyZ4ZI64AvLORMwu7SYWbFFhuRLZPcrIKrvw=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jEDbw-000AMy-OR; Tue, 17 Mar 2020 15:54:28 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 11/17] net: core: dev.c: fix a documentation warning
Date:   Tue, 17 Mar 2020 15:54:20 +0100
Message-Id: <23cd1652cbe7009f25993786c91460543e8a8a41.1584456635.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1584456635.git.mchehab+huawei@kernel.org>
References: <cover.1584456635.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a markup for link with is "foo_". On this kernel-doc
comment, we don't want this, but instead, place a literal
reference. So, escape the literal with ``foo``, in order to
avoid this warning:

	./net/core/dev.c:5195: WARNING: Unknown target name: "page_is".

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d84541c24446..474762ea256a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5195,7 +5195,7 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
  *
  *	More direct receive version of netif_receive_skb().  It should
  *	only be used by callers that have a need to skip RPS and Generic XDP.
- *	Caller must also take care of handling if (page_is_)pfmemalloc.
+ *	Caller must also take care of handling if ``(page_is_)pfmemalloc``.
  *
  *	This function may only be called from softirq context and interrupts
  *	should be enabled.
-- 
2.24.1

