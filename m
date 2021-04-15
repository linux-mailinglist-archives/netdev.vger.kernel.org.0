Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD0E360062
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 05:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhDODYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 23:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhDODYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 23:24:39 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779F7C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 20:24:15 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id w31-20020a9d36220000b02901f2cbfc9743so21353539otb.7
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 20:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d2HEmPut3FRTMN01XADXKPtUGd4De47HChWhWiI7IS4=;
        b=qkgp323gNpWusk4USnvIUD03PyZoWAo3rlBQOl/0uMLaYDoIkLHbnM/Fo492VC1KVH
         Ud9BSRpUNLyUB0HOoN/l/R8iV7QH2/1ZsZvNtSmaXfda3qeMsEcaBvxkbUDh0unjDOU6
         O4Fmvgjyu4lSAi0ur+Se4g22Knff40Tpen5a3BXJtK7K4DfaMyUSlqJfS57RUdVMDPZp
         vHuFjkBujhty5dLwr+kTXM1mQiqci1TlbPpne66je3eDiZjjZ74asI7oMPDwkI7NehfX
         iTMbbHhSDtosuAl7oDWO1hhQQYlkT391rII+TYgvsVTOykixmXfBkH42ue2Q9aMCDuYt
         f4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d2HEmPut3FRTMN01XADXKPtUGd4De47HChWhWiI7IS4=;
        b=IA1707nk+vsCje88Mh427Uz5HM7TzXXdbFou1eXPnU1j8dToad8xqpxF9zQ9X+EbY+
         9syqNI57JUjtHSt4fj8pW+DjfuufOhBKD9JtK6yl5NaA0Orqkq2Hv1Mr+IfmhMZZ1hAH
         BSKUGQH6Z7EovXhqdprf3nqipw5rPReULHv/NADSPSQY/w80G0iyYfytOcRyMIgeqSMa
         oc9a3vETyV6Yvidhrx6pqn6qKBf2fz+sgOqnzKOGcM4I+g1iBJ2l1OgvcyBVMv/8BZMS
         OJbdT6qJfJQFAA7c03drZchu3eUYO0w643M0BMm0V/OqODkD3Nt+FPxltGy3pPLAMDOY
         BLoQ==
X-Gm-Message-State: AOAM533hSDBDSXQSNOJFaZyVGnlyNtM9I+XwdGPZgLrrkhuXe1P54OyU
        baPgkHIDwt/a/wxT/hVhZ3A=
X-Google-Smtp-Source: ABdhPJw57pL6shIGH5iuuvHGvqo1FFmi7ewDHnGYM0rgQ9a4fd1V36Q52zh34j5XqetB/bn/k47oAw==
X-Received: by 2002:a9d:1788:: with SMTP id j8mr1034586otj.9.1618457054953;
        Wed, 14 Apr 2021 20:24:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.70])
        by smtp.googlemail.com with ESMTPSA id w2sm332747oov.23.2021.04.14.20.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 20:24:14 -0700 (PDT)
Subject: Re: [PATCH v3 net-next] net: multipath routing: configurable seed
To:     Pavel Balaev <mail@void.so>, netdev@vger.kernel.org
Cc:     christophe.jaillet@wanadoo.fr, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <YHWGmPmvpQAT3BcV@rnd>
 <08aba836-162e-b5d3-7a93-0488489be798@gmail.com> <YHaa0pRCTKFbEhA2@rnd>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bcf3a5d5-bfbd-d8d3-05e9-ad506e6a689e@gmail.com>
Date:   Wed, 14 Apr 2021 20:24:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YHaa0pRCTKFbEhA2@rnd>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/21 12:33 AM, Pavel Balaev wrote:
>>
>> This should work the same for IPv6.
> I wanted to add IPv6 support after IPv4 will be approved,
> anyway no problem, will add IPv6 in next version 
>> And please add test cases under tools/testing/selftests/net.
> This feature cannot be tested whithin one host instance, becasue the same seed
> will be used by default for all netns, so results will be the same
> anyway, should I use QEMU for this tests?
>  
> 

why not make the seed per namespace?
