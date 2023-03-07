Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27826AEFEC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjCGS1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbjCGS0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB56B9EF56;
        Tue,  7 Mar 2023 10:20:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4782061501;
        Tue,  7 Mar 2023 18:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9C8C4339B;
        Tue,  7 Mar 2023 18:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213235;
        bh=+SVjmFeoitwY56tf4BRMZdfwmTz2I/jifxLbrlbtKKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWtSEFrhzjXt8a/O6k9UqI2r94s4dtqMqsGeDqcDGF6HDuPRhrT7Ue8KM8CmZkcDI
         oV0qhrG0+bs+IVbsU41k8j+IFyOk08/SIu6F7CKfRtQ4CAwmz73uzBnuiVNeRNPWTL
         6gu8q1A/uyZYW4YAs9E0+fh0OxArW0VUdR7AZAeBZ/VRAfJmavh8t59IvSsHHtcTnC
         lcamH9SIsLJS1PcnmWThfdwWj2Oli9qGdyimJjb/Cg97kIuUauyyxRz2jxOmicwxaa
         6Je6hdFkLnEClEDU1O9thFDxKPYn3OGMVXsv4y0CDPSPdqshl1/CRmkJOMltz2Y33C
         Qb8QsU919Vt3A==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH 21/28] e1000e: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:32 -0600
Message-Id: <20230307181940.868828-22-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

<linux/aer.h> is unused, so remove it.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e1eb1de88bf9..6f5c16aebcbf 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -23,7 +23,6 @@
 #include <linux/smp.h>
 #include <linux/pm_qos.h>
 #include <linux/pm_runtime.h>
-#include <linux/aer.h>
 #include <linux/prefetch.h>
 #include <linux/suspend.h>
 
-- 
2.25.1

