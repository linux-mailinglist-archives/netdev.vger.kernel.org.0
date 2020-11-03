Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E5F2A44D7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 13:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgKCMNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 07:13:35 -0500
Received: from mail-eopbgr30082.outbound.protection.outlook.com ([40.107.3.82]:54246
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728354AbgKCMNe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 07:13:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMzdHVpZpY1eZcn9xws+s1z/ioP7aHKBjKPlGqLgn6gFGvpIS0NKHgopuATvY/6SQInZBmqaGZJyqb7BnIRshDxRV3gTC5OC78n9JfsM1N7DaXPchjm7KgzwIaHuYHNNWuyRN/h0YJ2R13kNRnrfdaOg33RQ+4xEkUMesaN9phaqft5rOA7UsJY1zVPadaR00O6jA3NSoIGAw+4qHXHsLO/zzDaKuoYnC8gY5vD+zgVlYaJfIf884D7RBzKfdxY6SLhIYfs6oa2RIYQKwIQraH9G3IQptXr06XubCBPGyk2A0YmTaOMsL5BT5FEksdMeFsqFAV8TNU34wf18peIG5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJEu7h/smCyvfoZp+QFE2W8v6qNHkCBO5x4Hg8dfaMQ=;
 b=Hfr0hXeOBE22I5KF8a8/pA+osO65WSeGdJMdTWI7HKaIteF2zGkbSEjVzL0BJtSb6ej+ywDuDVyYtFNbDS3R60/Y1TLA6Jq4gkywkruo28jb8cFbVdwqtBlWhwhH6X/l2Fs27LpbPo9HtVGY4A4gaBIGiQJDr5yvg66L5GFYDQWeOVScm8BeZCaaBRHNTigSj18MtLArR/JLFVbB9KQF4LFT+mjrK78KxAwKkERvYH9/YZQYMb/weaTbvoUp+GYqNIHSGiBx0+SvarnI7FcC4jIosYLzWbMPGGIXdn8nMnwmSEkGpmZidOchmoLhG6vCXEMyWys5ROZpUybpWDs0Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJEu7h/smCyvfoZp+QFE2W8v6qNHkCBO5x4Hg8dfaMQ=;
 b=g9UIxyUg5C2/taS/+w4x26KeU/QzrmzIKt/kMItt3I1vnl/7TmHTF5j3avYNF8TJQeJgCtP5IkZsEs4gwgOEbujlHCeEbjZVQpprjjbXF/JRrkeE1QoUH5uTCPdyKDEaRhfa6ztT43wZs83K9eMXP5wlGYwN96r+sQWMCjv2jE8=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM5PR0401MB2452.eurprd04.prod.outlook.com (2603:10a6:203:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Tue, 3 Nov
 2020 12:13:29 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71%4]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 12:13:29 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Zou Wei <zou_wei@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] dpaa_eth: use false and true for bool variables
