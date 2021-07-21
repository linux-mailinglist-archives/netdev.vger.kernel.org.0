Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D1E3D0D9B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhGUKqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:46:52 -0400
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:61844
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238684AbhGUJuE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 05:50:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuQTt8bimVuJ0RUdiCw/1iV4GEpUbI+aD4mKRp+CsB5aLe92y5STOdDkuT0IuQfo9cAa2TMNsq5d5Bp2zf5PrVojkph9i7+GYBbXxTYJh50K9nwr8OMpyZHdVQgbWzo5yKie+GWuf0QRkxHKbwswTrh3RU+i8WEx5rTh2fxMmHVteCTSHfjrHCMmWEoIBYaiXEEDbxg8IpEmoewfNz20FRSPKfE9y0Jns2+uqT22P0WiM4UyE3gzVbd3ARL47+/YuFoFZ5TlJvEPf9TjmqTKrEbmKcABTo/aKQ1PftOCbY28kWlBgvMbUGeyf5JwrQmLR8s+CPROUjLJuV8yEUZB5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yMeZN3nGJl3aOuYXjAzvRRhuTrPGMy8YY0TEYudfgM=;
 b=DQdxWQT0ipFebp/DRw9RdmJfbSp+KF6XUDBLVFsNH6lOocTalsTojqscN8/JgP9SUBlbIFtSeBDROtiuIoOQtd0h2xF/M1HpQvVGESobijRFu0VVaxwVfRIwYWI7GYq6n+XkI5NGoeMqqq7pqzL2YgVwM432xJfM5hc30MfJOfP4hx9jD40MfaIWKRn8LhQgtfvzDpVfQ6g44ghd96SjLoaReAnWHIfFc4e5pUnySuxKMmk8TYeqro8AfLZVw6uq6j74dZxAxBN56pYCbvfcGdlVw3tW36ugBo0UCExi1pTBv2plNdMzv0AaPQbwxfmT1348p07J9fN/Nj7amISzKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yMeZN3nGJl3aOuYXjAzvRRhuTrPGMy8YY0TEYudfgM=;
 b=qo4KsjpYkHx28RVdyds11MByMsWvoc1ZjjzBCAjbe8l21Pc+smPMeBclG+KE59z576yergKQeZJ+3iWP0RqGP5YGNTQB40HqO7Kp73MSDn/HrDN4Emg1gsIbUFqKTF3N6R19m1t19obCmdjhgLS7ey5pV9xVKCJ1Bkj1wOx/dWI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 10:30:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 10:30:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHXfc+BUi5PeIFlAECY83S5wMlCkatNOx6A
