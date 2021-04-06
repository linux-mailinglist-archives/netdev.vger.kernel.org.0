Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F0E355F27
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbhDFW7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232983AbhDFW7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:59:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B980611EE;
        Tue,  6 Apr 2021 22:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617749973;
        bh=nRu36rewHiHvppJj3ayQMlyRrC8vxUGN/RLb5DH6vwE=;
        h=From:To:Cc:Subject:Date:From;
        b=Ha5KamI/9UPPJOKjCt/+yIl2hueqR9iO8pCD5tPh7rYXNnm2En+NCZsdziblFoewA
         PhkkBDCrXaLTqIZmpKyQOrLioh7ekdiRfjt7wHq7huohdZgQjnMTMCIfsOBHjwwzIc
         bIxZE30NRnCah0kHHcCg9QGc0vjY2+NWytd1JOfyJ3WtbJ3hLuDkr3cvRdItPhS6Lo
         OyM9MKi5Bwj3PfLTXb3A9CmUXoEzMFgmiBQFnCzlwOOg+zxgZI4aF5XWG8EyTos3hX
         4PpGPRIrw+gGv4uxLzwv7H5qzht07MaOB6/4d4IooLPQxneK5SkfnbdN+stzoW5cNb
         YOCpVkAOtnP1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        mkubecek@suse.cz, andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] docs: ethtool: correct quotes
Date:   Tue,  6 Apr 2021 15:59:31 -0700
Message-Id: <20210406225931.1846872-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quotes to backticks. All commands use backticks since the names
are constants.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Targeting net-next to avoid conflicts with upcoming patches.

 Documentation/networking/ethtool-netlink.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index dcb75c84c1ca..ce4a69f8308f 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1433,7 +1433,7 @@ are netlink only.
   ``ETHTOOL_PHY_STUNABLE``            n/a
   ``ETHTOOL_GFECPARAM``               ``ETHTOOL_MSG_FEC_GET``
   ``ETHTOOL_SFECPARAM``               ``ETHTOOL_MSG_FEC_SET``
-  n/a                                 ''ETHTOOL_MSG_CABLE_TEST_ACT''
-  n/a                                 ''ETHTOOL_MSG_CABLE_TEST_TDR_ACT''
+  n/a                                 ``ETHTOOL_MSG_CABLE_TEST_ACT``
+  n/a                                 ``ETHTOOL_MSG_CABLE_TEST_TDR_ACT``
   n/a                                 ``ETHTOOL_MSG_TUNNEL_INFO_GET``
   =================================== =====================================
-- 
2.30.2

