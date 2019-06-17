Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F85489A4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfFQRG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:06:58 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42276 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFQRG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:06:58 -0400
Received: by mail-io1-f67.google.com with SMTP id u19so22747369ior.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hso2hpDSUoMsb1JjQK0z24V+CPw4Dn9wVIbzzerRy3I=;
        b=NnlFyRsTJy4BTSuh2noKJ48qrkmfquHevpe/EexO7CMG3W+Ee29081houiX2avjbZy
         hfmW52G++wFkU59alc/vnjuuPpbQmuFhG+WPzr3/aD7VSKb9JbGcU/8FOYFrVyUfZYeu
         OthGpn9I/P5SBTwbaIy0mvgLXK1DEZV0zsCawij2VGmaUMo92nIDfb5RcfgKzg428bLV
         5PaTTkgcNzyTJFN42964szHHdQ2FxnPFuuxUzisKPReFYcjvJC9tGwtqdJ8vMrjM3tSb
         cWH/dn/guwTeqgO7Jm31gk8NXwZVf7JdP7HpYIPgD0CMgH6B4cqnCSV7iFnWwG5OK4ut
         kqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hso2hpDSUoMsb1JjQK0z24V+CPw4Dn9wVIbzzerRy3I=;
        b=QS/xA0qY0mjx1VVb+VIzmj/C3K/ES8zlG5+0gW4sKfGDqoEgzc5ZG1+WXN8a6UsWwh
         hcQcsnwAiYdCtb8C/N+zapSfH+1bWeTyLFgk492Pxj2SXhtjCHCntah5K08KZmMubJPT
         Uc0d3jn2BgjJIpizijl+Q1ZSpHLEWhZUqvX7Vyx42hDluIYAaNy19erX6y99xxBUGxIY
         bOp+7CHRhY0/11TEOECoC7SJtwqWyzfqp3z+v7LwtgOWsOeyjanIkPNCbWFb9hpBG6J9
         tAivA5sgry2kCg1tY++7/AKGk8txzgl5lwot8wOfzSJIV2TM6AtvNyuAuZLLeJu3sl6z
         UGkw==
X-Gm-Message-State: APjAAAXRkhGpyAuws6uGE9kdcPb89Jt9wj39yWk15WvVBFSEa65DH9O1
        Kesqw741QfudKqI3x8EjmQkyAnHr
X-Google-Smtp-Source: APXvYqw1kXdaZjXZZ7QcPfozEJvQm3rrbCb0rEk8FsG0B5L/U3D5RCCb6vzqzl6P87ODjJDV3TB2HQ==
X-Received: by 2002:a02:40c8:: with SMTP id n191mr56571755jaa.14.1560791217085;
        Mon, 17 Jun 2019 10:06:57 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id c23sm11862049iod.11.2019.06.17.10.06.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:06:55 -0700 (PDT)
Subject: Re: [PATCH net v4 1/8] ipv4/fib_frontend: Rename
 ip_valid_fib_dump_req, provide non-strict version
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560561432.git.sbrivio@redhat.com>
 <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
 <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
 <20190615051342.7e32c2bb@redhat.com>
 <d780b664-bdbd-801f-7c61-d4854ff26192@gmail.com>
 <20190615052705.66f3fe62@redhat.com> <20190616220417.573be9a6@redhat.com>
 <d3527e70-15aa-abf8-4451-91e5bae4f1ab@gmail.com>
 <20190617161333.29cab4d7@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <43a9b0c7-27b4-733c-d3f2-60ad894e8aeb@gmail.com>
Date:   Mon, 17 Jun 2019 11:06:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190617161333.29cab4d7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 8:13 AM, Stefano Brivio wrote:
>>
>> With strict checking (5.0 and forward):
>> - RTM_F_CLONED NOT set means dump only FIB entries
>> - RTM_F_CLONED set means dump only exceptions
> 
> Okay. Should we really ignore the RFC and NLM_F_MATCH though? If we add
> field(s) to the filter, it comes almost for free, something like:
> 
> 	if (nlh->nlmsg_flags & NLM_F_MATCH)
> 		filter->dump_exceptions = rtm->rtm_flags & RTM_F_CLONED;
> 
> instead of:
> 
> 	filter->dump_exceptions = rtm->rtm_flags & RTM_F_CLONED;

This is where you keep losing me. iproute2 has always set NLM_F_MATCH on
dump requests, so that flag can not be used as a discriminator here.

> 
>> Without strict checking (old iproute2 on any kernel):
>> - dump all, userspace has to sort
>>
>> Kernel side this can be handled with new field, dump_exceptions, in the
>> filter that defaults to true and then is reset in the strict path if the
>> flag is not set.
> 
> I guess we need to add two fields, we'll need a 'dump_routes' too.
> 
> Otherwise, the dump functions can't distinguish between the three cases
> ('no strict checking', 'strict checking and RTM_F_CLONED', 'strict
> checking and no RTM_F_CLONED'). How would you do this with a single
> additional field?
> 

sure, separate fields are needed for the pre-strict mode use case. So, I
take it we are converging on this:

1. non-strict mode, dump both (FIB entries and exceptions). Userspace
has to filter. This is the legacy behavior you are trying to restore.

2. strict mode:
   a. dump only FIB entries if RTM_F_CLONED is not set
   b. dump only exception entries if RTM_F_CLONED is set

Agreed?

Martin, others, ok with this?
