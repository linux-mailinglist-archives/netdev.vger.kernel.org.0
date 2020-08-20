Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9663524C00A
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgHTOGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgHTOAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:00:30 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B223C061385;
        Thu, 20 Aug 2020 07:00:30 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id f19so1242498qtp.2;
        Thu, 20 Aug 2020 07:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y7kkZbgDKvfpk/574axpOPBBzS1cZF0VR+SWjBoO9H0=;
        b=UJkB6f8EFnalqyaUZ8xxRkZa/deKn9zHwP/QN0nYHhh0DnGBB+xdUmx1s2WfRWMxwD
         yEqcrDdCI4yQEg9zIMM4tU4wZIWEISRJutE318s0IR3dvwSiCDWqMWT3I4rqv4nAu9Za
         TIdIBV8ujpbdCOWWSGWizwDlyamNPswkvAlRVXUSunP59QNsCYH2RfHEab4b6i2Yn801
         F0j1ln4MQe520NWTXicnIjtT0Bs+HGaOLb0KnZzhodh8EBMGg0WD2H2IVyG3mLrOwhqn
         4wQY5ejivfNU9JNBxuJ05alPdqOIwDYxaPbY+JHziVw11Gpskx94yLkvhA2WLYKkfzjs
         o8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y7kkZbgDKvfpk/574axpOPBBzS1cZF0VR+SWjBoO9H0=;
        b=Jo/c6Dft181PytDVpP5S/n7qQSyZDYNrwUAHo4VUwksqft+3IN7M2v8a65dk6IRwYj
         gkBUOzPCsiGv66HLsSma15gRa4jbkE/mGjcL7VxbQhacDu8uhA+hzJBMBlMvz8LvDRMP
         21UWhb2Hs9ChcIk9WSFZGC47MysUzTKzXLgaRnKQPD6u32kQThlfGctL8IfZSHWKQk+p
         fXnZib2FZiOgARcs++SgcESDN8RTraH4GwvWU9P1jCXeQuIJHdD8i1Ny4fi+qpMG4yej
         uU+N92fzyPTvqpFMW/VC3h5UHcl39t4y2NkJRZZ4qUVnIsZaVRdqIrxTGs8/0+PJvvvi
         LU8Q==
X-Gm-Message-State: AOAM530Yerclc+vZKfX8GLUXSlvr7k6ira8lxpSi0ykzA3FK6PrZJQe2
        G2Xb1KWjkJujRBV2nfs4z28=
X-Google-Smtp-Source: ABdhPJzNPNvFa9F9ysTxspkq0uataKkZ7GDKUu3868rXwV4g7nFWZdGmIZoPnveSD9k5k0gUm9ei8g==
X-Received: by 2002:ac8:6b92:: with SMTP id z18mr2670985qts.96.1597932029418;
        Thu, 20 Aug 2020 07:00:29 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4452:db16:7f2f:e7bf? ([2601:282:803:7700:4452:db16:7f2f:e7bf])
        by smtp.googlemail.com with ESMTPSA id m26sm3198218qtc.83.2020.08.20.07.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 07:00:28 -0700 (PDT)
Subject: Re: xdp generic default option
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20200819092811.GA2420@lore-desk>
 <CAEf4BzZSui9r=-yDzy0CjWKVx9zKvQWX6ZBNXmSUTOHCOR+7RA@mail.gmail.com>
 <20200820102539.35ad8687@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dad435ca-d7df-f78e-93bf-4016545c15d8@gmail.com>
Date:   Thu, 20 Aug 2020 08:00:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200820102539.35ad8687@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/20 2:25 AM, Jesper Dangaard Brouer wrote:
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index a00aa737ce29..1f85880ee412 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -8747,9 +8747,9 @@ static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
>>>  {
>>>         if (flags & XDP_FLAGS_HW_MODE)
>>>                 return XDP_MODE_HW;
>>> -       if (flags & XDP_FLAGS_DRV_MODE)
>>> -               return XDP_MODE_DRV;
>>> -       return XDP_MODE_SKB;
>>> +       if (flags & XDP_FLAGS_SKB_MODE)
>>> +               return XDP_MODE_SKB;
>>> +       return XDP_MODE_DRV;
>>>  }
>>>  
>>
>> I think the better way would be to choose XDP_MODE_DRV if ndo_bpf !=
>> NULL and XDP_MODE_SKB otherwise. That seems to be matching original
>> behavior, no?
> 
> Yes, but this silent fallback to XDP_MODE_SKB (generic-XDP) have
> cause a lot of support issues in the past.  I wish we could change it.
> We already changed all the samples/bpf/ to ask for XDP_FLAGS_DRV_MODE,
> so they behave this way.
> 

I would prefer the flags check in Lorenzo's proposed patch which is an
explicit opt in to the SKB mode.
