Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C930A25D4E8
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIDJ3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:29:21 -0400
Received: from foss.arm.com ([217.140.110.172]:46788 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730048AbgIDJ3R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 05:29:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDA9512FC;
        Fri,  4 Sep 2020 02:29:16 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1E3EA3F66F;
        Fri,  4 Sep 2020 02:29:10 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        nd@arm.com
Subject: [PATCH v14 03/10] smccc: Export smccc conduit get helper.
Date:   Fri,  4 Sep 2020 17:27:37 +0800
Message-Id: <20200904092744.167655-4-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904092744.167655-1-jianyong.wu@arm.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export arm_smccc_1_1_get_conduit then modules can use smccc helper which
adopts it.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/firmware/smccc/smccc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
index 4e80921ee212..d26d3512b145 100644
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -24,6 +24,7 @@ enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
 
 	return smccc_conduit;
 }
+EXPORT_SYMBOL_GPL(arm_smccc_1_1_get_conduit);
 
 u32 arm_smccc_get_version(void)
 {
-- 
2.17.1

