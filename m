Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26811C1883
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729492AbgEAOpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbgEAOpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:05 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE090208DB;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=hboY7LvkSkG+z9pZ1T82TwKQFJjcn1LXM91doMsst3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsPMDGoEYR9sGgftuvVNtqmzF35W8IbmSE422+UronlGfOib3qMp1x43IQZP5kdp3
         ufwypaCJTzjls/26N5M1YHZ9fipdY0NxMAkT5hi88M/aidtscdJ28NbZPpPBvbjhbe
         FpkRdUvezN2TaSInntJZpA85VQs4mdERYz/wpq28=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCd2-Dt; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 08/37] docs: networking: convert xfrm_proc.txt to ReST
Date:   Fri,  1 May 2020 16:44:30 +0200
Message-Id: <b888b39a925d0c8385b9a3fa338edb762cf78a7d.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../{xfrm_proc.txt => xfrm_proc.rst}          | 31 +++++++++++++++++++
 2 files changed, 32 insertions(+)
 rename Documentation/networking/{xfrm_proc.txt => xfrm_proc.rst} (95%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index e31f6cb564b4..3fe70efb632e 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -118,6 +118,7 @@ Contents:
    x25-iface
    x25
    xfrm_device
+   xfrm_proc
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/xfrm_proc.txt b/Documentation/networking/xfrm_proc.rst
similarity index 95%
rename from Documentation/networking/xfrm_proc.txt
rename to Documentation/networking/xfrm_proc.rst
index 2eae619ab67b..0a771c5a7399 100644
--- a/Documentation/networking/xfrm_proc.txt
+++ b/Documentation/networking/xfrm_proc.rst
@@ -1,5 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
 XFRM proc - /proc/net/xfrm_* files
 ==================================
+
 Masahide NAKAMURA <nakam@linux-ipv6.org>
 
 
@@ -14,42 +18,58 @@ as part of the linux private MIB.  These counters can be viewed in
 
 Inbound errors
 ~~~~~~~~~~~~~~
+
 XfrmInError:
 	All errors which is not matched others
+
 XfrmInBufferError:
 	No buffer is left
+
 XfrmInHdrError:
 	Header error
+
 XfrmInNoStates:
 	No state is found
 	i.e. Either inbound SPI, address, or IPsec protocol at SA is wrong
+
 XfrmInStateProtoError:
 	Transformation protocol specific error
 	e.g. SA key is wrong
+
 XfrmInStateModeError:
 	Transformation mode specific error
+
 XfrmInStateSeqError:
 	Sequence error
 	i.e. Sequence number is out of window
+
 XfrmInStateExpired:
 	State is expired
+
 XfrmInStateMismatch:
 	State has mismatch option
 	e.g. UDP encapsulation type is mismatch
+
 XfrmInStateInvalid:
 	State is invalid
+
 XfrmInTmplMismatch:
 	No matching template for states
 	e.g. Inbound SAs are correct but SP rule is wrong
+
 XfrmInNoPols:
 	No policy is found for states
 	e.g. Inbound SAs are correct but no SP is found
+
 XfrmInPolBlock:
 	Policy discards
+
 XfrmInPolError:
 	Policy error
+
 XfrmAcquireError:
 	State hasn't been fully acquired before use
+
 XfrmFwdHdrError:
 	Forward routing of a packet is not allowed
 
@@ -57,26 +77,37 @@ Outbound errors
 ~~~~~~~~~~~~~~~
 XfrmOutError:
 	All errors which is not matched others
+
 XfrmOutBundleGenError:
 	Bundle generation error
+
 XfrmOutBundleCheckError:
 	Bundle check error
+
 XfrmOutNoStates:
 	No state is found
+
 XfrmOutStateProtoError:
 	Transformation protocol specific error
+
 XfrmOutStateModeError:
 	Transformation mode specific error
+
 XfrmOutStateSeqError:
 	Sequence error
 	i.e. Sequence number overflow
+
 XfrmOutStateExpired:
 	State is expired
+
 XfrmOutPolBlock:
 	Policy discards
+
 XfrmOutPolDead:
 	Policy is dead
+
 XfrmOutPolError:
 	Policy error
+
 XfrmOutStateInvalid:
 	State is invalid, perhaps expired
-- 
2.25.4

