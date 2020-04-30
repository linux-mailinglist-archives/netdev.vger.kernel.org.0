Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EA81BF12A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 09:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD3HTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 03:19:09 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:29355 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgD3HTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 03:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588231148; x=1619767148;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=49aIoMJfZD48Zv0jPVQLv85WcEcgrU7KH5esWay/qvU=;
  b=k9p0pKH4TREqaVe8zrqwDzlFUwLiLxKchOuetK7CF0J//NCXcamDuCm8
   ZR2BGIg8ehrmuh0zk0zLpyTGyGZjJtxBgmr5xE9Ms1xSNbM0WgbLerhDb
   0HvCbGwk0WzvsX485Q+AkQf9zMhx56uR12aoKT7GkDyhcYZP4qB5UTb/t
   0=;
IronPort-SDR: IlHjtA3eOb1l09Nb+e8NXZtuMd9Wiq/R1iYFI7f9hxls5nYp7ejSi19bXNpDrn8BE53sgkv4uZ
 5KZImaeRH56Q==
X-IronPort-AV: E=Sophos;i="5.73,334,1583193600"; 
   d="scan'208";a="28239627"
Subject: RE: [PATCH] net: ena: fix gcc-4.8 missing-braces warning
Thread-Topic: [PATCH] net: ena: fix gcc-4.8 missing-braces warning
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 30 Apr 2020 07:18:55 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 86C5FA1D38;
        Thu, 30 Apr 2020 07:18:52 +0000 (UTC)
Received: from EX13D08EUC003.ant.amazon.com (10.43.164.232) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 07:18:51 +0000
Received: from EX13D11EUC003.ant.amazon.com (10.43.164.153) by
 EX13D08EUC003.ant.amazon.com (10.43.164.232) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 07:18:50 +0000
Received: from EX13D11EUC003.ant.amazon.com ([10.43.164.153]) by
 EX13D11EUC003.ant.amazon.com ([10.43.164.153]) with mapi id 15.00.1497.006;
 Thu, 30 Apr 2020 07:18:50 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
CC:     "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Thread-Index: AQHWHadH74VL29pWn0eLulmochhjwKiRPQvg
Date:   Thu, 30 Apr 2020 07:18:47 +0000
Deferred-Delivery: Thu, 30 Apr 2020 07:17:49 +0000
Message-ID: <03f3568ec8c646cdb7c767b16d19525a@EX13D11EUC003.ant.amazon.com>
References: <20200428215131.3948527-1-arnd@arndb.de>
In-Reply-To: <20200428215131.3948527-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.46]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Arnd Bergmann <arnd@arndb.de>
> Sent: Wednesday, April 29, 2020 12:51 AM
> To: Belgazal, Netanel <netanel@amazon.com>; Kiyanovski, Arthur
> <akiyano@amazon.com>; David S. Miller <davem@davemloft.net>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jakub Kicinski <kuba@kernel.org>; Jesper Dangaard Brouer
> <hawk@kernel.org>; John Fastabend <john.fastabend@gmail.com>; Jubran,
> Samih <sameehj@amazon.com>
> Cc: Arnd Bergmann <arnd@arndb.de>; Tzalik, Guy <gtzalik@amazon.com>;
> Bshara, Saeed <saeedb@amazon.com>; Machulsky, Zorik
> <zorik@amazon.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; bpf@vger.kernel.org
> Subject: [EXTERNAL] [PATCH] net: ena: fix gcc-4.8 missing-braces warning
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> Older compilers warn about initializers with incorrect curly
> braces:
>=20
> drivers/net/ethernet/amazon/ena/ena_netdev.c: In function
> 'ena_xdp_xmit_buff':
> drivers/net/ethernet/amazon/ena/ena_netdev.c:311:2: error: expected ','
> or ';' before 'struct'
>   struct ena_tx_buffer *tx_info;
>   ^~~~~~
> drivers/net/ethernet/amazon/ena/ena_netdev.c:321:2: error: 'tx_info'
> undeclared (first use in this function)
>   tx_info =3D &xdp_ring->tx_buffer_info[req_id];
>   ^~~~~~~
> drivers/net/ethernet/amazon/ena/ena_netdev.c:321:2: note: each
> undeclared identifier is reported only once for each function it appears =
in
>=20
> Use the GNU empty initializer extension to avoid this.
>=20
> Fixes: 31aa9857f173 ("net: ena: enable negotiating larger Rx ring size")
Please use the correct fixes, it should be XDP TX commit.
Otherwise looks good,
Thanks!
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 2cc765df8da3..ad385652ca24 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -307,7 +307,7 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
>                              struct ena_rx_buffer *rx_info)  {
>         struct ena_adapter *adapter =3D netdev_priv(dev);
> -       struct ena_com_tx_ctx ena_tx_ctx =3D {0};
> +       struct ena_com_tx_ctx ena_tx_ctx =3D { };
>         struct ena_tx_buffer *tx_info;
>         struct ena_ring *xdp_ring;
>         u16 next_to_use, req_id;
> --
> 2.26.0

