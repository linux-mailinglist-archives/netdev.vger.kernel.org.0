Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCF227CFCA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgI2NtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:49:03 -0400
Received: from mail-eopbgr00068.outbound.protection.outlook.com ([40.107.0.68]:28802
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729807AbgI2NtB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:49:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETmzGDvAyqGSIj19d6xNCgaL5oTf57M1SXpo6yEF2b/2SJQwyGbmL5K3nf+3FE8e5PTvA7iD+BEsPFGEDTjM78dEPadWKVaXNKNos6ZqwSRYJap05KyRLQ2OM4fW/ZrjW2eRCVt4OiupO9+AVhgTR3uhdaVU6skqHCBrEoyrSsVGoDvOE8qz4ld7H3wcJ5V2jvsfg0L8mp8L18h8Bv1xPGy3yHF4/nV4kKokah/LS1VcSq9wSS2r5gxy2ZyMi4XiSb1QaP0dDNZfU+yO+eDX5pXQ9BHLs9vIBHK35CGbBg+SON7KqklbojZdZ4y5tCuexR0lCs3UxG1nlzADKD9JpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdX/R9tt8K47/Pa9bYbr1gSmKSFG7OqL4QvwUyz7ut8=;
 b=eGFc1BHJVNu4hsvq6uBkn2OdSG1Xmv/rWx+Voo9gWZd6dYyg1Ml7sibW72LujvWmxznD0eUqHn2o1N7sRJv70LARQTPvwMf56eMRRVv/8lpMwhBBevdlod9734+iHVGAa4F8nZZ/A7Jb/S5CjWG/ktGtqFaoZymt3c6vcsXBnIJAkldsRScUOETDB/qkQZHr0qNvxPg7DCg8a1ScCWelO0hjCVUxJEAkvdcMYM7OHAWDf4jKFzEhcCgcPoo/xMmgef+gKB7JYfreLcuRr33v9SN/TNhK/cwTMEExtjhlI1y56jlS3LgnkoSXGmRcKSqvbOGE3p8ZpY7o6LyOhmjDrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdX/R9tt8K47/Pa9bYbr1gSmKSFG7OqL4QvwUyz7ut8=;
 b=FxZPoux5dMRhHGeznvh5A4wrgPRAoZi7f31g7jKzY/YFQk/ePwybMO/lrJw+pzscoDl9KuM5Ok+t4XishUrAWWqQGzubZ5PWStzy7ETAE4Hvox2sBnpr5+rFJXIikFioE1MUp1G4vtHmgkK2qeXKe3zQFYitTW7T00JqJxKxvwI=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4223.eurprd04.prod.outlook.com (2603:10a6:803:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 13:48:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 13:48:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Thread-Topic: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Thread-Index: AQHWlEkF4CNV15jT2UqI85y8iY116Kl+lQCAgAAJR4CAAACrAIAAB7MAgAAAfwCAABGJAIAAI2IAgACb0QCAACKoAIAAC3GA
Date:   Tue, 29 Sep 2020 13:48:56 +0000
Message-ID: <20200929134855.5vqrvdrtjxdzb23t@skbuf>
References: <20200926210632.3888886-2-andrew@lunn.ch>
 <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200928220507.olh77t464bqsc4ll@skbuf> <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
 <20200929110356.jnqoyy72bjer6psw@skbuf> <20200929130758.GF8264@nanopsycho>
In-Reply-To: <20200929130758.GF8264@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0b6b36fc-f798-477e-ae45-08d8647e6906
x-ms-traffictypediagnostic: VI1PR04MB4223:
x-microsoft-antispam-prvs: <VI1PR04MB4223895DF75BD92A9E73BC70E0320@VI1PR04MB4223.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: guhFY9k91yUzA0SwETY6TWdLTBUiTFoPp2YzyQzFsuY+7bp8H66861G8NU99qNNbordNaJqYY7G441FpzG08kM+lEniYe5NQ/qtcwUSS7zqM2Gy7QIP0bgJI9yBlEc7xy3Oivt3hJa8Ns5vcb02Xz+p+fKDZcv3v8GZqwFItFP2QTYxILqSjaFzHSwIeSCGHy1q5KMStvId7dDsW/JYyhYxNMHFjf0eQ7gZHwQ5iu1M2II4Emc7DLrrL+pRHWGHVDsJDGMYcYidMYICjCrND0+2/zpb5ovqXoN5xKaDXuxGDmRqmqn4dVkH+hNTJHKs6SxHrIQ6mndItLzIuQItzkHZbwTflHcwuhOTYtGsAKyV62Y7F5zNAaP5nSErnFanI9DEnPuZ6wb9zIT1apkhS1jFNdwIf58slWxrmHDvS+VtLItpctqDqLBjXCQTniSEpuzN6BheKOMM1lFTBjm229w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39850400004)(136003)(346002)(376002)(366004)(71200400001)(44832011)(8936002)(478600001)(8676002)(6486002)(4326008)(66476007)(5660300002)(76116006)(91956017)(6916009)(66556008)(966005)(6512007)(9686003)(66946007)(64756008)(4744005)(2906002)(1076003)(66446008)(54906003)(186003)(26005)(33716001)(6506007)(316002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xbUz9EQ0eEJzlutWZrDIuiTCuusm6GE0tLVBJbq8Uk4TV8MkghL99Gl8bxSdQffnnfffyROWsDjND4bICR6qK9BhhdoXOgS9HihfaYHlnAApwtf77FXVz8znsy0QJpn55GW466rODXJlsxI/l1ktwyesbIawBwjYe3RkNdW5+rlH5SqLAOu6kesKKhvcICzbchi80b3HGEdFB3HAsO/pFNIy0EDenb+zUwcOOZ2jb8xkCSw5jNNVHh7RCf02mMsGmZdtOmA1SNSQ5jIS0hy0jL/fEZKzQomT5Mxci02RxObCs3h/H/Uf/QtafpiYnhSsRGXSkA5r+/2DQ+E2KSjZh/t36UUOEL5sKEiVg2qvAeD7CnLX8vTDgjewt+yr2LBYWFSivtELuxpI0Ttf8HILfd6A36JWI+lFjc7exkcDHeWZW43gtn09mOzkCl01ysGy/qAy0/KJuXvn4vZiNbPhuaqTFKB1X++tyh5I2ErpXaNy6zMXUS0ZeC5Q5ChnJcPvG2g8WA+70/aqC9d9wB5lYXCK1YjK9v+73wBwZKpp3G/X+ta6S3aXe38Qs6+o5f0Muwu8pkuQ4BNfwCnRRnVx7NHhf8kdCJUCqGZpkQm6Z/SCB0X6/aapXvd+I2TLZZiPOcMXYpzk5F5/3/i5OmEngA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC164E235C23E544B1CE618F908DA9E8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6b36fc-f798-477e-ae45-08d8647e6906
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 13:48:56.2768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ql+9OZHZkq0umx2P49zcxsUyHGDfSgdQqAUYNLfBmfMkpiN6LibyAql6qN5LiAWZjYg21dxg/A5rpAiycP8XZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 03:07:58PM +0200, Jiri Pirko wrote:
> Tue, Sep 29, 2020 at 01:03:56PM CEST, vladimir.oltean@nxp.com wrote:
> >On Mon, Sep 28, 2020 at 06:46:14PM -0700, Florian Fainelli wrote:
> >> That makes sense to me as it would be confusing to suddenly show unuse=
d port
> >> flavors after this patch series land. Andrew, Vladimir, does that work=
 for
> >> you as well?
> >
> >I have nothing to object against somebody adding a '--all' argument to
> >devlink port commands.
>=20
> How "unused" is a "flavour"? It seems to me more like a separate
> attribute as port of any "flavour" may be potentially "unused". I don't
> think we should mix these 2.
>=20

I guess it's you who suggested it might make sense to add an "unused"
port flavour?

> Okay. That looks fine. I wonder if it would make sense to have another
> flavour for "unused" ports.

https://patchwork.ozlabs.org/project/netdev/cover/20180322105522.8186-1-jir=
i@resnulli.us/

Thanks,
-Vladimir=
