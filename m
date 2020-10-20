Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED1D294546
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392434AbgJTW4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390707AbgJTW4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 18:56:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EBEB2225C;
        Tue, 20 Oct 2020 22:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603234561;
        bh=4xsXzivDSSZzi0+9Sk/F0zxJEqnSMlw/RyvgqK6teBE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C0zcL8+KT/l2QEgBzBqRC8YNDRJUmvgEWoLRU39qRQbm68IQlaDGUMVYXoMeGrk9A
         VrUsRUQqdHhV7b4uDRiXZdTwAgVYepJ3tdWKhny5Xh+KfDuWM0Med2iNkdONoK7ye0
         2lfu+LQBXxpruyd5rC9JCEuJfrGBrJqlAc0uDnXM=
Date:   Tue, 20 Oct 2020 15:55:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Bernat <vincent@bernat.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next v1] net: evaluate
 net.conf.ipvX.all.ignore_routes_with_linkdown
Message-ID: <20201020155559.69c5389e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <m34kmp8ll0.fsf@bernat.ch>
References: <20201017125011.2655391-1-vincent@bernat.ch>
        <20201019175326.0e06b89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <m34kmp8ll0.fsf@bernat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 08:20:43 +0200 Vincent Bernat wrote:
>  =E2=9D=A6 19 octobre 2020 17:53 -07, Jakub Kicinski:
> > I'm not hearing any objections, but I have two questions:
> >  - do you intend to merge it for 5.10 or 5.11? Because it has a fixes
> >    tag, yet it's marked for net-next. If we put it in 5.10 it may get
> >    pulled into stable immediately, knowing how things work lately. =20
>=20
> I have never been super-familiar with net/net-next. I am always using
> net-next and let people sort it out.

Since there is some breakage potential I'd prefer to merge this change
into net-next and give it more testing. But net-next is currently
closed (don't pay attention to the graphic at vger).

If you wouldn't mind - please repost next week.

You can split out and repost the documentation change separately if you
want, that's a fix that can go into net right away.

> >  - we have other sysctls that use IN_DEV_CONF_GET(), e.g.
> > "proxy_arp_pvlan" should those also be converted? =20
>=20
> I can check them and do that.
