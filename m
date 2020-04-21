Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD501B1C95
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgDUDXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:23:32 -0400
Received: from foss.arm.com ([217.140.110.172]:57324 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgDUDXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 23:23:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03367C14;
        Mon, 20 Apr 2020 20:23:31 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D44B43F6CF;
        Mon, 20 Apr 2020 20:23:23 -0700 (PDT)
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
Subject: [RFC PATCH v11 1/9] psci: export psci conduit get helper.
Date:   Tue, 21 Apr 2020 11:22:56 +0800
Message-Id: <20200421032304.26300-2-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421032304.26300-1-jianyong.wu@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
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
index 2937d44b5df4..fd3c88f21b6a 100644
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

