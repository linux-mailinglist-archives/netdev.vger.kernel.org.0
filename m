Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E3F660925
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbjAFV70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbjAFV7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:59:20 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140726B5F0;
        Fri,  6 Jan 2023 13:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673042360; x=1704578360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sQb3sEVMUrtQ11r87eT7TSDBLNdId+qUxBQzgXh/Yr4=;
  b=AJGaUUeLiVw+MSnV9EoFlzWtud8NDBlwuLKrtYNmM7XkSEKP7V/b6HJc
   ya6OxH062uVVl+SLJ+BeDZBhHg0LmHfQMMjZQPpGlEijjvodvl6soaswp
   FjXYgLQ4dEcjUv4pOx4guGGvFZ1D2AwaPnn37OkCncuCeGWKGdkPu6XME
   jLQEBGtLuKmroxafRqIAVLNUAR+2w48cubP8brLpLiHcMGsMZahHEEUfU
   GW7gC0P5BUmcrVdcxapFddAExhnaZ4GRHaVGI43k5r7IhjxlG8KAf4kOv
   +ZMB/jMWQGeIDwttaWmPJ33HJIWaBD3QsFD3WxoTl62kJko9IXol7hbSg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="387030715"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="387030715"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 13:59:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="763652888"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="763652888"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.60])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jan 2023 13:59:16 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 4/7] mips: configs: Remove reference to CONFIG_CASSINI
Date:   Fri,  6 Jan 2023 14:00:17 -0800
Message-Id: <20230106220020.1820147-5-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An earlier patch removed the Sun Cassnini driver. Remove references to
CONFIG_CASSINI from the mtx1 defconfig

Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 arch/mips/configs/mtx1_defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 89a1511..17d88a0 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -305,7 +305,6 @@ CONFIG_PCMCIA_SMC91C92=m
 CONFIG_EPIC100=m
 CONFIG_HAPPYMEAL=m
 CONFIG_SUNGEM=m
-CONFIG_CASSINI=m
 CONFIG_TLAN=m
 CONFIG_VIA_RHINE=m
 CONFIG_VIA_VELOCITY=m
-- 
2.37.2

