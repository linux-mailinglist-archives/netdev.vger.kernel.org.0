Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABA94954E8
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 20:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377413AbiATTdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 14:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347174AbiATTdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 14:33:33 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE897C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:33:32 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id u3so7389110qku.1
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6Gp/5hK4THZoVjgGoSiChxrkwYLiAHf/mRfYrr0vigE=;
        b=7ophgrJsDikUw/SCBxe5AHhQE6lX+Vlm/k4xhcIKkrOYD6g6uVJRSF+6rOUhZOHzGx
         JhKCo5y1R0ObtwWbdG5KJ+Vm2jG2lWfUIlLeL1Iiwl9GFENIUX4QSDAjPESLTNgnLxnE
         /80jdIBeN8jvhZyCPjBqSMwPlva0Ug9D4AdE7yLIh3/yqY1lUoznrp2wRYqET1AeZvr4
         zdZ0z/lGFxHn1FY5SEr7le/Bb/MylUO0tebeBAvKlGVrx2rdCdCw29uEreGPQltUmSMA
         +x4vEo+cSdNuTkbayD5oE7l2J79fHRU5DtP8juG4eV0DBeplRji7Z/04kgXLCLZjhuje
         Im0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6Gp/5hK4THZoVjgGoSiChxrkwYLiAHf/mRfYrr0vigE=;
        b=MMgxpjL0rqeZHqxRGn5jy9a39tx4keoXbShvlBumOGbqwywcPKPDX0unuMEdBqbBYm
         ZukZoRynNsYnM6b3sSwJI0kpYLTgSf0iuoe1hAgpKy5LJhXxa9oMYKObkiEKVSGBMLRc
         qVdxaDldUdjckj2kLNZ6bonxOaK82pGXFcsbTR7djTsVUSgPid/tWOtYP5b6eLnubyxS
         qjbdAxxa4/BK+xsYKB04NxqMYgA6iPxeBdHn3fjm0KjjOu19CZNGP9MaMw+2LtHr048w
         lpOnLkwje7RhPon6etqflo+6oq6ig5cdaONIgyGjjwdrFKQ3F7jN+/vku0WPxG0tZ5Bz
         w/MQ==
X-Gm-Message-State: AOAM530f9ucVfrE9SeLiXT19xwKnwXVpgLqUn2f8/WdzlZ4X+21PyB7M
        j/BZcJrEydTl0cFG4ypp3J78wQ==
X-Google-Smtp-Source: ABdhPJyKXNaLOXEwD7m9Y3QZJfpPEoPkQgWRrG5RznAdTIoQYvXxsDCTV0OQoseJcdCEnJQs8lkUZQ==
X-Received: by 2002:a05:620a:372b:: with SMTP id de43mr316131qkb.338.1642707211899;
        Thu, 20 Jan 2022 11:33:31 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id i5sm2114055qkn.19.2022.01.20.11.33.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 11:33:31 -0800 (PST)
Message-ID: <c4983694-0564-edca-7695-984f1d72367f@mojatatu.com>
Date:   Thu, 20 Jan 2022 14:33:30 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: tdc errors
Content-Language: en-US
To:     Victor Nogueira <victor@mojatatu.com>, baowen.zheng@corigine.com
Cc:     simon.horman@corigine.com, netdev@vger.kernel.org,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        David Ahern <dsahern@gmail.com>
References: <CA+NMeC-xsHvQ5KPybDUV02UW_zyy02k6fQXBy3YOBg8Qnp=LZQ@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CA+NMeC-xsHvQ5KPybDUV02UW_zyy02k6fQXBy3YOBg8Qnp=LZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-20 12:22, Victor Nogueira wrote:
> Hi,
> 
> When running these 2 tdc tests:
> 
> 7d64 Add police action with skip_hw option
> 3329 Validate flags of the matchall filter with skip_sw and
> police action with skip_hw
> I get this error:
> 
> Bad action type skip_hw
> Usage: ... gact <ACTION> [RAND] [INDEX]
> Where: ACTION := reclassify | drop | continue | pass | pipe |
> goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>
> RAND := random <RANDTYPE> <ACTION> <VAL>
> RANDTYPE := netrand | determ
> VAL : = value not exceeding 10000
> JUMP_COUNT := Absolute jump from start of action list
> INDEX := index value used
> 
> I'm building the kernel on net-next.
> 
> I'm compiling the latest iproute2 version.
> 
> It seems like the problem is that support is lacking for skip_hw
> in police action in iproute2.
> 


So... How is the robot not reporting this as a regression?
Davide? Basically kernel has the feature but code is missing
in both iproute2 and iproute2-next..

cheers,
jamal
