Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736556AEFEA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbjCGS1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjCGS0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A91D8C805;
        Tue,  7 Mar 2023 10:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C53C0B819D2;
        Tue,  7 Mar 2023 18:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4597FC4339B;
        Tue,  7 Mar 2023 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213239;
        bh=TljbBfxVOqKVnxlRPxJh7wfvgBgvno87gbT8Pk/fdoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLJa18E5GfrF6pP384PHVfh8oe+OOxkwbv+32yIGw0SQjqXmUtY6jt3VvN1GPSKMV
         H7lgOgmYuPktGtKoUMzG6lzjdihCOWzuihwAJ5Onu5pJ1upxPPtqzjSay+S47T/jdM
         lMLmT9tqCwzi0/LEbReV2XQr0yEu83MVQDwHIm0+6WwJHnGA8vMZlCO6F+JQaTgnBi
         zvkdMHD7XQZIe+C/3xdc3b7UUlx6w/RNA6mUBEYf84GscKPjhiAL6/6qOilHDDihEO
         aySfDTZ/MQN3ddWiLBNWYB7FBS9OV2SWK6O9DiqTGke9Dtt1kSfaK2UjDHRqM51kAw
         Z4lr9A/4VEpAA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 23/28] i40e: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:34 -0600
Message-Id: <20230307181940.868828-24-helgaas@kernel.org>
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
 drivers/net/ethernet/intel/i40e/i40e.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 60ce4d15d82a..6e310a539467 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -10,7 +10,6 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/aer.h>
 #include <linux/netdevice.h>
 #include <linux/ioport.h>
 #include <linux/iommu.h>
-- 
2.25.1

