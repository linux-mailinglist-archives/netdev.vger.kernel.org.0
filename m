Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CA86AEFFC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbjCGS2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbjCGS0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ABD9FE7E;
        Tue,  7 Mar 2023 10:20:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6297C61549;
        Tue,  7 Mar 2023 18:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A189DC4339B;
        Tue,  7 Mar 2023 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213244;
        bh=B4VcwYAM8bIrgPqF9a1HoFkWWXvHnK9JzfKrJBVVkrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AREF4cEThPeBwKNSseOGHlvfxoR0rEQndHAbN2MwMZ8bbR/lhvFWmNTuP2wRwW4nn
         wGP+QacNy3JQNFgZHbnYV+d/1rn6UqxuoOwGEF+vkddmqrPrps/dEI/hpM2r1w9YMm
         q5tASJwLRdTaOp6LLLP4ivtmY0Yps7xheOQVlET0cSCszuRieZcEHl4opod7Ys/fiA
         rRXm+EI8yamLqOBdjAXsh5bFJb74OeFLUsR7tP0t/iK7hXki7jFr0uTAKw9WADFPFf
         sZGfkntTOtdpLWPO361RNNrxbNdB78dtrQzoEf75REJbJuF1sZgH2m6vPQ7z7xeq/Y
         VUelKPnwgl4iA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 26/28] igb: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:37 -0600
Message-Id: <20230307181940.868828-27-helgaas@kernel.org>
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
 drivers/net/ethernet/intel/igb/igb_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03bc1e8af575..a2914298dd69 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -28,7 +28,6 @@
 #include <linux/tcp.h>
 #include <linux/sctp.h>
 #include <linux/if_ether.h>
-#include <linux/aer.h>
 #include <linux/prefetch.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
-- 
2.25.1

