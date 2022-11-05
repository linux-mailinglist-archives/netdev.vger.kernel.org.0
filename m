Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2B061DC93
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 18:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiKERjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 13:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiKERjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 13:39:18 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3521C917
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 10:39:17 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id q9so7125521pfg.5
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 10:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WWrco+vXh1FbuoaRINj7wlDyd8eAZjNE4VHFGZp67xQ=;
        b=tIMJvPzkHDIyKiPdGwqxg/svC3w0FkTPRJansTyXplDRdyay7bQCFAoI+4+Fba1aiy
         8gWl1frw0GVmz5q147uAckoYIQlfraawpo9HctXDE7iij+90PUr7wwVjhM8Ti4ND/BNJ
         Nk6/dViWcvSVqsLoWMwiKOsexmZ1cUpbr09x3zFlKIGUPLZUb8kxtQRySNTsX3LoZXMD
         2h3SpRuuvPxM69XIab10T8Mb4GGy5IGkC5QhmrcWzLol9g19wSpfYg2/1pIgqh7hYgDq
         UX5Q5blWMEiBeWdtZJKK87s002w7fiswuJzzy0UmGbMrv3KcvKcfC7ugLnMO53w8YVG4
         jsZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WWrco+vXh1FbuoaRINj7wlDyd8eAZjNE4VHFGZp67xQ=;
        b=IgXzHXAcPuc0hSmlL4sapH//mvfbe2NCqKZiUG5Lm/3wNhncK5Jy2yj1rgpWcX7gUn
         ZIQkYn+tHfotJqByFsI4u+02jToXFOBeAaXohiv1ba2GWimB6PRzU0OLSpabA1XvG/Sa
         Xs8+mzhGT5cECUjB+rA4MusytGDhBCwrbbGaZMqx3fRA4dhnxk7bQv1uVlM8j38X5fgA
         fNi62qAZ2nNC5mxhYKoJ3UztlKCNyLWm3YmNhitg3BRRylil0OF0N448sT94pJL2/b3F
         nTI7NJ5HQjTVleF8Mc9P5jdAuZ6b7Fxwkq8pOuEHp5CVC2TJ3Xga2yvjx9HWI++QTPWP
         ze2g==
X-Gm-Message-State: ACrzQf23WAnhuVB3QYH4tCbgydzVk+plTxcSnqXh7JKP1pacqmj3vTlM
        33wRBpNBG1WHPNDcupSqfl8lzg==
X-Google-Smtp-Source: AMsMyM6whexvajtuOncywX1ipcU7re5Fgjil52gkJ4VtzeHnP+Xj9pb3WrlwK4d2B7vJ6DVmp81RCg==
X-Received: by 2002:a63:1748:0:b0:46f:18be:4880 with SMTP id 8-20020a631748000000b0046f18be4880mr35434657pgx.128.1667669956645;
        Sat, 05 Nov 2022 10:39:16 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903120d00b00186a1b243basm1934278plh.226.2022.11.05.10.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Nov 2022 10:39:15 -0700 (PDT)
Message-ID: <fe28e9fa-b57b-8da6-383c-588f6e84f04f@kernel.dk>
Date:   Sat, 5 Nov 2022 11:39:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20221030220203.31210-1-axboe@kernel.dk>
 <CA+FuTSfj5jn8Wui+az2BrcpDFYF5m5ehwLiswwHMPJ2MK+S_Jw@mail.gmail.com>
 <02e5bf45-f877-719b-6bf8-c4ac577187a8@kernel.dk>
 <CA+FuTSd-HvtPVwRto0EGExm-Pz7dGpxAt+1sTb51P_QBd-N9KQ@mail.gmail.com>
 <88353f13-d1d8-ef69-bcdc-eb2aa17c7731@kernel.dk>
 <CA+FuTSdEKsN_47RtW6pOWEnrKkewuDBdsv_qAhR1EyXUr3obrg@mail.gmail.com>
 <46cb04ca-467c-2e33-f221-3e2a2eaabbda@kernel.dk>
In-Reply-To: <46cb04ca-467c-2e33-f221-3e2a2eaabbda@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> FWIW, when adding nsec resolution I initially opted for an init-based
>> approach, passing a new flag to epoll_create1. Feedback then was that
>> it was odd to have one syscall affect the behavior of another. The
>> final version just added a new epoll_pwait2 with timespec.
> 
> I'm fine with just doing a pure syscall variant too, it was my original
> plan. Only changed it to allow for easier experimentation and adoption,
> and based on the fact that most use cases would likely use a fixed value
> per context anyway.
> 
> I think it'd be a shame to drop the ctl, unless there's strong arguments
> against it. I'm quite happy to add a syscall variant too, that's not a
> big deal and would be a minor addition. Patch 6 should probably cut out
> the ctl addition and leave that for a patch 7, and then a patch 8 for
> adding a syscall.
I split the ctl patch out from the core change, and then took a look at
doing a syscall variant too. But there are a few complications there...
It would seem to make the most sense to build this on top of the newest
epoll wait syscall, epoll_pwait2(). But we're already at the max number
of arguments there...

Arguably pwait2 should've been converted to use some kind of versioned
struct instead. I'm going to take a stab at pwait3 with that kind of
interface.

-- 
Jens Axboe

