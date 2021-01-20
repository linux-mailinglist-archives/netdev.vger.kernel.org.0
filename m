Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614BA2FC9F2
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 05:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbhATEZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 23:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbhATEXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 23:23:30 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEC1C061575;
        Tue, 19 Jan 2021 20:22:43 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id x71so7931656oia.9;
        Tue, 19 Jan 2021 20:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GP6CcfjV/nEcKJK3Rxlv4zO7l7XOzbH7ZH19Z8QJF8E=;
        b=Vcth5JiSXjuEHV3SJWLTc9nv/u3U5+IPgeWg9LYr2lj7oCtkjGxId8yuC5GIa4rw9h
         q3oIvUyQHXsbeBV1dgvUKkROI2nVhlN9aFhr+iB/DW+2QVG8TivGlMoYzlcG09cCNA62
         vKIRA06CBPIG1i7tkFwPI5sjiIZA7Xrj6QjL90opwNum4WTc8vXUbx392ZwVca9xmH0K
         eK7hX5gDGKnUhK3L+lzlnXqqMNpf66YbfyTBtV8vH2d2f7j5bWQ9eWtgp43RUsdqYr3O
         p/RyRtcPn77FOgCRW1VCP3M1VRVVQFAIKxPizO/SMELy0YkoQHHcg/u5c+rgcroC9onH
         IOvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GP6CcfjV/nEcKJK3Rxlv4zO7l7XOzbH7ZH19Z8QJF8E=;
        b=PzjCwiQbLrY4UUSR6TVozfLwnCN/81IVYlWayfcpAP063WFnfZ5Y80kUrUcsTZez/A
         umQ5ytsAo441XJfn4KnE/1UA1vo9jyxy4s0DYSAYtbI4gt9fxtJh8CNDc9/S3QRg5BMB
         qG9ihCVmn8gbYx6vB2M6a8tGd5Woxhc5WwJLyiZsJFh89KbgThIzIgJp1IIdtltNeSG9
         Rb23OYtCd18jsCQqCzUEw/ruL42yJ5TXR8vdRsLDepesKwRV6V2pVpC38NOGd+5Tfbeb
         p2R0y8vSoX81AJsw9EBBfbbYQEOLIP7M0yHjTTjAdQ6AEY1lXswdSeGFOcK/dGtJMkid
         NiBw==
X-Gm-Message-State: AOAM5313yo2kFI1wheJv4pF+74URom7LBohO43lb9MaMd6oPlo3EX9km
        1GN9Bjd+gFp//v3qF+BmCv8=
X-Google-Smtp-Source: ABdhPJy7cUXT/3a2USlFCorl1HDBicSLZCXIdOyOaH/EPPttM5sW7Yg2soQ/slabJaZe6wm5dgC44w==
X-Received: by 2002:aca:be54:: with SMTP id o81mr1806904oif.67.1611116562271;
        Tue, 19 Jan 2021 20:22:42 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.20.123.12])
        by smtp.googlemail.com with ESMTPSA id f3sm185743otq.42.2021.01.19.20.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 20:22:41 -0800 (PST)
Subject: Re: [PATCH v2 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
To:     praveen chaudhary <praveen5582@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>
References: <20210115080203.8889-1-pchaudhary@linkedin.com>
 <0f64942e-debd-81bd-b29c-7d2728a5bd4b@gmail.com>
 <A2DE27CF-A988-4003-8A95-60CC101086DA@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7839be40-6555-3e5a-3459-c3f0e4726795@gmail.com>
Date:   Tue, 19 Jan 2021 21:22:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <A2DE27CF-A988-4003-8A95-60CC101086DA@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/21 3:17 PM, praveen chaudhary wrote:
>>> ----------------------------------------------------------------
>>> For IPv4:
>>> ----------------------------------------------------------------
>>>
>>> Config in etc/network/interfaces
>>> ----------------------------------------------------------------
>>> ```
>>> auto eth0
>>> iface eth0 inet dhcp
>>>    metric 4261413864
>>
>> how does that work for IPv4? Is the metric passed to the dhclient and it
>> inserts the route with the given metric or is a dhclient script used to
>> replace the route after insert?
>>
>>
> 
> Yes, DHCP client picks config under “iface eth0 inet dhcp” line and if metric is configured, then it adds the metric for all added routes.

As I recall ifupdown{2} forks dhclient as a process to handle dhcp
config, and I believe there is a script that handles adding the default
route with metric. Meaning ... it is not comparable to an RA.

> 
> Thanks a lot again for spending time for this Review,
> This feature will help SONiC OS [and others Linux flavors] for better IPv6 support, so thanks again.

I think SONiC is an abomination, so that is definitely not the
motivation for my reviews. :-)

