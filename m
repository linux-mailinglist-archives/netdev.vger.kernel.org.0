Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6FF218D14
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbgGHQiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:38:21 -0400
Received: from out0-138.mail.aliyun.com ([140.205.0.138]:59854 "EHLO
        out0-138.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgGHQiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 12:38:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594226299; h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type;
        bh=hkRthTcMLG1q9jDST+dEqyAw1+1vw6MW62OpyYdhjN8=;
        b=dEbK0GRrTlDkewN9cVglNijCEvcFdGyWy+lxKBz3keZjy8UbWn31W9M/QqXbrbxGWBMzoiwwnCPTy1VY9W6Btc4lDKb3uBhoVry8iY4kC4N730N3Vp9bEKr3OTO90UR0oh3WJbmF9TCCY1JjRwXjJm14wkONdt73j+c99NXwQxA=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03293;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.I-GUlfS_1594226296;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-GUlfS_1594226296)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 00:38:17 +0800
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Subject: [PATCH net-next v2 1/2] irq_work: Export symbol "irq_work_queue_on"
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Message-ID: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 00:38:16 +0800
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
index eca83965b631..e0ed16db660c 100644
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
2.18.4

