Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D474FEB63
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiDLX3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiDLX20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:28:26 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D89F6D2;
        Tue, 12 Apr 2022 15:32:14 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id t25so332340lfg.7;
        Tue, 12 Apr 2022 15:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=bTkux4B6XrPxs7uR/ZWdE6mZk/YED01EcqeCEeBlQD4=;
        b=TTiGkV3DCIvaovkwxhVL7WNQMC+mAxvDYsPenZC7aTXi53vQJbXOpmxfvWHW8pUvK/
         QnqO4W+u6ZT0zEXXdcvFmDI8JgqQAVzMDQY81z/qjnyRybpd5GD2eas95viKqdNWD7jH
         wGPcl1GsxL/6H8y4SQb6EK+ftO7dH9xBWLbGHj5xHw8zMq0aJ/ax8oc2p7Gf0LMs87K9
         VOdrR3PbdsH4SWqZZ7PQvn1k8B+xGt3tJpG2optHOe6IRiYZgMhKsKb1VVGqU6XzFCdD
         56o94e7I+/5mtl688yVKNE4c3xjnWU/IjU8carUf2N1y50lBR1+8YsQyjKWuuxMf5sRH
         URQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=bTkux4B6XrPxs7uR/ZWdE6mZk/YED01EcqeCEeBlQD4=;
        b=0I23jPXciTRSyYX62Zh1XSDcRVXRjUtigyTKbhD5EbAFjaH31TTKemaeAXb1s81MLl
         XBdV/n7+1L5fgv5onpkEAA8aw/jo5HlfPA5IxYNL8/B07r64snM50L7iuO6wP9Gqtb5Q
         VVBNSB+TmrObAq22lElXOjZAwoid0EpY8xMxJADF+TUJam1LVEe0DG1DXtB3gTmFnhqx
         7iJvRfXtOZezbdkt2t+IjJupHyfVEU4hX/lgMsdrSc5miHHi8QAQWenLzWUxieQJkQG3
         vHhGwjqZBpQg0dhnVbFx5Ij5ZOzNEPcMggSH5QAallz5TJMgozxd1mOVh9z+MNozQ/Na
         AMVg==
X-Gm-Message-State: AOAM531uIECyRfYiCOp8gFKztF4t17xsjPOmdLuDyOoH6zeuRGHkacBy
        uXSoL4xZBqpaSG+XpanOtcY=
X-Google-Smtp-Source: ABdhPJzzw+FMh3QyfjXmS6pY5uqsp1uVsRUc2yhPf3faGKX1J/PYPc0TH/CN2Q/29KdqkrDFUioK+A==
X-Received: by 2002:a19:6759:0:b0:46b:b99f:a7ac with SMTP id e25-20020a196759000000b0046bb99fa7acmr3403805lfj.312.1649802732918;
        Tue, 12 Apr 2022 15:32:12 -0700 (PDT)
Received: from ?IPV6:2001:470:6180:0:a105:2443:47df:c2c9? ([2001:470:6180:0:a105:2443:47df:c2c9])
        by smtp.googlemail.com with ESMTPSA id w14-20020a0565120b0e00b0044a9b61d2b3sm3811099lfu.221.2022.04.12.15.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 15:32:12 -0700 (PDT)
Message-ID: <c37dd38f-c855-fb86-643b-c35ef5bb8ca6@gmail.com>
Date:   Wed, 13 Apr 2022 00:32:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/3] rndis_host: enable the bogus MAC fixup for ZTE
 devices from cdc_ether
Content-Language: en-GB
From:   Lech Perczak <lech.perczak@gmail.com>
To:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
References: <20220407001926.11252-1-lech.perczak@gmail.com>
 <20220407001926.11252-3-lech.perczak@gmail.com>
 <87o81d1kay.fsf@miraculix.mork.no>
 <c5f5e028-26b1-5c2d-ed7f-e36550ce6ac2@gmail.com>
