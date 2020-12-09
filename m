Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70AD2D3FD0
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgLIKYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:24:52 -0500
Received: from mga04.intel.com ([192.55.52.120]:23405 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbgLIKYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 05:24:52 -0500
IronPort-SDR: XtMsd7Fk1cm12p0kbZtUOuqAvlN8jrGilPoB0OFSyUQBUIT7auNgIiEkyCNG3KkBMNxSSMq97V
 i6yR/UuMzUcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9829"; a="171482649"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="171482649"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 02:24:12 -0800
IronPort-SDR: HogXuwPQfuKaHfy+WI7BszGxBk0Vt+Q3kyfK0CJ9tQkboGNLHGOhis16rNG8XiY47ZgCAxgeXQ
 2P6lmtuzcPWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="552578966"
Received: from lkp-server01.sh.intel.com (HELO 2bbb63443648) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 09 Dec 2020 02:24:09 -0800
Received: from kbuild by 2bbb63443648 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kmwdk-0000ED-OY; Wed, 09 Dec 2020 10:24:08 +0000
Date:   Wed, 9 Dec 2020 18:23:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
        will@kernel.org
Cc:     kbuild-all@lists.01.org
Subject: [RFC PATCH] ptp: clock_pair_gpa can be static
Message-ID: <20201209102322.GA48751@21f297abc363>
References: <20201209060932.212364-4-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209060932.212364-4-jianyong.wu@arm.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 ptp_kvm_x86.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index e011d691e549a7..19cad4c0297265 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -15,8 +15,8 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/ptp_kvm.h>
 
-phys_addr_t clock_pair_gpa;
-struct kvm_clock_pairing clock_pair;
+static phys_addr_t clock_pair_gpa;
+static struct kvm_clock_pairing clock_pair;
 struct pvclock_vsyscall_time_info *hv_clock;
 
 int kvm_arch_ptp_init(void)
