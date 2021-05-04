Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BCB372689
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 09:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhEDH0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 03:26:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:18342 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhEDH0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 03:26:12 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FZBBV3vbRzCqrD;
        Tue,  4 May 2021 15:22:42 +0800 (CST)
Received: from [10.174.179.57] (10.174.179.57) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 4 May 2021 15:25:09 +0800
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <christian.brauner@ubuntu.com>, <jamorris@linux.microsoft.com>,
        <jingxiangfeng@huawei.com>, <orcohen2006@gmail.com>,
        <gustavoars@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH] cleancode: add space around '&'
Message-ID: <ed093244-1ac3-8163-eb45-1e85fef46d32@huawei.com>
Date:   Tue, 4 May 2021 15:25:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add space around '&'

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5a31307ceb76..c0808dd19e98 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1635,7 +1635,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		return err;

 	err = -EOPNOTSUPP;
-	if (msg->msg_flags&MSG_OOB)
+	if (msg->msg_flags & MSG_OOB)
 		goto out;

 	if (msg->msg_namelen) {
-- 
2.23.0

-- 
Best wishes
Kemeng Shi
