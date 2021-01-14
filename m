Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5452F56A3
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbhANBuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbhANBuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:50:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF4442343F;
        Thu, 14 Jan 2021 01:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610588965;
        bh=+ewwbscJG8gN79Z/7/M0nsiaIH7FkPETo2tfMBdeq1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCy53TMNbE/MQAxvMVOJvjqPSfwpyS5C/uh1+rKw6InXd50MfBZ7uVpGO57ywxyxC
         xyLSOxIflWbkULS4IP2NkAIMCA8JmHvvFq2Z3rAA7zHDoN1JOIb5AJSZSiqw/KaAZy
         knl9uKGuk6atJ0qrv3HWLhB7rtgo9dBa8Y2Ew57m5OXAtKyuHFpf7u1PYq7mqbEItJ
         b/Rd1J/cPmr6N78tLsqIZtwZnPZiWADkKl7ZBZv70CLPElfbLORe0gCXqVhvU3Wj6A
         6kHRBISWA2iFafDWlPlqCWwuIxmzK/3dbmF2LUlGZOzyu2qofHaiWduimWHTUywyxD
         KygXU+iKEpmEQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Chris Snook <chris.snook@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>
Subject: [PATCH net v2 1/7] MAINTAINERS: altx: move Jay Cliburn to CREDITS
Date:   Wed, 13 Jan 2021 17:49:06 -0800
Message-Id: <20210114014912.2519931-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114014912.2519931-1-kuba@kernel.org>
References: <20210114014912.2519931-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jay was not active in recent years and does not have plans
to return to work on ATLX drivers.

Subsystem ATLX ETHERNET DRIVERS
  Changes 20 / 116 (17%)
  Last activity: 2020-02-24
  Jay Cliburn <jcliburn@gmail.com>:
  Chris Snook <chris.snook@gmail.com>:
    Tags ea973742140b 2020-02-24 00:00:00 1
  Top reviewers:
    [4]: andrew@lunn.ch
    [2]: kuba@kernel.org
    [2]: o.rempel@pengutronix.de
  INACTIVE MAINTAINER Jay Cliburn <jcliburn@gmail.com>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Chris Snook <chris.snook@gmail.com>
---
CC: Jay Cliburn <jcliburn@gmail.com>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 090ed4b004a5..59a704a45170 100644
--- a/CREDITS
+++ b/CREDITS
@@ -710,6 +710,10 @@ S: Las Cuevas 2385 - Bo Guemes
 S: Las Heras, Mendoza CP 5539
 S: Argentina
 
+N: Jay Cliburn
+E: jcliburn@gmail.com
+D: ATLX Ethernet drivers
+
 N: Steven P. Cole
 E: scole@lanl.gov
 E: elenstev@mesatop.com
diff --git a/MAINTAINERS b/MAINTAINERS
index b15514a770e3..57e17762d411 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2942,7 +2942,6 @@ S:	Maintained
 F:	drivers/hwmon/asus_atk0110.c
 
 ATLX ETHERNET DRIVERS
-M:	Jay Cliburn <jcliburn@gmail.com>
 M:	Chris Snook <chris.snook@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-- 
2.26.2

