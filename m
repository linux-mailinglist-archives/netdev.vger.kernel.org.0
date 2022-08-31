Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B285A7E6B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiHaNNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiHaNNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:13:53 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40185C6956;
        Wed, 31 Aug 2022 06:13:49 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id D665F84053;
        Wed, 31 Aug 2022 15:13:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1661951627;
        bh=p+x5vCC1MuVZ93HxywP/IqGvH3aiSHuaSnRXADOII7E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=utzYtx0Xv5xnxbTcCdn+oKwZOEdASaW5/1uRAyeq0HooV7HINMrh01sU5T3xrKcUA
         lEEi2dvsWJbH3f2tHFezKghxWw0mUMEHOweDCTk8St6N/NxmQF+eFN9DyRDIJMukYr
         b7V3VyNdUZAQDJHHH6v1X/9Ow3skrwTbODQYiPk+ie5raNuTs+1K7/FgeEWDUY/0jM
         ieyr6S5YDe8M4sa87i1J0rfQQEypohHkvDpK48lm4SFeApeqW2Q+wDnNfMsvgtcVfY
         DnXYC1PRdWI2U7lnQ+MiSUXAQvAabFvQ5qNJ8CHaTzBagu5PFpWE0PrLV2RZiWW9Je
         j7ZOPhXk06h1Q==
Message-ID: <99ac701e-65b3-3bdf-6051-27723df2dcd8@denx.de>
Date:   Wed, 31 Aug 2022 15:13:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] brcmfmac: add 43439 SDIO ids and initialization
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
References: <20220827024903.617294-1-marex@denx.de>
 <874jxsfxkh.fsf@kernel.org>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <874jxsfxkh.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/22 13:43, Kalle Valo wrote:
> Marek Vasut <marex@denx.de> writes:
> 
>> Add HW and SDIO ids for use with the muRata 1YN (Cypress CYW43439).
>> Add the firmware mapping structures for the CYW43439 chipset.
>> The 43439 needs some things setup similar to the 43430 chipset.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> The title should be:
> 
> wifi: brcmfmac: add 43439 SDIO ids and initialization
> 
> I can fix that during commit.

Please do, thank you.
