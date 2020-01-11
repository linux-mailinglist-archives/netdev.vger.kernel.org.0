Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4C713817A
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 15:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbgAKOIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 09:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729674AbgAKOIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 09:08:11 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BD2F20842;
        Sat, 11 Jan 2020 14:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578751690;
        bh=49yNVjrUNIa8teHfZrhS1FTBl3geKHch17rvqg+qPQM=;
        h=From:To:Cc:Subject:Date:From;
        b=qN5CEyfk6QnsJaQTvacvjf9yKJPGa9PU178+G8A1vDckKwLFkV7Ck1RRogpdc1YOc
         dDUR2lAkoZc1yuOD0JFQioH/OIfW9TyI4mZVm3bSbkcBnNrisG/mr4T4zCD+TuhJ1X
         3bm8HTi1X1OpAXSzMqxpDNkAm7pVhQKSHTJCMLAA=
From:   kuba@kernel.org
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: update my email address
Date:   Sat, 11 Jan 2020 06:07:52 -0800
Message-Id: <20200111140752.137292-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

My Netronome email address may become inactive soon.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .mailmap    |  1 +
 MAINTAINERS | 10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/.mailmap b/.mailmap
index a7bc8cabd157..d9d5c80252f9 100644
--- a/.mailmap
+++ b/.mailmap
@@ -99,6 +99,7 @@ Jacob Shin <Jacob.Shin@amd.com>
 Jaegeuk Kim <jaegeuk@kernel.org> <jaegeuk@google.com>
 Jaegeuk Kim <jaegeuk@kernel.org> <jaegeuk@motorola.com>
 Jaegeuk Kim <jaegeuk@kernel.org> <jaegeuk.kim@samsung.com>
+Jakub Kicinski <kuba@kernel.org> <jakub.kicinski@netronome.com>
 James Bottomley <jejb@mulgrave.(none)>
 James Bottomley <jejb@titanic.il.steeleye.com>
 James E Wilson <wilson@specifix.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 4017e6b760be..7933584afc56 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3150,7 +3150,7 @@ S:	Maintained
 F:	arch/mips/net/
 
 BPF JIT for NFP NICs
-M:	Jakub Kicinski <jakub.kicinski@netronome.com>
+M:	Jakub Kicinski <kuba@kernel.org>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Supported
@@ -11431,7 +11431,7 @@ F:	include/uapi/linux/netrom.h
 F:	net/netrom/
 
 NETRONOME ETHERNET DRIVERS
-M:	Jakub Kicinski <jakub.kicinski@netronome.com>
+M:	Jakub Kicinski <kuba@kernel.org>
 L:	oss-drivers@netronome.com
 S:	Maintained
 F:	drivers/net/ethernet/netronome/
@@ -11591,7 +11591,7 @@ M:	Boris Pismenny <borisp@mellanox.com>
 M:	Aviad Yehezkel <aviadye@mellanox.com>
 M:	John Fastabend <john.fastabend@gmail.com>
 M:	Daniel Borkmann <daniel@iogearbox.net>
-M:	Jakub Kicinski <jakub.kicinski@netronome.com>
+M:	Jakub Kicinski <kuba@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	net/tls/*
@@ -11603,7 +11603,7 @@ L:	linux-wireless@vger.kernel.org
 Q:	http://patchwork.kernel.org/project/linux-wireless/list/
 
 NETDEVSIM
-M:	Jakub Kicinski <jakub.kicinski@netronome.com>
+M:	Jakub Kicinski <kuba@kernel.org>
 S:	Maintained
 F:	drivers/net/netdevsim/*
 
@@ -18042,7 +18042,7 @@ XDP (eXpress Data Path)
 M:	Alexei Starovoitov <ast@kernel.org>
 M:	Daniel Borkmann <daniel@iogearbox.net>
 M:	David S. Miller <davem@davemloft.net>
-M:	Jakub Kicinski <jakub.kicinski@netronome.com>
+M:	Jakub Kicinski <kuba@kernel.org>
 M:	Jesper Dangaard Brouer <hawk@kernel.org>
 M:	John Fastabend <john.fastabend@gmail.com>
 L:	netdev@vger.kernel.org
-- 
2.24.1

