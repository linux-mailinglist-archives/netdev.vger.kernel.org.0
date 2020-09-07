Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4998260338
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgIGRqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:46:12 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:23681
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729392AbgIGNPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 09:15:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQqgnEnpmkSSOLoU94iPnRtWuKRB/xUnrRrrTiZK2v9ywY5qI/074A2G/dYnz4hVRnXR0iFikGTGcO8qGu8n3lraBURclOjKv+c1uUyT8yOAd9riVv/abucNbsTNQjlCq4s02l9ZpGYFwlhoZ8VILEk2EvrNkvsbYhrfLclNtoq9SLuzOGUFs9UUz7R9f0kKOAz+4eUxleZ787psaLxUbxZ1RGMWO3+szF8lfT2ltbrjiXHrXstGez2nw6oC+A20AZamX6y+GZ3d5yEr6/mIjmM/tSJqaDSmBIxGVlgn0M1658rO/JJ0NJG60foIZszd51jSKdRmuP2r35kAFStdPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoePcN69ivmb0SggDRYbg2M7F+yG+BSHLfiE7Hl7W6w=;
 b=W4R2RQ88KV1isL17FlmWx8jP5gcAHvHewtHEMa2IuQlp77ywWPcI3P9YEdxsqP0oIFuzGrrZruoTbPIhf108XgLh+PbE8WEkrGEgX6tTLk5qqyVgjl8PeTE2M4nnDtGrCbNhKMmB+Oydh6vkoy3qtcwkDjxiEgDQyjXg6Om/qMhZKVHiE/UPO/lh72z2gtYC3Rouv4r8V0lNJj5wCjcgr6hgx62+zZ5KhJuXVOqjD9o3RBcHw1igX8mAKXDCPIPKUOwRTREGABSp0gC2gG+e1QEdEDigttC00gJeyJ/8IUsuNnudCHy5jYIz5X4qOua1VUAVwT8ZkC4Sk9GLja3Yzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoePcN69ivmb0SggDRYbg2M7F+yG+BSHLfiE7Hl7W6w=;
 b=pv6055qYV2mYnbgMWrQbKh2HR8WPCFhqlxkm2X/PBfjFVH2rZ5CrgIUZjvmcNA9YPi+YwaiiEEe1cuwMZtUjo71ThhB0keC9wNKKRNTiJIMs66VzudwYI1lpNYGsMsnDLBc1pBUO2TCDH5aYOCQDQyqhCDIcJ82kGFOFIifB2XU=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR04MB6403.eurprd04.prod.outlook.com (2603:10a6:208:16a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 7 Sep
 2020 13:14:50 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::c10b:eaf9:da9a:966e]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::c10b:eaf9:da9a:966e%7]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 13:14:50 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: ethernet: fec: remove redundant null check
 before clk_disable_unprepare()
Thread-Topic: [PATCH net-next] net: ethernet: fec: remove redundant null check
 before clk_disable_unprepare()
Thread-Index: AQHWhRWCkFkK9RfGS0CnsK1Xua9dPKldJlLA
Date:   Mon, 7 Sep 2020 13:14:50 +0000
Message-ID: <AM8PR04MB731542047A051973B74BBAD4FF280@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <1599482984-42783-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1599482984-42783-1-git-send-email-zhangchangzhong@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f5383ef1-b98d-42f7-b3ee-08d853300071
x-ms-traffictypediagnostic: AM0PR04MB6403:
x-microsoft-antispam-prvs: <AM0PR04MB640370E77CC7439F053EAD10FF280@AM0PR04MB6403.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:483;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZyUVeYENs573Ts9zj+nXRMmEAMlXywpTaMsjXphBP8zDDS1e5TlOEVsojK7ppVOShe0EQTBUB5fhf9CH059OAvTfPO99NFIU3W1IwSNFIwKbnmXGsN2GfdWdAe0UkT9QpBAD7Ju0GUQvsoZNdNSfq8qZ+xM8BwH8mQj9OfAfz7Z/42mpW9Vy/3IhRcz9yRLvAxm388jXnJuMCcONUti9vV3uRBpbDa3B6iKQe2bFg0qvliT4q6/tNPleoCNp1YZylhvvok5fDZcGmP6SnTuYb+5xbkpHzEbonLgBTFNvh4pPZrirpwhC4OB+Vi7s5RZz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(7696005)(6506007)(478600001)(2906002)(26005)(5660300002)(316002)(186003)(66946007)(4744005)(76116006)(54906003)(110136005)(4326008)(66476007)(64756008)(66446008)(8936002)(66556008)(55016002)(86362001)(71200400001)(8676002)(52536014)(9686003)(83380400001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: UbNdXXJShXprBKfOSzJLXMhpCFVP86aGqyRT3sTjMBKpcZ+iPLgQQz7resJeaqER1aGugtLm8gVSs8jYC7C9oJst1WwJBbyMDdAZJxc3oKCY8RtPsHHo42sG3g+79QtDYE6sG21CCTTg84HVtydrYVZ2JdkBhF8dLLFnHUpsL4KXpzYukY/JTtKRhDPk6Ejj738waORoANywhvAq+5o67uk2v+/Cj0V9QOUJvqPIYEbQEHW5mn4gzEnmku+TSt92J6JhqETit6UeSbZeEAKf7qOifXrz6q28zGKlczfd6ijbgqVo7UY9lDGUy9VtIYDsfPjolnKJJtxklHHD+tOKwShlregqSARfo7YpRmbu/GAV094GIejeiwf1v+ntu6XitGM8Fz7NMiRGH4Umh24vaLXAxgd9Br2BC1lIS2CrbS8fKUvEqH1aeZiG6alcMCuyX+CS1BEs8pFearpKY75tu51pSDWTP56xaUlM6jvOWN4UTjPxmv6gPO3QNyDwJAjxTjo/lCK47ohWt9oyx+28pYmCCSwEeEC2eq0a+XZEpsUUdYCfp0lWB0jCuNMA/MFQn3NW1Iq83dzZuc65ut8VwIgmkKayMbUGGR6eQBXVvGQPOzNBvpl3SHdkg00Vom+6Sn1jmwOpf0R9DtaBfciNaQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5383ef1-b98d-42f7-b3ee-08d853300071
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2020 13:14:50.3016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ssi9yKZqctULFfkE0pHbL7wH75cdM7EzF6TmPDNIGC44LCFSy1ttC/c7NQwtkA9YEF1jPQ+n/kANxaGQDuC0Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6403
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com> Sent: Monday, September=
 7, 2020 8:50 PM
> Because clk_prepare_enable() and clk_disable_unprepare() already checked
> NULL clock parameter, so the additional checks are unnecessary, just remo=
ve
> them.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index fb37816..c043afb 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1960,8 +1960,7 @@ static int fec_enet_clk_enable(struct net_device
> *ndev, bool enable)
>  		mutex_unlock(&fep->ptp_clk_mutex);
>  	}
>  failed_clk_ptp:
> -	if (fep->clk_enet_out)
> -		clk_disable_unprepare(fep->clk_enet_out);
> +	clk_disable_unprepare(fep->clk_enet_out);
>=20
>  	return ret;
>  }
> --
> 2.9.5

