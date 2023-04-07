Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EABE6DAEF8
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjDGOzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjDGOzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:55:45 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A219759;
        Fri,  7 Apr 2023 07:55:43 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E19078611D;
        Fri,  7 Apr 2023 16:55:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1680879341;
        bh=LUrHDtYdRr2EkQo65wZH81MV1QaySRUxWq5e8XmnnFw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=AoLb6GXIIEHsXk4NHukrCGQhcn9jKhdegdbJm5mA/0kLMnBzEY0MK71LFc3kOhdpI
         8tapKzJizYu2t1maNtflZe99nI8VBL86+Z8T5GogIVnJnO/wPbXiO5hZRGp8FQGeb2
         1DCYRRhUMDCqQq/AM5lNR45ShhkvEx2+H6D9EiG5NqeRmmPdhv63CuC0uKkf3+T2hk
         i+oJNEGlM+/K0by4f7ntKz0isc5Wpp1v9y8NoSsQ6uSk/l7hU21POwCs3pb5wQTxDf
         sdiHfyCwJXIGhwuDLRPi7JxW8F1cCybiPNxqlEBekuoRokMqwU/ZfWP5AQU3eid0Bb
         PJMyYl/g92WGA==
Message-ID: <07ef5b7b-0219-f99a-f825-7766451f1e7a@denx.de>
Date:   Fri, 7 Apr 2023 16:55:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] wifi: brcmfmac: add Cypress 43439 SDIO ids
To:     Hans de Goede <hdegoede@redhat.com>, linux-wireless@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
References: <20230407013118.466441-1-marex@denx.de>
 <845521b4-0451-f0c0-7606-0144475e98f7@redhat.com>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <845521b4-0451-f0c0-7606-0144475e98f7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/23 15:15, Hans de Goede wrote:
> Hi,

Hi,

> On 4/7/23 03:31, Marek Vasut wrote:
>> Add SDIO ids for use with the muRata 1YN (Cypress CYW43439).
>> The odd thing about this is that the previous 1YN populated
>> on M.2 card for evaluation purposes had BRCM SDIO vendor ID,
>> while the chip populated on real hardware has a Cypress one.
>> The device ID also differs between the two devices. But they
>> are both 43439 otherwise, so add the IDs for both.
>>
>> ```
>> /sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
>> 0x04b4
>> 0xbd3d
>> ```
>>
>> Fixes: be376df724aa3 ("wifi: brcmfmac: add 43439 SDIO ids and initialization")
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> Thanks, patch looks good to me:

Thanks. I now assembled the old device and got both IDs, so I will add 
them to the commit message and send V2. I also noticed that the old 
device is some ES1.4 chip, while the new one is production silicon:

On-device 1YN (43439), the new one, chip label reads "1YN":
```
/sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
0x04b4
0xbd3d
```

EA M.2 evaluation board 1YN (43439), the old one, chip label reads "1YN 
ES1.4":
```
/sys/.../mmc_host/mmc0/mmc0:0001/# cat vendor device
0x02d0
0xa9a6
```
