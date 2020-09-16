Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF2E26C702
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgIPSPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:15:01 -0400
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:29155
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727700AbgIPSOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:14:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORCtNjfFq5ZjXE2/vr4IyjXfuANE72S7Zue8keGPCy3jF5hrWPZvIvsoX2F6JT3TKrmF7KwzveIA0OgHVoCl00MTGTKdE979BDSaAhqNLzGLpM0bh6CY3DbcrXVIEEejkhXD4l48+achCXFr6E2npAbrQVl3oYKXyFo5ur0kN70uGiXH387rBoFeQJB2Zqf5nfR/g+sNOzKxe80i2gFVmzq4LnEhyzmmH53sAuWRdsSdGsmWzijE3Hjm57buacCkpASZ96KHT7MN7Er9Ly0Pyn3nOdBW7HUnVIZgocCLmZsE9nnd8tvYKTCHb6zr/C6Be61tzSABrmWt54W8aOd/sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyat+zX3dmDoMrJfaU1OB9sMd/SA5e2F5u5cP5YRjxA=;
 b=Akd4zm/uvTPtQXj8ov4ygXtD5prD27tS+3ABSVjoTFA4eXIH3n6NWZzgCe4CYt4XrIyziMyqDf7aSIUOMFFB9USjXiH3cMgK2lp5EN/zWdGmo6MzyC1JUq5fNHs6Oc7U4DIkGdlW3MsE8xbBE+xwXpEuz1AePgM37HBYrkL5XOJBR8hkcPIEdLmWeWyePAS6vGRkHqpJp72Tc5/CXuzanBmu2+SF9PybRz0FZeGyqNoxDmEz3eABGc+mcIgw4RFtwSOBGVLN/yN5cmt/CWa4VlwDRZUh7Hq1PJBAs7dXNM4SBYzoNStNmQW6BznwtRFNNMgUh4N+KQTpgO0W7WzabA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyat+zX3dmDoMrJfaU1OB9sMd/SA5e2F5u5cP5YRjxA=;
 b=PQK+KV4WIJTR5Jp7fWCeN7hg9jbzLWPNhIHs5g9j11Uu8tOf6p9wMF5xj0C06LU3bKLFXMUt6ppQaYA+hHr67HuqkwzDTJWE2PGM4wcZOVl3M48j5LsVhvtfdBcfBsgM7fdvuCB+ykYQPmTh54dF0U65QqkM9SMYDPdgaILYlB4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3471.eurprd04.prod.outlook.com
 (2603:10a6:803:7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 14:33:02 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::9488:e177:a8e8:9037]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::9488:e177:a8e8:9037%7]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 14:33:02 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [v3, 6/6] dpaa2-eth: fix a build warning in dpmac.c
Thread-Topic: [v3, 6/6] dpaa2-eth: fix a build warning in dpmac.c
Thread-Index: AQHWjCNEpF39sBI2Nk+pizT/HmVdiqlrUw0g
Date:   Wed, 16 Sep 2020 14:33:01 +0000
Message-ID: <VI1PR0402MB3871D33D658BF35116426E9EE0210@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200916120830.11456-1-yangbo.lu@nxp.com>
 <20200916120830.11456-7-yangbo.lu@nxp.com>
