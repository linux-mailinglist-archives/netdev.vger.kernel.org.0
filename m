Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC85360B5E
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 20:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfGESZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 14:25:02 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42770 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGESZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 14:25:01 -0400
Received: by mail-qk1-f193.google.com with SMTP id 201so6401356qkm.9;
        Fri, 05 Jul 2019 11:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EGPVypn6CKAAN7UHHn0KvjwCwIhSqraRSiekyt3NwfU=;
        b=bMXd1i8a2cZiAC/g0/DWJxB6nY60Ra3aWdS1SaTItqFB1aiwx2oLFB/65/QzFuLbIH
         FD6wWCis+PUlYWc8MZAItrEjxZE1hA5F7nOysU2xP4CNxDfvv+FKRyfj+Vk+b9td5mUy
         r4wysSmsAx+Gbi353wH+nd6zYl4kjAGve+QMYA9LMGrwjZ/Osit7h1ezIRLRp8PjfOur
         qMtXhKs/zWLIT8osrD3FzLPQ+WZUhI/0mtWTmUV6Nl2lqKPOKch+7H64BEkSM/GrxL6u
         M+iGif7K7eUwyjfUtdW4htg8eSOCcVMoE4JCXUlQ1ke5EMVl/7mhCslzOp8qhqIKiW2R
         lYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EGPVypn6CKAAN7UHHn0KvjwCwIhSqraRSiekyt3NwfU=;
        b=RiOven2QvRwUZYOlMmIiAa7CctZ73PbWyZzDg2ckmt8qR1VaBiefqWmRY5cbbLd8eP
         TN0HhqhfY9oEYAo3Iu+VLydeK2s++iNmMRQxuymyudwaWNVvO+M61765qk/c2Pf4ndcR
         gIBisEw9RjXf65/0nXwElT2nB1qY/DJoj1YLWlXl5I4bNKTld6uN7indQcrgRM06w6bc
         +ZXeYmJqumANMvE9Tr75fQcNXAOAbGRbbN5LRTez39M28Ah5Q5yDJ4dxYZv32qar9jEe
         cFDlXzpIOKerX7O+ZFVeXeAbDaH3K6VoXFAfpd9XZunHspDyNNQt/DQ772Efp1YLy4ap
         fCOg==
X-Gm-Message-State: APjAAAUNq4k3VNZNeHfUNALLxR57MpAgBhzCDwFyAdQEoJ6vnc+wp53n
        BWOduv/DvB2uwmQ8/BMLGZU=
X-Google-Smtp-Source: APXvYqwzEBrVmSKcUKg1bt+Hr27s3R/Z8WyEUHSpT+W84+y4zHJEaU0FMvaiRD+WOkFg4Ynbm3mcrA==
X-Received: by 2002:a37:7643:: with SMTP id r64mr4105639qkc.467.1562351099833;
        Fri, 05 Jul 2019 11:24:59 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d1::107e? ([2620:10d:c091:480::a5e6])
        by smtp.gmail.com with ESMTPSA id r26sm4081395qkm.57.2019.07.05.11.24.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 11:24:59 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: Fix wifi low signal strength issue of
 RTL8723BU
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
References: <20190704105528.74028-1-chiu@endlessm.com>
 <8f1454ca-4610-03d0-82c4-06174083d463@gmail.com>
 <CAB4CAwc8jJQ2f8vpoB0Y6sc0fJmmrq+5rRuJ+TqGMMgCczRi+A@mail.gmail.com>
Message-ID: <9d971d4c-8bad-75a5-5b69-d10082d5f2ab@gmail.com>
Date:   Fri, 5 Jul 2019 14:24:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAB4CAwc8jJQ2f8vpoB0Y6sc0fJmmrq+5rRuJ+TqGMMgCczRi+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/4/19 10:27 PM, Chris Chiu wrote:
> On Fri, Jul 5, 2019 at 12:43 AM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>>
>> On 7/4/19 6:55 AM, Chris Chiu wrote:
>>> The WiFi tx power of RTL8723BU is extremely low after booting. So
>>> the WiFi scan gives very limited AP list and it always fails to
>>> connect to the selected AP. This module only supports 1x1 antenna
>>> and the antenna is switched to bluetooth due to some incorrect
>>> register settings.
>>>
>>> Compare with the vendor driver https://github.com/lwfinger/rtl8723bu,
>>> we realized that the 8723bu's enable_rf() does the same thing as
>>> rtw_btcoex_HAL_Initialize() in vendor driver. And it by default
>>> sets the antenna path to BTC_ANT_PATH_BT which we verified it's
>>> the cause of the wifi weak tx power. The vendor driver will set
>>> the antenna path to BTC_ANT_PATH_PTA in the consequent btcoexist
>>> mechanism, by the function halbtc8723b1ant_PsTdma.
>>>
>>> This commit hand over the antenna control to PTA(Packet Traffic
>>> Arbitration), which compares the weight of bluetooth/wifi traffic
>>> then determine whether to continue current wifi traffic or not.
>>> After PTA take control, The wifi signal will be back to normal and
>>> the bluetooth scan can also work at the same time. However, the
>>> btcoexist still needs to be handled under different circumstances.
>>> If there's a BT connection established, the wifi still fails to
>>> connect until BT disconnected.
>>>
>>> Signed-off-by: Chris Chiu <chiu@endlessm.com>
>>> ---
>>>
>>>
>>> Note:
>>>  v2:
>>>   - Replace BIT(11) with the descriptive definition
>>>   - Meaningful comment for the REG_S0S1_PATH_SWITCH setting
>>>
>>>
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 11 ++++++++---
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  3 ++-
>>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
>>> index 3adb1d3d47ac..ceffe05bd65b 100644
>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
>>> @@ -1525,7 +1525,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
>>>       /*
>>>        * WLAN action by PTA
>>>        */
>>> -     rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
>>> +     rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);
>>>
>>>       /*
>>>        * BT select S0/S1 controlled by WiFi
>>> @@ -1568,9 +1568,14 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
>>>       rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
>>>
>>>       /*
>>> -      * 0x280, 0x00, 0x200, 0x80 - not clear
>>> +      * Different settings per different antenna position.
>>> +      *      Antenna Position:   | Normal   Inverse
>>> +      * --------------------------------------------------
>>> +      * Antenna switch to BT:    |  0x280,   0x00
>>> +      * Antenna switch to WiFi:  |  0x0,     0x280
>>> +      * Antenna switch to PTA:   |  0x200,   0x80
>>>        */
>>> -     rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
>>> +     rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);
>>
>> Per the documentation, shouldn't this be set to 0x200 then rather than 0x80?
>>
> Per the code before REG_S0S1_PATH_SWITCH setting, the driver has told
> the co-processor the antenna is inverse.
>         memset(&h2c, 0, sizeof(struct h2c_cmd));
>         h2c.ant_sel_rsv.cmd = H2C_8723B_ANT_SEL_RSV;
>         h2c.ant_sel_rsv.ant_inverse = 1;
>         h2c.ant_sel_rsv.int_switch_type = 0;
>         rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
> 
> At least the current modification is consistent with the antenna
> inverse setting.
> I'll verify on vendor driver about when/how the inverse be determined.

Fair enough :)

Cheers,
Jes


