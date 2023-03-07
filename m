Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954C46AEFEE
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbjCGS1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbjCGS0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868F59DE15;
        Tue,  7 Mar 2023 10:20:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2601B6154E;
        Tue,  7 Mar 2023 18:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E8BC4339B;
        Tue,  7 Mar 2023 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213237;
        bh=xZeCbayYrVhu8ichVDtPhdqLO81L+GFGIOk8oMP+2DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUo/07cFEWvAjxyWxduBiLutX3WEM4TKC2hVQDuBmJePgKmBfdMI8tkKWewBZuIGN
         anG+98OsZI0huduLILIowWc//50OUGkWqUhZUHQaRVeZh4Cv0l1Ses70zeew7h2auw
         B/wHXbS+hQy8H6N6ieywODw6aef4cZgvhkJTbqXy0BFLzQIo3B3VOxrZT1b2Ub18X8
         zygEfI91JelgNMj5PkTV6tlr4BwxBhhj7ESM24977mVptkIN4D3uo8Dbc0nrQ4hcKF
         F+VLulD5nlze/YwSuktn+3h/wmbSxDlFOieVW2j9eznpcFOFp8CHAcwAXSY5JHlqGs
         VGzTTDmlhNYHw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 22/28] fm10k: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:33 -0600
Message-Id: <20230307181940.868828-23-helgaas@kernel.org>
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
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index 027d721feb18..d748b98274e7 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -3,7 +3,6 @@
 
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/aer.h>
 
 #include "fm10k.h"
 
-- 
2.25.1

