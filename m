Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381BDF39A8
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 21:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfKGUk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 15:40:26 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51291 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGUkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 15:40:24 -0500
Received: by mail-wm1-f66.google.com with SMTP id q70so3974508wme.1
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 12:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/pKH0tT7IUWPxlqReLKSDJjr+ZKqHoHFlpAU48nDsb8=;
        b=YJruocL3WMHsSdrAyY52mp704CIZlMgZTUFDzjAsr0YlHFddlJA0cTV1nlVZRLwFHb
         jUQfYrr/sRxB7PFJ4W08gutrX2v/Clmr3WpGEORKeKLuxqF/cVtZOoi5Mfq+Jc/5psVV
         SSBjEKQVrwI9IptIxB6HyM5eXh9id07j8C7r8KeprTTreRrvLqAK/qRzRmIsoetJ9xKG
         FP4C2TdMB62F4KwRRzxluS4yXYRAuFR77Xp5SAmlgh9SPA9/lrDbeT4PhAK0N9Mn4Udl
         C4lx+IzKQiOfy+WDLgquCQEJN5AAJFuuv62ZVkLB6DnuKLCNe/wDVDtIB8hUJASWVtal
         +1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/pKH0tT7IUWPxlqReLKSDJjr+ZKqHoHFlpAU48nDsb8=;
        b=HXz8hrHNlMNWZ7uKUhGDiRR90ZJWBenm4PBout6njWwiiruH3tWfL6Crw2XHYn64PT
         sJ1bEcDxbLT8hziAsIYv61ZBhD4cbQCRbj+J6jWqrGwb/8qNoA8bZNqMQvCPHXR6x2jT
         igWDj1ySupC1nETWAkWLMTg1AibHGb8nqe0ojzHJU4CIcoobGGiyiqaab6n/PFfHCAfD
         5WqthNGKMJVq20uaiQCdRSfclM9VskpHEeqqOwW9IAOPFk9B/myL89Bk9dxHQsy4OL9q
         OvE1FVZy9Q+D8u8XzpZbgfQbC4p11kWyIMeR6NxlfGKXZ8e3uhCP+koI6LfxNhap7D27
         UflA==
X-Gm-Message-State: APjAAAX4Zf0kATGQVyEwmqSGZyL9P16YhqXiBTkUTRVCr7lM9vbg21Fj
        AJjiWA7DrxTIKHG/kOmj6omovqiCxEuLa4N52jHc6w==
X-Google-Smtp-Source: APXvYqwJSeRni4hQ3v3vC2wuYAdNlSyGM6v5AS0hn8e7JMxXC+lI4FPDSl05I/OcHMJOn0gPs4pgz+LQyi9uFGs8jEA=
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr5148663wme.92.1573159221150;
 Thu, 07 Nov 2019 12:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20191107132755.8517-1-jonas@norrbonn.se>
In-Reply-To: <20191107132755.8517-1-jonas@norrbonn.se>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Thu, 7 Nov 2019 12:40:04 -0800
Message-ID: <CAF2d9jjteagJGmt64mNFH-pFmGg_eM8_NNBrDtROcaVKhcNkRQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Add namespace awareness to Netlink methods
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     nicolas.dichtel@6wind.com, linux-netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 5:30 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Changed in v3:
> - added patch 6 for setting IPv6 address outside current namespace
> - address checkpatch warnings
> - address comment from Nicolas
>
> Changed in v2:
> - address comment from Nicolas
> - add accumulated ACK's
>
> Currently, Netlink has partial support for acting outside of the current
> namespace.  It appears that the intention was to extend this to all the
> methods eventually, but it hasn't been done to date.
>
> With this series RTM_SETLINK, RTM_NEWLINK, RTM_NEWADDR, and RTM_NEWNSID
> are extended to respect the selection of the namespace to work in.
>
This is nice, is there a plan to update userspace commands using this?

> /Jonas
>
> Jonas Bonn (6):
>   rtnetlink: allow RTM_SETLINK to reference other namespaces
>   rtnetlink: skip namespace change if already effect
>   rtnetlink: allow RTM_NEWLINK to act upon interfaces in arbitrary
>     namespaces
>   net: ipv4: allow setting address on interface outside current
>     namespace
>   net: namespace: allow setting NSIDs outside current namespace
>   net: ipv6: allow setting address on interface outside current
>     namespace
>
>  net/core/net_namespace.c | 19 ++++++++++
>  net/core/rtnetlink.c     | 80 ++++++++++++++++++++++++++++++++++------
>  net/ipv4/devinet.c       | 61 ++++++++++++++++++++++--------
>  net/ipv6/addrconf.c      | 13 +++++++
>  4 files changed, 145 insertions(+), 28 deletions(-)
>
> --
> 2.20.1
>
