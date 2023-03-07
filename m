Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84396AEFF2
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbjCGS2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjCGS0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED3B9FE75;
        Tue,  7 Mar 2023 10:20:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EDC5614E8;
        Tue,  7 Mar 2023 18:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAE3C4339B;
        Tue,  7 Mar 2023 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213243;
        bh=9iCFzc2QqDeX+XEzEK67hx5JvvMn4Tky3ek230eHt58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1fCVlZuEjlME/3MHfneKNMrZpZPMBpAR54NxEVX9f9z9SBbJY5ThjOaSsZtd0hjm
         7ABLWkyDbB5p5gU+wEYQBijE7HsIxdm12esRd2gAbMz63Mqr+BEIuf52d0VjJRCvO/
         /soT7vjH7mBIxwxXk5SHQDldKVKGmOBKzoLHBku0ePxEX2fnvhi+CKJxYFdFPf+p13
         6PXBzT2iYQ50VyeiHY6xOTNhLFNujTcbS7bIEHplIEtyd9vr8yAMaI5OXUjtHDszZN
         LVMrHo/+924GJVNvM2+DOwlyefYAWk9HR5po9rHlhcfSUxQhLzqYz73fL+aoFwNgqp
         IosK++mBocb0Q==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 25/28] ice: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:36 -0600
Message-Id: <20230307181940.868828-26-helgaas@kernel.org>
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
 drivers/net/ethernet/intel/ice/ice.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b0e29e342401..d79a48d27f1a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -20,7 +20,6 @@
 #include <linux/pci.h>
 #include <linux/workqueue.h>
 #include <linux/wait.h>
-#include <linux/aer.h>
 #include <linux/interrupt.h>
 #include <linux/ethtool.h>
 #include <linux/timer.h>
-- 
2.25.1

