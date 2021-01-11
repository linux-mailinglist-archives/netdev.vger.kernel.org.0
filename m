Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A082F0C87
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbhAKF3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:29:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbhAKF3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:29:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F25229CA;
        Mon, 11 Jan 2021 05:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342886;
        bh=ytSScwngMKJLWFP1M4ViMrdpdvck1ZRmBNqGYlZLdB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VE0rJ3pCmrnFMNq0KCz31E5ncyeK2AV7l7+HslSOirvele+C7s6r8CafKaexvjFfN
         /oDmXwcdXh+ttC1sSeeYk1BaAF0QJyTJZuXgqAGuckRwIe8uO1mWdYLNspJ33Aocf1
         8c+FIfo2NOGfSpof2QJ/dzUKDbJeRhneMfONgcehcPhzWLDleUrJo310o0Rb4ntfEK
         KQR1p0EU0AQUYKgrNGoqokVOg9D0fKD6SKDCZ/4oDht2Omjnc6zDCsj3JxRely4ryk
         jlnrbFLxW9IEkpk3URupW9kG3fzc28MhC00gadotFqMJrOfOfO6ctMmdwbsXcuMj/d
         Mci5mYXbi633g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net 9/9] MAINTAINERS: skge/sky2: move Mirko Lindner to CREDITS
Date:   Sun, 10 Jan 2021 21:27:59 -0800
Message-Id: <20210111052759.2144758-10-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111052759.2144758-1-kuba@kernel.org>
References: <20210111052759.2144758-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We haven't heard from Mirko in 6 years.

There are only 57 changes to this driver, but it seems
like a pretty clear cut case.

Subsystem MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
  Changes 11 / 57 (19%)
  Last activity: 2020-11-11
  Mirko Lindner <mlindner@marvell.com>:
  Stephen Hemminger <stephen@networkplumber.org>:
    Author 5aafeb74b5bb 2019-09-24 00:00:00 5
    Tags 0575bedd6a15 2020-11-11 00:00:00 5
  Top reviewers:
    [2]: edumazet@google.com
    [1]: andrew@lunn.ch
  INACTIVE MAINTAINER Mirko Lindner <mlindner@marvell.com>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Mirko Lindner <mlindner@marvell.com>
CC: Stephen Hemminger <stephen@networkplumber.org>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 9add7e6a4fa0..87699f2ee6ad 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2262,6 +2262,10 @@ D: and much more. He was the maintainer of MD from 2016 to 2018. Shaohua
 D: passed away late 2018, he will be greatly missed.
 W: https://www.spinics.net/lists/raid/msg61993.html
 
+N: Mirko Lindner
+E: mlindner@marvell.com
+D: Marvell Gigabit Ethernet drivers (skge/sky2).
+
 N: Stephan Linz
 E: linz@mazet.de
 E: Stephan.Linz@gmx.de
diff --git a/MAINTAINERS b/MAINTAINERS
index 17736ec96ec4..1e0d1e1fcf46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10604,7 +10604,6 @@ F:	drivers/crypto/marvell/
 F:	include/linux/soc/marvell/octeontx2/
 
 MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
-M:	Mirko Lindner <mlindner@marvell.com>
 M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-- 
2.26.2