In-Reply-To: <20200916120830.11456-7-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7fadc4c3-62ab-477f-0ead-08d85a4d6a9e
x-ms-traffictypediagnostic: VI1PR0402MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3471FCDB12C52531AAD46524E0210@VI1PR0402MB3471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:416;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5lpDcoQiCZXxC9veBmNkzXfNRKv04mvaw2rOhqz+1s0/0MUyT8/up35NDYnNJQrcGUvgfEPOO4KT1Rhcj4rDl2dSg16n/waQqIv7BhrMkC2xnLfWU0EopvE4+ZGNAyC/a7GnWlO1IvZ7qpLt+PswRd6KBHZAOXiKRDUWNR+S87DzEeQm/isdsPh9lS99E/sGkHjy/kSWQfHAMCle18pqIwGI8cn3oK2hA6R0kViv3cTqDULVvBZfLn5XkH23VfoeIufV0c/vD3lI7Ghm64cY8Wktd+gqimwa8RGsDzpyTtnepy2VxgIoGOE5HRERaN7MS28AnWY1sUg7DU1p+5ErVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(2906002)(66946007)(76116006)(9686003)(66446008)(55016002)(71200400001)(66556008)(4326008)(66476007)(83380400001)(86362001)(6506007)(8936002)(8676002)(33656002)(64756008)(52536014)(5660300002)(110136005)(316002)(26005)(186003)(7696005)(478600001)(44832011)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +vaOTMqtcqC/YxW6lS8MQJLsGWSC2yjW8c1EGX/KGEpgRZhKRKlzVM707dKshHY4yPfjiReo4FeBM1BaTOvFiDVYMI8w+FGf1v+wTFnjl8/VLLu9F2MjRanV+vkjL5nugnFebXd6/3RH8lifLkiKb5MGDmAROYK1k3OsI1KzFxshOcuNupm9s0p03hm5/FTfalo9FQxSguUuVB2uv5xkxXmpx3JtIFbPbsb7Mb7Oaxpae3c7eJdDQc0BDYoFAT9ObuTISghSwtl82bQQyLbBJZCKAC5FYay9lgFrUzRz5vgU6985j3U9zkVAfgn5WhhNWzfDWFgmy11MGgaDKn4eU0L0n7VPfu0zIPomuZNMORAXghaOqkTPU39LNZ+nHH9Ny4EUuzJo0TFMwFpDH24OzCWpTc1ZzF2clxcKzY+D4BquKqXURiTLftZ7sqsEjLl+mqtAZ3/Q8i1u6e8JffNuQiYEOhMhHnyrK3XErSTA/TyYLjLBCh3BOhdsFbLVgywEduNAMYj/jQ2O0P6eZ1Q4n47Qtx/PlsU7g5AhOfH8kBdIqdUiiQcFWIPuru6TTqykhDFrGnVA7EWJNA5Bk1uB+oy5CsC2ywRrhsKeaGYwlGPWbvc0UxvtkeGOb8Pj4NceWn0LDjKhvO3IQgvRINjx/g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fadc4c3-62ab-477f-0ead-08d85a4d6a9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 14:33:01.9580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zAxwNYVBlcAd0GAMkggYSNN23TvyTE5v0aptBOegVES8WEFwMW7VpvBAOkM7r29A1Fi/xBUneQJlMHqhC6EAEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3471
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: [v3, 6/6] dpaa2-eth: fix a build warning in dpmac.c
>=20
> Fix below sparse warning in dpmac.c.
> warning: cast to restricted __le64
>=20
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
> Changes for v3:
> 	- Added this patch.
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpmac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
> b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
> index d5997b6..71f165c 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
> @@ -177,7 +177,7 @@ int dpmac_get_counter(struct fsl_mc_io *mc_io, u32
> cmd_flags, u16 token,
>  		return err;
>=20
>  	dpmac_rsp =3D (struct dpmac_rsp_get_counter *)cmd.params;
> -	*value =3D le64_to_cpu(dpmac_rsp->counter);
> +	*value =3D dpmac_rsp->counter;
>=20

Hi Yangbo,

The proper fix for this is to define as __le64 the counter in the dpmac_rsp=
_get_counter structure as below:

--- a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
@@ -67,7 +67,7 @@ struct dpmac_cmd_get_counter {
=20
 struct dpmac_rsp_get_counter {
        u64 pad;
-       u64 counter;
+       __le64 counter;
 };

Also, if you feel like this is not really part of the series I can take it =
and send the patch separately.

Thanks,
Ioana

>  	return 0;
>  }
> --
> 2.7.4

