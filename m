Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6561B8C16
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 06:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgDZEat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 00:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgDZEat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 00:30:49 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87E3C061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 21:30:48 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n4so11151258ejs.11
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 21:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dGljgKqFbOSCOK416dlDQ7OE9Q9XHxLwAaM/JlhPvh0=;
        b=XFqwSaFPaSn2hPzPe4fTCd5zUNM0AGu+FG3vwlZvZF7uWn090JQRHL15RZxLL0fkAc
         AOqjIoccyiP4338K6uHchnm5nLJQZE+t1VXEMt/Q9z5CU9DlHnocDxRann4mdeH9/FvN
         DEhalcWGGnwJKGDqTvx7Qjm62R/yZgDwZ6IoU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dGljgKqFbOSCOK416dlDQ7OE9Q9XHxLwAaM/JlhPvh0=;
        b=rpQ+H82l41jBVrL40cDjqUfTWKIPiR0s/iCOQ2EQCTy2HiSZ/c36KsbqTlri5opSAv
         Ww7PQGRPaxVsgCzo+cOvwREXVJMR7mYlqI0g5/0/RI9Q+eVmwmGOtuKWdhvEtJfhC0mT
         2BqbmNyF9C2zqlX9cI33aWj/SjySZn63HJ4w97h+WrG4gOWJkoSAWBhJ940WtbEAUHZP
         ILzjU4cOzmKHNpL6LX5RwWyO3xo1sgw8MxVzV8To+0NoaiOJc54iOII19YIF7c8GaKE/
         I3pOQnaz1YiYrtkZ804MvyDZaHems1LLK3SWxXVYr5QHQQCWU40Zxg7ZmrLzZtuBq8e9
         mHFA==
X-Gm-Message-State: AGi0PuYhfqlXedr+U4Hyn8kfRqOS94lhbzZx3dS51WLNaWesQiy2NfSz
        qhPbYNW742f8cYb2yYpbufXzwQl2VmN2aTVQyVOzoA==
X-Google-Smtp-Source: APiQypJgBEJwUj609X6Un0u/9GcBLYiYfBeHJ8rx2xcfoWwPbUhW9vYo+fhKTBw9M7mKoPyuh9wCYuoQau1CK5b1I+A=
X-Received: by 2002:a17:906:7c4e:: with SMTP id g14mr14378453ejp.382.1587875447347;
 Sat, 25 Apr 2020 21:30:47 -0700 (PDT)
MIME-Version: 1.0
References: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
 <1587862128-24319-3-git-send-email-roopa@cumulusnetworks.com> <33d13007-1b31-7d2b-dc85-c28d73e0985b@infradead.org>
In-Reply-To: <33d13007-1b31-7d2b-dc85-c28d73e0985b@infradead.org>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Sat, 25 Apr 2020 21:30:36 -0700
Message-ID: <CAJieiUhgyT5DqPp9RVbKGHgrp5uTQZ1JGYEdNFLCN1nvvWC07A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] ipv4: add sysctl for nexthop api
 compatibility mode
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 7:08 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 4/25/20 5:48 PM, Roopa Prabhu wrote:
> > From: Roopa Prabhu <roopa@cumulusnetworks.com>
> >
> > Current route nexthop API maintains user space compatibility
> > with old route API by default. Dumps and netlink notifications
> > support both new and old API format. In systems which have
> > moved to the new API, this compatibility mode cancels some
> > of the performance benefits provided by the new nexthop API.
> >
> > This patch adds new sysctl nexthop_compat_mode which is on
> > by default but provides the ability to turn off compatibility
> > mode allowing systems to run entirely with the new routing
> > API. Old route API behaviour and support is not modified by this
> > sysctl.
> >
> > Uses a single sysctl to cover both ipv4 and ipv6 following
> > other sysctls. Covers dumps and delete notifications as
> > suggested by David Ahern.
> >
> > Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> > ---
> >  include/net/netns/ipv4.h   | 2 ++
> >  net/ipv4/af_inet.c         | 1 +
> >  net/ipv4/fib_semantics.c   | 3 +++
> >  net/ipv4/nexthop.c         | 5 +++--
> >  net/ipv4/sysctl_net_ipv4.c | 7 +++++++
> >  net/ipv6/route.c           | 3 ++-
> >  6 files changed, 18 insertions(+), 3 deletions(-)
>
> Hi,
>
> Are net sysctls supposed to be documented, e.g. in
> Documentation/admin-guide/sysctl/net.rst?
>

thanks, good reminder. It was on my TODO and missed it. This one can
go in Documentation/networking/ip-sysctl.txt

will include it in v3.
