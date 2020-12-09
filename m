Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10A42D3EA8
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgLIJZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:25:20 -0500
Received: from mail-db8eur05on2059.outbound.protection.outlook.com ([40.107.20.59]:53088
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728703AbgLIJZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 04:25:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4jODpcXsO9vTeNXQx+JAxe+AIFuzSJKXzVf+COqoJuo+Ya2/ICH8uph5TsfHAaOVj5b+LGjb+2VidBwL99BtnmZtfwEiidmrKnQ8Qpp7bo27SI099qRSLfCsT0sW+ZHEBAvTjANQKaVHlNIJSVhatEToVsgIZY7HnCMf3Zt2zRyGnOTM3Emv5NDQEv+DG8Ys+MMuTREWRk9Mr/KaBtzp/D8DqEc+6xvObcbqqgN1U2nW3+LLuW3e2t9Aijix660UcAX40Kj4Sxw9cfgVLzN1PIL7SvTN+xWvY2c9OJn3LejudhC82iEt27s33ID+RJBR9rjIvHQhaRdpdq87zys3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uY86FoLjNFB4KhFxZ5/r87aQjHp39CCFZcl21iWVwYc=;
 b=NPKlLEvDeN2jlqXmD/bBwOBLIX0uKGTSRZetXBCg9NPtrVTurmninMCQq2wzUewzqOkjLQQwwBai5JEcvxexGb3UmrfISeenXJtGoWy1zSigmqNukrUDrR6zCVqf5KqnyV6e1dRTli1LL2rGZjMV2dnEp2l6lshWL53LghX19e0MHQ2KFePXCsagUW2cOERkkPu/lwUusWUBBLk7ylV7TUoC3g60TxyyyaKC4anZy9hcIdDHFfd7iO0Az2URcqhbusRYGBVjWFu1jZBVa/odLTxY3irpu3PQ5NSOt9GrKZKeYrHLVhlUDJU5Cbajjw/RDAW+BdRUyAqLDVAil4s2TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uY86FoLjNFB4KhFxZ5/r87aQjHp39CCFZcl21iWVwYc=;
 b=S8Wh08pSN+4eflFlQHmw4oSi9HDX89AkDH2TJs+1W6hZRp4HJ15lNLyqKx+wwUG3D2YM88Tw1hOTIm8nZ1/NzZd3xYKXVDa7GjLbS5pYUA/KlPCbFfDl/9DhIa3it7dE7K2EE3gFtdlXcO2veNr7kiRDljrMtVREhU+9y0iGvSg=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR0402MB3336.eurprd04.prod.outlook.com (2603:10a6:209:12::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 9 Dec
 2020 09:24:30 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f022:b0a2:ee2b:2ddc]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f022:b0a2:ee2b:2ddc%6]) with mapi id 15.20.3632.022; Wed, 9 Dec 2020
 09:24:30 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: freescale: dpaa: simplify the return
 dpaa_eth_refill_bpools()
Thread-Topic: [PATCH net-next] net: freescale: dpaa: simplify the return
 dpaa_eth_refill_bpools()
