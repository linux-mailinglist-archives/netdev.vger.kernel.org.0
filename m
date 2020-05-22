Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFF41DE29F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgEVJKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:10:02 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:63262 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgEVJKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138601; x=1621674601;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=5ZB22TlOkWPK1n2tbjN/zfXX87lJ9u2hzTa99HOiaE8=;
  b=jxk2usxWjz1flxQnkv+kHSXz1erVBZZBoi/j4KGtw6yidmCdhAZ3QgZw
   ZNC6WWcyoPzKMTITgEkMI3Fb8GLO79xkI8oJMp02zRgFPAj60oum0gsz7
   PCtu21jD4fegLma/9EYq8MkWOVj5FBlFB92tiTj3GDADhb1chwvnXY2DM
   8=;
IronPort-SDR: lIc4fBIZ3kPp9VdgbNLyiOLX1IotEqeGvMRx2BHi2TiEeBrGxXPmSX6THAy6AQ+zEL3lJ/IEyj
 VAKu4SZac+ng==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="36968165"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 May 2020 09:09:59 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 4358AA1D43;
        Fri, 22 May 2020 09:09:58 +0000 (UTC)
Received: from EX13D10EUB003.ant.amazon.com (10.43.166.160) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:09:57 +0000
Received: from EX13D22EUB004.ant.amazon.com (10.43.166.219) by
 EX13D10EUB003.ant.amazon.com (10.43.166.160) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:09:56 +0000
Received: from EX13D22EUB004.ant.amazon.com ([10.43.166.219]) by
 EX13D22EUB004.ant.amazon.com ([10.43.166.219]) with mapi id 15.00.1497.006;
 Fri, 22 May 2020 09:09:56 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
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
Subject: RE: [PATCH V1 net-next 05/15] net: ena: add prints to failed commands
Thread-Topic: [PATCH V1 net-next 05/15] net: ena: add prints to failed
 commands
Thread-Index: AdYwGHPJU9ML4ym9TC+5j0QCjy/xWA==
Date:   Fri, 22 May 2020 09:09:48 +0000
Deferred-Delivery: Fri, 22 May 2020 09:09:37 +0000
Message-ID: <830b7c963d764b37af1c7f7229d21923@EX13D22EUB004.ant.amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, May 22, 2020 1:00 AM
> To: Kiyanovski, Arthur <akiyano@amazon.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Woodhouse, David
> <dwmw@amazon.co.uk>; Machulsky, Zorik <zorik@amazon.com>;
> Matushevsky, Alexander <matua@amazon.com>; Bshara, Saeed
> <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>; Liguori, Anthony
> <aliguori@amazon.com>; Bshara, Nafea <nafea@amazon.com>; Tzalik, Guy
> <gtzalik@amazon.com>; Belgazal, Netanel <netanel@amazon.com>; Saidi, Ali
> <alisaidi@amazon.com>; Herrenschmidt, Benjamin <benh@amazon.com>;
> Dagan, Noam <ndagan@amazon.com>; Agroskin, Shay
> <shayagr@amazon.com>; Jubran, Samih <sameehj@amazon.com>
> Subject: RE: [PATCH V1 net-next 05/15] net: ena: add prints to
> failed commands
> =20
>=20
>=20
> On Thu, 21 May 2020 22:08:24 +0300 akiyano@amazon.com wrote:
> > diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> > b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> > index a014f514c069..f0b90e1551a3 100644
> > --- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> > +++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> > @@ -175,8 +175,10 @@ static int ena_com_close_bounce_buffer(struct
> ena_com_io_sq *io_sq)
> >       if (pkt_ctrl->idx) {
> >               rc =3D ena_com_write_bounce_buffer_to_dev(io_sq,
> >                                                       pkt_ctrl->curr_bo=
unce_buf);
> > -             if (unlikely(rc))
> > +             if (unlikely(rc)) {
> > +                     pr_err("failed to write bounce buffer to
> > + device\n");
>=20
> Could you use dev_err() or even better netdev_err() to give users an idea=
 which
> device is misbehaving?
>=20
> >                       return rc;
> > +             }
> >
> >               pkt_ctrl->curr_bounce_buf =3D
> >
> > ena_com_get_next_bounce_buffer(&io_sq->bounce_buf_ctrl);

Yes, you're right, that would be better.
I'll remove this patch from the patchset, rework it, and submit it again in=
 a future patchset.
Thanks!


