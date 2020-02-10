Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174B9157100
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 09:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgBJItc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 03:49:32 -0500
Received: from foss.arm.com ([217.140.110.172]:57446 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbgBJItb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 03:49:31 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF2DE328;
        Mon, 10 Feb 2020 00:49:30 -0800 (PST)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8844B3F68F;
        Mon, 10 Feb 2020 00:49:25 -0800 (PST)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH 1/9] psci: export psci conduit get helper.
Date:   Mon, 10 Feb 2020 16:48:58 +0800
Message-Id: <20200210084906.24870-2-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210084906.24870-1-jianyong.wu@arm.com>
References: <20200210084906.24870-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export arm_smccc_1_1_get_conduit then modules can use smccc helper which
adopts it.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/firmware/psci/psci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index b3b6c15e7b36..e0738d6f3d16 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -64,6 +64,7 @@ enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
 
 	return psci_ops.conduit;
 }
+EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
 
 typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
-- 
2.17.1

