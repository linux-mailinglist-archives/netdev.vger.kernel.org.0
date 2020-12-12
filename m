Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EFE2D8704
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 15:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439129AbgLLN75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 08:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437600AbgLLN75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 08:59:57 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB4EC0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 05:59:17 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id h19so18618931lfc.12
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 05:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+HqaFo8/63MKBwKdhiM+FD4FMHjaEyHHlZNZq4zUHOY=;
        b=DbkyZnG9DWqyLXAn0FwqTnZufMaig7zSAnUocaQ5ZYF+ObdwBGEeuGU8WBBTc1YdBd
         /lK2eGOaF0Ra8FOcxtX92zOrH2KYbCn/qOUyI0dzFokeJ2EOol7/mu0HuQiGDWoPsZOT
         jCt1OZ9fNfJUsq7B5CEnPwl3EGr52rQrjug1PIXWH1arBXjAgJGlnwYvVcvY9hbo6GOI
         cC2eS3hx9ckuYUcIWiH5xe/K7ObCyFijNCNw6CmzETkIoIHhWvAnFbpIGeGx4+y5mEEO
         J4RyOPaSOzYM/YVxy5D9OdKJow/S2i4phqTG8TOuvYNB3zB3yUcfsJ0FP5haAK/15CPA
         e+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+HqaFo8/63MKBwKdhiM+FD4FMHjaEyHHlZNZq4zUHOY=;
        b=O0H8FKBn+1nNCjXl3Zh2Ok355W6kkID8d0JVDe1bpLwrGuS1qaRtTkvoWDRB276cIF
         BQc9U9V/Ty9S0QzdRZE37odO0KQpGW+iU5X+9/gkMUFRZe009X853i3nqQB4z6olvEsh
         LLJukgUb5WpxlO5VQt+NiXlTJM+kIhAn9r0ETh6YuxBvfFtOE7+NkPM1IPv89Ffx2w0u
         eyxyiV+EpMmHiJAb9ChPRj2w+Qqmdq4xag1yeSx6nwt82rio7i2TvODIOjIBUb+ErCD2
         LahhiBTYXgmfl7QpdyGLWKq10PwvO9Yk+cyFhlAtB6xuKSiNx12RiT1K9LNO7zh90g56
         4NXg==
X-Gm-Message-State: AOAM530J826o+45ojzlLUssz8PwnhINQfae0inFE1mmWpdH8c8bYLsE7
        NCxV1hH4atcEze0oXq71EvUFr7MD2DmGBg==
X-Google-Smtp-Source: ABdhPJyAzVbi2JV3MIxrg4YVp3Lmw9vH8NeD3uHd4gZaUh35BfwSC94cNQNkJbwroY4XWc7QOGdNuA==
X-Received: by 2002:a05:651c:3db:: with SMTP id f27mr7180297ljp.494.1607781555592;
        Sat, 12 Dec 2020 05:59:15 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id a15sm1352944lji.105.2020.12.12.05.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 05:59:15 -0800 (PST)
Subject: Re: [PATCH net-next v2 10/12] gtp: add IPv6 support
To:     Harald Welte <laforge@netfilter.org>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-11-jonas@norrbonn.se> <X9SoDToVmUdhgP0D@nataraja>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <e5c51154-3ec8-7d84-c1d9-c7ceac0f3c36@norrbonn.se>
Date:   Sat, 12 Dec 2020 14:59:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X9SoDToVmUdhgP0D@nataraja>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

On 12/12/2020 12:22, Harald Welte wrote:
> Hi Jonas,
> 
> thanks again for your patches, they are very much appreciated.
> 
> However, I don't think that it is "that easy".
> 
> PDP contexts (at least) in GPRS/EDGE and UMTS come in three flavors:
> * IPv4 only
> * IPv6 only
> * IPv4v6 (i.e. both an IPv4 and an IPv6 address within the same tunnel)
> 
> See for example osmo-ggsn at https://git.osmocom.org/osmo-ggsn
> for an userspace implementation that covers all three cases,
> as well as a related automatic test suite containing cases
> for all three flavors at
> https://git.osmocom.org/osmo-ttcn3-hacks/tree/ggsn_tests
> 
> If I read your patch correctly
> 
> On Fri, Dec 11, 2020 at 01:26:10PM +0100, Jonas Bonn wrote:
>> -	struct in_addr		ms_addr_ip4;
>> -	struct in_addr		peer_addr_ip4;
>> +	struct in6_addr		ms_addr;
>> +	struct in6_addr		peer_addr;
> 
> this simply replaces the (inner) IPv4 "MS addr" with an IPv6 "MS addr".

Yes, that's correct.  It's currently an either-or proposition for the UE 
address.

I actually wanted to proceed a bit carefully here because this patch 
series is already quite large.  I do plan on adding support for multiple 
MS addresses, but already just juggling mixed inner and outer tunnels 
seemed challenging enough to review.

> 
> Sure, it is an improvement over v4-only.  But IMHO any follow-up
> change to introduce v4v6 PDP contexts would require significant changes,
> basically re-introducing the ms_add_ip4 member which you are removing here.

I think we ultimately need to take the MS (UE address) member out of the 
PDP context struct altogether.  A single PDP context can apply to even 
more than two addresses as the UE can/should be provisioned with 
multiple IPv6 addresses (as I understand it, superficially).

> 
> Therefore, I argue very much in favor of intrducing proper IPv6 support
> (including v4v6) in one go.

For provisioning contexts via Netlink, I agree that we should try to 
avoid pathological intermediate steps.  For the actual packet handling 
of outer and inner IPv6 tunnels, I think it's moot whether or not the 
PDP contexts support multiple addresses or not: the subsequent step to 
extend to multiple IP's is a bit of churn, but doesn't immediately seem 
overly intrusive.

Anyway, I'll look into making this change...

Thanks for the review!

/Jonas



> 
> Regards,
> 	Harald
> 
