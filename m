Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5676E26E6C8
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgIQUa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgIQUa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:30:58 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F23C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:30:58 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jw11so1806013pjb.0
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=fGCJ4JTDHUWTlT62n/L57b9IhQwcdzXAZckq1i7mzBY=;
        b=0YhtlSazWMOi2RkqtA75LogUf/C9IuhugluXHadw94VY+Bu+cZrKO5BoUdB/7saav4
         nUzwq+Wy8WcWBMv/8RiM12/eAHr6nnTY/EbkIHwtObSnSMLjYuwOrnOy9X0Tec5DdpJk
         +kTNTzOaGw4ji69jaQCKjkgE5u32U+ef2JsexMqeQJ1LYcbaHpguBfJzzbpNyu6rbS8b
         g+7o/t1LWook0gYoGYQteYfLO75DplBXhb1KqY/bxSEZc3dFfCdUUCQVdgvKrIbycs6O
         DA0qH2UUh9dNmop4eatQTUyli4L3Sf+NGBNcdpbUVm3v65GEla/MbuN9yO25hBdLqhZM
         CJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fGCJ4JTDHUWTlT62n/L57b9IhQwcdzXAZckq1i7mzBY=;
        b=Y+jXUoZbIDlZCflpd7zjTJIxGL+8STTnVcr7m/YGrQbNiyGg4eR6DRGqueevwBuJ/M
         UB9bTljoSWkQyKdXEcBG0DNkbw1o/Z3yf3AFRZIPgQes0eU50kyavA022nUNfX2yHSkJ
         HtSkRsKIecrmpWGW7BBuqALbVjeqe0Vdj0DWxrZngeo4OhrZGJAUKLuOWxLpcrZI8CYT
         edVvQOl4HQsmLcbPlen2CY4XWcf9Qnt8VKCEfW56kzJaatAWULe1vhJB52nbRrH7OZ1t
         YO2iwsHc/vTiS9ZIROZ8ap7YJqH04hjaPtK0nYskGt+SNVV59d90QJhxUwCrm5pgfOtd
         G8tw==
X-Gm-Message-State: AOAM533p8CwAeFLzqLjG42tVgtfe3JLijSz+nyrzX0bWpP1l/B3oWQdR
        EzyVHCPOpigici3ZBeAuLWkaUA==
X-Google-Smtp-Source: ABdhPJzC3p+22J5ExTdXCvZUuJdT3v8EcWfUqJUyYkO9DCQ1Pwpt2V8vCGYPrenLn8CfJGCqAYxTJQ==
X-Received: by 2002:a17:90a:d18f:: with SMTP id fu15mr9233205pjb.133.1600374657531;
        Thu, 17 Sep 2020 13:30:57 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id i30sm487012pgn.49.2020.09.17.13.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:30:56 -0700 (PDT)
Subject: Re: [PATCH net-next] ionic: add DIMLIB to Kconfig
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200917184243.11994-1-snelson@pensando.io>
 <20200917120243.045975ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a17b550c-1db1-d32e-f69c-d51bb4a1ca2b@pensando.io>
 <20200917130231.65770423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <25cb015f-96d1-1ebb-9f31-af594ba5458d@pensando.io>
Date:   Thu, 17 Sep 2020 13:30:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917130231.65770423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 1:02 PM, Jakub Kicinski wrote:
> On Thu, 17 Sep 2020 12:08:45 -0700 Shannon Nelson wrote:
>> On 9/17/20 12:02 PM, Jakub Kicinski wrote:
>>> On Thu, 17 Sep 2020 11:42:43 -0700 Shannon Nelson wrote:
>>>>>> ld.lld: error: undefined symbol: net_dim_get_rx_moderation
>>>>      >>> referenced by ionic_lif.c:52 (drivers/net/ethernet/pensando/ionic/ionic_lif.c:52)
>>>>      >>> net/ethernet/pensando/ionic/ionic_lif.o:(ionic_dim_work) in archive drivers/built-in.a
>>>> --
>>> This is going to cut off the commit message when patch is applied.
>> Isn't the trigger a three dash string?  It is only two dashes, not
>> three, and "git am" seems to work correctly for me.  Is there a
>> different mechanism I need to watch out for?
> I got a verify_signoff failure on this patch:
>
> Commit a92faed54662 ("ionic: add DIMLIB to Kconfig")
> 	author Signed-off-by missing
> 	author email:    snelson@pensando.io
>
> And in the tree I can see the commit got cut off.
>
> Maybe it's some extra mangling my bot does. In any case, I wanted to
> at least give Dave a heads up.

Okay, thanks for the note.  I'll respin without the dashes.

sln

