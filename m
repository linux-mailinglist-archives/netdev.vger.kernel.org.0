Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F1A5C0F3
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfGAQOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:14:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42443 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbfGAQOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:14:10 -0400
Received: by mail-lf1-f68.google.com with SMTP id x144so9198605lfa.9
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0U0YPTwJgVIJVRdYc6tYY8FIRvP636LwdBcXQglF9w0=;
        b=ZTGIimF8m4qAIqTUoATDA5KYKjbD3VAysQPkHYNPieUHtwWAfP/JHrR5mMcL1jmavO
         4gFsC3yaDu6RuaPgU5nWN78lLegRoHN2Sl8xXG2hox7H8TlAx4YZwtvnjleyb1IIEnEX
         W30EZLtEfQuDGC5u/5LLFZuP47/xQSuPIdiOvYsbjxIC4HeNC06p9K7pRZvkMmndZlQU
         9rYw4pOv4PqkUZK+kqNQKekXRBiTOvkHhAFfl4MnTgwuSNewNWFGE16wipdL6CTJUEVw
         8yo+VjwctITrBuuFFnyFhIbSC7+0uKUo5q6BQimDziNYOn9X+GFZG9LSWLZp6cMI5oON
         Z2hw==
X-Gm-Message-State: APjAAAXPgfNFl19y90+Ucnca+Fieds5LLCFjNqFkIniokG3FJANddZKB
        rcc34E46OkmqhG5SrasklhCP38jeA+y63rmwy2V9Xw==
X-Google-Smtp-Source: APXvYqzriltBqe9R7oQnUm+t1kiD/JXfO+P5w1S5DjKPm1jZ3LxfH1T50G3V+2i3+aAxPMfHqfVYaccEHxDlHv7SpJE=
X-Received: by 2002:ac2:4466:: with SMTP id y6mr6082599lfl.0.1561997648899;
 Mon, 01 Jul 2019 09:14:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190701160805.32404-1-mcroce@redhat.com> <42624f83da71354a5daef959a4749cb75516d37f.camel@perches.com>
In-Reply-To: <42624f83da71354a5daef959a4749cb75516d37f.camel@perches.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 1 Jul 2019 18:13:32 +0200
Message-ID: <CAGnkfhx9F1G8K6PjBdUnkCO07GR=ktWAnqOLTcOvg7VGwWb69Q@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: don't set IPv6 only flags to IPv4 addresses
To:     Joe Perches <joe@perches.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 6:10 PM Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2019-07-01 at 18:08 +0200, Matteo Croce wrote:
> > Avoid the situation where an IPV6 only flag is applied to an IPv4 address:
> []
> > diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> []
> > @@ -468,6 +473,9 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
> >       ifa->ifa_flags &= ~IFA_F_SECONDARY;
> >       last_primary = &in_dev->ifa_list;
> >
> > +     /* Don't set IPv6 only flags to IPv6 addresses */
>
> umm, IPv4 addresses?
>
>

Ouch, right.

/* Don't set IPv6 only flags to IPv4 addresses */

Can this be edidet on patchwork instead of spamming with a v2?

-- 
Matteo Croce
per aspera ad upstream
