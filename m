Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAC82A3710
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgKBXTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:19:23 -0500
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:40161
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725831AbgKBXTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:19:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGDUI4nR/iVh792TJERC/LOkGjHzLNhY60L1LkPIoy8fTazveSx3KyLNft6EF2A2OcnLbobzvzrRUYcFzUGhmbJHGoT2DmQYF0vCw6csgEOjaji6fPEkGq8FPgt9pzg4KDGq1d8r9PeyeND5pYUWZm3Y2VzMb1RkULTVM1/zOAGOnIvhcfHrSBLBPBvadU9LekIpaONbLyILgcGSP0yU5N+Ndh+FuA2OqSU904bHU1iruiDbP9+/Mw/PmNgG9DUcrbpEPf5zXz4S2W1xBIj8hzP6Zqc/RP85zyZZjcBc5029MkVIyYgboakHuoWFxXlCNF80m+BClqLDoQhPQd5ytQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54+CpIip7BR8d/qP+3/OvQuXxc1ifCvQkMdizoxgUIA=;
 b=BnuXBaIYfeI8K7fSnPko5oZJQbu1xMO/N17d3jrvLjdWT73MgaFALLjcDCG8a46jxdI7f7/AlUb65xbsrVshwSyQQIwSoKnbGUXXJSRRSzUe3+27ytOMJRmGKoL4gpaugj9/2p1VAq0JWFBq4uK93Qse10dLkzOHdan26TirY8+GKfYo1CN8uggH5pnEz9Fnc1ELrCqFn26X4vrbEEtqC9RZvf0B0CMF0fgt/BY4G5UHObSNchQ/BKLFmXE+7IoZi3uhlamNGtA/YaeAqr6iLA67Y119rSXTOFUIC6hPzZ5zGCb5oWkU2MoM1JSgidHQIKDKx9/Swmg/Idyh/nlH5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54+CpIip7BR8d/qP+3/OvQuXxc1ifCvQkMdizoxgUIA=;
 b=bEDCcdTYczBuRq9KympMt+LRGmAGT976tvNM1RWnrYtTjNTxzfqR7QFAj2PNp24Cy45F/ywIuN8ZEFnIcfUzkEp1o7M7Sk1d9AU5pB4DRM8pH3N2/vtAuL5avhbECwcHE9qgOKkOMPruv75tfc7vQGhiNMmSQxo57oRhMH7cEt4=
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com (2603:10a6:20b:a4::30)
 by AM6PR04MB5798.eurprd04.prod.outlook.com (2603:10a6:20b:a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Mon, 2 Nov
 2020 23:19:20 +0000
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226]) by AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226%4]) with mapi id 15.20.3499.032; Mon, 2 Nov 2020
 23:19:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Pujin Shi <shipujin.t@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: mscc: fix missing brace warning for old
 compilers
Thread-Topic: [PATCH] net: ethernet: mscc: fix missing brace warning for old
 compilers
Thread-Index: AQHWsR3tdRvpxbUwu0avLaQhXZnXo6m03c4AgACJQACAABPjgA==
Date:   Mon, 2 Nov 2020 23:19:20 +0000
Message-ID: <20201102231919.n2isaam3xefujycs@skbuf>
References: <20201102134136.2565-1-shipujin.t@gmail.com>
 <20201102135654.gs2fa7q2y3i3sc5k@skbuf>
 <20201102140808.54c156fa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102140808.54c156fa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b6ab1554-13fb-4d79-be9a-08d87f85ba17
x-ms-traffictypediagnostic: AM6PR04MB5798:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB579872909146A37EA0E73CC4E0100@AM6PR04MB5798.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hLoZxaT8Py3zpIyzc5Dz6WRNgFPj5TCucK8PgE8cNDxyY4dx2uW6jYQ0BAeNUsmvXyR0UWskLvzK/+tNdi6plLFuWFRlqyLCIJfLTITpoBvt4YFh7maxnQ2vA9vBekjJEHrGQhQuZtJgfM4nd1neDAYe3bLdovsuNYfIE8guGI+LEznf8W0Aih3HWnWDegS2htnAzm+8UneI2bcBhhVgVseos+Icna66vXd5oBCNNxScFkJMK9Nzcl5G/xEuV65Xo+XrTo1h2n2UA94J+sddf1222dwo9cW9339H0HW5scVbGwhLgo5dst6XYSz4W97KG2lU7a5hcDd9Zx1TwPwAIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5685.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(83380400001)(54906003)(6916009)(316002)(2906002)(71200400001)(6486002)(33716001)(6512007)(9686003)(44832011)(478600001)(186003)(8676002)(8936002)(4744005)(5660300002)(1076003)(66476007)(64756008)(4326008)(66946007)(86362001)(66446008)(91956017)(66556008)(26005)(6506007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MiElZBQvpqfMokDA24NLy1mJEL+BEmQCdFAL8tnqLR7jgdW9t9I/4UN1nqTFu4TYwJlN1Sooh6SWxhtUobdtXnfX+cfB6Bq2I9ZHN1dzXjs6siR9YqO/Gdnit6p1eFQEtKsIa+Kj258yRN/CqCFbII0aZwdLzIYyud6BJVRGr20yf3Ob8LnEXbsACzpSFEUGl9lneQBaxdvczFc8e6EOdcqgVZqcaUNp+Gavxgd3QGNYudwaBt40tHCBwD7wRFaaN/frxJig9kYXOPwHdTKlFnZiAhBiSCKQnJDghAq9EgMa5xOR56lnykzZpmNXUh8HwjkQHBdX9CC65vTHBAMr5jmppbQB7P+DzlvJB6gdFX2IMCFjNm0PeOOsAZ/QdDzWcS4/plJukd1lGRRQl78rcdP6rOUMlAYpWbFSp2DU4M6vZarkWi8JO+aHp3Dg3X6jottG+hT+6KJ7bBk0ZURCkfyVSme58cJw1awstlKUDoEU/U6ZlatRRVmojabSE6El72+lMv6AtIqArWCb/RAtVTXYZoa25WiMHdTBDYofV21oa40aFsFk0uLO/RMsNoVISVrCENzz0pBHx4WfsuGGlhdBRlAIY8iF0Tn7DBPY3D/KYUzPufQzD8OxmCcIYPq1hrSfGAMeCLKSZzXTID2KZg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C9F222BED2C4C4B8A5593E46656F4A3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5685.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ab1554-13fb-4d79-be9a-08d87f85ba17
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 23:19:20.1362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hogIjG8yxcHliOKgpJDTCFVnVGIimgumOS6djucKZpcV9g0K6DfynTIiMjYBdGkffrG33FJIQvBN5Ez+ct7B6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5798
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 02:08:08PM -0800, Jakub Kicinski wrote:
> Old GCC does not like the 0, if the members of struct are not scalars.
>
> struct ocelot_vcap_u16 {
>         u8 value[2];
>         u8 mask[2];
> };
>
> In this case the first member is an array.
>
> It wants us to add another curly brace:
>
> struct ocelot_vcap_u16 etype =3D {{0}};
>
> ... or we can just skip the 0.

I am reading that the empty set initializer is a GNU extension. I would
not like to see yet another patch from clang folks coming as a follow-up
to this one.

> That's just FWIW. I don't remember which versions of GCC behave like
> that, I just know we get a constant stream of this sort of fixes.
> I think clang may generate a similar warning.
>
> Pujin, please specify the version of GCC you're using and repost.

If the initializer really has to be changed, I would prefer to see a memset=
.=
