Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E49D2E7104
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgL2NtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:49:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9941 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgL2NtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:49:13 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D4wj21gcNzhys4;
        Tue, 29 Dec 2020 21:47:50 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:48:20 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: wan: Replace simple_strtol by simple_strtoul
Date:   Tue, 29 Dec 2020 21:48:56 +0800
Message-ID: <20201229134856.23076-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The simple_strtol() function is deprecated, use simple_strtoul() instead.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wan/sbni.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 2fde439543fb..3092a09d3eaa 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -1535,7 +1535,7 @@ sbni_setup( char  *p )
 		goto  bad_param;
 
 	for( n = 0, parm = 0;  *p  &&  n < 8; ) {
-		(*dest[ parm ])[ n ] = simple_strtol( p, &p, 0 );
+		(*dest[ parm ])[ n ] = simple_strtoul( p, &p, 0 );
 		if( !*p  ||  *p == ')' )
 			return 1;
 		if( *p == ';' ) {
-- 
2.22.0

