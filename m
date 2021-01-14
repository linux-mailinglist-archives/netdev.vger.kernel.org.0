Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CFF2F56AC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbhANBuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727457AbhANBuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C311235FF;
        Thu, 14 Jan 2021 01:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610588967;
        bh=C5+s0PAMidhIwIYtcL/rpfHpRYh4nXlftK0MEQM4/Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+QbSREXoR6o++6vJzdPKJIy45JTylxu34QClK26Mo15xBowDQDUxoIvZ6Gt/b4Aj
         GiG+CpJuCjHfUmKcR/7XW97AY3foj+Y5QTje6kXLrbF2Re/uNYKXpQoNXm3x9fxf/s
         L2q256GKuaYS/fFQEK/XFoFtnMYkpaDjN/fnAXkM/P9TPSq8hT/lJmAtX2ZXgOCUXT
         Zy7nvXetnQpfREGDM5jmshfKfUaLRhhx4rkzf8fqrARqIQikj+81ixGUyGeBmvuzp/
         HnI5inNbUtNDHrmHVTvKUZy2kHvAIViPb26eUb4Rj4l5uMCGRqNGPiOXycfIAZH1my
         y/OqK+dtmguGw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>
Subject: [PATCH net v2 6/7] MAINTAINERS: ipvs: move Wensong Zhang to CREDITS
Date:   Wed, 13 Jan 2021 17:49:11 -0800
Message-Id: <20210114014912.2519931-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114014912.2519931-1-kuba@kernel.org>
References: <20210114014912.2519931-1-kuba@kernel.org>
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
index 92fdc134ca14..18e75e29c672 100644
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

