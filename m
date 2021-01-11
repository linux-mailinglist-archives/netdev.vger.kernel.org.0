Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107892F0C86
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbhAKF30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:29:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhAKF3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4D44229EF;
        Mon, 11 Jan 2021 05:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342885;
        bh=uvpFKpZIYnYAfE+BZMDDN1ummCwtUM1Hwvisj/xH0IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCjUX0WQwe5YDKVeK0DKGFLS89Xak7GXV4HmisMb77mnSYLTT9M6nxI+bokuy5PVB
         vapF8hOVqSIQ2NUeyude4ViA+B7FISyVu+iaLuF/ojkvKUaCC+utDrWiz+u8A6mNrZ
         //8D/lkTpPpH1EdIdBSNpxQ3NlrbRTH3LabJYlaLBcPSDG04Zp/EDTMnJMSMSnGfiW
         VxhckRoJ1KQ1kZRDAhoAfB0Q0YzPzyWuxUwo+L9VfzW0e+fT/Wc1gd38FSfhp/0ebr
         J9xDStbuOP/PEXJp6kZUJjoBKt0fAp4FyubMHAiQ/ALSyR8wz1vKkSEU3S32khxl5I
         ooJ1bYY9hQP5Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net 5/9] MAINTAINERS: tls: move Aviad to CREDITS
Date:   Sun, 10 Jan 2021 21:27:55 -0800
Message-Id: <20210111052759.2144758-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111052759.2144758-1-kuba@kernel.org>
References: <20210111052759.2144758-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aviad wrote parts of the initial TLS implementation
but hasn't been contributing to TLS since.

Subsystem NETWORKING [TLS]
  Changes 123 / 308 (39%)
  Last activity: 2020-12-01
  Boris Pismenny <borisp@nvidia.com>:
    Tags 138559b9f99d 2020-11-17 00:00:00 1
  Aviad Yehezkel <aviadye@nvidia.com>:
  John Fastabend <john.fastabend@gmail.com>:
    Author e91de6afa81c 2020-06-01 00:00:00 22
    Tags e91de6afa81c 2020-06-01 00:00:00 29
  Daniel Borkmann <daniel@iogearbox.net>:
    Author c16ee04c9b30 2018-10-20 00:00:00 7
    Committer b8e202d1d1d0 2020-02-21 00:00:00 19
    Tags b8e202d1d1d0 2020-02-21 00:00:00 28
  Jakub Kicinski <kuba@kernel.org>:
    Author 5c39f26e67c9 2020-11-27 00:00:00 89
    Committer d31c08007523 2020-12-01 00:00:00 15
    Tags d31c08007523 2020-12-01 00:00:00 117
  Top reviewers:
    [50]: dirk.vandermerwe@netronome.com
    [26]: simon.horman@netronome.com
    [14]: john.hurley@netronome.com
  INACTIVE MAINTAINER Aviad Yehezkel <aviadye@nvidia.com>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Aviad Yehezkel <aviadye@nvidia.com>
CC: Boris Pismenny <borisp@nvidia.com>
CC: John Fastabend <john.fastabend@gmail.com>
CC: Daniel Borkmann <daniel@iogearbox.net>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 98e7485ec106..90384691876c 100644
--- a/CREDITS
+++ b/CREDITS
@@ -4122,6 +4122,10 @@ S: B-1206 Jingmao Guojigongyu
 S: 16 Baliqiao Nanjie, Beijing 101100
 S: People's Repulic of China
 
+N: Aviad Yehezkel
+E: aviadye@nvidia.com
+D: Kernel TLS implementation and offload support.
+
 N: Victor Yodaiken
 E: yodaiken@fsmlabs.com
 D: RTLinux (RealTime Linux)
diff --git a/MAINTAINERS b/MAINTAINERS
index 64dd19dfc9c3..92fdc134ca14 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12472,7 +12472,6 @@ F:	net/ipv6/tcp*.c
 
 NETWORKING [TLS]
 M:	Boris Pismenny <borisp@nvidia.com>
-M:	Aviad Yehezkel <aviadye@nvidia.com>
 M:	John Fastabend <john.fastabend@gmail.com>
 M:	Daniel Borkmann <daniel@iogearbox.net>
 M:	Jakub Kicinski <kuba@kernel.org>
-- 
2.26.2

