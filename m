Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404973077A3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhA1OFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhA1OEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:04:53 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE762C061574;
        Thu, 28 Jan 2021 06:04:12 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id j18so4404264wmi.3;
        Thu, 28 Jan 2021 06:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Gh/i/8MlizRX5IQWlRcyYy2kUD58gzAYUv+/PTyTmjI=;
        b=lAz2tk81dNW/ss1goqU5xOiyODxZfADKM3/AZynRT23v1fINlzFtN8iXYRI8HdC1LU
         VdOeelwGOjQcKVaJfQFT453fK1WDp6MlsYi6AFPOPXoFf7BUzPC48ar0xQ8Dk2RqHgwn
         0AEUdNheyBbUnrEYKGuSCTf3FuAVHdBkOnWj4BqmZjgXpQcQtFZHPItNGoBjceWS3HIu
         DWfZNcTyGiaBJ68w0tw7M/BoRie10jQESaUbtw6XHVZ3c3DRKvNgcctKv7xOkOpaouhD
         nzZPy6CINR3Ec0AGus0ME/oo5POKi8qNdP0S5uT3QV66CxzfnQ8lvND+zf5hI5K4aRJN
         OSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gh/i/8MlizRX5IQWlRcyYy2kUD58gzAYUv+/PTyTmjI=;
        b=SpVLeJHUXX2xgArLZ4HAUZRFTLSqxn9cbZ2SSlxHn7QQ91ywKT5ECsMYxfxxmQiKeo
         OvAz8M678FnISA2cdi3Aio6f/Xb8YZ2qK7WvmDQaGdO0k7GwxdE/23oU4N4K8dBKRAII
         si09a46TO4nOH67gI6eKNczoyFBQwLzD9EcGXP2KeD2b9gKntZAbKnoHCbONEGUfloDV
         u7I+SC8GREk4f2TcpT5rhlAmffocWzkupe76OoEwSOxngan6Bh86XhJV87VIGbDHGz3e
         ErDA99G5COzOKAE+HHDOGqtq8mJ5JyG6oBtgdzFDfhmJDPbGpgpP5BQDgirg7/hXjfO5
         raFg==
X-Gm-Message-State: AOAM530vDeIoWV5sQRLbyBX0kKJRowEQuRdxIN03zlnRKkx7xzHSAPPr
        1X470O/vIjjGuHRGtzXm7Kbyzlu08L8=
X-Google-Smtp-Source: ABdhPJx7z87B+OoID+mnImCQAb1fk7ztSQYODL/5uWsYeS0YLLhAxMg9N/t/dTCg8qNxJ+COLM1kcA==
X-Received: by 2002:a1c:ba83:: with SMTP id k125mr8949464wmf.5.1611842651433;
        Thu, 28 Jan 2021 06:04:11 -0800 (PST)
Received: from [192.168.0.160] ([170.253.49.0])
        by smtp.gmail.com with ESMTPSA id p17sm6158804wmg.46.2021.01.28.06.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 06:04:10 -0800 (PST)
Subject: Re: [PATCH v3] netdevice.7: Update documentation for SIOCGIFADDR
 SIOCSIFADDR SIOCDIFADDR
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        linux-man@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        netdev@vger.kernel.org
References: <20210102140254.16714-1-pali@kernel.org>
 <20210116223610.14230-1-pali@kernel.org>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <0eb0fa42-9417-6a7e-a849-28fc7746212d@gmail.com>
Date:   Thu, 28 Jan 2021 15:04:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210116223610.14230-1-pali@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali,

On 1/16/21 11:36 PM, Pali Rohár wrote:
> Unlike SIOCGIFADDR and SIOCSIFADDR which are supported by many protocol
> families, SIOCDIFADDR is supported by AF_INET6 and AF_APPLETALK only.
> 
> Unlike other protocols, AF_INET6 uses struct in6_ifreq.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>

Patch applied!

Thanks,

Alex

> ---
>  man7/netdevice.7 | 64 +++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 55 insertions(+), 9 deletions(-)
> 
> diff --git a/man7/netdevice.7 b/man7/netdevice.7
> index 15930807c..bdc2d1922 100644
> --- a/man7/netdevice.7
> +++ b/man7/netdevice.7
> @@ -56,9 +56,27 @@ struct ifreq {
>  .EE
>  .in
>  .PP
> +.B AF_INET6
> +is an exception.
> +It passes an
> +.I in6_ifreq
> +structure:
> +.PP
> +.in +4n
> +.EX
> +struct in6_ifreq {
> +    struct in6_addr     ifr6_addr;
> +    u32                 ifr6_prefixlen;
> +    int                 ifr6_ifindex; /* Interface index */
> +};
> +.EE
> +.in
> +.PP
>  Normally, the user specifies which device to affect by setting
>  .I ifr_name
> -to the name of the interface.
> +to the name of the interface or
> +.I ifr6_ifindex
> +to the index of the interface.
>  All other members of the structure may
>  share memory.
>  .SS Ioctls
> @@ -143,13 +161,33 @@ IFF_ISATAP:Interface is RFC4214 ISATAP interface.
>  .PP
>  Setting the extended (private) interface flags is a privileged operation.
>  .TP
> -.BR SIOCGIFADDR ", " SIOCSIFADDR
> -Get or set the address of the device using
> -.IR ifr_addr .
> -Setting the interface address is a privileged operation.
> -For compatibility, only
> +.BR SIOCGIFADDR ", " SIOCSIFADDR ", " SIOCDIFADDR
> +Get, set, or delete the address of the device using
> +.IR ifr_addr ,
> +or
> +.I ifr6_addr
> +with
> +.IR ifr6_prefixlen .
> +Setting or deleting the interface address is a privileged operation.
> +For compatibility,
> +.B SIOCGIFADDR
> +returns only
>  .B AF_INET
> -addresses are accepted or returned.
> +addresses,
> +.B SIOCSIFADDR
> +accepts
> +.B AF_INET
> +and
> +.B AF_INET6
> +addresses, and
> +.B SIOCDIFADDR
> +deletes only
> +.B AF_INET6
> +addresses.
> +A
> +.B AF_INET
> +address can be deleted by setting it to zero via
> +.BR SIOCSIFADDR .
>  .TP
>  .BR SIOCGIFDSTADDR ", " SIOCSIFDSTADDR
>  Get or set the destination address of a point-to-point device using
> @@ -351,10 +389,18 @@ The names of interfaces with no addresses or that don't have the
>  flag set can be found via
>  .IR /proc/net/dev .
>  .PP
> -Local IPv6 IP addresses can be found via
> -.I /proc/net
> +.B AF_INET6
> +IPv6 addresses can be read from
> +.I /proc/net/if_inet6
> +file or via
> +.BR rtnetlink (7).
> +Adding a new or deleting an existing IPv6 address can be done via
> +.BR SIOCSIFADDR " / " SIOCDIFADDR
>  or via
>  .BR rtnetlink (7).
> +Retrieving or changing destination IPv6 addresses of a point-to-point
> +interface is possible only via
> +.BR rtnetlink (7).
>  .SH BUGS
>  glibc 2.1 is missing the
>  .I ifr_newname
> 

-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
