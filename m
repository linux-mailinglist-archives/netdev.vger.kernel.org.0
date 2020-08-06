Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D60A23E2C1
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 22:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgHFUBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 16:01:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58326 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725272AbgHFUBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 16:01:46 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CBDF78BFDF619C666FCF;
        Thu,  6 Aug 2020 19:51:59 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 6 Aug 2020
 19:51:48 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH 4/5] net: Remove meaningless jump label out_fs
Date:   Thu, 6 Aug 2020 19:54:19 +0800
Message-ID: <1596714859-25352-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

The out_fs jump label has nothing to do but goto out.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/socket.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index ee9c9dac4728..e1a1195ce69e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3056,7 +3056,7 @@ static int __init sock_init(void)
 
 	err = register_filesystem(&sock_fs_type);
 	if (err)
-		goto out_fs;
+		goto out;
 	sock_mnt = kern_mount(&sock_fs_type);
 	if (IS_ERR(sock_mnt)) {
 		err = PTR_ERR(sock_mnt);
@@ -3079,7 +3079,6 @@ static int __init sock_init(void)
 
 out_mount:
 	unregister_filesystem(&sock_fs_type);
-out_fs:
 	goto out;
 }
 
-- 
2.19.1

