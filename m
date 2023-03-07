Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17496AEFF8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjCGS2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbjCGS0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8245BA2F0D;
        Tue,  7 Mar 2023 10:20:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 506586154A;
        Tue,  7 Mar 2023 18:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A4FC433A7;
        Tue,  7 Mar 2023 18:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213246;
        bh=5kvX7HRO05Aqml11yDkUPLOoDba6HFrNQVxp5lmDDUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FK4V3NNMm3OmmicVSOfFo5G7t1hG8HSWU2y2l8IZBlHXe54s9gGhWvdB9z0BiisX4
         oxArsMFWaWeWzsBJQ2JRgSTNNi5GW9DM/DgGWesgfBDn703ldoyna4auED7QRfPICM
         qe47K41avRIjFxUZJ1xp8Ks6aMf2V+nGmngAP8tEsVlFESKaY/7R5wLo0Uni1pR+AU
         6WZtQfJEqeqIc7OOcsasLTkXlaokiYjAbDXVtv380HMwi4dKLucxqN55gLa4f0Pv6Y
         XaOfbJoHAml01pQB9x242M+QP2bYqTOlsiPpVkfSrUCEOtxZnbnmclxsAexaLR13O9
         iPbSeGpBsFgzQ==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 27/28] igc: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:38 -0600
Message-Id: <20230307181940.868828-28-helgaas@kernel.org>
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
 drivers/net/ethernet/intel/igc/igc_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 2928a6c73692..d7ee06d28b50 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4,7 +4,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/if_vlan.h>
-#include <linux/aer.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/ip.h>
-- 
2.25.1

