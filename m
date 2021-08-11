Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3D73E931B
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhHKN5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbhHKN5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:57:25 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6E7C061765;
        Wed, 11 Aug 2021 06:57:02 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id u10so4697804oiw.4;
        Wed, 11 Aug 2021 06:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bIBlP3UwzKpqrkTRDPJtDHwi6egy8ClHSbK6GsDGiO4=;
        b=eQM3hy0sFYoc8BCC11C8wX27ZlVsL25n5IqWc9uavRaYdYMJJTg37oJItt3nbIRPfe
         VA1Wph3SpWDzf9yk0VObgehNz5yVg0c4dtNfJGsORCXciYT3j3EnR4oq7jDMgIQDpj8m
         a2HpHbs19eYFJjyQIGvAtxIFgMBll5p0rpy3mfstDEg61bG0Xjsfo5KTLTpu6zCMx1wU
         5IJnGWD6okHwloDW021IE5n/z+FyT6ys5rfo6rosb8eeblpqsef8V/QxOYLGFF9f2FV4
         3NiwKVR3yHld4KT+ZbVVBmsFcpmCcUwz08MK6g4rHNhJkf8ry3xSJEM3iJiIlRzBhhey
         Gqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bIBlP3UwzKpqrkTRDPJtDHwi6egy8ClHSbK6GsDGiO4=;
        b=m052sctEknx7uwSH2jPxZhplpv1Fb/GFlgtvyYJNeTzqYdPxZZiCokhdoLQxMstYye
         cah52cUIHDj6usN3fcm6NdezahdMDFige4iV1r8Z6PqovO6vzq3wpiztz0JBQzoC0H9c
         Y7D8l0fcPql3LQ/SXqNPbZkleG/n/CwoqUjEaFVGQIn/VtWXwgBXeQI7/8njgjGcJ7HA
         Z2pmI5ewPa+QGNSO9mbeAM3BeNyDDMNY7TTz1Gte72ebyJZ4Mm31gcdRqboUkHbepp19
         DIo5JZTnysbJugZ20Vh0XYfDPHMUMR0y3StnZoYNyzYM5/Rib4pso+cMzEsHTthJX99B
         UXWw==
X-Gm-Message-State: AOAM530u+iKLSjZ0bvSnMG46ojdJENcmjbOp+l0X4RgLedi5LZwh8HXs
        qPnyOwLrps2s7WVqG9eVJoQ=
X-Google-Smtp-Source: ABdhPJxfYd7WuRuE7eu7Z1jeM+G/vO74qHut8Y47MOkI0xaLfLjRtiL5dj9vY28R9X+ZClUmCa6WUA==
X-Received: by 2002:a05:6808:14:: with SMTP id u20mr7722445oic.150.1628690221588;
        Wed, 11 Aug 2021 06:57:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id y33sm1548029ota.66.2021.08.11.06.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 06:57:01 -0700 (PDT)
Subject: Re: [PATCH net-next v3] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <c0a6f817-0225-c863-722c-19c798daaa4b@gmail.com>
 <20210810123327.15998-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <25dcf6e8-cdd6-6339-f499-5c3100a7d8c4@gmail.com>
Date:   Wed, 11 Aug 2021 07:56:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810123327.15998-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/21 6:33 AM, Rocco Yue wrote:
> On Mon, 2021-08-09 at 16:43 -0600, David Ahern wrote:
>> On 8/9/21 8:01 AM, Rocco Yue wrote:
> 
>> +
>>>  #ifdef CONFIG_SYSCTL
>>>  
>>>  static int addrconf_sysctl_forward(struct ctl_table *ctl, int write,
>>> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
>>> index c467c6419893..a04164cbd77f 100644
>>> --- a/net/ipv6/ndisc.c
>>> +++ b/net/ipv6/ndisc.c
>>> @@ -1496,6 +1496,12 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>>>  		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
>>>  		mtu = ntohl(n);
>>>  
>>> +		if (in6_dev->ra_mtu != mtu) {
>>> +			in6_dev->ra_mtu = mtu;
>>> +			inet6_iframtu_notify(in6_dev);
>>> +			ND_PRINTK(2, info, "update ra_mtu to %d\n", in6_dev->ra_mtu);
>>> +		}
>>> +
>>>  		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
>>>  			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
>>>  		} else if (in6_dev->cnf.mtu6 != mtu) {
>>
>> Since this MTU is getting reported via af_info infrastructure,
>> rtmsg_ifinfo should be sufficient.
>>
>> From there use 'ip monitor' to make sure you are not generating multiple
>> notifications; you may only need this on the error path.
> 
> Hi David,
> 
> To avoid generating multiple notifications, I added a separate ramtu notify
> function in this patch, and I added RTNLGRP_IPV6_IFINFO nl_mgrp to the ipmonitor.c
> to verify this patch was as expected.
> 
> I look at the rtmsg_ifinfo code, it should be appropriate and I will use it and
> verify it.
> 
> But there's one thing, I'm sorry I didn't fully understand the meaning of this
> sentence "you may only need this on the error path". Honestly, I'm not sure what
> the error patch refers to, do you mean "if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu)" ?
> 

looks like nothing under:
    if (ndopts.nd_opts_mtu && in6_dev->cnf.accept_ra_mtu) {

    }

is going to send a link notification so you can just replace
inet6_iframtu_notify with rtmsg_ifinfo in your proposed change.
