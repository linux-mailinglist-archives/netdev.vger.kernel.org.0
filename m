Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659B14A4F74
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376516AbiAaTaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376534AbiAaTaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:30:19 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B059CC06173D
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:30:18 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id r59so14922937pjg.4
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5FaPVBNiY/lOMcEWmR3okbgU8ECND+NFqZwsmhMAmew=;
        b=DUicWE+w5TCgVJpjn+2UP1FCd7JU0T3ZnrXI+RcDXbH4p9ZNReoeCmsVmt1YlsBsiH
         prywLaVb0U1Q6swZBjVLEa3dd/t0JmmRuiymMg7fHNiGUAbGuJsSuCCEThxVLRI7TJPa
         OX1IhZgW31J0lGeLwkmhQ25RhGCYOjbBn/M2a3l3T8p/RgT+q/q5sWq52CYejSQ8yRvI
         xtdW36URZl0a02a9ZiYBneijUkg5rEnUB8EVHbywRG0zto4ttR8CdMrY9631S4V29yTs
         1ylN2aPsyrjif2PsIF8CaYCxXGS5SXD4ToS5WrLiQAEwJpIpE3JPmkJBzKBIiMC4h0Qi
         fR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5FaPVBNiY/lOMcEWmR3okbgU8ECND+NFqZwsmhMAmew=;
        b=yvt3aYHZtDDKb9usOGnzefEB2jAYMZw8guatLhzscjDmujmBB+pm9xWY0LShh7Ojq+
         hq62NRMesHYV623EtLCUMeGsIgaR7A+rPfqIj2cInsVtk4yarb+iNnVjMSv+3p0A1EXY
         p0hTKANHeDvAHu+tPGWNZhRLdD9CVMmnKc8acwl80R/PjXdLxVxWB9uHZ3s3L9eVkyaX
         E9eE7mTss2a/+t0DKcrHbieMqBnKUyYG9+SqF9y4qyg/YH13E+cu3o4cSLLbYDbX0bKQ
         ojn2cw7UxZHvHwYHFSmb0teHcna0Qt4IZnES+X0E6LbXkJL24itgZvnchk8D5C9ub9gC
         GplA==
X-Gm-Message-State: AOAM5331seH5LU2xThS3iUz3arjQcfBDpWy4NwhLYeP4APj/5llEz0I6
        vrt3/DPmusTM6u5coeEWoyySXA==
X-Google-Smtp-Source: ABdhPJwC7sry6Dm9HqgozoPN+E025YClomxnghDUqNXj93eXJUJE8B3G9azyvCmj5Fpy8riqn7qC6A==
X-Received: by 2002:a17:903:2451:: with SMTP id l17mr22681230pls.84.1643657418136;
        Mon, 31 Jan 2022 11:30:18 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q140sm30364328pgq.7.2022.01.31.11.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 11:30:17 -0800 (PST)
Date:   Mon, 31 Jan 2022 11:30:15 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vadim Priluzkiy <oxyd76@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Iproute2 v5.16.0 "ip address" issue
Message-ID: <20220131113015.63b77b3c@hermes.local>
In-Reply-To: <CAO-kc_UnKm2+bwe_Ran5cyJ15jQ17mdgev=q4a8PuGtBFNrGcA@mail.gmail.com>
References: <CAO-kc_UnKm2+bwe_Ran5cyJ15jQ17mdgev=q4a8PuGtBFNrGcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 01:13:36 +0300
Vadim Priluzkiy <oxyd76@gmail.com> wrote:

