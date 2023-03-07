Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2816AEFF7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbjCGS2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjCGS04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328EEB06E1;
        Tue,  7 Mar 2023 10:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFB81B819C5;
        Tue,  7 Mar 2023 18:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D7EC433D2;
        Tue,  7 Mar 2023 18:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213248;
        bh=+/3xSbuw/CpH0rA4rIXLVesO5yLlQvOJu29BU7PVVoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAnO2XEy5qZvJxmDdRFRtFW4oc5onWVDPLMtG2u/zbdf9AS+1k5d8FRe1IVYemhJH
         CrtZU3AizKsrYNKmer+v86N0ejAkseLmfChJJa0NkJCg6PfmVN+t8IRzNGXupdkcNq
         g28NWJ4I5mDDwWIwkoqzalvfH/WTBJc20FqKd/YsWHOLFjugygkaql6exqSU9dekhX
         lH/+XJk+ognGipPn9IWB8imwUqMhdRTgarzzJ70RD2hITCOeza3+aju6izuyIT7n8S
         ktL2Z9XTAd/6BDdlewRzvOQhxzwRHSxXb6jgFDQPftTTMeN1/wziRB/6COeBxXSogE
         l4kYlvA/XmXig==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 28/28] ixgbe: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:39 -0600
Message-Id: <20230307181940.868828-29-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
 drivers/net/ethernet/intel/ixgbe/ixgbe.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 8736ca4b2628..63d4e32df029 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -9,7 +9,6 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/cpumask.h>
-#include <linux/aer.h>
 #include <linux/if_vlan.h>
 #include <linux/jiffies.h>
 #include <linux/phy.h>
-- 
2.25.1

