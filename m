Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A1A18ABDA
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 05:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgCSEhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 00:37:02 -0400
Received: from mail.nic.cz ([217.31.204.67]:55036 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgCSEhB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 00:37:01 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 28ADF141B24;
        Thu, 19 Mar 2020 05:37:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1584592620; bh=kaY1PjINlwjFDoDMYK0fz4Q2P5Z9IyaYYnVRM/K6Cv4=;
        h=Date:From:To;
        b=YhTIpSDS7M34nREp0/giQVyUyTTiL7DvQTrr81+RnPiIbJVcvbi2VBv4/YEzZovUc
         GYa5xGCTK7i9ngudRSBz/LlKRLReI+stwr+xNwLmaBPoqwbuuvckDtMSiqVYacgYTG
         apYgyhkJqGE2WKASwJcHMY1e324MPDnL5oZmA9fg=
Date:   Thu, 19 Mar 2020 05:36:59 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: mvmdio: fix driver probe on missing irq
Message-ID: <20200319053659.4da19ae0@nic.cz>
In-Reply-To: <de28dd392987d666f9ad4a0c94e71fc0a686d8d6.camel@alliedtelesis.co.nz>
References: <20200319012940.14490-1-marek.behun@nic.cz>
        <d7cfec6e2b6952776dfedfbb0ba69a5f060d7cb5.camel@alliedtelesis.co.nz>
        <20200319052119.4e694c8b@nic.cz>
        <de28dd392987d666f9ad4a0c94e71fc0a686d8d6.camel@alliedtelesis.co.nz>
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

On Thu, 19 Mar 2020 04:27:56 +0000
Chris Packham <Chris.Packham@alliedtelesis.co.nz> wrote:

> On Thu, 2020-03-19 at 05:21 +0100, Marek Behun wrote:
> > On Thu, 19 Mar 2020 02:00:57 +0000
> > Chris Packham <Chris.Packham@alliedtelesis.co.nz> wrote:
> >  =20
> > > Hi Marek,
> > >=20
> > > On Thu, 2020-03-19 at 02:29 +0100, Marek Beh=C3=BAn wrote: =20
> > > > Commit e1f550dc44a4 made the use of platform_get_irq_optional, whic=
h can
> > > > return -ENXIO when interrupt is missing. Handle this as non-error,
> > > > otherwise the driver won't probe.   =20
> > >=20
> > > This has already been fixed in net/master by reverting e1f550dc44a4 a=
nd
> > > replacing it with fa2632f74e57bbc869c8ad37751a11b6147a3acc. =20
> >=20
> > :( It isn't in net-next. I've spent like an hour debugging it :-D =20
>=20
> I can only offer my humble apologies and promise to do better next
> time. I did test the first minimally correct change, but clearly
> stuffed up on v2.

That's ok, but this should be also in net-next as well. Has Dave
forgotten to apply it there, or is there some other plan?
Marek
