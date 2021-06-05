Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492EE39C876
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 15:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhFENUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 09:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230116AbhFENU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 09:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3519061415;
        Sat,  5 Jun 2021 13:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622899118;
        bh=cv0Fq8XBwwCcSGi4/13mLE9m2cuH8J7MyDsU6+0ZiuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3enBLKV4MqDnjlUp2Ei/hkhU+YELzMKAMzJpVEizYJb59Dv91x8+TWB54IRPLmsg
         yD/XdkbfpaTRxTWpWMUDPFvlnexSTJnIPd+FGUKtloYkKURHOoU4TAoYirja26Yid3
         0OvrjOqA9yBNHvGSInJxFTNnuRMp2O+kyoihHDg4hqsrJTkKeBxKuHzKqoeOCvhk7F
         5TUAkB7YFLTkiNgXM4CEqCoxk48HaYrgF6WtbTsbuuZQrxTmW29o4669F+JnBbCAyN
         c1kTyPN+GygMF8Sj8Ydqbgl/5rIWeQ2l3ADxGLn+mg645+G1tWjjrD1V8ZjRx/mals
         JqQqzzs0FpJSg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lpWCC-008GG5-E5; Sat, 05 Jun 2021 15:18:36 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     "Jonathan Corbet" <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 25/34] docs: networking: devlink: avoid using ReSt :doc:`foo` markup
Date:   Sat,  5 Jun 2021 15:18:24 +0200
Message-Id: <55bd69d386069745dad377f180345f75d27d2d75.1622898327.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622898327.git.mchehab+huawei@kernel.org>
References: <cover.1622898327.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The :doc:`foo` tag is auto-generated via automarkup.py.
So, use the filename at the sources, instead of :doc:`foo`.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/devlink/devlink-region.rst | 2 +-
 Documentation/networking/devlink/devlink-trap.rst   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index 3654c3e9658f..58fe95e9a49d 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -22,7 +22,7 @@ The major benefit to creating a region is to provide access to internal
 address regions that are otherwise inaccessible to the user.
 
 Regions may also be used to provide an additional way to debug complex error
-states, but see also :doc:`devlink-health`
+states, but see also Documentation/networking/devlink/devlink-health.rst
 
 Regions may optionally support capturing a snapshot on demand via the
 ``DEVLINK_CMD_REGION_NEW`` netlink message. A driver wishing to allow
diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 935b6397e8cf..efa5f7f42c88 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -495,8 +495,8 @@ help debug packet drops caused by these exceptions. The following list includes
 links to the description of driver-specific traps registered by various device
 drivers:
 
-  * :doc:`netdevsim`
-  * :doc:`mlxsw`
+  * Documentation/networking/devlink/netdevsim.rst
+  * Documentation/networking/devlink/mlxsw.rst
 
 .. _Generic-Packet-Trap-Groups:
 
-- 
2.31.1

