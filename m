Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205D837BD38
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 14:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhELMxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 08:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231504AbhELMxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 08:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0448261490;
        Wed, 12 May 2021 12:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620823903;
        bh=P9S9FDPjkGyLPgGS0Ee7GPWkFYrytOORnj43F6Ph9g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/i0bYQzJEf+oPMgJbfcEZMj9nJMClHeAJd6N7TG3sOkWH2pYhds4rR7KcKXZi1ld
         YMXwah/poZy7ExyXbFoFXsBVDp/pIjbnHnPn5DaVYvoabTgnrytJe7BXh/Sd0yI1/l
         tcnMu1Ulul2q3a/g/o6c8/+nfTmiO1rlCuSlO5nL2g5KkRlb21EMaTL8fVcbTWK+US
         x2C1frgjGTqKvHhGj7PEPzykbGwdqPL5qYWFbGwkSUsAECzRzVvDK7+r1lA9QT3Hdz
         5i7zKrOQHTwCLbrNMJJwU1Idq+Hfmhm8J6MfNwaT6v4kH2uvpfhXheAR6NCq3lSufK
         KNrDNNhDimw+Q==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lgoKz-0018iQ-5a; Wed, 12 May 2021 14:51:41 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 25/40] docs: networking: devlink: devlink-dpipe.rst: Use ASCII subset instead of UTF-8 alternate symbols
Date:   Wed, 12 May 2021 14:50:29 +0200
Message-Id: <ac0eb250139c41c6f90a79a187f7e46d8ef38ed8.1620823573.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620823573.git.mchehab+huawei@kernel.org>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion tools used during DocBook/LaTeX/Markdown->ReST conversion
and some automatic rules which exists on certain text editors like
LibreOffice turned ASCII characters into some UTF-8 alternatives that
are better displayed on html and PDF.

While it is OK to use UTF-8 characters in Linux, it is better to
use the ASCII subset instead of using an UTF-8 equivalent character
as it makes life easier for tools like grep, and are easier to edit
with the some commonly used text/source code editors.

Also, Sphinx already do such conversion automatically outside literal blocks:
   https://docutils.sourceforge.io/docs/user/smartquotes.html

So, replace the occurences of the following UTF-8 characters:

	- U+2019 ('’'): RIGHT SINGLE QUOTATION MARK

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/devlink/devlink-dpipe.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-dpipe.rst b/Documentation/networking/devlink/devlink-dpipe.rst
index af37f250df43..2df7cbf1ba70 100644
--- a/Documentation/networking/devlink/devlink-dpipe.rst
+++ b/Documentation/networking/devlink/devlink-dpipe.rst
@@ -52,7 +52,7 @@ purposes as a standard complementary tool. The system's view from
 ``devlink-dpipe`` should change according to the changes done by the
 standard configuration tools.
 
-For example, it’s quite common to  implement Access Control Lists (ACL)
+For example, it's quite common to  implement Access Control Lists (ACL)
 using Ternary Content Addressable Memory (TCAM). The TCAM memory can be
 divided into TCAM regions. Complex TC filters can have multiple rules with
 different priorities and different lookup keys. On the other hand hardware
-- 
2.30.2

