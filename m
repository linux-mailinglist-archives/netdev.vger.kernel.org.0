Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5842F56AA
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbhANBux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:50:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbhANBuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 381902075E;
        Thu, 14 Jan 2021 01:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610588966;
        bh=HGMJeQ8e3q7zdlYhm3Kud5OAXcaI5a4RohcTtzmUELI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sak6hbxgMKiE8tuTrVlRxOdbX1hj0TwECu7UqyM6jQDMeMqEkw8FNeKzTRG6zXVzP
         Xoff0UR7T83ak2MAKfMpr5ZsPJXTmGHB4zNlVaetWtZM9C6ElcM0hcvtHat2tKyfpq
         HUcVn0xHm3iDS/XQNWWbP/3OR0NhzBq3QHJR2SxQ8Lum+6kLrFkqCYYqldzTnpELoL
         co6rP+DaAB+mmRam+Dm5YejMBt/QROupi6WrO43yE/9HByFiIhM8vbj20nz/MZeIL6
         evn0Y6v5OgabkIvGxkDZLox+C5StYiwjBdf1OFV7wo3foGNE8NimYdfwSkjskmcxfW
         ddalVOMMik34Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>
Subject: [PATCH net v2 4/7] MAINTAINERS: ena: remove Zorik Machulsky from reviewers
Date:   Wed, 13 Jan 2021 17:49:09 -0800
Message-Id: <20210114014912.2519931-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114014912.2519931-1-kuba@kernel.org>
References: <20210114014912.2519931-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While ENA has 3 reviewers and 2 maintainers, we mostly see review
tags and comments from the maintainers. While we very much appreciate
Zorik's invovment in the community let's trim the reviewer list
down to folks we've seen tags from.

Subsystem AMAZON ETHERNET DRIVERS
  Changes 13 / 269 (4%)
  Last activity: 2020-11-24
  Netanel Belgazal <netanel@amazon.com>:
    Author 24dee0c7478d 2019-12-10 00:00:00 43
    Tags 0e3a3f6dacf0 2020-07-21 00:00:00 47
  Arthur Kiyanovski <akiyano@amazon.com>:
    Author 0e3a3f6dacf0 2020-07-21 00:00:00 79
    Tags 09323b3bca95 2020-11-24 00:00:00 104
  Guy Tzalik <gtzalik@amazon.com>:
    Tags 713865da3c62 2020-09-10 00:00:00 3
  Saeed Bishara <saeedb@amazon.com>:
    Tags 470793a78ce3 2020-02-11 00:00:00 2
  Zorik Machulsky <zorik@amazon.com>:
  Top reviewers:
    [4]: sameehj@amazon.com
    [3]: snelson@pensando.io
    [3]: shayagr@amazon.com
  INACTIVE MAINTAINER Zorik Machulsky <zorik@amazon.com>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Netanel Belgazal <netanel@amazon.com>
CC: Arthur Kiyanovski <akiyano@amazon.com>
CC: Guy Tzalik <gtzalik@amazon.com>
CC: Saeed Bishara <saeedb@amazon.com>
CC: Zorik Machulsky <zorik@amazon.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a06faf9e2018..64dd19dfc9c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -820,7 +820,6 @@ M:	Netanel Belgazal <netanel@amazon.com>
 M:	Arthur Kiyanovski <akiyano@amazon.com>
 R:	Guy Tzalik <gtzalik@amazon.com>
 R:	Saeed Bishara <saeedb@amazon.com>
-R:	Zorik Machulsky <zorik@amazon.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/amazon/ena.rst
-- 
2.26.2

