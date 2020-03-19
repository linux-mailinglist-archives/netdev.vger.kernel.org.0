Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A9918AB34
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 04:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgCSDgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 23:36:31 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:2321 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSDga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 23:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584588991; x=1616124991;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=GAsCjObHr/8ZfqVLUIhArlaI/oXvJvWpmdlCiLb6Fsw=;
  b=CR16xe7cODieYNLasRul/izFrZQA/sQWrE7RkSH3AThjVHSULfhHKnvR
   l9+p7XhQM6Y6/u6A77rmw9Ctie1Km+TbqCZIQ/b0IN5xj2jV5By7PlIDC
   jTGmPO70T2UGdoMGMEZVaiDFhZPI6Hfob1dDHidHcWyK6HcX7MIW81Eef
   E=;
IronPort-SDR: ruMMCJZ7fApUQIVF9DZVeM3dvRT/AWslGTOzt0cfEeIfviEUYbCa7vdtNwrGQfSu56xWm9MDTl
 pRn3VzwX/y5g==
X-IronPort-AV: E=Sophos;i="5.70,570,1574121600"; 
   d="scan'208";a="32039858"
Subject: RE: linux-next: manual merge of the net-next tree with the net tree
Thread-Topic: linux-next: manual merge of the net-next tree with the net tree
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Mar 2020 03:36:28 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 76563A247B;
        Thu, 19 Mar 2020 03:36:27 +0000 (UTC)
Received: from EX13D17EUB003.ant.amazon.com (10.43.166.139) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Thu, 19 Mar 2020 03:36:26 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D17EUB003.ant.amazon.com (10.43.166.139) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Mar 2020 03:36:25 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1497.006;
 Thu, 19 Mar 2020 03:36:25 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Dagan, Noam" <ndagan@amazon.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>
Thread-Index: AQHV/YLplQ6FCTxckkWvIAUktW3nY6hPQn/Q
Date:   Thu, 19 Mar 2020 03:36:07 +0000
Deferred-Delivery: Thu, 19 Mar 2020 03:35:53 +0000
Message-ID: <cd2de6ba830f4f5ea897f4b7969248ea@EX13D22EUA004.ant.amazon.com>
References: <20200319111053.597bd4d1@canb.auug.org.au>
In-Reply-To: <20200319111053.597bd4d1@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Sent: Thursday, March 19, 2020 2:11 AM
> To: David Miller <davem@davemloft.net>; Networking
> <netdev@vger.kernel.org>
> Cc: Linux Next Mailing List <linux-next@vger.kernel.org>; Linux Kernel Ma=
iling
> List <linux-kernel@vger.kernel.org>; Kiyanovski, Arthur
> <akiyano@amazon.com>; Dagan, Noam <ndagan@amazon.com>; Leon
> Romanovsky <leonro@mellanox.com>
> Subject: [EXTERNAL] linux-next: manual merge of the net-next tree with th=
e net
> tree
>=20
> Hi all,
>=20
> Today's linux-next merge of the net-next tree got a conflict in:
>=20
>   drivers/net/ethernet/amazon/ena/ena_netdev.c
>=20
> between commit:
>=20
>   dfdde1345bc1 ("net: ena: fix continuous keep-alive resets")
>=20
> from the net tree and commit:
>=20
>   1a63443afd70 ("net/amazon: Ensure that driver version is aligned to the=
 linux
> kernel")
>=20
> from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This is now=
 fixed as
> far as linux-next is concerned, but any non trivial conflicts should be m=
entioned
> to your upstream maintainer when your tree is submitted for merging.  You=
 may
> also want to consider cooperating with the maintainer of the conflicting =
tree to
> minimise any particularly complex conflicts.
>=20
> --
> Cheers,
> Stephen Rothwell
>=20
> diff --cc drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 4647d7656761,555c7273d712..000000000000
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@@ -3486,10 -3473,7 +3483,8 @@@ static int ena_restore_device(struct en
>   		netif_carrier_on(adapter->netdev);
>=20
>   	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
>  +	adapter->last_keep_alive_jiffies =3D jiffies;
> - 	dev_err(&pdev->dev,
> - 		"Device reset completed successfully, Driver info: %s\n",
> - 		version);
> + 	dev_err(&pdev->dev, "Device reset completed successfully\n");
>=20
>   	return rc;
>   err_disable_msix:

Acked-by: Arthur Kiyanovski <akiyano@amazon.com>

Thanks!