In-Reply-To: <c5f5e028-26b1-5c2d-ed7f-e36550ce6ac2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 2022-04-07 o 22:51, Lech Perczak pisze:
> Hi Bjørn,
>
> Many thanks you for your review! Answers inline.
>
> W dniu 2022-04-07 o 08:25, Bjørn Mork pisze:
>> Lech Perczak <lech.perczak@gmail.com> writes:
>>
>>> +static int zte_rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>>> +{
>>> +    return rndis_rx_fixup(dev, skb) && usbnet_cdc_zte_rx_fixup(dev, 
>>> skb);
>>> +}
>> Does this work as expected? Only the last ethernet packet in the rndis
>> frame will end up being handled by usbnet_cdc_zte_rx_fixup(). The
>> others are cloned and submitted directly to usbnet_skb_return().
> I've got some positive reports from at least two owners of the device 
> - I don't have one myself. In the meantime asked them to run tests 
> with high traffic, because this should most probably manifest itself 
> in that scenario easily - my wild guess is that the modem doesn't use 
> batching, but you are most certainly right in the general case. And 
> for testing on older modems, we can probably only count on Kristian.
>>
>> I don't know how to best solve that, but maybe add another
>> RNDIS_DRIVER_DATA_x flag and test that in rndis_rx_fixup?  I.e something
>> like
>>
>>     bool fixup_dst = dev->driver_info->data & 
>> RNDIS_DRIVER_DATA_FIXUP_DST:
>>          ..
>>
>>         /* try to return all the packets in the batch */
>>         skb2 = skb_clone(skb, GFP_ATOMIC);
>>         if (unlikely(!skb2))
>>             break;
>>         skb_pull(skb, msg_len - sizeof *hdr);
>>         skb_trim(skb2, data_len);
>>                  if (fixup_dst)
>>                      usbnet_cdc_zte_rx_fixup(dev, skb2);
>>         usbnet_skb_return(dev, skb2);
>>     }
>>          if (fixup_dst)
>>                  usbnet_cdc_zte_rx_fixup(dev, skb);
>>
>>     /* caller will usbnet_skb_return the remaining packet */
>>     return 1;
>> }
>
> I'll consider that. My concern with that approach is degradation of 
> performance by testing for that flag, both for ZTE and non-ZTE 
> devices, for each and every packet. But this might be the only 
> solution, as I cannot catch the n-1 sk_buffs from the batch 
> mid-flight, only the last one. The only other way that currently comes 
> to my mind, is to duplicate rndis_rx_fixup, with added calls to 
> usbnet_cdc_zte_rx_fixup in the right places. But the amount of 
> duplicated code by doing so would be huge, so I'd like to avoid that 
> as well.
>
> I will definitely send a V2 after I decide on a solution and do some 
> testing, including high downlink traffic.
>
>>
>>
>>
>> Bjørn
>
Hi Bjørn,

I implemented the fix according to your suggestion and did some testing.
Although I don't have a full MF286R myself, I used my Raspberry Pi 
Zero's USB gadget
to simulate the modem's RNDIS interface, and compared three scenarios:
- generic VID/PID with "locally administered" bit off,
- generic VID/PID with "locally administered" bit on,
- ZTE VID/PID (of MF286R's modem) with "locally administered" bit on.

Of course, only the last one activated the MAC fixup path.

For testing I used one of my modem-less MF286A cross-flashed to MF286R 
using current
OpenWrt master - which are exactly the same hardware, modulo the 
internal modem.
In all three scenarios, when running iperf3 server on the Pi Zero,
I got constant 150Mbps of traffic in both directions, with iperf3 client 
running on the
router itself. When router was uploading data to my "modem", CPU usage 
was around 66%.
When downloading, the total usage would hit 100%, with about 15% 
attributed to syscalls,
and about 85% attributed to softirq.
When using iperf3 client on a PC connected to the router, and enabling 
flow offload,
the softirq load would drop to around 75%, and CPU would idle for the 
rest of time,
in both directions, but the downlink speed would drop to around 125Mbps, 
with upload the
same as if running iperf3 on router itself.

I compared all of this against a build without this patchset, with 
scenario one - getting
exactly  the same performance.
So, suumming up - it seems my concerns about performance were 
exaggerated, so I decided to just
introduce the check inside zte_rndis_fixup(), just as suggested in this 
thread. V2 coming shortly.

One strange quirk I noticed while testing, is that when "locally 
administered" bit in MAC address
was set, the interface would get "usb" prefix on the host side, and 
"eth" otherwise.

-- 
Pozdrawiam/Kind regards,
Lech Perczak

