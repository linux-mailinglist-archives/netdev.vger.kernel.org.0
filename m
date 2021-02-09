Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49323157DD
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbhBIUmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233435AbhBIUez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 15:34:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C76664E0D;
        Tue,  9 Feb 2021 20:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612902851;
        bh=oPjvlMxlIPYt9I59yK+UsEcm/ukx/JEVU6S9XbJEeeA=;
        h=From:To:Cc:Subject:Date:From;
        b=nSTVy4fHLZtQj3DM2v7euw4zRY4Lgda4yYdJOhKMarzA3VEqkRGmEvLsrSVPTt3IL
         B6Vp2kCxoV8QzMnU2KpayX2+wP9FqDHqNxjlzjPA4iQmPhu2e6uygbiiT8gNUEqM6/
         bG7zk7ek1O7BzISKvLPKQhI3b2X3Fpfv5S/OnXa+WZQr7OKGPMYUYFuA6dyATXjFRh
         RpSCO8lfZBX3IrsEFDAsNvVv+uGAzTJS+EUata93PEPBxTDhYMI3JtWSd3lBlDNniK
         eOs2K81hONdsdnQwwpGiLKqXBhGEk6pfgZUcavCaxn1ZfqiGJlkxlBwvxQewvCPgzg
         16xdbsi3r7eWg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] netdev-FAQ: answer some questions about the patchwork checks
Date:   Tue,  9 Feb 2021 12:34:09 -0800
Message-Id: <20210209203409.1716847-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Point out where patchwork bot's code lives, and that we don't want
people posting stuff that doesn't build.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index ae2ae37cd921..a64c01b52b4c 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -272,6 +272,22 @@ user space patches should form separate series (threads) when posted
 Posting as one thread is discouraged because it confuses patchwork
 (as of patchwork 2.2.2).
 
+Can I reproduce the checks from patchwork on my local machine?
+--------------------------------------------------------------
+
+Checks in patchwork are mostly simple wrappers around existing kernel
+scripts, the sources are available at:
+
+https://github.com/kuba-moo/nipa/tree/master/tests
+
+Running all the builds and checks locally is a pain, can I post my patches and have the patchwork bot validate them?
+--------------------------------------------------------------------------------------------------------------------
+
+No, you must ensure that your patches are ready by testing them locally
+before posting to the mailing list. The patchwork build bot instance
+gets overloaded very easily and netdev@vger really doesn't need more
+traffic if we can help it.
+
 Any other tips to help ensure my net/net-next patch gets OK'd?
 --------------------------------------------------------------
 Attention to detail.  Re-read your own work as if you were the
-- 
2.26.2

