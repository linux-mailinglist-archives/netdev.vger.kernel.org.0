Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9109F411471
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238239AbhITMbp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Sep 2021 08:31:45 -0400
Received: from mail.shanghaitech.edu.cn ([119.78.254.11]:55730 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238240AbhITMbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:31:44 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 480405189764503;
        Mon, 20 Sep 2021 20:30:08 +0800 (CST)
Received: from DESKTOP-U066CHB.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Mon, 20 Sep 2021 20:30:06 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/udp_tunnel_core.c: remove superfluous header files from udp_tunnel_core.c
Date:   Mon, 20 Sep 2021 20:29:57 +0800
Message-ID: <20210920122957.11264-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udp_tunnel_core.c hasn't use any macro or function declared in udp.h, types.h,
and net_namespace.h. Thus, these files can be removed from udp_tunnel_core.c
safely without affecting the compilation of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/udp_tunnel_core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index b97e3635a..8efaf8c3f 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -2,11 +2,8 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/socket.h>
-#include <linux/udp.h>
-#include <linux/types.h>
 #include <linux/kernel.h>
 #include <net/dst_metadata.h>
-#include <net/net_namespace.h>
 #include <net/udp.h>
 #include <net/udp_tunnel.h>
 
-- 
2.25.1


