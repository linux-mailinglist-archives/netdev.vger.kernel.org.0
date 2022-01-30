Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81BA4A37E2
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 18:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355728AbiA3RY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 12:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243481AbiA3RY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 12:24:27 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B762C061714
        for <netdev@vger.kernel.org>; Sun, 30 Jan 2022 09:24:26 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id v74so10842853pfc.1
        for <netdev@vger.kernel.org>; Sun, 30 Jan 2022 09:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lLL2OEKXKcdwXIcMUkt7RNNnhAcpkl6ESbUrbhc0JMA=;
        b=R6qZ6KEc/bfz41fR2WuPmJ2lknHy2jZ7ac3UTHyYx7SC72tGLRJqsR4tzO7kbOZKEa
         6qwk4W7KKFrfI9+zuOitA2l/N6q3P+E7UI46oqOYIXRzeAPfgtnlkNynSMeq+jVB3S+c
         N90+PjdMMlIIGMcfBtAPdma//+omJGGpW2FO0XhViM1aZA8ujg9SNE/5KEPF1MsC4emd
         j1qgkoeTaDY1dGI/LyNmul4g0Lcg2JdBu7/Jm7TcAGZ5LQ0/rvYn02fGhVPmJk2+l4pr
         g24jlnNOwcvUGqpJQOk1qLDAVtCa4K176AyBZrJXiyv7hnB3TBdCkPblfMe/5NEDB8DH
         5fcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lLL2OEKXKcdwXIcMUkt7RNNnhAcpkl6ESbUrbhc0JMA=;
        b=xQgUSilIDZYg+7doVZBJEBa9elmXnLEt0nR76rE4/1n57HUkuTL9gcNUdJv21ywmuG
         KdjJbeSy4eegOiaINEmIVeOyto8jZwdTdIVYJpEQ++ORDCDskbSu9OSWqt+9vv2HUJ0y
         EqwjDC4zM9G9AQvEFCjRJb0bZIaiXTBYtAaDqwgl5FFg75su3FlT9ArD18T7+6GGMKjJ
         piMo8LGa6Xc7Ql6MfM1M1yC4uTrBoa0SXWQJ1tksaCWJkGz2GBS99zCYotQx28jxsGHs
         0V/MSTRwjvV2+JzwlMn+jgJTcixe4e12izHa9v0vU29Bb7aE8Su9DUpcC3knA7sxiJqp
         eoBA==
X-Gm-Message-State: AOAM532rXZjWGT6jssP/L3eLJh+JtS0PpAqjLoZHRplSiihGdkT2NXW3
        gzHs+QUgT9o7WvlPrEvxFrQ=
X-Google-Smtp-Source: ABdhPJyVFJl2mQWebL/9ETWoVTL0UGKQANfq5GI9RL3iOyTXXzpw+8jFT+7SqNaA25M0OPjnYJ3YMQ==
X-Received: by 2002:a05:6a00:1594:: with SMTP id u20mr17040981pfk.75.1643563465472;
        Sun, 30 Jan 2022 09:24:25 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:31be:19f8:e4b4:84c8? ([2600:8802:b00:4a48:31be:19f8:e4b4:84c8])
        by smtp.gmail.com with ESMTPSA id s37sm11443407pfg.144.2022.01.30.09.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jan 2022 09:24:24 -0800 (PST)
Message-ID: <5355fa92-cf8c-4fa5-5157-9b6574f1c876@gmail.com>
Date:   Sun, 30 Jan 2022 09:24:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-12-luizluca@gmail.com> <87ee5fd80m.fsf@bang-olufsen.dk>
 <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk>
 <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <CAJq09z5sJJO_1ogPi5+PhHkBS9ry5_oYctMhxu68GRNqEr3xLw@mail.gmail.com>
 <CAJq09z4tpxjog2XusyFvvTcr+S6XX24r_QBLW9Sov1L1Tebb5A@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJq09z4tpxjog2XusyFvvTcr+S6XX24r_QBLW9Sov1L1Tebb5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2022 8:42 PM, Luiz Angelo Daros de Luca wrote:
