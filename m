Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966361547BA
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgBFPSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38066 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qBT8hXW0utD0sQMt8fDsSEi1NxQdqsHcjdFdMI3bOsE=; b=fmRZCfRtkomoh3HfCGzMQrfDqO
        oH4kbl10zhC74TYWCrjhl0UaIe6XO3xjuVJUpbTlNF31TO2wm4ekMTvAUXcq7C3qTKihkfL0OqZil
        DS92TK6AEHJYT0M4LDn21MWiWMAkOHGNMfx+HrtFDoY5D6kr3UecKq4W6Hvrl7I/9Ga/u7bsO1DEE
        L69B6/lBZmuaTHadfl/gDiFwf0wmY4nP34ALflUeqN0nKeHXh9cKBQusfl7xL9KS3MHQpKkavryyw
        /iOmDTmhO+ky0jEanlQL8/upQP3UGiJ8ZiseMQYI1zftZxaNZuJA9523h/+msFc+SnY1cTjH4Xhhz
        wbeoO82A==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jJ-B7; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVB-1B; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 07/28] docs: networking: convert atm.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:27 +0100
Message-Id: <e771aefe31b94ae0989e52c21a7f0a0b0f09ea68.1581002063.git.mchehab+huawei@kernel.org>
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
 Documentation/networking/{atm.txt => atm.rst} | 6 ++++++
 Documentation/networking/index.rst            | 1 +
 2 files changed, 7 insertions(+)
 rename Documentation/networking/{atm.txt => atm.rst} (89%)

diff --git a/Documentation/networking/atm.txt b/Documentation/networking/atm.rst
similarity index 89%
rename from Documentation/networking/atm.txt
rename to Documentation/networking/atm.rst
index 82921cee77fe..c1df8c038525 100644
--- a/Documentation/networking/atm.txt
+++ b/Documentation/networking/atm.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===
+ATM
+===
+
 In order to use anything but the most primitive functions of ATM,
 several user-mode programs are required to assist the kernel. These
 programs and related material can be found via the ATM on Linux Web
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index fb35cfc5d0a0..41386bff41f2 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -39,6 +39,7 @@ Contents:
    altera_tse
    arcnet-hardware
    arcnet
+   atm
 
 .. only::  subproject and html
 
-- 
2.24.1