Thread-Index: AQHWzgyXbbn/4YHEm0u0eQQDT5oI+6nufeNw
Date:   Wed, 9 Dec 2020 09:24:30 +0000
Message-ID: <AM6PR04MB3976CAEC2D3C70E86CDA80C4ECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201209092107.20306-1-zhengyongjun3@huawei.com>
In-Reply-To: <20201209092107.20306-1-zhengyongjun3@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [109.166.137.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3dd69ace-0ded-4e72-c026-08d89c243b8b
x-ms-traffictypediagnostic: AM6PR0402MB3336:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-microsoft-antispam-prvs: <AM6PR0402MB3336AD2D6B3F1DED5E272C06ADCC0@AM6PR0402MB3336.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xNDZXAEu8VwPTzykKzmeUaCI1SfLxvQKQZX1kEiLQSpEjkBmATJobyzWce9SDRd6PpNnZsa/ahs+JGgYhjOKr0mmHvkw1OjG/je1VfyId4CK/Wg+H5YRI/rVLckoTpZiNahAlJL56nGoddI7uTB0gqSKcGmNYphW2UzmL7HR1egjm7JuTUBKFWIr6TZdC49tsHaWILoNfMB3+l2Os3Y9+XGca9cxNyWRIgjqwm+L/hgrwsELLBRiZm8YuMPt2cFu4i5+GQ7SqkmoOywtAeI1DG1qJLT6VItsM74gnzbDcebR8mBcJ5fglkangHhWZ2ADva+uWMZ0p7i12dMz773dOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(6506007)(26005)(66556008)(71200400001)(66476007)(86362001)(52536014)(54906003)(53546011)(33656002)(508600001)(8676002)(64756008)(8936002)(66946007)(55016002)(2906002)(83380400001)(4326008)(110136005)(9686003)(186003)(76116006)(5660300002)(66446008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fctUWMBzGKL14Fjy4hvpj1RIcR+DOkyUR5Eu1uSdggjBjy8lF7YRLrn9/LVb?=
 =?us-ascii?Q?LNTkPa3PQt5wbBksxMqzOB46HHrvTAqzhbz4F3jwMnWn29nzOC8QMobmPQT6?=
 =?us-ascii?Q?/nKz8FKYpjd+VgqGY/NGRqBATWWfHTPSyIaq00DXEdVCQ6DyaIZ3khJnUgl/?=
 =?us-ascii?Q?iYlU9WckpfaLhhatl11d6/rGr3RcUC4RnB0kpg8aPF1LTaOymUeijk3f1gkn?=
 =?us-ascii?Q?2tqxky9X1nvg55nd7+f22JADw5ixWQTUCwBwQlkess0QhFm0ffC8JrkPTBTm?=
 =?us-ascii?Q?RyRLOHtf620uE6WP10O+uJuCsRturLPz3PE9SIzmHO0dZI7Qo8DusWYetcUQ?=
 =?us-ascii?Q?zDrw/7YDrS4z0rUh1ME9LH1BFAkwVs/vYEMWht2sOlpelM+Eifl7DnfxP00S?=
 =?us-ascii?Q?0Jh+DFyfPg7xAiIvhC3pyLTz+5J3vQ1rcHEUa1B2EqwpcLD2O++2XUvByqYR?=
 =?us-ascii?Q?YI8+5xt5iGKwKxklyPXbG1D5eC/1/ptYIQC6P83gvPSkzzfpprdERZ3+oNyF?=
 =?us-ascii?Q?/s96qVrOSE7ABDoig1MMxc5nEgSOGydeCVSob4Ooerdos6vEZtA+8eyCw5LS?=
 =?us-ascii?Q?er6VR4QydcEu5557+BpYbC1u5HEcyRJ+mIJKxEgwvg+dHF515wBilt9kRoff?=
 =?us-ascii?Q?n/9AJk3Kb55ReLIuHrnVymzbIBTBYErFNt4lLZmIXUQFr5rBuonPq7OvjVaM?=
 =?us-ascii?Q?uqf1qRlY4F3Z8lHjg96pzIsrqIM7q62tl+4jpTJ1XkmHdn3Ll98bCUG6wQue?=
 =?us-ascii?Q?3H1R3UKGbawCY0JDF4kenJqJZ+VWYX4gzeKyD/lpqnjPASCrSv20UFkrOucl?=
 =?us-ascii?Q?WUGEo0dVSXhU+N5s+HgOUqntOvUiQrl61rjvIbgQI6c21SKTyO+a33abj3rz?=
 =?us-ascii?Q?nBWYqejcrHK5EMtco/Hvc59bqrRNWWNUpccE88JhtJDp/YJHRZTpDwaCWtuL?=
 =?us-ascii?Q?wej2Ufxp+PV1jri1bcHBYXI8btDDzllg3/G/gUziikI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd69ace-0ded-4e72-c026-08d89c243b8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 09:24:30.3585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /IRg0a6wYS/uSdM9WZm6rbJF1f44MqR4m0umztexrxInrcyFkobNXoV8yvJCA07vLTOdeHZuNxqAMl8Fd8oaig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3336
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Zheng Yongjun <zhengyongjun3@huawei.com>
> Sent: 09 December 2020 11:21
> To: davem@davemloft.net; netdev@vger.kernel.org
> Cc: kuba@kernel.org; linux-kernel@vger.kernel.org; Madalin Bucur
> <madalin.bucur@nxp.com>; Zheng Yongjun <zhengyongjun3@huawei.com>
> Subject: [PATCH net-next] net: freescale: dpaa: simplify the return
> dpaa_eth_refill_bpools()
>=20
> Simplify the return expression.
>=20
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index cb7c028b1bf5..edc8222d96dc 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -1599,17 +1599,13 @@ static int dpaa_eth_refill_bpools(struct dpaa_pri=
v
> *priv)
>  {
>  	struct dpaa_bp *dpaa_bp;
>  	int *countptr;
> -	int res;
>=20
>  	dpaa_bp =3D priv->dpaa_bp;
>  	if (!dpaa_bp)
>  		return -EINVAL;
>  	countptr =3D this_cpu_ptr(dpaa_bp->percpu_count);
> -	res  =3D dpaa_eth_refill_bpool(dpaa_bp, countptr);
> -	if (res)
> -		return res;
>=20
> -	return 0;
> +	return dpaa_eth_refill_bpool(dpaa_bp, countptr);
>  }
>=20
>  /* Cleanup function for outgoing frame descriptors that were built on Tx
> path,
> --
> 2.22.0

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
