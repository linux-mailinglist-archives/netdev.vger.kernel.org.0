Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727AC21F69B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgGNP7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbgGNP7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 11:59:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62A2D223C6;
        Tue, 14 Jul 2020 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594742361;
        bh=3+u1zrLc/VCPEpaP0kAdAA5uhAKmeFvVSxzG4BJM9QE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=w1cEurK1Vw1wJtxuclT0P2lJDueXHD5oZVyHoqJcJejMqzMDzbErZoK7A5wMf73up
         kOJ0SzrjUrBsHvItK6ozB1vwVlGJbrJ8FUGjP5dmS3HTYW3ma6P6ojmi5uhqjGeqT1
         g4Ftbh15uecydYG8HmJMi/OJYQLHmWIA/+Fbwf08=
Date:   Tue, 14 Jul 2020 08:59:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kiyanovski, Arthur" <akiyano@amazon.com>
Cc:     "Machulsky, Zorik" <zorik@amazon.com>,
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
Message-ID: <20200714085918.5e8f8a97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c5274c7769ac48bea39d63063728e695@EX13D22EUA004.ant.amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
        <1594321503-12256-7-git-send-email-akiyano@amazon.com>
        <20200709132311.63720a70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <53596F13-16F7-4C82-A5BC-5F5DB22C36A4@amazon.com>
        <20200710130513.057a2854@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <C1F3BC8C-AFAD-4AB4-8329-A48F4AD0E60B@amazon.com>
        <c5274c7769ac48bea39d63063728e695@EX13D22EUA004.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 11:20:27 +0000 Kiyanovski, Arthur wrote:
> > This commit actually enables a feature after it was fixed by previous c=
ommits,
> > therefore we thought that net-next could be a right place. But if you t=
hink it
> > should go to net, we'll go ahead and resubmit it there. Thanks for your
> > comments. =20
>=20
> Jakub,=20
> I=E2=80=99ve removed the patch from v2 but it seems to me there was some
> miscommunication and IMO the correct place for the patch should be
> net-next. This feature was actually turned off until now, and this
> patch turns it on. It is not a bug fix, it is actually a feature. Do
> you have an objection to me returning this patch (with this
> explanation in the commit message) to this patchsets V3?

Sounds good, the commit message makes all the difference.
