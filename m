Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA91E1547D6
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgBFPT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38016 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vsCJgMod9IRhYUs+7Ev711kOL2gRDtBSktRiz7ZiI1U=; b=MLF394YzkvykV73u70f90/+/WV
        sAr4fjOlozsB96cEQaPy+RwZTAUv256MFwyeABY1RJuCkAiYZ7dqfyIaNJjDNTrUnP4cAeDw9SQC+
        2HmJIKdTSnV8IvXaJolkKOwFomjfiPj3XZcved/qWwe27TcMrC0rOjoC8jIvBuDMdHFVLhG0L6Qqt
        KlOMdJ+KQPUEefIqQgKqtUegSVSRpn7Jp6sk4GZ4fKb1TrtTZHfC9xyUA7Rrj0U9kg/T7j1fwim6o
        W58XUQsnQ/3+y57C15xAomr97dH7d8BYh/69/GFrEhzZYQAckcOOaQFxWpiop70n7OGczVYs7P/op
        Fhv2/b2Q==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziuk-0005jB-VS; Thu, 06 Feb 2020 15:17:58 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVF-2Y; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 08/28] docs: networking: convert ax25.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:28 +0100
Message-Id: <2d570e7948cbe3f2d59beff75bab2ddafbe22d55.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There isn't much to be done here. Just:

- add SPDX header;
- add a document title.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/{ax25.txt => ax25.rst} | 6 ++++++
 Documentation/networking/index.rst              | 1 +
 2 files changed, 7 insertions(+)
 rename Documentation/networking/{ax25.txt => ax25.rst} (91%)

diff --git a/Documentation/networking/ax25.txt b/Documentation/networking/ax25.rst
similarity index 91%
rename from Documentation/networking/ax25.txt
rename to Documentation/networking/ax25.rst
index 8257dbf9be57..824afd7002db 100644
--- a/Documentation/networking/ax25.txt
+++ b/Documentation/networking/ax25.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====
+AX.25
+=====
+
 To use the amateur radio protocols within Linux you will need to get a
 suitable copy of the AX.25 Utilities. More detailed information about
 AX.25, NET/ROM and ROSE, associated programs and and utilities can be
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 41386bff41f2..1e0fc66739cc 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -40,6 +40,7 @@ Contents:
    arcnet-hardware
    arcnet
    atm
+   ax25
 
 .. only::  subproject and html
 
-- 
2.24.1