Thread-Topic: [PATCH -next] dpaa_eth: use false and true for bool variables
Thread-Index: AQHWsdfxVunRuryS/kCLXNLVwfyWWqm2UX9Q
Date:   Tue, 3 Nov 2020 12:13:29 +0000
Message-ID: <AM6PR04MB397628B89D6A10C973FF3162EC110@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1604405100-33255-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1604405100-33255-1-git-send-email-zou_wei@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.227.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b8c4778b-533a-4e1d-155a-08d87ff1dfd8
x-ms-traffictypediagnostic: AM5PR0401MB2452:
x-microsoft-antispam-prvs: <AM5PR0401MB24525D3044535AB42ADA2FE8EC110@AM5PR0401MB2452.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A0DDvIFeaY3m9FV6BUMJiNkTEbqu3IciOhcXx4jqIB0TSpvJODhDTJLpbjsDjUk9qqEfOtknaiW6MJwiqT21FUh9aLStHsEsGCXiseuMAK7QeNXv5pmAuDb6MSfyFFIWR9k1jIUZHCDnopKsSg96t8r/7v9wqHZAguDp64qrJZxExnVsllQF6cnx3kMjQYUMO8GstOQ49+mK9J8kOWKuSnJ3yyHiU89CeDNZ30phWj+W5/L65LjDauagVx/zCg7Ef0dd2NsJA7BsxJHLeBW+4MT9iyGExhjQOg5S6WMGStRh4F4AJ29O3gr/bjb0uTIs5XsrHxBCIzl1V9BGLXiETg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(9686003)(478600001)(52536014)(8676002)(66476007)(66946007)(44832011)(86362001)(66556008)(83380400001)(64756008)(66446008)(7696005)(186003)(5660300002)(26005)(2906002)(4326008)(76116006)(55016002)(8936002)(53546011)(110136005)(6506007)(71200400001)(54906003)(33656002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WOm0p+epl7PocoTgSf40MUOpOf6MnWw4STBEGGHwcYbaZLFv36dJkPPSmAiJzOfkPkEyrMbujON8r2VUT76rIG365SNQWDSS8XItwO/wTzOfNqfZvAmsR0G3H4VacD3yX+TVeeewAnDSCKE0+KXBnLqC5QGMwvhqhUxpIOU8tDAs2bLXB32AUV0pLBCWpPgEhYyMvkhrIz+udOINZ8IXPn1H7YBb2FMYC2Nq1pviXfJ+QHR4spJKJcJDHMjqHttdehWN11xMDneynk3SQEcamEt1B54HSDXCJKl8/vyLRHcLaMWYVq8CMTMc0vFflCA5RhBzGvsPKnetRGuoqpkGBTMPqmo2Qk/oPb47Ok4qap/Zem473fcl5h331CvT/NO3rIskFU4Syd/QABrFYhZXOb09RPKyRYUhoZr70Qo+yMinX+cdCwTdPFavtqlOJy9d3h67bXhsOeWIz+8YEFrxZbYgtG27AORMGS8nL1/rIxdsGfsfKsZzbaV+ytOPzn0ylrjuTXXdOPsRZhb4BwiLyJN6mJt8pmkidoKeZvUgKfA1I7bTlXkNJMupHeNI82s6JtNcs+XVQoOA+roLSogCfzIrDH3gdysHTFBVAlFkDJClLMKNesGH8c6cILDayN28AIYeHthiaCSJQBPZFYYA5g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c4778b-533a-4e1d-155a-08d87ff1dfd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 12:13:29.1411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kn3kIufSDQqCJUaEgc0NuuMPO/pXTSR2sm4vRplzqnpRPdlJ3wJpTxvyBKGXOo780NeA0lu9hEOB1OwTQRzqvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2452
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Zou Wei <zou_wei@huawei.com>
> Sent: 03 November 2020 14:05
> To: Madalin Bucur <madalin.bucur@nxp.com>; davem@davemloft.net;
> kuba@kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Zou Wei
> <zou_wei@huawei.com>
> Subject: [PATCH -next] dpaa_eth: use false and true for bool variables
>=20
> Fix coccicheck warnings:
>=20
> ./dpaa_eth.c:2549:2-22: WARNING: Assignment of 0/1 to bool variable
> ./dpaa_eth.c:2562:2-22: WARNING: Assignment of 0/1 to bool variable
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index d9c2859..31407c1 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2546,7 +2546,7 @@ static void dpaa_eth_napi_enable(struct dpaa_priv
> *priv)
>  	for_each_online_cpu(i) {
>  		percpu_priv =3D per_cpu_ptr(priv->percpu_priv, i);
>=20
> -		percpu_priv->np.down =3D 0;
> +		percpu_priv->np.down =3D false;
>  		napi_enable(&percpu_priv->np.napi);
>  	}
>  }
> @@ -2559,7 +2559,7 @@ static void dpaa_eth_napi_disable(struct dpaa_priv
> *priv)
>  	for_each_online_cpu(i) {
>  		percpu_priv =3D per_cpu_ptr(priv->percpu_priv, i);
>=20
> -		percpu_priv->np.down =3D 1;
> +		percpu_priv->np.down =3D true;
>  		napi_disable(&percpu_priv->np.napi);
>  	}
>  }
> --
> 2.6.2

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
