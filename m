Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC13C2AB316
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 10:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgKIJFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 04:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgKIJFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 04:05:20 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960DFC0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 01:05:18 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id za3so11119986ejb.5
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 01:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hvaF8HXiCnRMvM3pn23F+gmFypHWaWheg3PJy5itkNk=;
        b=BwyMAE5GDSBa0j9ztihVl8ufSeA6aUVr2IxpWMT/np+lMnPzkehJpeBXeut76XmoYh
         y0MAELVZXHCKTERNemtTCpefN+tXkQEFnAZcUPk/aZKKo77lye6hbVGjPZC8q/K5VAOZ
         nF0iejQFdUlWcn94LxcypOPnkos99j+alOZMMwVnyDMUAjP1UDjBAHtD6Uc6VQG919bM
         7IP/qObArpiRvALqFtjmd2XKFdEuTDdRjFiO+tfIfAhnzmxAB8qNRIH7LRO8KLM98Fsz
         028eYURFG8M1Klpqb0MLfy25LGADd0aCV2A7hPWFRFJxZLV/c3LCVNwsio5u6hpzo2RF
         g9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hvaF8HXiCnRMvM3pn23F+gmFypHWaWheg3PJy5itkNk=;
        b=FxdvNQzvqv7UC/a6Xd5FEMCMOhNHZ0LDTFxmhXkL4tzN0o2PKh1c8Fu/l5sNYDgiV4
         DD6BEMvaktCRiTMTTh+TZUipfmnG8G6epeHoQl0HtXITYRmmrHP8EKHAZRRlHBF3MSmU
         DBEfGlu8a/lt2n/lOsPNM4MocJd2lv6UgTkMIPyD4XttAyL0aW8qGy9wiSb6XAjiaqiw
         X3VCSuEjc4Kn4aPFU0Q/M3e7M/nWInyvUOZV9INpzUWeU/x6uGaoYlPFYj0qopvLZ7Tp
         cjiUTbeNbIEpL/3qb3iHe6seCDUL0EwxzJQSWIUn0ABngpY6RLBCyx18dHkLOfCN5+hA
         UGAw==
X-Gm-Message-State: AOAM530OQeSfDxXElsPsvzNi5aAa0RZQqa5Avd7emOQj+wSASN8zvFtl
        xxKSh0D1w6flAtnbGs7XijQ=
X-Google-Smtp-Source: ABdhPJxcaF2wiI0SPeQXGE6Ww9TYQ0eLLCvFsYGTW8/hFkXpymBzgcfDFKwLRmfM2IrK2grTcAePBg==
X-Received: by 2002:a17:906:e15:: with SMTP id l21mr14622212eji.509.1604912717122;
        Mon, 09 Nov 2020 01:05:17 -0800 (PST)
Received: from ?IPv6:2a0f:6480:3:1:d65d:64ff:fed0:4a9d? ([2a0f:6480:3:1:d65d:64ff:fed0:4a9d])
        by smtp.gmail.com with ESMTPSA id m27sm8322088eji.64.2020.11.09.01.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 01:05:16 -0800 (PST)
Subject: Re: [PATCH] IPv6: Set SIT tunnel hard_header_len to zero
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201103104133.GA1573211@tws>
 <CA+FuTSdf35EqALizep-65_sF46pk46_RqmEhS9gjw_5rF5cr1Q@mail.gmail.com>
 <dc8f00ff-d484-f5cf-97a3-9f6d8984160e@gmail.com>
 <CA+FuTSeqv=SJ=5sXCrWWiA=nUnLvCgX4wjcoqZm93VSyJQO1jg@mail.gmail.com>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <66145819-f0aa-794f-4045-1c203b260f47@gmail.com>
Date:   Mon, 9 Nov 2020 10:05:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSeqv=SJ=5sXCrWWiA=nUnLvCgX4wjcoqZm93VSyJQO1jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04.11.20 20:52, Willem de Bruijn wrote:
>>>> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
>>>
>>> How did you arrive at this SHA1?
>> I think the legacy usage of hard_header_len in ipv6/sit.c was overseen in c54419321455.
>> Please correct me if I'm wrong.
> 
> I don't see anything in that patch assign or modify hard_header_len.
> 
It's not assigning or modifying it but changing expectations about how dev->hard_header_len is to be used.

The patch changed the MTU calculation from:
mtu = dst_mtu(&rt->dst) - dev->hard_header_len - tunnel->hlen;

to this:
mtu = dst_mtu(&rt->dst) - dev->hard_header_len - sizeof(struct iphdr);

Later is became this (in patch 23a3647. This is the current implementation.):
mtu = dst_mtu(&rt->dst) - dev->hard_header_len - sizeof(struct iphdr) - tunnel_hlen;

Apparently the initial usage of dev->hard_header_len was that it contains the length
of all headers before the tunnel payload. c54419321455 changed it to assuming dev->hard_header_len 
does not contain the tunnels outter IP header. Thus I think the bug was introduced by c54419321455.

Kind Regards
Oliver
