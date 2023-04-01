Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6295E6D2CF4
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 03:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbjDABop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 21:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbjDABoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 21:44:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D231D84C;
        Fri, 31 Mar 2023 18:43:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDFABB83262;
        Sat,  1 Apr 2023 01:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45BCC4339B;
        Sat,  1 Apr 2023 01:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313375;
        bh=DNHA9w31gGi6slqGhnDugKrUxRmBTEkUVrJjeSv3J8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bj+zZr29DeWFw9WqGSarEPq/MkzEDeVJSka19tsq7qm96s+8mtD529ZqHQACu07vN
         jGALJeXKYLeIBEnvZkvYExYJX06wXmEyOwbiBvknTDhF5Jt82eDtQOy9SadM1IOQw3
         DfRp5IOYahiocCEMTDAtaqF5Ky2C5Cq0I3Y8yeHE+GytRO4M+ijq8nKFfG4Nbh0UGB
         B0SuaT5HjLaIgB5YlTdN2sjRNs7+tlRcfC3VQWEu9vzXEmVHRQjQCKz6BfH7De1ipC
         4qF7K9MT9b0/txy9nuSdqj6c+yrXKgOe3seRKG5bNc693oLOZhBxZsT/JMfSG2GRrG
         VHkmj5lgobI8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 07/24] wifi: mwifiex: mark OF related data as maybe unused
Date:   Fri, 31 Mar 2023 21:42:23 -0400
Message-Id: <20230401014242.3356780-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 139f6973bf140c65d4d1d4bde5485badb4454d7a ]

The driver can be compile tested with !CONFIG_OF making certain data
unused:

  drivers/net/wireless/marvell/mwifiex/sdio.c:498:34: error: ‘mwifiex_sdio_of_match_table’ defined but not used [-Werror=unused-const-variable=]
  drivers/net/wireless/marvell/mwifiex/pcie.c:175:34: error: ‘mwifiex_pcie_of_match_table’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230312132523.352182-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 5dcf61761a165..9a698a16a8f38 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -172,7 +172,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
 	.can_ext_scan = true,
 };
 
-static const struct of_device_id mwifiex_pcie_of_match_table[] = {
+static const struct of_device_id mwifiex_pcie_of_match_table[] __maybe_unused = {
 	{ .compatible = "pci11ab,2b42" },
 	{ .compatible = "pci1b4b,2b42" },
 	{ }
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 9f506efa53705..ea1c1c2412e72 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -479,7 +479,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 	{"EXTLAST", NULL, 0, 0xFE},
 };
 
-static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+static const struct of_device_id mwifiex_sdio_of_match_table[] __maybe_unused = {
 	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
-- 
2.39.2

