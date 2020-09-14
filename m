Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0BE26974C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgINVCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:02:30 -0400
Received: from mout.gmx.net ([212.227.17.20]:57177 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgINVCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1600117316;
        bh=JmaF7j7XQXfSM9pxvN8XXHJ6ixxgG4k1NYzPaQrsoE8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=H0bgSBCPLOVxKiDNk01Ku7nBeMgaXu/ID1gXBn9M60SPvZ7eQMNSBIufqzbdWdOIn
         q1DpAXaSJILEnxNHWeqJCpMyqn0wDbbXiPZA9Rwzyb6vxU/jA5wzprddZDFmciJC4p
         YbA1QEHE31rh0FyFvH2a73uquVSJ3Ail3ZoPvS0w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([79.242.188.32]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MSKu0-1k6syy1k76-00Sgw4; Mon, 14 Sep 2020 23:01:56 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5 3/6] 8390: Replace version string with MODULE_* macros
Date:   Mon, 14 Sep 2020 23:01:25 +0200
Message-Id: <20200914210128.7741-4-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200914210128.7741-1-W_Armin@gmx.de>
References: <20200914210128.7741-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jNNF3hKad1a/mSMVFbeuJFKofZaY5X/TQLCLV2RDt4l6jyWrrru
 wdKGPIHbOypIOmB2QjuajMfXZ6zh519HRL1MJH8GSxW82kk19e+sISZN4sDQ6W1iXu7JVGo
 IUaURFRM2IwzfVfoHhseMJmSqmUtXwFAVVp5G8vXHokpccc66UZCVuhWh4CX2Kue64ou8y1
 M2ZtlOUHoF+OqpmxIr9Ow==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2m35YEGXlAU=:y4kYq5xwPKwaHHAXiN+OJc
 gQAF+DvAq+c8IXeXT7xVNvTZ1F5fDudaTkMwF8m4LERR23SMsh6tYXsgBNiBjOQ+JQuPDdHTx
 78v7VuspVQ6fZkXQwq+OCNm8hlqpj0lm76Crjjv6bsNHjT4qpYZh0+SwBaPiZu+3ysgJ+iEx5
 Bt6gPs0Otyc3fnzCAwaQ4lKT71HdPXbRwURdcjCkkIF9HdoBJZiKfYXPXtM+GpmwbTHor2LU5
 YS+cgr/KxV4VehnWJvZi/fbF5eN9fawcxto80ZMdMjppSGmDYLPydZ8KKXwiJP1tPTa1y5Qpe
 I+woPzUQCLOr8pABezRQk5IvTJpr1hM/ZUByzfP5NDLaN/KQ116zG3VaDFwzt75/euCNFKXPb
 M+Fsig57VH/Qem+gXJN3rZCw0PIXpSKWbigO97b7GHfD/XOCtAa6xCIpHJtIY3A6U0Im0L++B
 dlFUxZBAcqHqBT65CtRS3fEUvMgRCoAp23W8A0r76jcFB94+vdGUcAit5B1So+iPjr+SR4jpE
 XbunUgFhPgRPRU7P07sN/8pDEByxYkrPbC75vd3lobHDfYKgkCw3UV9OypPOv0X3ALpwH0wvh
 Y7kgGMouhOi388/U+je3gI92Uu2j50bqQdZKzx9WX/1sVuh6eWtnYT+iVjOtxoV+EndN/c2vT
 962w1jh6b+cNJvTLGXOtcRbFqRLcPditUjs1WWRpu5CbzbkXcIF+9PxRGDi3vL+B/wprc4mRU
 6mz+94PeXuvtKmoevbdw5h1Dq2S3I/YUO9W/p3J73kHxMGnvO+9aiq0MfzI7nZquri94puzMA
 wGZIboqHaUQ8h76hmSwJVMV7lLKY+uEjZLEbZDWjbIzr45JxciF1pJj31DHv8U1n78VjQOZNC
 2qkAeODUPyFe6OcTpY242uiz+zG6T9KQO0v6zmX7/FcqA1OjGK4m2gvaOlYp9qhuiC4r2hmir
 ORJM1WRVLyf8aGHYwk7yPNLI6ZoZEUWTL/0Rzx7BBYWvbexBwoTHziSqif5BxSjGvVDuwqE8v
 r42F3EH/r4+8ZVnqye46fmN9rcHfMHijUJmlaFDEAB4gC4A/4D75nl/8OHlkjYnqtTb+xw6co
 ofxLEKnBc6mI+x57CM1xkhqci21/9TbVe2irEQ4tEZ8+tSknp/VkzI8ioe1J3yNPu96M0wbzJ
 ccLMeA/HijnJSQFZv8UYf4PyO/yLEu30ED96ZF+4AUcuOW3U9tH8Puqup3Xp7MuqtK77+ZHx6
 LmV2X1r9/B2pzh234
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace version string with MODULE_* macros.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/8390.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390/=
8390.c
index 0e0aa4016858..318f827cc085 100644
=2D-- a/drivers/net/ethernet/8390/8390.c
+++ b/drivers/net/ethernet/8390/8390.c
@@ -1,11 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* 8390 core for usual drivers */

-static const char version[] =3D
-    "8390.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\=
n";
+#define DRV_DESCRIPTION "8390 core for usual drivers"
+#define DRV_AUTHOR "Donald Becker (becker@cesdis.gsfc.nasa.gov)"

 #include "lib8390.c"

+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+
 int ei_open(struct net_device *dev)
 {
 	return __ei_open(dev);
=2D-
2.20.1

