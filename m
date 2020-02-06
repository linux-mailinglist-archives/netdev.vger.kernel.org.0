Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9E4154782
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgBFPSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38090 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=t2yWmhu1E5vZJKxFd22eXuudQGWyjBMcjrUmGzb6AJ8=; b=I7AU+Ful4eBxEXYWh/h3Q/pFNo
        TPr4sZuabGHRRtrEPnInySpPHKamVwqtrVrRo2J6bFAfh6N2S0BC7BpAzwzKQ7NJqv6mVTYd1hfmi
        ruwsQTlbuISoBMBKtwIAzSZeOmM0v2oyUIV+OGjXGK0n8o0IJkOcWKcImpVikJzvz16zVTddqRgbS
        QDIYZC1wDB0EDXyaUvaN1GEaNKF/ldq18y73bb0Mlp5WBzycYpjKvh6MxMM2FT9HDaZ0SdqqdW8gg
        CL2gCBukzgtRR8cAQRrB7gzCFC8eai6bI8unRgWJJKOktrHQwAPIODp/h2xp4HIlprVI1fZ10I6TW
        DAPjMWVw==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jD-Ay; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziuc-002oUr-GO; Thu, 06 Feb 2020 16:17:50 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Aring <alex.aring@gmail.com>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: [PATCH 02/28] docs: networking: convert 6lowpan.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:22 +0100
Message-Id: <bfa773f25584a3939e0a3e1fc6bc0e91f415cd91.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- use document title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{6lowpan.txt => 6lowpan.rst}   | 29 ++++++++++---------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 17 insertions(+), 13 deletions(-)
 rename Documentation/networking/{6lowpan.txt => 6lowpan.rst} (64%)

diff --git a/Documentation/networking/6lowpan.txt b/Documentation/networking/6lowpan.rst
similarity index 64%
rename from Documentation/networking/6lowpan.txt
rename to Documentation/networking/6lowpan.rst
index 2e5a939d7e6f..e70a6520cc33 100644
--- a/Documentation/networking/6lowpan.txt
+++ b/Documentation/networking/6lowpan.rst
@@ -1,37 +1,40 @@
+.. SPDX-License-Identifier: GPL-2.0
 
-Netdev private dataroom for 6lowpan interfaces:
+==============================================
+Netdev private dataroom for 6lowpan interfaces
+==============================================
 
 All 6lowpan able net devices, means all interfaces with ARPHRD_6LOWPAN,
 must have "struct lowpan_priv" placed at beginning of netdev_priv.
 
-The priv_size of each interface should be calculate by:
+The priv_size of each interface should be calculate by::
 
  dev->priv_size = LOWPAN_PRIV_SIZE(LL_6LOWPAN_PRIV_DATA);
 
 Where LL_PRIV_6LOWPAN_DATA is sizeof linklayer 6lowpan private data struct.
-To access the LL_PRIV_6LOWPAN_DATA structure you can cast:
+To access the LL_PRIV_6LOWPAN_DATA structure you can cast::
 
  lowpan_priv(dev)-priv;
 
 to your LL_6LOWPAN_PRIV_DATA structure.
 
-Before registering the lowpan netdev interface you must run:
+Before registering the lowpan netdev interface you must run::
 
  lowpan_netdev_setup(dev, LOWPAN_LLTYPE_FOOBAR);
 
 wheres LOWPAN_LLTYPE_FOOBAR is a define for your 6LoWPAN linklayer type of
 enum lowpan_lltypes.
 
-Example to evaluate the private usually you can do:
+Example to evaluate the private usually you can do::
 
-static inline struct lowpan_priv_foobar *
-lowpan_foobar_priv(struct net_device *dev)
-{
+ static inline struct lowpan_priv_foobar *
+ lowpan_foobar_priv(struct net_device *dev)
+ {
 	return (struct lowpan_priv_foobar *)lowpan_priv(dev)->priv;
-}
+ }
 
-switch (dev->type) {
-case ARPHRD_6LOWPAN:
+ switch (dev->type) {
+ case ARPHRD_6LOWPAN:
 	lowpan_priv = lowpan_priv(dev);
 	/* do great stuff which is ARPHRD_6LOWPAN related */
 	switch (lowpan_priv->lltype) {
@@ -42,8 +45,8 @@ case ARPHRD_6LOWPAN:
 	...
 	}
 	break;
-...
-}
+ ...
+ }
 
 In case of generic 6lowpan branch ("net/6lowpan") you can remove the check
 on ARPHRD_6LOWPAN, because you can be sure that these function are called
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 3ccb89bf5585..cc34c06477eb 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -34,6 +34,7 @@ Contents:
    tls
    tls-offload
    nfc
+   6lowpan
 
 .. only::  subproject and html
 
-- 
2.24.1

