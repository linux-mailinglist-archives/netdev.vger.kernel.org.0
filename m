Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3391E22F9D2
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgG0UJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:09:25 -0400
Received: from mout.gmx.net ([212.227.17.20]:42699 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgG0UJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 16:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1595880558;
        bh=tGb8+Ir1JKaNvocd5sLTTCsHYGTdOj1WTvfqesZFzEs=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=AjLtwO1FbMZkM0pyZuvlmD2qmTkjK9EpdGZTpJXybqFn15XSzQPTpunhccw55bC0F
         s/2pBssEbztqVHSc6qOkhcxx9IILbCKF2WO5ZiIWLUlRNOYXrrTzM6Y1rkRfBniYho
         EE1kWblhAsZzNevftEQ6NbgSRA01BM7z0sdebruA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from gmx.fr ([131.100.39.57]) by mail.gmx.com (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mxm3K-1kitUp3WhC-00zBnA; Mon, 27
 Jul 2020 22:09:18 +0200
Date:   Mon, 27 Jul 2020 16:09:12 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Broken link partner advertised reporting in ethtool
Message-ID: <20200727200912.GA1884@gmx.fr>
References: <20200727154715.GA1901@gmx.fr>
 <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
X-Provags-ID: V03:K1:tCHNVCx3t0BVmo4ThNWusGRsSAjN5ia4bEwvv7N689HX8jCvqhw
 yTm/ksI+Bssy1Ky0sc5/hus04iURpkARaNLD0zXXWkBtpfqF9g5iNOTsulEgsFVrFGVludi
 h6KYWT9ueExDfQ4peh8RWr/UoTMaLKmRYYcxZZXkGSGnLxyPu/qDVTRMb1iydj7squqB6I7
 TfkMxjOkWWoVzeN0+caMg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9qIYc8ef2Mo=:TUOm9vfL/NhpPv4vB/36EC
 7J5o1o89Z9KumHXftwKxG5lknsT+KvofmUfRaOQlthK0LpN4+oyFR9ANyLZmBwaOoM9ST6uj9
 HuHw3Ns1RxWC+hst2wjXJaGLaHK2JpoXfhEOL+5pGXzd/mwOYsHjG3RXAYt7ozqlDbjCDIp3K
 KSsJ9fcdYvi1vK8JxAbTJWXWDgT9vgaBvheqtnCTdKMBOf0NF9Pyn4/gRsZatwIoi2Hm7kRJf
 FPHmzgHchRSRF9KKxvIkZ/jgFGo3UHCrhce8ouXTJJ7dT6m5/96Ivb7eEATqXO+5Z6RvjAef9
 QXLI2egcMeRkC9VJMoyICnMjXFioxMQnYI8tdri1ixZ2ef2n6R2mPFDhSTHrzdggrk0eCY5X+
 px3sejgTMRm9QDHnTlSsqkvkjUrY4HyQwf9jvRmmaiHknkx4H5eD9CtJHFpgHrQwgPOlTMlwy
 Xlz2AlN1Gn1ReKER56YrJ+k6LivCtqnSvBfhgP5rcfUf/+vtgx1oV6L30gyjQCf+WSnEDy55n
 exO/1VhWa6hcj2aDWYU2qPvptHCQE8BS5VIoopBvhFMvB5pr8gpaFCSZSP2ypqidP6Wv2+MuE
 protK+eKsi/4jt21zv+NYUYb5rl4KgcYsDTGn90+huq+cpHnFcY84zx1uEr1WaHmew9H+Dqto
 ojdjadntYPr847X9yjHCnzDyr3diQZrODTOvuzMdBfRHAS+CyWXbPeLnimPx0IScxyQHd6+9y
 rvQwR1YMHY+KkX+fzaNQ2OB2dQqdBNA8+8ZJCqWwqTDNxgVWowNN0bABOjMHHE2FT5piSxy+2
 cclXXSCtV0nKFBLVJZMC1PFxC5mu9IwScVn4mqF1vh5Srl1ZNoZDIbJ23kr14dj3jcyXRvVrF
 6U1ahjCz3TR7mOn/rrN4Fmuo1lR6BADnx94FuYGFjgOvl+3e0JxmJs9nKA4powRv412ay6hUc
 Uuf4A/ygysNEP3JE7MCzmLJ4NcdbhHm6Nu2EnB9WbfErwccy4BVGHTe/lI0YtZUpNxTu53chy
 uEZUslLLhx8oHbqWXDYRr1tnn73dMDOqBkmJ1/0dsLCUGoctDeieiXa+lUN+Y3WodmLcYOB+A
 mIpaPSjk4u55FoGb8KyZw/AVdSmZg5NRQEnG6mBo4HhPEDyRWq9m9lYM+TlB9yNNZtzw2s+6J
 XM6phn2apkGhewZH7COWk7tSGQL/j4gUagFHEE99CneH7uuWAelH4nC5Rw9Uf8X/Yf+Ev3G29
 eZoQpTWMKdJdES31Ai7kbVF4/QmiyJDgHDgyH2Q==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:19:13PM -0700, Jacob Keller wrote:
>
>
> On 7/27/2020 8:47 AM, Jamie Gloudon wrote:
> > Hey,
> >
> > While having a discussion with Sasha from Intel. I noticed link partne=
r
> > advertised support is broken in ethtool 5.7. Sasha hinted to me, the
> > new API that ethtool is using.
> >
> > I see the actual cause in dump_peer_modes() in netlink/settings.c, tha=
t
> > the mask parameter is set to false for dump_link_modes, dump_pause and
> > bitset_get_bit.
> >
> > Regards,
> > Jamie Gloudon
> >
>
> Hi,
>
> Seems like more detail here would be useful. This is about the ethtool
> application.
>
> Answering the following questions would help:
>
>  - what you wanted to achieve;
>
>  - what you did (including what versions of software and the command
>    sequence to reproduce the behavior);
>
>  - what you saw happen;
>
>  - what you expected to see; and
>
>  - how the last two are different.
>
> The mask parameter for dump_link_modes is used to select between
> displaying the mask and the value for a bitset.
>
> According to the source in filling the LINKMODES_PEER, we actually don't
> send a mask at all with this setting, so using true for the mask in
> dump_link_modes here seems like it would be wrong.
>
> It appears that to get link partner settings your driver must fill in
> lp_advertising. If you're referring to an Intel driver, a quick search
> over drivers/net/ethernet/intel shows that only the ice driver currently
> supports reporting this information.
>
> Given this, I am not convinced there is a bug in ethtool.
>
> Thanks,
> Jake

I am using r8169 with phy driver which actually fills lp_advertising.
I recompiled ethtool v5.7 with --disable-netlink and "Link partner
advertised link modes" works as it should.