Date:   Wed, 21 Jul 2021 10:30:05 +0000
Message-ID: <20210721103005.vqll3bhqixkc7uym@skbuf>
References: <20210721112652.47225cb4@canb.auug.org.au>
In-Reply-To: <20210721112652.47225cb4@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec70f31e-d916-4cdb-1ebc-08d94c3281a3
x-ms-traffictypediagnostic: VI1PR04MB5295:
x-microsoft-antispam-prvs: <VI1PR04MB5295354CB1EC550443698115E0E39@VI1PR04MB5295.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j1LV3umiwRRnlcasvQv55ZpWzHiLMm/mWTguyXu3Rd3stqVe1QLGUA6J4Kh4xIisaFOWDXJuFZE6nYwz2Wj8wzWjOu/xj9xO2NuSR3NhzJugffkL1ApZsqjoZitw5Rzp9ilEHtpUsL9PkBF+8KQTD2rpePZCHNOvXB5WONKzVpMFoN+WCY4PyqrRPnn3OT/JDt7fa7VdKa8rf3x7KASdITRH+KSD0Q1PdpJMNVGSbbC6dysCF8vxCSTmJsdv2y9QrZGytLkyy1VoB/6pPN3GWGT/rBewo7iYHgol+0R2ohcfYqtz8itg08mSWj4QlnuuNC7Lhn++RlkZSdGAPKxCoJzzJZRTNozKvjtuo6cXfjrn7XDPFPH+QOUbWWJrZQ8s18NIQ2k4shLqssiOGOGd9mB665dMQ4FO9F9dY5LlV9I3XxEDKLhnqX969J8elPHFK5eH/eEPBNUdfB56oXSkOWJb1QqAfLWFvcEyqx+1MkLMeJQqw14bPafr030vkXj0oRfoxtlzAGChRV5IAc1zMk8PyKhUvm+SFJSI0eQua6RM4VQQ5Vg9xwa9zAh2WXgI3pPq4P5+SrH1a6zLr3uZjH8R/iicH4IHQ56mOLD7rTkG2EQMuhInvneLvGXU4wXE33KYXTyhDRAN2k2W4SnDyalHhbCZb8s5W2bNeUXoOFKrxSSYKNTwm/n0deBqRt1ou1ZKr02tcS0wMMCcCfAsWTXvFIs2QTGGSafasHtbdD0zjntcs2XGMhw54dLcQviw4PXn/EPa0kDZi8PA+0Xhtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(33716001)(6512007)(8676002)(5660300002)(4326008)(38100700002)(6506007)(6916009)(64756008)(54906003)(66476007)(66556008)(2906002)(8936002)(86362001)(9686003)(1076003)(4744005)(966005)(66446008)(66946007)(316002)(44832011)(6486002)(122000001)(71200400001)(26005)(478600001)(76116006)(186003)(91956017)(83380400001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O7ChQBiag5gmr3va295wuKxQWBGd//uy5bErLV03jU2SLVPIAsyFTUqCsUaK?=
 =?us-ascii?Q?EErP0OiLSmVJaryHvDhEXJ4ZQ2+lI8IcXwR/YdXOQCpOmt56LgIICR5F0jWo?=
 =?us-ascii?Q?cI+pu7wwQoZkMYn2eRwd91QV89QgGzy10QDUTGoIlnh0iQZ2c2FbsJvhlB9t?=
 =?us-ascii?Q?kvzqMealeOXGqYYYOyfo3ssgpDh7tVlmJCEsvZ5TBG+gRaijn0MDUbFZvkqV?=
 =?us-ascii?Q?n+8ohajC8498cmwR/dZywE6o1KA6G5mYCx7atMmowVrepY5rwGFNiIRhSJjD?=
 =?us-ascii?Q?qilXnJpggvDq5UchSdS3RnJD90+OHSzvFY+b2tZ321x9qxgjC/cE5RQuKe9y?=
 =?us-ascii?Q?blawT4pIysssQnAnI4ZDnWywnwaRUCJ0DGKh+JgG/KxskzDgUFCxxvNH7ay9?=
 =?us-ascii?Q?cT/n37p48miexCzX5NXcZN/Ey2WpnGq9YwDg7YF/D5Cm5yQfDQMtTMiZGpuR?=
 =?us-ascii?Q?xMXT+G5Aa87qpNtBgaD5aBldqEdkE3HLHDU8csREA3OWGOli7AAXHunEQ/gz?=
 =?us-ascii?Q?a6NI5b4sTiOTIAFYQHd35dTKY/1Nu/28rL6qynBc3UvV3HKZ2ZMIGauXj2/l?=
 =?us-ascii?Q?i2dWGC/eGhy7PGR5dOyPX8Rxlb8gHCfDLbJtFt+J6CYVLCKyPchmQN2sSZg0?=
 =?us-ascii?Q?wC23RYPJqJ+TEv6XX17dri7zMFmAaET5eJ2rJYCsFOCfRDvB51d76FNnwvMc?=
 =?us-ascii?Q?wbKuzQMbcqWVctRmHZlAzKQ6Fr6KOr5SFEA73K5qktOFpcNqdkrsO9EB2PSU?=
 =?us-ascii?Q?y1OHvsYl/df2Wyu8rtgQ8SvvfCFCTwrvMlTUqjmHOlPaMUYrbuD8DMFZ1aQq?=
 =?us-ascii?Q?CwXvnWG6mYST7yWDs4HT6DWw0D2QEirb9C96TKety7XYE6kUGUBHrLKFfjy4?=
 =?us-ascii?Q?E0H8CbnXT1hJSnY4IxKHeqlrccJsQcreU4kSGP2Rn2r+99P4zkBGenQKv7E2?=
 =?us-ascii?Q?9tAjoD5DlElXBIHMhvXomZdKvQGQSoNwq0w/KwDWRv5MDheVUmenKybWLcR4?=
 =?us-ascii?Q?6QN32P6eCySTlTTDoSNx5b8fDGXGYwhi6ipkm2+8I+Q6Gb33DJVmv+2todg3?=
 =?us-ascii?Q?QVTO8/hrGAo75FaFKjQ8U3F8IFZm6GNVl40F9nNOrTAH91r+YAztWvNSUKNR?=
 =?us-ascii?Q?fJ81LY46pvQLJGkGXG52170GCYAS3ouNqFn0IegZkq3376TPdV8uq6dBPCtf?=
 =?us-ascii?Q?WgSFYk5mLAof2OM9qqX8bmXiVKvsmbzsMXB/VWKjPoIa1AFloXeB4VKGKGuE?=
 =?us-ascii?Q?xwc/2rLkr1oglHaogNPPKWecr985BiIgz+8BzB0ZwFADLPi4NqcU7ELe3ZB4?=
 =?us-ascii?Q?GPxM5HzJunIDHGbkuU6Cn/fm?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D1DD2D17A64EAA4BBBC29744295AFDAE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec70f31e-d916-4cdb-1ebc-08d94c3281a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2021 10:30:05.6123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eqrlau2gJbDk0z4YVSHxZsCRiGF5nHKNRDnES7ZxYRyKlO/CfpVIBAIKpC6tFDqAYUOH1x0mS64KaCpnP983hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 11:26:52AM +1000, Stephen Rothwell wrote:
> include/net/switchdev.h:399:1: warning: 'switchdev_handle_fdb_del_to_devi=
ce' declared 'static' but never defined [-Wunused-function]
>   399 | switchdev_handle_fdb_del_to_device(struct net_device *dev,
>       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sorry for the breakage.
https://patchwork.kernel.org/project/netdevbpf/patch/20210720173557.999534-=
2-vladimir.oltean@nxp.com/=
