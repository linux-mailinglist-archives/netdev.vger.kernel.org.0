Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE876A271A
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 04:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBYDri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 22:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjBYDrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 22:47:36 -0500
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD0446170;
        Fri, 24 Feb 2023 19:47:35 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 3239C42188;
        Sat, 25 Feb 2023 03:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677296854;
        bh=9w6bfsuULjah3KOP3rBjhmCazbuLV8pgKwfm04IQKjM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Fw7HJlgNyg150FU4HGATAfTdrRbwFOtxDjQlVD9KudOhktca4jMZlEw0Q+j7JH+rj
         lwgSfkv1cLbDw89xCfyP4V3YjWn/7c6ZZSjRKtj9o8XZL/9Wc5byKKKABMT8ATyhoq
         9YYVZafs96WzciID87L29gsrPW+6jLlyPFVpKbaJcN45YVKPiYTqElZ2h9G7R2mkeV
         uBCrzxkSUEDKypSTx+gA4kGumHsiS8zYWKInhReY4TRAG7rWkAMeztx1EF0HaU5Gb2
         TnIHcWr4hKRZ/AGoCeYPF3S+mH398HoTLr7eRTcomSoXjE3ZgN0ORk+npMjj/jneHR
         2TSdff3r6c4eg==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH net-next v9 1/5] Revert "PCI/ASPM: Unexport pcie_aspm_support_enabled()"
Date:   Sat, 25 Feb 2023 11:46:31 +0800
Message-Id: <20230225034635.2220386-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230225034635.2220386-1-kai.heng.feng@canonical.com>
References: <20230225034635.2220386-1-kai.heng.feng@canonical.com>
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

This reverts commit ba13d4575da5e656a3cbc18583e0da5c5d865417.

This will be used by module once again.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v9:
 - No change.

v8:
 - New patch.

 drivers/pci/pcie/aspm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 4b4184563a927..692d6953f0970 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1372,3 +1372,4 @@ bool pcie_aspm_support_enabled(void)
 {
 	return aspm_support_enabled;
 }
+EXPORT_SYMBOL(pcie_aspm_support_enabled);
-- 
2.34.1

