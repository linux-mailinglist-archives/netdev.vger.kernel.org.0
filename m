Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8075AFE62
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiIGICG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiIGIBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:01:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE0F6CD11;
        Wed,  7 Sep 2022 01:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F1FB81B8E;
        Wed,  7 Sep 2022 08:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BD7C433C1;
        Wed,  7 Sep 2022 08:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662537685;
        bh=N+7iZGeOHbg0TPasbx+AdEIV8g3wgzwCGlxN4DcmeAo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TJkr5j3pNDnkllm1lIQEogNKElKW3BDjmBvL7CiePXCsjIRl9G+NYFb9NMZ1gwPI9
         vQOHGmId7ppcCvF/OXJwxbK1gpjVA4DL4wVvFvufQet8vPsaWSXNHUT/9jG2p65gVG
         6RBapPFmQF+dr2cUuzMUf+9DhM6j/bujy1lCRAODjw1Jr8RfihLM6vtQm6yqrQdd7Y
         M9ku/iyt3cuVdnz5PXyCAIMUGJ17zkr+9LCFfEkPsnSwtjgkDJUun6gW6ZPMQxW3Ga
         ClczsFAfkizG6szezkUjmUDcQvhRLpA90A57SIapBS0aUWcRk9DL3v+TcQPLqGfge2
         QZNNCDbiFItCw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmfmac: add 43439 SDIO ids and initialization
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220827024903.617294-1-marex@denx.de>
References: <20220827024903.617294-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253768156.23292.6474967284299325719.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 08:01:23 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> Add HW and SDIO ids for use with the muRata 1YN (Cypress CYW43439).
> Add the firmware mapping structures for the CYW43439 chipset.
> The 43439 needs some things setup similar to the 43430 chipset.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Patch applied to wireless-next.git, thanks.

be376df724aa wifi: brcmfmac: add 43439 SDIO ids and initialization

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220827024903.617294-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

