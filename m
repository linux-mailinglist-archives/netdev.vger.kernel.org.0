Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2491B1364EA
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 02:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgAJBjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 20:39:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9146 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730596AbgAJBjh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 20:39:37 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E8A7C6512FD905BCFAA9;
        Fri, 10 Jan 2020 09:39:34 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Fri, 10 Jan 2020 09:39:28 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] sfc: remove duplicated include from ef10.c
Date:   Fri, 10 Jan 2020 01:35:17 +0000
Message-ID: <20200110013517.37685-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/sfc/ef10.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index dc037dd927f8..fa460831af7d 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -16,7 +16,6 @@
 #include "workarounds.h"
 #include "selftest.h"
 #include "ef10_sriov.h"
-#include "rx_common.h"
 #include <linux/in.h>
 #include <linux/jhash.h>
 #include <linux/wait.h>



