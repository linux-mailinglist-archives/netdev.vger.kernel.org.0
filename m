Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CFC5E6331
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiIVNIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiIVNIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:08:44 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06815EBBD6;
        Thu, 22 Sep 2022 06:08:30 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 2817641F12;
        Thu, 22 Sep 2022 13:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1663852109; bh=icQWkxx6xaBpvv1YkBTD1bpN7od8H2KAyKOq4vcIuo0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=q6ClAiMNXr93Ys9uLuWzN6aRggytNKr3Y8jNu6qRpFFktcOkJg3SKf+VzSL5aBBLn
         PSMFKtm8bLeXfBf0OxyE/6FzMVMRk4OHgg/fJa8u8AiP7/SGDszX0+Tn54mMdQ07a9
         bHShPY1NZFsZFhBGHqzLiDNKpS5XTM99sQCzl8lAasBZQ6rsGxPdTFeacZVHG7XuVS
         tJFafqS92DHurw3p+u2DXiid4gFKvoZ4CVhlXDGlp1J+esJdBKsy0U0BkdIuDczFjW
         Iu7HFE5UDFpQC5cXLMm64bF8nXe+DbYxvRE6t6kJ+Ne1QhbZekSossn1spPxIbFQDU
         jZZq7ywarqEpg==
Message-ID: <e620b07d-e53e-edae-1078-2a776abf1e17@marcan.st>
Date:   Thu, 22 Sep 2022 22:08:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
Content-Language: es-ES
To:     Linus Walleij <linus.walleij@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        marijn.suijten@somainline.org, jamipkettunen@somainline.org,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Soontak Lee <soontak.lee@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/09/2022 22.02, Linus Walleij wrote:
> On Thu, Sep 22, 2022 at 12:21 PM Konrad Dybcio
> <konrad.dybcio@somainline.org> wrote:
> 
>> Also worth noting is the 'somc' bit, meaning there are probably *some* SONY
>> customizations, but that's also just a guess.
> 
> What I have seen from BRCM customizations on Samsung phones is that
> the per-device customization of firmware seems to involve the set-up of
> some GPIO and power management pins. For example if integrated with
> an SoC that has autonomous system resume, or if some GPIO line has
> to be pulled to enable an external regulator or PA.
> 
> To the best of my knowledge that customization is done by consultants
> from Broadcom when working with the device manufacturer, and
> eventually they roll a unique firmware for the device. Probably because
> the firmware can only be signed for execution by Broadcom?

I don't think the firmware is signed, they probably just don't want to
share the source code with most customers? (Except Apple maybe, but
Apple gets custom silicon too...).

- Hector
