Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F4721F14
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEQUa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:30:28 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:36233 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbfEQUa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:30:28 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c7c4d1c5
        for <netdev@vger.kernel.org>;
        Fri, 17 May 2019 20:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=5pXLjyd/ph4k9nkLysuF4dSx6Cs=; b=lme7Op
        VkO/rhMCqzOXyYM9EPfz6DW7TndiN4tvdHvUHAUufDtH7VO8aZyfLgmowm2Z9ZXz
        7TaAmaJAQ+8ylKwqeR4yCoqCwqHJl1KGfa18/wcb1lDt1Gvg9hif+mSC3j15q43E
        F6lbdhgoeiQPK37P829dUNpANspDveQQDTKemvYa7ivEm975zQ/qz/OsIzi7PRGm
        93vOSYWzXGg6Bs6MVPKCpa7XrWU425gTq5ADSxzYN3YH0uLVIYDzj9EVYUbONiR8
        VYSEBJ90Z6ME6HYwgYHrquo/wZl0dfZ4AbQa4Uhxe5cGD3dDOmxorVVD0Hv7v1kI
        N3qX+8poF/xOUJKA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 541b316a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 17 May 2019 20:01:29 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id f4so6113440oib.4
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 13:30:26 -0700 (PDT)
X-Gm-Message-State: APjAAAUApLFnPUUd9p4o/f5DwdxR7Tvl8khaAaNpH3CwqW+xsXptOqjH
        giHcRp1ZMJHGh54SmJKvhhcB+ENtq4eGETdUt4E=
X-Google-Smtp-Source: APXvYqzBLpHgOu2MohvFpXxinP6HOvmlATr/De1/MYglVKp9rxYDZoLjE6b1w2cwrwR/bDeMSRQwPiH6hiHGwiZ0dPU=
X-Received: by 2002:aca:7255:: with SMTP id p82mr2322406oic.119.1558125026314;
 Fri, 17 May 2019 13:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <LaeckvP--3-1@tutanota.com> <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
 <2e6749cb-3a7a-242a-bd60-5fa7a8e724db@gmail.com> <20190517103543.149e9c6c@hermes.lan>
 <5c899e85-ab00-f13b-7651-e157d9837505@gmail.com> <CAHmME9qHfDywJHhwjqqJ-8vDDdaqpGYHWDG7LTvQZ+f5b2UVng@mail.gmail.com>
In-Reply-To: <CAHmME9qHfDywJHhwjqqJ-8vDDdaqpGYHWDG7LTvQZ+f5b2UVng@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 17 May 2019 22:30:15 +0200
X-Gmail-Original-Message-ID: <CAHmME9p7FsLXtjK3=6zOWFZc9vLhUg=aRf=XBSYu7BwAotnmmA@mail.gmail.com>
Message-ID: <CAHmME9p7FsLXtjK3=6zOWFZc9vLhUg=aRf=XBSYu7BwAotnmmA@mail.gmail.com>
Subject: Re: 5.1 `ip route get addr/cidr` regression
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        emersonbernier@tutanota.com, Netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>, piraty1@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 10:19 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Fri, May 17, 2019 at 7:39 PM David Ahern <dsahern@gmail.com> wrote:
> > Not sure why Jason is not seeing that. Really odd that he hits the error
> > AND does not get a message back since it requires an updated ip command
> > to set the strict checking flag and that command understands extack.
> > Perhaps no libmnl?
>
> Right, no libmnl. This is coming out of the iproute2 compiled for the
> tests at https://www.wireguard.com/build-status/ which are pretty
> minimal. Extact support would be kind of useful for diagnostics, and
> wg(8) already uses it, so I can probably put that in my build system.

Voila, extack:

+ ip link add wg0 type dummy
+ ip addr add 192.168.4.2/24 dev wg0
+ ip link set wg0 up
+ ip route get 192.168.4.0/24
Error: ipv4: Invalid values in header for route