> Hi ppl!
> 
> RFC 6943 (https://datatracker.ietf.org/doc/html/rfc6943#section-3.1.1) say:
> 
> "In specifying the inet_addr() API, the Portable Operating System
>    Interface (POSIX) standard [IEEE-1003.1] defines "IPv4 dotted decimal
>    notation" as allowing not only strings of the form "10.0.1.2" but
>    also allowing octal and hexadecimal, and addresses with less than
>    four parts.  For example, "10.0.258", "0xA000102", and "012.0x102"
>    all represent the same IPv4 address in standard "IPv4 dotted decimal"
>    notation.  We will refer to this as the "loose" syntax of an IPv4
>    address literal."
> 
> Also "man 3 inet" say:
> 
> "inet_aton()  converts  the  Internet host address cp from the IPv4
> numbers-and-dots notation into binary form (in network byte order) and
> stores it in the structure that inp points to.  inet_aton() returns
> nonzero if the address is valid, zero if not.  The address supplied in
> cp can have one  of  the following forms:
> 
>        a.b.c.d   Each of the four numeric parts specifies a byte of
> the address; the bytes are assigned in left-to-right order to produce
> the binary address.
> 
>        a.b.c     Parts  a  and  b  specify the first two bytes of the
> binary address.  Part c is interpreted as a 16-bit value that defines
> the rightmost two bytes of the binary address.  This notation is
> suitable for specifying (outmoded) Class B network addresses.
> 
>        a.b       Part a specifies the first byte of the binary
> address.  Part b is interpreted as a 24-bit value that defines the
> rightmost  three  bytes  of the binary address.  This notation is
> suitable for specifying (outmoded) Class A network addresses.
> 
>        a         The value a is interpreted as a 32-bit value that is
> stored directly into the binary address without any byte
> rearrangement.
> 
>      In all of the above forms, components of the dotted address can
> be specified in decimal, octal (with a leading 0), or hexadecimal,
> with a leading 0X).
>     Addresses in any of these forms are collectively termed IPV4
> numbers-and-dots notation.  The form that uses exactly four decimal
> numbers  is  referred to as IPv4 dotted-decimal notation (or
> sometimes: IPv4 dotted-quad notation)."
> 
> 
> Okay! I know that many utilities (ping, curl, tracepath, browsers etc)
> support int, octal, hexadecimal notations very well.
> I tried assigning an address to an interface using "ip address" using
> various notations and that's what happened (test address: 10.8.0.5,
> removed after every test):
> 
> Octal dotted notation:
> # ip a add 012.010.000.005/24 dev dummy0
> # ip a show dev dummy0
> 6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group
> default qlen 1000
>     inet 10.8.0.5/24 scope global dummy0
> 
> Hexadecimal dotted notation:
> # ip a add 0xA.0x8.0x0.0x5/24 dev dummy0
>                                                                # ip -4
> a show dev dummy0
> 
> 6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group
> default qlen 1000
>     inet 10.8.0.5/24 scope global dummy0
> 
> Hexadecimal notation:
> # ip a add 0xA080005/24 dev dummy0
> 
>  Error: any valid prefix is expected rather than "0xA080005/24".
> 
> Int notation:
> # ip a add 168296453/24 dev dummy0
> 
> Error: any valid prefix is expected rather than "168296453/24".
> 
> Hmm... Okay, let's try something simple. For example address 0.0.0.1:
> # ip a add 0x1/24 dev dummy0
> 
>  # ip -4 a show dev dummy0
>                                                               6:
> dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default
> qlen 1000
>     inet 1.0.0.0/24 scope global dummy0
> 
> (similar effect on "ip a add 1/24 dev dummy0")
> 
> WTF?
> ip, instead of counting values from the last octet, counts them from the first!
> Perhaps somewhere mixed up little/big endian?
> 
> Testcase: Manjaro Linux, kernel version 5.15.16, iproute2 version 5.16.0
> 
> PS: Legacy ifconfig works fine with any notation and assigns the
> address correctly.

You are the first to care in many years, and Iproute2 (before the current maintainers)
decided to make the choice that 10.8 would get parsed as 10.8.0.0 no 10.0.0.8.
This is a choice that was made early on, and changing would break other users.

A previous attempt to change this caused backlash, not revisiting it.

commit cafa6c8ec1d6e4bddde190edb742be864ce3f9b3 (tag: v2.6.27)
Author: Stephen Hemminger <stephen@networkplumber.org>
Date:   Mon Oct 27 10:27:27 2008 -0700

    Restore old address parsing but with checking
    
    Go back to original address parsing for compatability, but
    document it and add more stringent checking.

commit 94afda752956ddc6ff1accf931bc3d03c070bb18
Author: Stephen Hemminger <stephen@networkplumber.org>
Date:   Tue Oct 14 15:02:16 2008 -0700

    Compatiable network abbreviation support
    
    Handle 10/8 as 10.0.0.0/8 and check for bogus values like 256/8.
    This is a comprimise between original iproute2 parsing and standard BSD
    parsing of abbreviated IPV4 addresses.


