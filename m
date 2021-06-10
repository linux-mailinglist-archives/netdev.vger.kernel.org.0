Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48013A245B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 08:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhFJGVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 02:21:31 -0400
Received: from m12-14.163.com ([220.181.12.14]:34099 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJGVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 02:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=xhzqc
        qyX7DowfdZyA5ftUwBoLpefEUNOStWWIOhwbL0=; b=pnPuqOQO7N5kCGW2NsmsZ
        26vQ74Ec4AM2foplE4cWBEJ/0GGP0ghEi0wOpipJxOWSP0O+lJErqrz5BxiXrgcN
        gf1vAIaj6XsvNFyO/cKBjj1rEv73eC1j0GyGUi3eddyo7v5/Y1Dnzyhq0K+/6Pph
        lj03Fby226gP4Ooupx+7oU=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowAD3PmPQrsFgbKfaNw--.3761S2;
        Thu, 10 Jun 2021 14:18:58 +0800 (CST)
From:   13145886936@163.com
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] tipc: socket.c: fix the use of copular verb
Date:   Wed,  9 Jun 2021 23:18:53 -0700
Message-Id: <20210610061853.38137-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowAD3PmPQrsFgbKfaNw--.3761S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GryDCFW5Gry5GF4rCw4fAFb_yoWfGFb_Ww
        1UGF4kXrW8Cw4S9a4Uur4DXF4Iy3Wj9F4I9w13tFy3C3sYyFWvk3ykArs5Jry3Kr4UC3yU
        C3y8t3Z3Aw47ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5O0eJUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiQhOtg1aD-NN8+QAAsA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix the use of copular verb.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/tipc/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 575a0238deb2..34a97ea36cc8 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -662,7 +662,7 @@ static int tipc_release(struct socket *sock)
  * @skaddr: socket address describing name(s) and desired operation
  * @alen: size of socket address data structure
  *
- * Name and name sequence binding is indicated using a positive scope value;
+ * Name and name sequence binding are indicated using a positive scope value;
  * a negative scope value unbinds the specified name.  Specifying no name
  * (i.e. a socket address length of 0) unbinds all names from the socket.
  *
-- 
2.25.1

