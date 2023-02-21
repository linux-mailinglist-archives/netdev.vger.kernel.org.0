Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83B169D8A0
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjBUCkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjBUCj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:39:59 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B82448B;
        Mon, 20 Feb 2023 18:39:53 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 0CBC13F158;
        Tue, 21 Feb 2023 02:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676947192;
        bh=bhjZxuXkm1MHeyPMkpuHBbBuF0eWs3dLUcdK/gbm22M=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=sVFwdem5XR4yjnDTanXqgcRjFp2ZadRa79H4Q+MNB5HJuL8btJR+ijuo+BQQu7o78
         XWyqtV/FFaNkfXy7Ll3dLUxya5cby2SvtvP3I4XhXL3N2HPTibaRlHB3IjbMjjjhfW
         4baW2zpyGyiR0rjJ6E9Fiyntnk1p2g2NAqWZTWDFycwaIXYQlgGhCYvo5jWLOb1o3F
         Q95vOlWJCiEsivCT2pflGFq9T0m8Bitx7fQ3ND6VDlMEmuGUWDQWP78GHYBoZM3vR/
         LjhFV8tiDPbIfYbbvWP+a3VARgT17TdN8jD7NDBS2usVRBMaqQSuNbLBQCf290k99K
         3Pfg0plbiPF7g==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v8 RESEND 2/6] Revert "PCI/ASPM: Unexport pcie_aspm_support_enabled()"
Date:   Tue, 21 Feb 2023 10:38:45 +0800
Message-Id: <20230221023849.1906728-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
References: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
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

