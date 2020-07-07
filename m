Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208D921650B
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 06:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgGGEFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 00:05:14 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:65198
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726491AbgGGEFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 00:05:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlcrbRTFZs9dA0WWjsg/1HAY/fAIP94arzrdQlHSU7+DxSEnpsW+/ysJm9LJQldQcDDCkp4p2fcoy7Ht7N+gflHbQnqJHKs2TGC6uMQ7wl5cYo70wlAWfJWWoAVrL+05LNekpi1g/jv3LWZjK7pXypM88qq3MgvpP6RliddW5zeyjJUJghSiluzNp791bIl91rgTsEdqg5MXRUt9pWJYYWOZoByF9GgbxaQmi4CdduWNt1Gwi6EdF1peqmKV0QRLI7K/rRcxArsVAfOkXySne2J2jYNTPp23GbdPLQVByWV6R20GysuXG/eevfdi7DTU6dR11iSABRD7C6gLR/uEIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPZ7KSYL3EVQGocQfAp0YdyQ7McHmsYOgnx1O4A/sb4=;
 b=lfQn2ek3dBYUV1DYbC6+/wIVD1PkIqrYxTT8Et4ZTHw21BDkEI5xGK+Dzl/jwXlbG2I3FWyjFZQUtJmGZ34hLcEWVT3V+ke17xmj4LS5rwEthhW+ufSkoEulEzJYyJjaPof7a0ZfYJeOkBOMC6S/kq469Gw83hBpu9YhuAXDfkvjALELGZquX/oTxEdAz/bF66XwleuL4SrdKiIw6AgO0qWoZan8T6HRN7Sb0EpaNvIK5z+i4ynqXu6XsgmCC5bQI2gbhYS8D/GA4kk/6ODTA9nE2H6y3wlHF8YcONsUoq4kV4oTeQM82qZIncK77eZd7YNkNWrII70IXiOqEpYNCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPZ7KSYL3EVQGocQfAp0YdyQ7McHmsYOgnx1O4A/sb4=;
 b=Eh+OT9gBTm1y/xVy2PwYC0juLRsUI3Wp3bw2T08guPYYAlY3nfinWDDtaxYvsymh8oUPbDiMtZRJbhkgq6XN9w5hUnN6qWzNBIIqlb4aTJKgKie/d/JVRMlf+0AIvbydjyH0P02X1kTHn4qgV/RhxxvbF1qSHYVUyM6ylInu5wU=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM7PR04MB6902.eurprd04.prod.outlook.com
 (2603:10a6:20b:107::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Tue, 7 Jul
 2020 04:05:11 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 04:05:11 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sergey Organov <sorganov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [EXT] [PATCH  2/5] net: fec: enable to use PPS feature without
 time stamping
Thread-Topic: [EXT] [PATCH  2/5] net: fec: enable to use PPS feature without
 time stamping
Thread-Index: AQHWU6F3aAODXW9jZUmdteAGjEWX/qj7f+Dw
Date:   Tue, 7 Jul 2020 04:05:11 +0000
Message-ID: <AM6PR0402MB360752A10C9529B13051C7F2FF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-3-sorganov@gmail.com>
In-Reply-To: <20200706142616.25192-3-sorganov@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a09834f2-f82a-4160-344c-08d8222af1b2
x-ms-traffictypediagnostic: AM7PR04MB6902:
x-microsoft-antispam-prvs: <AM7PR04MB6902AC57D182F424605B50E7FF660@AM7PR04MB6902.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: imnLg/kqJUflSojyuY1xkoZUCwJrUP3ZzVdauk9eSA5GQr5Ykf38ymDB8vkqDz7tBCXH3nzzlUJYGeBEYerxpmH8mXfWiVv453K0pR2jnKSrb7tyjvOyganupe1CQ52RaanTz7RmeE8ywasC0XkV0O+7WIMi+bKTNpizPgbYVNGf6a/hROt0ItamIq+T66rJ1h4knamIgAM9QivzK7P4ydxXK27aPlOvgaqBz3Pyo/U3m+MKVrNijWyrlbgy++U0KGr98MYl/jP4A3/zONM5GLvAh2kpf0xyGlsxxW0xI9rn0/eN0atxSimZvYFKfrGr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(316002)(26005)(186003)(6506007)(110136005)(71200400001)(54906003)(7696005)(478600001)(8936002)(8676002)(4326008)(33656002)(55016002)(2906002)(9686003)(76116006)(83380400001)(52536014)(86362001)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: N037i5KJKcEkbn+hiBvePgpoLlMHozJzwKIy56df/6zfGrYrLiFI3WIeWxLFW329/brCBM1ClntqyBohAhRxb6fBTcncaii4wsAfWDUH+aM+LY7VtKRLdLJ480+5s9gB314MnemluJM+VHwX+Bofm++PXuZxvjSj2wRt08j0cRYt+VHWCYkkgTFPUKx3VhwO/dmkH5C4olXdYdvnlhZE4fJn0M4oYmdXqY7FI9vuUFX815XSrN9vfb18r85mWCcnupaaA9KIo5b0U6kpDQ3vcFZnuw72AT6ojKnrbtKdHGFBawtxl0bsIE5WOPG9r1DbIm1iBwTzmJc6QXkJG5ll6zmIUyJ31WPXH10ZnPlX2UDrTcPm+xLETPvXWlmdrwbdyD41iHG/bnSvBpmzsto9pvEtHWNR59P5C40TFaX5I4oZzS66WEgiRj6mnwXGeVO+5pcCJB7/cB9sQDB+6RxeeYlMxWPDpTeMFHcOpVh2V9w=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a09834f2-f82a-4160-344c-08d8222af1b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 04:05:11.1464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9bYNHz4MaC8PM8bdFVGsAV0zNbQ41w7fWwaRfpZfz8ve2pMVtCuh/1miOkWlT/Z30A7blJys60poPUYHwffoJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6902
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Organov <sorganov@gmail.com> Sent: Monday, July 6, 2020 10:26 =
PM
> PPS feature could be useful even when hardware time stamping of network
> packets is not in use, so remove offending check for this condition from
> fec_ptp_enable_pps().

If hardware time stamping of network packets is not in use, PPS is based on=
 local
clock, what is the use case ?

>=20
> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> ---
>  drivers/net/ethernet/freescale/fec_ptp.c | 5 -----
>  1 file changed, 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
> b/drivers/net/ethernet/freescale/fec_ptp.c
> index f8a592c..4a12086 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -103,11 +103,6 @@ static int fec_ptp_enable_pps(struct
> fec_enet_private *fep, uint enable)
>         u64 ns;
>         val =3D 0;
>=20
> -       if (!(fep->hwts_tx_en || fep->hwts_rx_en)) {
> -               dev_err(&fep->pdev->dev, "No ptp stack is running\n");
> -               return -EINVAL;
> -       }
> -
>         if (fep->pps_enable =3D=3D enable)
>                 return 0;
>=20
> --
> 2.10.0.1.g57b01a3

