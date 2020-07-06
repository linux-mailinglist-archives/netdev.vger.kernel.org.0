Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F684215DFB
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgGFSIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:08:11 -0400
Received: from out0-135.mail.aliyun.com ([140.205.0.135]:42055 "EHLO
        out0-135.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbgGFSIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594058888; h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type;
        bh=EPwxqlnSmmTL6OUhrd4XXH2lI1d1oVRu2RsxgOsZcvc=;
        b=WTP0UOsbZWBG3mJFTWLX7yvVJH5H2yf+Rv2qj6fV1fvFM+EjzBAS8rwDmfyl1lu9dDVj4y2cUxy9bosdsU2Q5Eh58A2PRj2yu2Sx8zDjq8UsQUj7R/y+K44pVx4I9gUlWz4546GvTYrOsD+kRtrO/o2RDiPb0rB3yiL3gECkb44=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03311;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.Hz5obiz_1594058887;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.Hz5obiz_1594058887)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Jul 2020 02:08:08 +0800
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Subject: [PATCH net-next 1/2] irq_work: Export symbol "irq_work_queue_on"
To:     netdev@vger.kernel.org
Message-ID: <c04ac6e3-2b3d-e249-0274-37582451c561@alibaba-inc.com>
Date:   Tue, 07 Jul 2020 02:08:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike other irq APIs, irq_work_queue_on is not exported. It makes sense to
export it so other modules could use it.

Signed-off-by: Xiangning Yu <xiangning.yu@alibaba-inc.com>
---
 kernel/irq_work.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index eca8396..e0ed16d 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -111,7 +111,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
 	return true;
 #endif /* CONFIG_SMP */
 }
-
+EXPORT_SYMBOL_GPL(irq_work_queue_on);
 
 bool irq_work_needs_cpu(void)
 {
-- 
1.8.3.1

