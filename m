Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7931B2DCD
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgDURFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbgDURFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 13:05:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE94206E9;
        Tue, 21 Apr 2020 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587488746;
        bh=wYIADnQG0TmxTbGgrJkqaa5SVwPVM6qbSyF3hlZwcKA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P79Hz8d5IV5O7NFjvVSKIdCAyFw4KwV+1hWCceAW0TSzHR1gARbC8TAtcTZhU2CET
         MPykn8PV4S9XYLq++7aF+t7goD9S70xjSs998b9F3OfT0fkVDK7Rzcn2qKj2jxuPIL
         kWklk4PF2zGQTJdU3t01hGmd5aJX6INmpGYD9q4E=
Date:   Tue, 21 Apr 2020 10:05:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     khalasa@piap.pl, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shengju Zhang <zhangshengju@cmss.chinamobile.com>
Subject: Re: [PATCH] net: ethernet: ixp4xx: Add error handling
 inixp4xx_eth_probe()
Message-ID: <20200421100544.0de3fbba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <71697844-cc03-9206-1594-b8af02f38018@cmss.chinamobile.com>
References: <20200412092728.8396-1-tangbin@cmss.chinamobile.com>
        <20200412113538.517669d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <71697844-cc03-9206-1594-b8af02f38018@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020 12:46:37 +0800 Tang Bin wrote:
> Hi Jakub:
>=20
> On 2020/4/13 2:35, Jakub Kicinski wrote:
> > On Sun, 12 Apr 2020 17:27:28 +0800 Tang Bin wrote: =20
> >> The function ixp4xx_eth_probe() does not perform sufficient error
> >> checking after executing devm_ioremap_resource(),which can result
> >> in crashes if a critical error path is encountered.
> >> =20
> > Please provide an appropriate Fixes: tag. =20
>=20
> Thanks for your reply.
>=20
> I don't know whether the commit message affect this patch's result. If so,
>=20
> I think the commit message in v2 needs more clarification. As follows:
>=20
>  =C2=A0=C2=A0=C2=A0 The function ixp4xx_eth_probe() does not perform suff=
icient error=20
> checking
>=20
> after executing devm_ioremap_resource(), which can result in crashes if=20
> a critical
>=20
> error path is encountered.
>=20
>  =C2=A0=C2=A0=C2=A0 Fixes: f458ac479777 ("ARM/net: ixp4xx: Pass ethernet =
physical base=20
> as resource").
>=20
>=20
> I'm waiting for you reply actively.

Please repost with the tag included.
