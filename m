Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFBC18ABB4
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 05:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgCSEVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 00:21:23 -0400
Received: from mail.nic.cz ([217.31.204.67]:52538 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgCSEVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 00:21:22 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 308A6141B3E;
        Thu, 19 Mar 2020 05:21:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1584591681; bh=GbN2LtHvJAhaEpIgUdRGKsayTclyixqGFEAoW4D9KB4=;
        h=Date:From:To;
        b=Q9+3sSlUJA14PVnzTLcPsygwdLfRo0R2LNf/ifNcMp9gwEDmyJ2muHmaolRTyEjVB
         8BF79JarOAqsb9/CwNgZL0HqbRa3kpuz56n5hqoXgr7n+jGUZkJX88kWcY0k4UVyzw
         g+15dkmK2gDyU4H4Bsdh7iFKkF5dFYcy0ttV8N/4=
Date:   Thu, 19 Mar 2020 05:21:19 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: mvmdio: fix driver probe on missing irq
Message-ID: <20200319052119.4e694c8b@nic.cz>
In-Reply-To: <d7cfec6e2b6952776dfedfbb0ba69a5f060d7cb5.camel@alliedtelesis.co.nz>
References: <20200319012940.14490-1-marek.behun@nic.cz>
        <d7cfec6e2b6952776dfedfbb0ba69a5f060d7cb5.camel@alliedtelesis.co.nz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Mar 2020 02:00:57 +0000
Chris Packham <Chris.Packham@alliedtelesis.co.nz> wrote:

> Hi Marek,
>=20
> On Thu, 2020-03-19 at 02:29 +0100, Marek Beh=C3=BAn wrote:
> > Commit e1f550dc44a4 made the use of platform_get_irq_optional, which can
> > return -ENXIO when interrupt is missing. Handle this as non-error,
> > otherwise the driver won't probe. =20
>=20
> This has already been fixed in net/master by reverting e1f550dc44a4 and
> replacing it with fa2632f74e57bbc869c8ad37751a11b6147a3acc.

:( It isn't in net-next. I've spent like an hour debugging it :-D
