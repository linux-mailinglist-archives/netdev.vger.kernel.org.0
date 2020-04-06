Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CE719F306
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 11:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgDFJyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 05:54:50 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36848 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgDFJyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 05:54:50 -0400
Received: by mail-lj1-f195.google.com with SMTP id b1so13986910ljp.3
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 02:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=q88PwMPFrKRg+/PoJrXz7UPf6Exsf5P6QhsiIaxYVwI=;
        b=My+pddKt8LWrUvVK6BE3akRgBlbRPpaRA/lkA+po4a7CoseAd/q1A/UKcbGKZbTFIw
         mRi9Ueb6l7LTKKPB3y8IMVVJrY6HNLRu22kn5VF52+weuCmirdjHQXvyS4j5Oxq+ELok
         v9k/w7r7GzCWtm7OEM/DDrjr57SRb/kaxvEzQVFLNO2rd3C4cW/YnInRZiZRsgupUMsx
         xuTYuW4u3AEqPwKyA/e63Z2MK1+w6Bf/4NydHUjTHreAR3vUtJyFR38an2A4g+l9w8da
         FKce+Q9jRqwwx6qqZPqu2tzscwcCqkt1jd6NuborK3mf0T88johT6S6OSGm+OBbrhpmd
         8Nqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q88PwMPFrKRg+/PoJrXz7UPf6Exsf5P6QhsiIaxYVwI=;
        b=Usn+XDFjmHOEhoJzps9SQOdjYC8wYQqT6F39LOgV+WuoMxCtXc51PBd4frA12RotH5
         1z7tZahaFT1NugzpEX53JGP3HYR5es6LFTXUgZr2m0bmLDhI6Rq9mqxfMwTMnLMiVzrl
         DTU/F5eFxzMx7sUXN3+Ts6zm5yxejAqVROK+n6OMn29S4rpg/rOHHN1XVJKU0sCgasKx
         1eHJbKcp1tg8m21EyW/gQztR7MinU68B16ztaFFr1eJC4C4Qmh0Vr89bWqF93tr+tPCF
         pNq/J5/sKVNGjZNw/qeMO1baZ2wEaMn5UcUm+hSH9hCURhfw9Nt/bSedd4WGw7ID6eWy
         VW0g==
X-Gm-Message-State: AGi0Pub4A0OPLuu2r7dxUdNlCCbwsXgcpjsPgT3gk07Mz43AKZiO0U4P
        ytqhspMTwk0Ou0J2r60V3EQK1bgvNNcgSA==
X-Google-Smtp-Source: APiQypKE+xX8JvxUnLaxw+nUa2Ap1+HRvRPRgYflNBLC87s4KQN+K/DOACyx4QGfTM/lQNTWOH8vZA==
X-Received: by 2002:a2e:9d98:: with SMTP id c24mr11035683ljj.137.1586166886442;
        Mon, 06 Apr 2020 02:54:46 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4863:d52f:6058:78be:308b:f26a? ([2a00:1fa0:4863:d52f:6058:78be:308b:f26a])
        by smtp.gmail.com with ESMTPSA id v22sm9594061ljj.67.2020.04.06.02.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 02:54:45 -0700 (PDT)
Subject: Re: [PATCH iproute2 5/6] Document root_block option
To:     rouca@debian.org, netdev@vger.kernel.org
References: <20200405134859.57232-1-rouca@debian.org>
 <20200405134859.57232-6-rouca@debian.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <c11b8832-7569-a09d-227a-84549ea8c031@cogentembedded.com>
Date:   Mon, 6 Apr 2020 12:54:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200405134859.57232-6-rouca@debian.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 05.04.2020 16:48, Bastien Roucariès wrote:

> Root_block is also called root guard, document it.
                                ^ port?
> Signed-off-by: Bastien Roucariès <rouca@debian.org>
> ---
>   man/man8/bridge.8 | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
> index 53aebb60..96ea4827 100644
> --- a/man/man8/bridge.8
> +++ b/man/man8/bridge.8
> @@ -372,6 +372,11 @@ enabled on the bridge. By default the flag is off.
>   Controls whether a given port is allowed to become root port or not. Only used
>   when STP is enabled on the bridge. By default the flag is off.
>   
> +This feature is also called root port guard.
> +If BPDU is received from a leaf (edge) port, it should not
> +be elected as root port. This could be used if using STP on a bridge and the downstream bridges are not fully
> +trusted; this prevents a hostile guest for rerouting traffic.

   s/for/from/?

[...]

MBR, Sergei
