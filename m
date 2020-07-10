Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE8221BE44
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGJUFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:05:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgGJUFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 16:05:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D632076A;
        Fri, 10 Jul 2020 20:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594411516;
        bh=UlCyki/vhtuNR2m/jbt+uFvu7jdXsVTHEaOocTcJv24=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lATf5TVHQANjexCBYG5MErJbdRgNTFBWXqLhcIWqqMQuDhqn6EZmj9GGJzkl2X0Vr
         zPk6/QWxLpGJ75J0HVHzcHwKADvXeXXv/XmU1Rq7rdgPY9TwteaJ5tAGEtm0mEs3gs
         NR4pIU6zMQPgfrcBRdDcGgXtzWI20Q1DqEx0PTrg=
Date:   Fri, 10 Jul 2020 13:05:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machulsky, Zorik" <zorik@amazon.com>
Cc:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Subject: Re: [PATCH V1 net-next 6/8] net: ena: enable support of rss hash
 key and function changes
Message-ID: <20200710130513.057a2854@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <53596F13-16F7-4C82-A5BC-5F5DB22C36A4@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
        <1594321503-12256-7-git-send-email-akiyano@amazon.com>
        <20200709132311.63720a70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <53596F13-16F7-4C82-A5BC-5F5DB22C36A4@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 19:53:46 +0000 Machulsky, Zorik wrote:
> =EF=BB=BFOn 7/9/20, 1:24 PM, "Jakub Kicinski" <kuba@kernel.org> wrote:
>=20
>     On Thu, 9 Jul 2020 22:05:01 +0300 akiyano@amazon.com wrote:
>     > From: Arthur Kiyanovski <akiyano@amazon.com>
>     >
>     > Add the rss_configurable_function_key bit to driver_supported_featu=
re.
>     >
>     > This bit tells the device that the driver in question supports the
>     > retrieving and updating of RSS function and hash key, and therefore
>     > the device should allow RSS function and key manipulation.
>     >
>     > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com> =20
>=20
>     Is this a fix of the previous patches? looks strange to just start
>     advertising a feature bit but not add any code..
>=20
> The previous related commits were merged already:
> 0af3c4e2eab8 net: ena: changes to RSS hash key allocation
> c1bd17e51c71 net: ena: change default RSS hash function to Toeplitz
> f66c2ea3b18a net: ena: allow setting the hash function without changing t=
he key
> e9a1de378dd4 net: ena: fix error returning in ena_com_get_hash_function()
> 80f8443fcdaa net: ena: avoid unnecessary admin command when RSS function =
set fails
> 6a4f7dc82d1e net: ena: rss: do not allocate key when not supported
> 0d1c3de7b8c7 net: ena: fix incorrect default RSS key

These commits are in net.

> This commit was not included by mistake, so we are adding it now.=20

You're adding it to net-next.

