Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52C4647225
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiLHOrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiLHOrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:47:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3070A27CC7;
        Thu,  8 Dec 2022 06:47:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAABF61F6E;
        Thu,  8 Dec 2022 14:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0173C433C1;
        Thu,  8 Dec 2022 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670510824;
        bh=DGZdBg2k+c0lbYP2UZKfn7NakVnAY+qm3K+z9ZUzG1A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=akW5tSpk2A9DJbUBKaMSgnTCK+d5lj5cplVyp4CCWolM45SCzt+7Z5Sff+yTZy/CU
         3YlGC3HjEsbcSMYytNmwW/hADadUkbN3/jGx6xckGK3LDuLHE3BZk0+X9no7E1aS9r
         j9opLw+A4vY+u9Gr2D6GLvypcvo1VV4P0J9w0S1N8qZFPP9TCOTrcsqYwLoL62Ks0b
         k1Co4f3OJTPSAwjWa3b9HyUf+Lb0x5GxtJb+72gOKdzLYgiehMxk+JR43Z3HYioUcg
         aHWRZhozrd1qtrOniKVF9J83z9WGbTMalLbZE9F45L/lyAWxHLBKBI9qMLLDzpNNMh
         EpoVhlHKJ9NKQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: brcmfmac: Fix error return code in
 brcmf_sdio_download_firmware()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1669959342-27144-1-git-send-email-wangyufen@huawei.com>
References: <1669959342-27144-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     <aspriel@gmail.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <arend@broadcom.com>, Wang Yufen <wangyufen@huawei.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167051081967.9839.17101667158820995353.kvalo@kernel.org>
Date:   Thu,  8 Dec 2022 14:47:01 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Yufen <wangyufen@huawei.com> wrote:

> Fix to return a negative error code instead of 0 when
> brcmf_chip_set_active() fails. In addition, change the return
> value for brcmf_pcie_exit_download_state() to keep consistent.
> 
> Fixes: d380ebc9b6fb ("brcmfmac: rename chip download functions")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-next.git, thanks.

c2f2924bc7f9 wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1669959342-27144-1-git-send-email-wangyufen@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

