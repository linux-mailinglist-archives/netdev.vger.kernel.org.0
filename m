Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39600389C1C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 05:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhETDwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 23:52:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3614 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhETDwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 23:52:20 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Flwh96mNxzmXfs;
        Thu, 20 May 2021 11:48:41 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:58 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH net-next 6/9] net: fddi: skfp: remove leading spaces before tabs
Date:   Thu, 20 May 2021 11:47:51 +0800
Message-ID: <1621482474-26903-7-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
References: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/fddi/skfp/ess.c        | 6 +++---
 drivers/net/fddi/skfp/h/supern_2.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/ess.c b/drivers/net/fddi/skfp/ess.c
index 35110c0..41107338 100644
--- a/drivers/net/fddi/skfp/ess.c
+++ b/drivers/net/fddi/skfp/ess.c
@@ -379,17 +379,17 @@ static int process_bw_alloc(struct s_smc *smc, long int payload, long int overhe
 	 * if the payload is greater than zero.
 	 * For the SBAPayload and the SBAOverhead we have the following
 	 * unite quations
- 	 *		      _		  _
+	 *		      _		  _
 	 *		     |	     bytes |
 	 *	SBAPayload = | 8000 ------ |
 	 *		     |		s  |
 	 *		      -		  -
- 	 *		       _       _
+	 *		       _       _
 	 *		      |	 bytes	|
 	 *	SBAOverhead = | ------	|
 	 *		      |	 T-NEG	|
 	 *		       -       -
- 	 *
+	 *
 	 * T-NEG is described by the equation:
 	 *
 	 *		     (-) fddiMACT-NEG
diff --git a/drivers/net/fddi/skfp/h/supern_2.h b/drivers/net/fddi/skfp/h/supern_2.h
index 78ae8ea..0bbbd41 100644
--- a/drivers/net/fddi/skfp/h/supern_2.h
+++ b/drivers/net/fddi/skfp/h/supern_2.h
@@ -1025,7 +1025,7 @@ struct tx_queue {
 #define	PLC_QELM_A_BIST	0x5b6b		/* BIST signature of QELM Rev. A */
 
 /*
- 	FDDI board recources	
+	FDDI board recources
  */
 
 /*
-- 
2.8.1