>>> I suggested it might be checksum problem because I'm also affected. In
>>> my case, I have an mt7620a SoC connected to the rtl8367s switch. The
>>> OS offloads checksum to HW but the mt7620a cannot calculate the
>>> checksum with the (EtherType) Realtek CPU Tag in place. I'll try to
>>> move the CPU tag to test if the mt7620a will then digest the frame
>>> correctly.
>>
>> I implemented a new DSA tag (rtl8_4t, with "t" as in trailing) that
>> puts the DSA tag before the Ethernet CRC (the switch supports both).
>> With no tag in the mac layer, mediatek correctly calculated the ip
>> checksum. However, mediatek SoC included the extra bytes from the DSA
>> tag in the TCP checksum, even if they are after the ip length.
>>
>> This is the packet leaving the OS:
>>
>> 0000   04 0e 3c fc 4f aa 50 d4 f7 33 15 8a 08 00 45 10
>> 0010   00 3c 00 00 40 00 40 06 b7 58 c0 a8 01 01 c0 a8
>> 0020   01 02 00 16 a1 50 80 da 39 e9 b2 2a 23 cf a0 12
>> 0030   fe 88 83 82 00 00 02 04 05 b4 04 02 08 0a 01 64
>> 0040   fb 28 66 42 e0 79 01 03 03 03 88 99 04 00 00 20
>> 0050   00 08
>>
>> TCP checksum is at 0x0032 with 0x8382 is the tcp checksum
>> DSA Tag is at 0x4a with 8899040000200008
>>
>> This is what arrived at the other end:
>>
>> 0000   04 0e 3c fc 4f aa 50 d4 f7 33 15 8a 08 00 45 10
>> 0010   00 3c 00 00 40 00 40 06 b7 58 c0 a8 01 01 c0 a8
>> 0020   01 02 00 16 a1 50 80 da 39 e9 b2 2a 23 cf a0 12
>> 0030   fe 88 c3 e8 00 00 02 04 05 b4 04 02 08 0a 01 64
>> 0040   fb 28 66 42 e0 79 01 03 03 03
>>
>> TCP checksum is 0xc3e8, but the correct one should be 0x50aa
>> If you calculate tcp checksum including 8899040000200008, you'll get exactly
>> 0xc3e8 (I did the math).
>>
>> So, If we use a trailing DSA tag, we can leave the IP checksum offloading on
>> and just turn off the TCP checksum offload. Is it worth it?
> 
> No, IP checksum is always done in SW.
> 
>> Is it still interesting to have the rtl8_4t merged?
> 
> Maybe it is. It has uncovered a problem. The case of trailing tags
> seems to be unsolvable even with csum_start. AFAIK, the driver must
> cksum from "skb->csum_start up to the end". When the switch is using
> an incompatible tag, we have:
> 
> slave(): my features copied from master tells me I can offload
> checksum. Do nothing
> tagger(): add tag to the end of skb
> master(): Offloading HW, chksum from csum_start until the end,
> including the added tag
> switch(): remove the tag, forward to the network
> remove_client(): I got a packet with a broken checksum.

This is unfortunately expected here, because you program the hardware 
with the full Ethernet frame length which does include the trailer tag, 
and it then uses that length to calculate the transport header checksum 
over the enter payload, thinking the trailer tag is the UDP/TCP payload.

The checksum is calculated "on the fly" as part of the DMA operation to 
send the packet on the wire, so you cannot decouple the checksum 
calculation from the DMA operation, other than by not asking the HW *not 
to* checksum the packet, and instead having software provide that.

Now looking at the datasheet you quoted, there is this:

241. FE_GLO_CFG: Frame Engine Global Configuration (offset: 0x0000)

7:4 RW L2_SPACE L2 Space
(unit: 8 bytes)
0xB

Can you play with this and see if you can account for the extra 4 bytes 
added by the Realtek tag?

> 
> ndo_features_check() will not help because, either in HW or SW, it is
> expected to calculate the checksum up to the end. However, there is no
> csum_end or csum_len. I don't know if HW offloading will support some
> kind of csum_end but it would not be a problem in SW (considering
> skb_checksum_help() is adapted to something like skb_checksum_trimmed
> without the clone).
> 
> That amount of bytes to ignore at the end is a complex question: the
> driver either needs some hint (like it happens with skb->csum_offset)
> to know where transport payload ends or the taggers (or the dsa) must
> save the amount of extra bytes (or which tags were added) in the
> sbk_buff. With that info, the driver can check if HW will work with a
> different csum_start / csum_end or if only a supported tag is in use.
> 
> In my case, using an incompatible tailing tag, I just made it work
> hacking dsa and forcing slave interfaces to disable offloading. This
> way, checksum is calculated before any tag is added and offloading is
> skipped. But it is not a real solution.

Not sure which one is not a "real solution", but for this specific 
combination of DSA conduit driver and switch tag, you have to disable 
checksum offload in the conduit driver and provide it in software. The 
other way would be to configure the realtek switch to work with 
DSA_TAG_8021Q and see if you can continue to offload the data path since 
tagging would use regular 802.1Q vlans, but that means you are going to 
lose a whole lot of management functionality offered by the native 
Realtek tag.
-- 
Florian
