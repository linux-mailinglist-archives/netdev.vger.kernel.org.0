Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19A33A9264
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhFPGaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231672AbhFPG3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 02:29:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A00A661417;
        Wed, 16 Jun 2021 06:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623824868;
        bh=cv0Fq8XBwwCcSGi4/13mLE9m2cuH8J7MyDsU6+0ZiuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFNh0LFNMxExEyjMTk405opmQBIURkA6aKBEpn5qjxgY7L0szMYGtlpdDfEPhQmt+
         QNV3L6nML0NY+CDvDgPbs3wV8Znc95iPBvPHJy05qtdYI9TjGoptKP1jDpv6D7yMqA
         G4yE6rFbFt0ua2EEpDdStTr1EJA8wUG+EpB9qYXhAdH85mUn4RvjEcwn1US1uJGat2
         YiVvjk0BDimButJ4TALG8YYvIzANXfYQgvfJDXJoBByiBeFagqF8EkijORZnnK5Sly
         ZR9mx96MS6f2D/Mpu0JFx6AAgkFF3digIKmzGuZiyrRtYNpxnCM7fUuKFUmNfv8qCp
         uygNbuJu69eTA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1ltP1e-004kJa-TF; Wed, 16 Jun 2021 08:27:46 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 20/29] docs: networking: devlink: avoid using ReST :doc:`foo` markup
Date:   Wed, 16 Jun 2021 08:27:35 +0200
Message-Id: <4553858bc9a5442eba6d71caff8047e84ece4d9b.1623824363.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623824363.git.mchehab+huawei@kernel.org>
References: <cover.1623824363.git.mchehab+huawei@kernel.org>
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

