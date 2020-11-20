Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396C42B9F9F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgKTBUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:20:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgKTBUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:20:10 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4000E22254;
        Fri, 20 Nov 2020 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605835209;
        bh=bZjfUL1UblIM9s71DnjwsiTSdfRM7AR55mXRwOocJc8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E8MpnOsNGeqopO5roB8ILOdC3mB7a19xAKbOX8voSBE4w4x37Jym1OmCMYz6SeLDg
         sqy4hRrDUk+hKTJfJbK88QZtZZvbqHwvtWLFypCTgnF+K5XKrzmPCrmldQ0EKbuCwo
         Lq71kermx0GKX5SCB5qg0UuCGR/hbjJyv5FB0gKI=
Date:   Thu, 19 Nov 2020 17:20:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V6] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
Message-ID: <20201119172008.4d26c0fb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
        <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
        <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
        <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
        <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 20:31:41 +0100 Dmytro Shytyi wrote:
>  > Thanks for adding the helper! Looks like it needs a touch up:  =20
> =20
> Understood. Thank you for pointing this out. I think I did not catch this=
 warning as my Makefile didn't include "-Wmissing-prototypes"
>=20
>  > net/ipv6/addrconf.c:2579:22: warning: no previous prototype for =E2=80=
=98ipv6_cmp_rcvd_prsnt_prfxs=E2=80=99 [-Wmissing-prototypes]=20
>  >  2579 | struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_if=
addr *ifp,=20
>  >  |                      ^~~~~~~~~~~~~~~~~~~~~~~~~=20
>  > net/ipv6/addrconf.c:2579:21: warning: symbol 'ipv6_cmp_rcvd_prsnt_prfx=
s' was not declared. Should it be static?=20
>  >  =20
>=20
> Hideaki Yoshifuji helped to improve this patch with suggestions. @Hideaki=
, should I add "Reported-by" tag in this case?
> Jakub Kicinski also helped to find errors and help with improvement. @Jak=
ub, should I add "Reported-by" tag in this case?=20

No need for a tag for me, it would be great if Hideaki was
willing to provide his acked-by or reviewed-by though :)
