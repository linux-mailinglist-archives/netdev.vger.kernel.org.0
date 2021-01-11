Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6EB2F0C85
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbhAKF3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:29:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbhAKF3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9FF4225AC;
        Mon, 11 Jan 2021 05:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342885;
        bh=SyB95GF/b1BdS3Toh2nKj6JApUe2Ipjjc0ztpUVfpjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ihjf6RW42E4SC8/eD5ac7865n6iHngTvEWgAit2wxupWZ+OStpi5M1KRGvMlN/c87
         d85diDMUB+GTHDU2FPuY9ouN+TptG9WRHFQ0AYMLQDjAvQoYU9ne51ovkcc5kGrbBr
         VEmc0RrtUt5SJE0ARJb+Bx/X6WGhq83qf+4ODH2hYq7GTh2eAo5XAyF1fAoK2LJhEv
         109Fl9Z96AnqzIpmVUzEVkNrseQ7hrY9HF3r8OGUeq7rwlC3GlZkCnjBLGMR5LVqI2
         78XmXN2bMCDy3n1fagpXw+siI5xFZK7+O0k+MBM3lNsA8dpny8bjDx1eqmUSwpb5k8
         Y/bqZsukR1aSA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>
Subject: [PATCH net 7/9] MAINTAINERS: ipvs: move Wensong Zhang to CREDITS
Date:   Sun, 10 Jan 2021 21:27:57 -0800
Message-Id: <20210111052759.2144758-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111052759.2144758-1-kuba@kernel.org>
References: <20210111052759.2144758-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move Wensong Zhang to credits, we haven't heard from
him in years.

Subsystem IPVS
  Changes 83 / 226 (36%)
  Last activity: 2020-11-27
  Wensong Zhang <wensong@linux-vs.org>:
  Simon Horman <horms@verge.net.au>:
    Committer c24b75e0f923 2019-10-24 00:00:00 33
    Tags 7980d2eabde8 2020-10-12 00:00:00 76
  Julian Anastasov <ja@ssi.bg>:
    Author 7980d2eabde8 2020-10-12 00:00:00 26
    Tags 4bc3c8dc9f5f 2020-11-27 00:00:00 78
  Top reviewers:
    [6]: horms+renesas@verge.net.au
  INACTIVE MAINTAINER Wensong Zhang <wensong@linux-vs.org>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Wensong Zhang <wensong@linux-vs.org>
CC: Simon Horman <horms@verge.net.au>
CC: Julian Anastasov <ja@ssi.bg>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 90384691876c..ce8eae8c5aa4 100644
--- a/CREDITS
+++ b/CREDITS
@@ -4183,6 +4183,10 @@ S: 1507 145th Place SE #B5
 S: Bellevue, Washington 98007
 S: USA
 
+N: Wensong Zhang
+E: wensong@linux-vs.org
+D: IP virtual server (IPVS).
+
 N: Haojian Zhuang
 E: haojian.zhuang@gmail.com
 D: MMP support
diff --git a/MAINTAINERS b/MAINTAINERS
index b3e88594808a..a5d69857f85a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9325,7 +9325,6 @@ W:	http://www.adaptec.com/
 F:	drivers/scsi/ips*
 
 IPVS
-M:	Wensong Zhang <wensong@linux-vs.org>
 M:	Simon Horman <horms@verge.net.au>
 M:	Julian Anastasov <ja@ssi.bg>
 L:	netdev@vger.kernel.org
-- 
2.26.2

