Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3ED216519
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 06:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgGGEIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 00:08:13 -0400
Received: from mail-eopbgr20083.outbound.protection.outlook.com ([40.107.2.83]:37228
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgGGEIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 00:08:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4WMvymFy1x/YtugGfxm/kCCThTi4+W1qa2+zr45H6Y5SAYFsMV1vte52YerKFHtFhVyGcw7MZ9yeZzgF1GXLGTEMgU+2tC3d9xPjO0VN5Kj1wr+6OBN8PqxEedXc5e717m6JZQnaxV3YX4FEYGMGP3rdmKy7bWxKnYtKP9SyG818zGaMBo69HVw3VSAGrOs1s+94bva/Y4XivIyvDFuj4u5qG0jFiVfis23MvFOlC36ZCRDMPnUSTU3k8DH6DQXgx5KwtV3oJgiAoQ7IRDbKCXVCQ3KEk/xOnhuMQLmLO9cQ3K7923CjSlHUgCMLT/uqGFJMM9rUK5Bln5pf71CgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmgcqBcBb6P2UhW8aGxHkTyTiQqbplue+L7CVRAi1io=;
 b=bRlKagOmczw5os1S5I7ilsKvQGwuU9jzHO8lHq2UUJc7s5alqEmegvhavyEZti3gcQNW2jA8882bosG+3blbjB+i863UtUUnH7/OUUyAl/9CvA5ZxGkzizrv9+a+K1no4KPY6wIwa4k3Sn48JW8HoXaW9Pc2YeKjjC+wPati26OKycsbGrpnz0uhZ1LtJ6L996A+ykBCOosA1YK4mHm0AQvQM3CswqTPubh5Ru/7R+oOfUSOFAaSPsZEmReFSqChJJUPLdMrqIKrgc5q3op0Cn7oF9vQhFCFAd+Y8kYo1GSqKlYlLLBsfmNZROGmmTLWl2R96GK7OWvOc+cS2spQUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmgcqBcBb6P2UhW8aGxHkTyTiQqbplue+L7CVRAi1io=;
 b=osXjIQWx2bGaJxGDfdR6skg+RChtRz7Y8/ljTa245l4omVXadyzILML3+TgxrkD+TuODgsSci77bIrFfv5vtq7PFR7H7nuc1FWCaGFDg73it+VTGXfXnSgYE8AgSQCKznGkE00R4qDjDnwB+ByJ69vlinGulvHVPdMyt47lOhBU=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM7PR04MB6902.eurprd04.prod.outlook.com
 (2603:10a6:20b:107::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Tue, 7 Jul
 2020 04:08:09 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 04:08:09 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sergey Organov <sorganov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [EXT] [PATCH  4/5] net: fec: get rid of redundant code in
 fec_ptp_set()
Thread-Topic: [EXT] [PATCH  4/5] net: fec: get rid of redundant code in
 fec_ptp_set()
Thread-Index: AQHWU6F5IyIEbIdp8UqiTSGJIl4IMaj7gQmw
Date:   Tue, 7 Jul 2020 04:08:08 +0000
Message-ID: <AM6PR0402MB3607DE03C3333B9E4C8D3309FF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-5-sorganov@gmail.com>
In-Reply-To: <20200706142616.25192-5-sorganov@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d624a583-d2fd-447a-d4d3-08d8222b5bb0
x-ms-traffictypediagnostic: AM7PR04MB6902:
x-microsoft-antispam-prvs: <AM7PR04MB690287CFF25C2A1C1DE2FFCEFF660@AM7PR04MB6902.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:147;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c/rGk4sWuxExwRHyxgx3tV8TQKxfw5Hoa120PTKF0GUDAhB02eqYWlbIbWLBRt9aGNZwY/fhHzZntwbpKSKmxpQ5b404x7MKFb9r/YiwglIi8Up9DzWzRmDg1dDcYv/WoruwOdVFfiShi/2Qf/C7bI9/DEHHkonQOg4qy2oRFkY1leoPfvR6cWl7Yfv1YpuZM/2VWSA8ar2RhEjoKJ8NzhfLWbW3ALaOIMXnpAfw83U0cGqmfMNlw5J243SIzTmZLtEzcrpXan+rX4Hpeg8a6nr2QonqpXPeFlVkX3Ky+NAD3s5Nt8yxGzDUMmC2V/5zqpSJnn032y0EYNOFZ1uom6mu5QEnHfAkmoIfC1R7h17goN78yLOQ8qZbH22FIZ1H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(316002)(26005)(186003)(6506007)(110136005)(71200400001)(54906003)(7696005)(478600001)(8936002)(8676002)(4744005)(4326008)(33656002)(55016002)(2906002)(9686003)(76116006)(83380400001)(52536014)(86362001)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(26583001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: G/flYSsH5//FdjZQs9ngz7EJbpmnpcUgNmTF+2nHSYwOzsdnOSmROMPvDXassijYpJsBwkOqUAJQr6jEDEu1ZXbqGfG3ugeCGBAqVgDRFvg3Chw8WBsX3e+nLRNbL4bSdCK0zpjdD7ub2JqMoc+f/VS4S7fb508xZTieFFHgZQ4X5LfDCRxBIYUBpkXINGA4lWCIrBVDpxP5wTET4JQ3TfRcarS3O4PQ6h1Vf0U4NDCyxpNR0FqjE+HQOtiJqN7J3qcPMP/wHzqmXquGE/CRL5Bx3QAkg3MirS6en1ckMa1vmxSngLNMmZYOgkNOkN74QU2rjPy8yge4eWLPxuq32iypxZE1eNJHlMSwoPNiUYDN+oIpWKCkyzLBGiNOg6Wwrfvy/ghfwN1xiDzD0T29qP0cJq/Jn/E8O3LrHmnEzAEDmY2aa0F+PHeG2HnFUSJHEeog1r5Da0pQXQSuru+eXogAvW9X3+dMNve/SV00TsVBfmlYKTdEBrK//51vqeSN
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d624a583-d2fd-447a-d4d3-08d8222b5bb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 04:08:08.9868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LnVSWBwdMHmWUjgZ9C8cpe3cXhq769zrOPF/ZEYH0asNvG88mbMRdJszSGFaako9nwx3lri8JHdH09A29vxriw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6902
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Organov <sorganov@gmail.com> Sent: Monday, July 6, 2020 10:26 =
PM
> Code of the form "if(x) x =3D 0" replaced with "x =3D 0".
>=20
> Code of the form "if(x =3D=3D a) x =3D a" removed.
>=20
> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> ---
>  drivers/net/ethernet/freescale/fec_ptp.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
> b/drivers/net/ethernet/freescale/fec_ptp.c
> index e455343..4152cae 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -485,9 +485,7 @@ int fec_ptp_set(struct net_device *ndev, struct ifreq
> *ifr)
>=20
>         switch (config.rx_filter) {
>         case HWTSTAMP_FILTER_NONE:
> -               if (fep->hwts_rx_en)
> -                       fep->hwts_rx_en =3D 0;
> -               config.rx_filter =3D HWTSTAMP_FILTER_NONE;
The line should keep according your commit log.

> +               fep->hwts_rx_en =3D 0;
>                 break;
>=20
>         default:
> --
> 2.10.0.1.g57b01a3

