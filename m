Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D304F8912
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiDGUzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiDGUzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:55:13 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A5BA2064;
        Thu,  7 Apr 2022 13:51:54 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p10so11647148lfa.12;
        Thu, 07 Apr 2022 13:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EFQFKgXzq6QSoC33rTqJQXlNI+CEd5gBMZePyscFbyw=;
        b=SZM6rO+0uFE4anXyFhzhJ9ODAQIA22CCchsSyFEaVNEXt5dcWB2MXmQGmbZ1sfbWvt
         5u/P8GJH7EA3lenOwSIFhnTcSPPI/7CdE0t6x9zxeiqJd5tUsNrgM2aoQCnXZcLhHuwL
         mxiyGp9wSNT2vkE7ISDB93AazLE4+nnp7kLwUuNOoeucWvpmqGYltaBVYLuNTviAoAlt
         42XQ2kB6db5idq4g3QVt6fV43xh2d4MV+LQ2fKCzKcL+uBombltNNBygvme4ZhlYlmBn
         cJijSy1VKTAur4iA3yUbRdPFFN8QwD1Us/sx/DYAXHXq7GomGMuKufeMUpvYfF6eKpFR
         7M0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EFQFKgXzq6QSoC33rTqJQXlNI+CEd5gBMZePyscFbyw=;
        b=x6TDFYZ/ZKD8Gf5aRDsefv5N6ES4EW2j2HnltGDSpHKz0p8JkKesRSzuoy7PRsKY3t
         FrLGLfTZ86WU6Dy8CqOLuwvlvZ98Oex+OHJofKhgtW0UzljB7CTvF8QkKNWhtee2t+mn
         REbjOixkYeU9k16k3jQ+xi2eDWnPvHghT+wNGRYrrh9L9r0cFdjryc6uA2zs791UMMxq
         dAL+mklPvpmK6VIM4NjMqybEJs4vluAgZa+syQotn0TLKia21L4j9wNfFzLB1Q/S1YDu
         D0uG3Y8IBQVA0g0FfbJEUOTXShLn224zWUfzes34yMe2+/JbVwml5bzZ7pc918MqPE2Z
         hibg==
X-Gm-Message-State: AOAM530btSsBZgpss4tlGhrePXo76wwLETY31NvSbBEZwQKV54Ga6bu/
        2ORXnS7FR3dBFC4rsfdwjlY=
X-Google-Smtp-Source: ABdhPJyy0fU1oI52cP+Ixer66pFEpY+xh19onGJTslmEeJzgy3vzrvnntbC3kZHg5ZhSE7PT7pjHPg==
X-Received: by 2002:a05:6512:12d4:b0:44a:27fd:c3a2 with SMTP id p20-20020a05651212d400b0044a27fdc3a2mr11096370lfg.75.1649364713057;
        Thu, 07 Apr 2022 13:51:53 -0700 (PDT)
Received: from ?IPV6:2001:470:6180:0:818f:9b:6443:a5bc? ([2001:470:6180:0:818f:9b:6443:a5bc])
        by smtp.googlemail.com with ESMTPSA id z21-20020a195e55000000b00466306e7b32sm168455lfi.222.2022.04.07.13.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 13:51:52 -0700 (PDT)
Message-ID: <c5f5e028-26b1-5c2d-ed7f-e36550ce6ac2@gmail.com>
Date:   Thu, 7 Apr 2022 22:51:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/3] rndis_host: enable the bogus MAC fixup for ZTE
 devices from cdc_ether
Content-Language: en-GB
To:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
References: <20220407001926.11252-1-lech.perczak@gmail.com>
 <20220407001926.11252-3-lech.perczak@gmail.com>
 <87o81d1kay.fsf@miraculix.mork.no>
From:   Lech Perczak <lech.perczak@gmail.com>
In-Reply-To: <87o81d1kay.fsf@miraculix.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjørn,

Many thanks you for your review! Answers inline.

W dniu 2022-04-07 o 08:25, Bjørn Mork pisze:
> Lech Perczak <lech.perczak@gmail.com> writes:
>
>> +static int zte_rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>> +{
>> +	return rndis_rx_fixup(dev, skb) && usbnet_cdc_zte_rx_fixup(dev, skb);
>> +}
>>   
> Does this work as expected? Only the last ethernet packet in the rndis
> frame will end up being handled by usbnet_cdc_zte_rx_fixup().  The
> others are cloned and submitted directly to usbnet_skb_return().
I've got some positive reports from at least two owners of the device - 
I don't have one myself. In the meantime asked them to run tests with 
high traffic, because this should most probably manifest itself in that 
scenario easily - my wild guess is that the modem doesn't use batching, 
but you are most certainly right in the general case. And for testing on 
older modems, we can probably only count on Kristian.
>
> I don't know how to best solve that, but maybe add another
> RNDIS_DRIVER_DATA_x flag and test that in rndis_rx_fixup?  I.e something
> like
>
> 	bool fixup_dst = dev->driver_info->data & RNDIS_DRIVER_DATA_FIXUP_DST:
>          ..
>
> 		/* try to return all the packets in the batch */
> 		skb2 = skb_clone(skb, GFP_ATOMIC);
> 		if (unlikely(!skb2))
> 			break;
> 		skb_pull(skb, msg_len - sizeof *hdr);
> 		skb_trim(skb2, data_len);
>                  if (fixup_dst)
>                  	usbnet_cdc_zte_rx_fixup(dev, skb2);
> 		usbnet_skb_return(dev, skb2);
> 	}
>          if (fixup_dst)
>                  usbnet_cdc_zte_rx_fixup(dev, skb);
>
> 	/* caller will usbnet_skb_return the remaining packet */
> 	return 1;
> }

I'll consider that. My concern with that approach is degradation of 
performance by testing for that flag, both for ZTE and non-ZTE devices, 
for each and every packet. But this might be the only solution, as I 
cannot catch the n-1 sk_buffs from the batch mid-flight, only the last 
one. The only other way that currently comes to my mind, is to duplicate 
rndis_rx_fixup, with added calls to usbnet_cdc_zte_rx_fixup in the right 
places. But the amount of duplicated code by doing so would be huge, so 
I'd like to avoid that as well.

I will definitely send a V2 after I decide on a solution and do some 
testing, including high downlink traffic.

>
>
>
> Bjørn

-- 
Pozdrawiam/Kind regards,
Lech Perczak

