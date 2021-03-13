Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EEE339A72
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 01:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhCMAas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 19:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231679AbhCMAac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 19:30:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E636A64F64;
        Sat, 13 Mar 2021 00:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615595431;
        bh=IGgof+EelZYWTOUwXFrfa+YA+gAvftdWyUJ0XPo3pdY=;
        h=From:To:Cc:Subject:Date:From;
        b=VW1RQttVXtSZQcEtqp2MNbdvV9Tobyj4fJypYnn7KiekWQ0Q10AL2HMVZCZNVB9Sq
         TKZ7zSh/Tx63HoRabD79d3YvtUS3lEkqfd3Z+9Yl7rCvs1vlq5iwTHUcVQSS/w+Pjc
         D6RHAEAy15xITKcYaZ5fDqYlJJejOTTEZEqVgYB6sLQipr6U/UMtU4irBadHaXPppU
         VRHNUACUxlrelEx3zhK+Ml+qXpk/5V1A7h6qLpWOldqa5ws6rF9hA/dt++LhdRMZI7
         hYX/+foq3OJjJhr6IL0zi3d0ylr/tf5e6b5mhzdlZS3IXMGiqK4in66PeHZyQUwwGX
         4VeCYwVaruaZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, eranbe@nvidia.com,
        jiri@nvidia.com, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/2] docs: net: tweak devlink health documentation
Date:   Fri, 12 Mar 2021 16:30:25 -0800
Message-Id: <20210313003026.1685290-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor tweaks and improvement of wording about the diagnose callback.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/devlink/devlink-health.rst | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-health.rst b/Documentation/networking/devlink/devlink-health.rst
index 0c99b11f05f9..d52c9a605188 100644
--- a/Documentation/networking/devlink/devlink-health.rst
+++ b/Documentation/networking/devlink/devlink-health.rst
@@ -24,7 +24,7 @@ attributes of the health reporting and recovery procedures.
 
 The ``devlink`` health reporter:
 Device driver creates a "health reporter" per each error/health type.
-Error/Health type can be a known/generic (eg pci error, fw error, rx/tx error)
+Error/Health type can be a known/generic (e.g. PCI error, fw error, rx/tx error)
 or unknown (driver specific).
 For each registered health reporter a driver can issue error/health reports
 asynchronously. All health reports handling is done by ``devlink``.
@@ -48,6 +48,7 @@ Actions
   * Object dump is being taken and saved at the reporter instance (as long as
     there is no other dump which is already stored)
   * Auto recovery attempt is being done. Depends on:
+
     - Auto-recovery configuration
     - Grace period vs. time passed since last recover
 
@@ -72,14 +73,14 @@ User can access/change each reporter's parameters and driver specific callbacks
    * - ``DEVLINK_CMD_HEALTH_REPORTER_SET``
      - Allows reporter-related configuration setting.
    * - ``DEVLINK_CMD_HEALTH_REPORTER_RECOVER``
-     - Triggers a reporter's recovery procedure.
+     - Triggers reporter's recovery procedure.
    * - ``DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE``
-     - Retrieves diagnostics data from a reporter on a device.
+     - Retrieves current device state related to the reporter.
    * - ``DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET``
      - Retrieves the last stored dump. Devlink health
-       saves a single dump. If an dump is not already stored by the devlink
+       saves a single dump. If an dump is not already stored by devlink
        for this reporter, devlink generates a new dump.
-       dump output is defined by the reporter.
+       Dump output is defined by the reporter.
    * - ``DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR``
      - Clears the last saved dump file for the specified reporter.
 
@@ -93,7 +94,7 @@ User can access/change each reporter's parameters and driver specific callbacks
                                           +--------------------------+
                                                        |request for ops
                                                        |(diagnose,
-     mlx5_core                             devlink     |recover,
+      driver                               devlink     |recover,
                                                        |dump)
     +--------+                            +--------------------------+
     |        |                            |    reporter|             |
-- 
2.30.2

