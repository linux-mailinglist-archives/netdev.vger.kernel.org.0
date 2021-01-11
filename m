Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4A82F0C7C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbhAKF2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbhAKF2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:28:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ABA1225AB;
        Mon, 11 Jan 2021 05:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342883;
        bh=6sNBeFdrVXPxgS59xVd078bOMwdGAYHFCWY6SjY4Aqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+fCS1INZ7aiEiRb+wzlbgMplBnlHHuVqqWGnBoVxO7ON+FT4Ggx3eGKb8away2kZ
         gUAon/9uMuWUDkupEeYtWPhCN3UjKgF+E9EYH/nyhf9ckkUgDje9epC2XVRD9ujf89
         2TR1RG8KL8Lou3f4olyKkZy9N7O70G8+LL2acqWty0sT1q4DZ7yGFw5IDjN9JhT+Mx
         VninL6jQ1RQ8RgS7H3faZ+m+gygwJuV+nXV5SNriZqUgLb2fWQtle9A0QisxvA5Du/
         Gi5cBjGPx3gbXe7YgP4zLAmQVr11Kvy0GOKNymFx/oFEEKkKUEGvZsSoT6HbUSn5Nj
         mbryHODkYdrVw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Subject: [PATCH net 1/9] MAINTAINERS: altx: move Jay Cliburn to CREDITS
Date:   Sun, 10 Jan 2021 21:27:51 -0800
Message-Id: <20210111052759.2144758-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111052759.2144758-1-kuba@kernel.org>
References: <20210111052759.2144758-1-kuba@kernel.org>
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
---
CC: Jay Cliburn <jcliburn@gmail.com>
CC: Chris Snook <chris.snook@gmail.com>
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

