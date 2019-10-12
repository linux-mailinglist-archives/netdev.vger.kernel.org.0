Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C01FD5253
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 22:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfJLULP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 16:11:15 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:43387 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbfJLULP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 16:11:15 -0400
X-Originating-IP: 209.85.217.46
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 5CABDC0007
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 20:11:13 +0000 (UTC)
Received: by mail-vs1-f46.google.com with SMTP id w195so8414921vsw.11
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 13:11:13 -0700 (PDT)
X-Gm-Message-State: APjAAAU0cipuXitru/lXDEN9GWcF9Ea0e/xiAYDqeE24yfjeG4wgh3jE
        ZDNyVylTv2qlNQasm0nCU6ZI31z6XUpyWxbfiwk=
X-Google-Smtp-Source: APXvYqzxtojYRI/zRe8CNTTc5lWVYO+0m13vyfQYXaQcJOwEicVQzfWjPIZQW8wXY7IW3JoXHAWYoKi5HykDzxHtMvI=
X-Received: by 2002:a67:e342:: with SMTP id s2mr13103275vsm.103.1570911071947;
 Sat, 12 Oct 2019 13:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <1570509631-13008-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_A6diWm08Swp3_2Eo+VCvugRsh60Vc8_t2pC3QLEAR9xQ@mail.gmail.com> <20191011033357.GA22105@martin-VirtualBox>
In-Reply-To: <20191011033357.GA22105@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 12 Oct 2019 13:11:02 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BkDY=ZEE+_BwhguMK+vokyctdsH=LtX+u1Mc8G7pdkmg@mail.gmail.com>
Message-ID: <CAOrHB_BkDY=ZEE+_BwhguMK+vokyctdsH=LtX+u1Mc8G7pdkmg@mail.gmail.com>
Subject: Re: [PATCH net-next] Change in Openvswitch to support MPLS label
 depth of 3 in ingress direction
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 8:34 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Wed, Oct 09, 2019 at 08:29:51AM -0700, Pravin Shelar wrote:
> > On Mon, Oct 7, 2019 at 9:41 PM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > > direction though the userspace OVS supports a max depth of 3 labels.
> > > This change enables openvswitch module to support a max depth of
> > > 3 labels in the ingress.
> > >
> > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > ---
...
...
> > >                 case OVS_ACTION_ATTR_SET:
> > >                         err = validate_set(a, key, sfa,
> >
> > I would also like to see patch that adds multi label MPLS unit test in
> > system-traffic.at along with this patch.
>
> the same patch to dev@openvswitch.org along with the changes in sytem-traffic.at  ?

You can send two patches one for kernel space and other for userspace
OVS including the unit test to ovs dev and netdev mailing list.

Thanks,
Pravin.
