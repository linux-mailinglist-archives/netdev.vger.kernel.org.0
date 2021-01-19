Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994882FC0CC
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbhASUTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729057AbhASUTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 15:19:13 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E34C061574;
        Tue, 19 Jan 2021 12:18:32 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id c5so20967461wrp.6;
        Tue, 19 Jan 2021 12:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PuaOfjM3Soqw0S93kb4MHx+At8RYMhQbRkwn0keMLhM=;
        b=CkJVb1VTvrvu8QfRzZMUDNPEJIX+Izr3GsEkfjrtjRc/F4QKux/IN3TpWx+OcV27St
         3gJTecgMo0tj5NhRsWaPZGLiiT6bIdL9VqSF32JfRn/l4aDpeyV7l+gGytM0Oy5ANVbp
         u0f15wL8enBORo3DF/evOAxeICAQH24tAR21cxM+0NbbWFPfcKYpiCzTl1tT9QlZ+jl4
         x4tNSi0nGmdBwcjDhDA3LDb7to7HERvgn0V4BtVKdteStDk/fBz5MqsH/GXbYFI1IDFN
         dR5S5t6csjdQBO+eguWypJt4Qiekf2SbmvDtPXrmcV+2/qDeVN7BVaBZ/vZoevovz81q
         IZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PuaOfjM3Soqw0S93kb4MHx+At8RYMhQbRkwn0keMLhM=;
        b=D0q9jfNe/sMh3nX7SfG37GK8jd7mwHbDF/57ubPDIhXw3Dn1hhfbnXZ/y1hautYCKR
         R4to/biVkzMhchi85yb5+sEdsmTSNfISW6zq+twkKITH5O3uo+XzNY/8hZJnwlw5wAWd
         2OGTqYx6ggPtjheD4xr5lg1wUZyIPN+MJMilYoFw2Zo8aWsN/R1FR4IG5oM6u8Ktqfbh
         nKwgmjBBooAVSLkEEKTzOtY8Avz3vNr/pwpGqi/mxNCOc2bhRYqQRXxI4ATxOTSDCHnI
         gJb5iW5Uo6PmyFP86872BEYs9TlSyLWBLXTdTO+yXUY1gs56Fp3WCk9wX0CASZHJwXmV
         nY6w==
X-Gm-Message-State: AOAM532ddk6YyM3+nw3g+6cqbbznniDGdOJJvs6TQmGUFv+nkqA2aiZZ
        NnGskBqcoQ7LqXacTvnDo9r5qdsv064=
X-Google-Smtp-Source: ABdhPJxGsJsp7R8+Hq+mcb3bu/MNS4Cafux9mcICdUliG5BaJiG8cHN3QtWW4kXG1JTBTDdm8d7zng==
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr5970744wrv.304.1611087511519;
        Tue, 19 Jan 2021 12:18:31 -0800 (PST)
Received: from [192.168.0.160] ([170.253.49.0])
        by smtp.gmail.com with ESMTPSA id a25sm5886559wmb.25.2021.01.19.12.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 12:18:31 -0800 (PST)
Subject: Re: [PATCH v3] netdevice.7: Update documentation for SIOCGIFADDR
 SIOCSIFADDR SIOCDIFADDR
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        linux-man@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        netdev@vger.kernel.org
References: <20210102140254.16714-1-pali@kernel.org>
 <20210116223610.14230-1-pali@kernel.org>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <fc4a94d4-2eac-1b24-cc90-162045eae107@gmail.com>
Date:   Tue, 19 Jan 2021 21:18:29 +0100
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

I was a patch for environ.7 while I found some pattern.
Please see below a minor fix.

Thanks,

Alex

On 1/16/21 11:36 PM, Pali Rohár wrote:
> Unlike SIOCGIFADDR and SIOCSIFADDR which are supported by many protocol
> families, SIOCDIFADDR is supported by AF_INET6 and AF_APPLETALK only.
> 
> Unlike other protocols, AF_INET6 uses struct in6_ifreq.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
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

I found a few pages with the pattern [.BR X / Y],
but none like [.BR X " / " Y].

$ grep -rn '\.BR [a-zA-Z]* / [a-zA-Z]*' man?
man1/getent.1:365:.BR ahosts / getaddrinfo (3)
man2/sigaction.2:526:.BR SIGIO / SIGPOLL
man2/sigaction.2:638:.BR SIGIO / SIGPOLL
man2/sigaction.2:814:.BR SIGIO / SIGPOLL
man3/sysconf.3:181:.BR PAGESIZE / _SC_PAGESIZE .
man7/signal.7:539:.BR SIGINFO / SIGPWR
man7/pipe.7:114:.BR SIGPIPE / EPIPE
man7/environ.7:127:.BR EDITOR / VISUAL
$ grep -rn '\.BR [a-zA-Z]* " / " [a-zA-Z]*' man?
$

Please fix this for the next revision.
However, don't send a new one only for this.
I'd wait to see if someone reviews it or helps in any way ;)


>  or via
>  .BR rtnetlink (7).
> +Retrieving or changing destination IPv6 addresses of a point-to-point
> +interface is possible only via
> +.BR rtnetlink (7).
>  .SH BUGS
>  glibc 2.1 is missing the
>  .I ifr_newname
> 
