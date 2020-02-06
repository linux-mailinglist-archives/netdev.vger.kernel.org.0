Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804DF15477C
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBFPSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38040 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1TqEDFg01vvnrBEbOBulEVHvDLAjKXC9WfKwX3sDMXM=; b=bSq1kH/LJmiReSNeOunn5cO9+c
        ojmkO67+QFBT0RFPZGmlw+VpUnJx7ahZfJo5PkZeJXHS1LLQgvadJUEzAN0Ya2PLpPQsLeIkRE8aG
        nEhswZ11P7L0QKNeWiy/PDLYcBA8n4zxNshp+Sy1foWxV4HSGFDPjInYAhH3Aq014d32LUBMxuIk8
        oHS9/+4RD7MWz8SqQtL5TbApCl/8gnj+ctb9m4QJg/twku48r11E3pCIF3lfMX96D5qN2S/x9hqQg
        Zz9CPHgGJ39GpEb2gJQ0p48Z1Xe2mv5G3A0Fahh6ELiX7JQHK9G9DIKFzDGShInijFNO6acy41Sh4
        LD/V+vxQ==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005ja-3W; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVp-HE; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 17/28] docs: networking: convert defza.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:37 +0100
Message-Id: <b48d3468376bd16ea001b6ee0ab68fa9f06850a8.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not much to be done here:

- add SPDX header;
- add a document title;
- use :field: markup for the version number;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/{defza.txt => defza.rst} | 8 +++++++-
 Documentation/networking/index.rst                | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)
 rename Documentation/networking/{defza.txt => defza.rst} (91%)

diff --git a/Documentation/networking/defza.txt b/Documentation/networking/defza.rst
similarity index 91%
rename from Documentation/networking/defza.txt
rename to Documentation/networking/defza.rst
index 663e4a906751..73c2f793ea26 100644
--- a/Documentation/networking/defza.txt
+++ b/Documentation/networking/defza.rst
@@ -1,4 +1,10 @@
-Notes on the DEC FDDIcontroller 700 (DEFZA-xx) driver v.1.1.4.
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================================================
+Notes on the DEC FDDIcontroller 700 (DEFZA-xx) driver
+=====================================================
+
+:Version: v.1.1.4
 
 
 DEC FDDIcontroller 700 is DEC's first-generation TURBOchannel FDDI
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 3acf02aaacee..198851d45b26 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -49,6 +49,7 @@ Contents:
    dccp
    dctcp
    decnet
+   defza
 
 .. only::  subproject and html
 
-- 
2.24.1

