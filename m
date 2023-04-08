Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E786DBC30
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 18:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjDHQor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 12:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDHQoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 12:44:46 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894DE30E0;
        Sat,  8 Apr 2023 09:44:44 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 62C4A85801;
        Sat,  8 Apr 2023 18:44:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1680972282;
        bh=1f4Cn1QAdMCmnPU1TvAc6dqYQPlZdOMKaWAMS0bapt8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=e5S+pUyrrT9bUrwVRuA6nXWkOIFT1fU9EfbNkAv5JkXsq5u/EvwizsNpBtqMVB++Y
         S128op5+e4QSfXoVR3CN845CvN6dPxoDAMKr38UA32IZq94QYh2y4meM8ta0nki3eD
         z/nVmz5Gu2bFEx7M+4iDXLe6MYpp93eVAbWkYPuqOufZACv8jK3rMBHJ1CWuz6Jwg4
         QmJeOmCHlLGzDFUmVRJKfqFqGD/WKkTqFZiBx5Sxn2YzEI/9tb2JpfJe0ioRZMYV4t
         ujwCpekHDwcqafMfyv3IlUxcGsAtKkQr2hVGGCdIsbOCm8xoSQ94w1ijouzzXaef1F
         XPOVnojrgPeVA==
Message-ID: <509e4308-9164-4131-4b93-75c42568d1e4@denx.de>
Date:   Sat, 8 Apr 2023 18:44:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2] wifi: brcmfmac: add Cypress 43439 SDIO ids
To:     Simon Horman <simon.horman@corigine.com>
Cc:     linux-wireless@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230407203752.128539-1-marex@denx.de>
 <ZDGHF0dKwIjB1Mrj@corigine.com>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <ZDGHF0dKwIjB1Mrj@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/23 17:24, Simon Horman wrote:
> On Fri, Apr 07, 2023 at 10:37:52PM +0200, Marek Vasut wrote:
>> Add SDIO ids for use with the muRata 1YN (Cypress CYW43439).
>> The odd thing about this is that the previous 1YN populated
>> on M.2 card for evaluation purposes had BRCM SDIO vendor ID,
>> while the chip populated on real hardware has a Cypress one.
>> The device ID also differs between the two devices. But they
>> are both 43439 otherwise, so add the IDs for both.
>>
>> On-device 1YN (43439), the new one, chip label reads "1YN":
>> ```
>> /sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
>> 0x04b4
>> 0xbd3d
>> ```
>>
>> EA M.2 evaluation board 1YN (43439), the old one, chip label reads "1YN ES1.4":
>> ```
>> /sys/.../mmc_host/mmc0/mmc0:0001/# cat vendor device
>> 0x02d0
>> 0xa9a6
>> ```
>>
>> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>> Fixes: be376df724aa3 ("wifi: brcmfmac: add 43439 SDIO ids and initialization")
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> 
>> ---
>> NOTE: Please drop the Fixes tag if this is considered unjustified
> 
> <2c>
> Feels more like enablement than a fix to me.
> </2c>

I added it because

Documentation/process/stable-kernel-rules.rst

L24  - New device IDs and quirks are also accepted.

So, really, up to the maintainer whether they are fine with it being 
backported to stable releases or not. I don't really mind either way.
