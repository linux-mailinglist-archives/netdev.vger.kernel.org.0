Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E52E6AEFF1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjCGS2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbjCGS0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830F6ADC04;
        Tue,  7 Mar 2023 10:20:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EEBAACE1C79;
        Tue,  7 Mar 2023 18:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB87C4339C;
        Tue,  7 Mar 2023 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213241;
        bh=DE92hw8t8/0nODEhiHkEnnlsRI/SWQU/hTMJS+17V8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Utqngn8FnD1QnkNMyz105aMZWZvoOdgvgFmcIVsgKcD5AdXJc2DStIs/ktxW+sLe+
         r/VsowUTdpMcIUhzozJxqJmvvZV+zh8rtUNF/4/LdpWjfFp5+jSK23u7xq6CJRMD0H
         FyIj9XEzXItwjHZGittnP0uzi/r1ZeJ5OzhoKNj56q95QC5wR5RxKQPTNtbI2Dtvmh
         CUgdJT7jpQ+Q5wLpCZITVc53nN8ZOIMlAQmzc2PE6jiKY4fUPz5A1g0qJNB6JHwE5D
         JG9uzdfgLZz30yrSRglBnn+BWsrsyKi8Zq+Tz/1Iy/fzK84RJXv+EbRcZW4OmvOd2r
         2WwWZo5zchL8w==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 24/28] iavf: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:35 -0600
Message-Id: <20230307181940.868828-25-helgaas@kernel.org>
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
---
 drivers/net/ethernet/intel/iavf/iavf.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 232bc61d9eee..2cdce251472c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -6,7 +6,6 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/aer.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
-- 
2.25.1

