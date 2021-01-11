Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439262F0C7D
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbhAKF2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbhAKF2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:28:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7E30227C3;
        Mon, 11 Jan 2021 05:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342884;
        bh=Vw2E/ouTW/PC+Jp+s1+TS7p+8aaujpRUFsWu2ikmoMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlH1n6flRULnt4ISBLWm8A7nNXMF/A5NjfTKyqVI2wKiQUtYDMECL7VzeK4ZzrgIi
         so2UTxvGpGdyd81gUiOTE5XqzUzzYW4b5ODP2Pczo97B/VjrO0dCZQ5NZt/5o/aHWp
         A8bqty/OV1JqJDnjogGPemLSKJ28SyrRCJk+L/UA8bPAoHgJuqU1BRyVM4J0QGlrdV
         Wp3Uoh9OfmEbqSVGZN4+YIkp6WuhQ4Icl8/Mp7PBWmon1sMvGHT2Xlw/26A7kqCpib
         eCugHGijssnBQC6P9c3aYgvxp0XXPWRoVHFlDxydxTDd89A+eO7Jk6vXQn2sjGSVPG
         QjFafJFJyIPHQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net 3/9] MAINTAINERS: vrf: move Shrijeet to CREDITS
Date:   Sun, 10 Jan 2021 21:27:53 -0800
Message-Id: <20210111052759.2144758-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111052759.2144758-1-kuba@kernel.org>
References: <20210111052759.2144758-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shrijeet has moved on from VRF-related work.

Subsystem VRF
  Changes 30 / 120 (25%)
  Last activity: 2020-12-09
  David Ahern <dsahern@kernel.org>:
    Author 1b6687e31a2d 2020-07-23 00:00:00 1
    Tags 9125abe7b9cb 2020-12-09 00:00:00 4
  Shrijeet Mukherjee <shrijeet@gmail.com>:
  Top reviewers:
    [13]: dsahern@gmail.com
    [4]: dsa@cumulusnetworks.com
  INACTIVE MAINTAINER Shrijeet Mukherjee <shrijeet@gmail.com>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Shrijeet Mukherjee <shrijeet@gmail.com>
CC: David Ahern <dsahern@kernel.org>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 3dceea737694..98e7485ec106 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2704,6 +2704,10 @@ N: Wolfgang Muees
 E: wolfgang@iksw-muees.de
 D: Auerswald USB driver
 
+N: Shrijeet Mukherjee
+E: shrijeet@gmail.com
+D: Network routing domains (VRF).
+
 N: Paul Mundt
 E: paul.mundt@gmail.com
 D: SuperH maintainer
diff --git a/MAINTAINERS b/MAINTAINERS
index c6e7f6bf7f6d..a06faf9e2018 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19056,7 +19056,6 @@ K:	regulator_get_optional
 
 VRF
 M:	David Ahern <dsahern@kernel.org>
-M:	Shrijeet Mukherjee <shrijeet@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/vrf.rst
-- 
2.26.2

