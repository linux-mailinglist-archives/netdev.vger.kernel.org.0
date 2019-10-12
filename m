Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F25FD4C01
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 04:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfJLCB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 22:01:27 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:46272 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfJLCB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 22:01:27 -0400
Received: by mail-lf1-f41.google.com with SMTP id t8so8245485lfc.13
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 19:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ObxpvZMPC9VLh3rf5eQ6e98cbkYVC/HrihNMLU3Zbao=;
        b=MDvUlgkWJfiEvwEN2mZ+XBFMQF6EL1W7Zyqyys2Tqp4NVnDKLRttiw4lROCYrrdXuf
         JobEDk4grzxvFMsnsXmd6rs/otTSvpOGnIaFwhpavH0X+BUQNKgkZIRL5GO2wcj+4TDQ
         WfJq2NGhQYoVQ9hnim/kXgLOkSKa6Z2IgNOwZmA44offHu9QwkXgmn4r8CfhWw7nSJaN
         tJYvmZQ7IAeGJ9TdkuI6s3ZkHexhYzYQ62iR1AWeK8anL9FBhzJX+P2jEp2DIblxSPyb
         +yLlnWlHRpNUDoV/ykO4VWl0fZRWXhjTf3r2HVl2GD5gwOxio97ZxfqxPVoEKIEmUJ8J
         ELMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ObxpvZMPC9VLh3rf5eQ6e98cbkYVC/HrihNMLU3Zbao=;
        b=B5E/3Dr/EvWstQlwe0UxH4un2Pi5+bnlekR4PIqp7bSXMHlq4DEKB2Pshn2AqCBIQE
         uapkqp583aTF84KNcPB99ceqpqI3aEx/Tx1aN1YYXJI9j6mZr9gJwo+yIxFyDp2eB2FS
         Z1PNTMXKi+hnDeQSOgpw/COQRHb3pAt9yTyGR2/0DWpwWj8/FJXKr6FLWUDObUfRYr1Y
         QcrYPkfXvpAID4ZSfWukvqvQ+BNCb957ajYMKYeHtJufnBVYXVU3KbjymhASYGgY20we
         dEogp3qtmomgwPLBecqhpi0CrO4EAEALwhC/jLICdlIOpOs7/cvMf0Ih2o7uK9FCP/3k
         CCvQ==
X-Gm-Message-State: APjAAAULY8rfXkUK4WuUX3RcHItG2muWzzB/3Im9XoqUNkFxG/GcDcl5
        4iy2KGWi52aYRaBvHlGFjOWR7v2IUCN0sdWUmTlbNg==
X-Google-Smtp-Source: APXvYqx3TWoFSEAXesbyWEz/moSWLSH05qnqDInPC+UGPb5zgZDA5kTc9jOHhnLCIGCGddEzGuk97z42YTQc9RBzuVc=
X-Received: by 2002:a19:c6c3:: with SMTP id w186mr9872657lff.111.1570845683607;
 Fri, 11 Oct 2019 19:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAPaK2r_T28BqvOkjDSD=SR-5sKeD_HgHu1tvB+b1jR20FuU0WQ@mail.gmail.com>
In-Reply-To: <CAPaK2r_T28BqvOkjDSD=SR-5sKeD_HgHu1tvB+b1jR20FuU0WQ@mail.gmail.com>
From:   yue longguang <yuelongguang@gmail.com>
Date:   Sat, 12 Oct 2019 10:01:12 +0800
Message-ID: <CAPaK2r-38JUpdZqhKWsY22C85ZHMJD3H4QEHkRd_TSKMFwMURQ@mail.gmail.com>
Subject: Re: ingress bandwidth limitation for ipv6 is inaccurate
To:     kuznet@ms2.inr.ac.ru, stephen@networkplumber.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, kuznet,i am looking forward to your reply.

thanks

On Tue, Oct 8, 2019 at 1:53 PM yue longguang <yuelongguang@gmail.com> wrote:
>
> Firstly, thank you  stephen.
>
> Hi, kuznet:
>
> 1.  according to my test,  bandwidth limitation is inaccurate for
> ingress ipv6 .  The accuracy is affected by burst.   if rate is less
> than 100mbit , set burst to 1MB or 2MB, the result is almost
> acceptable.  but when rate is bigger , the result is approximately 1/3
> of rate.
> command:  tc filter add dev qr-869fbdc2-1e parent ffff: protocol ipv6
> u32 match ip6 src any police rate 500mbit burst 1M drop
> so except for using ifb, what should be done to get a accurate result.
>
> 2. can flowid option of  ingess's filter belong to egress's class.
> for example    tc filter add dev qr-869fbdc2-1e parent ffff: protocol
> ipv6 u32 match ip6 src any police rate 500mbit burst 1M flowid 1:10
>  (1:10 classid  is egress's qdisc's class )
>
>
> thanks
