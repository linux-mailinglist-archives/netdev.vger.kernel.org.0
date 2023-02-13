Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A602694D4F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjBMQvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBMQvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:51:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CC56A46;
        Mon, 13 Feb 2023 08:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03915611E4;
        Mon, 13 Feb 2023 16:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B953AC433D2;
        Mon, 13 Feb 2023 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676307076;
        bh=cxfmvlcEDyvhLaP1zdMJGR8qwb1ghCxNyOs4BIQWtUQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Jqxqprt1sGLjXp23wbNImpiuk/gPibMur9A/y9fnk2SxKOF3UREh0bxkjBa1dSvbm
         nDRSf9bJBldT6x3COrov0AeNGE0c0+X9VZOI+97G3D8pFmJKxN6kxkAshNyPoVYXoz
         jb3EXNnq8qLRxAxsRZaROhaOcBjXKLcKSI/36tmm760OxlGkO/JJdf3Xf3PJtBUiLk
         ae2RoDeQYnsDJaN/O+d5idalUrJfHpPc4FMCsob+U5KZntu1IwFI2PyWNM7NnOH744
         Cx8kfU4fDG8Fk6/Ac5e0bFst967QkqXVgireH4jk02ldGsi3RnPLJdkiymjx4trZen
         vJtrQ1QiZcnGQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230212063813.27622-2-marcan@marcan.st>
References: <20230212063813.27622-2-marcan@marcan.st>
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Prutskov <alep@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630706967.12830.157103392387761972.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 16:51:11 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> wrote:

> The commit that introduced support for this chip incorrectly claimed it
> is a Cypress-specific part, while in actuality it is just a variant of
> BCM4355 silicon (as evidenced by the chip ID).
> 
> The relationship between Cypress products and Broadcom products isn't
> entirely clear but given what little information is available and prior
> art in the driver, it seems the convention should be that originally
> Broadcom parts should retain the Broadcom name.
> 
> Thus, rename the relevant constants and firmware file. Also rename the
> specific 89459 PCIe ID to BCM43596, which seems to be the original
> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
> driver).
> 
> Since Cypress added this part and will presumably be providing its
> supported firmware, we keep the CYW designation for this device.
> 
> We also drop the RAW device ID in this commit. We don't do this for the
> other chips since apparently some devices with them exist in the wild,
> but there is already a 4355 entry with the Broadcom subvendor and WCC
> firmware vendor, so adding a generic fallback to Cypress seems
> redundant (no reason why a device would have the raw device ID *and* an
> explicitly programmed subvendor).
> 
> Fixes: dce45ded7619 ("brcmfmac: Support 89459 pcie")
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hector Martin <marcan@marcan.st>

4 patches applied to wireless-next.git, thanks.

54f01f56cf63 wifi: brcmfmac: Rename Cypress 89459 to BCM4355
69005e67ce54 wifi: brcmfmac: pcie: Add IDs/properties for BCM4355
bf8bbd903f07 wifi: brcmfmac: pcie: Add IDs/properties for BCM4377
6a142f70774f wifi: brcmfmac: pcie: Perform correct BCM4364 firmware selection

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230212063813.27622-2-marcan@marcan.st/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

