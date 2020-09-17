Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DB626DE87
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgIQOep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 10:34:45 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:40418
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727635AbgIQOc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 10:32:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFcTuhmTRuMBNdoSICS1zFeR4CNosYfVRz/Esdt7mEd4xZ9AiySiXzwasmrxwOoPzQg8Xujafz58cfo1J+H/+FxcJ9XJCcAxS8295eQctjk7iUS12UcuDvDofGYyCsqSfs6BdXdgF9t8Othjqu4ZeGOOF9gTF4+9kbMCsSlAiq4ZwWdkBGxj8jAvkJeXqsdH4l/c/zDLSgqb74PXIiT1HPyhwkqj90P3fskF58GKqt8EfF/9iY1eUGQwKbZkmrSMbi8ifXVywXJvAMZ2Tw2jkm9ieAeyDBycVOuX2gK1ZRDfmoG4BWtrg7ihlxt9OaD/qAohnCAFLTNh7MchA+ql9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDZs1CtzXQ+mz12mXflTcKAQi+QqMa8cxmdSISP8K8Y=;
 b=QRu/ZqA6zrs/yY2e2J8oT6M1BCpTYUIHdh6PfDw8ybtFlU1j9KkLJucDb6DiN2mbAvY0HQT1T2qczB3HTxKbDziZe04qtm9odPJ6J4ESipaTP7ksEe4Tkvf6ztr8Pn8UQGnBXLjWB8uAwTnW2xcAI2zFHgdivvHYDrzU4+bc18H3pUZqe51oYM5lTrxDhMaI2enpWoL43q5mFe3TlD7Der2a/ZY0gNgs6i9NqvjDy/KjAyiSbUzfN+fk+qAoXpIZW1VqAgttLcvdo6XFer/z4HXzRREnhN60y829WaZr1J14PCme5Vc4I5P1rhwveRIw5WQkzW8NAM9oTYd/oUGIBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDZs1CtzXQ+mz12mXflTcKAQi+QqMa8cxmdSISP8K8Y=;
 b=ntAg/xQ5iyEyX17MnMtgxDxQMDqOjz+j+pyrc3YFr00TX6ZbrkYY/7MgUUcvzoooHou40dXflgfLT/LZPPSUDKgfjWD2PoaoAazTDERk2VZufKxZL0Y7eOCGrJDJ8bJXDba5Cj9GJ9JpnMzTODxenoVZNW9ptgM6n73g8l0dPu0=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VE1PR04MB7422.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Thu, 17 Sep
 2020 14:15:26 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::9488:e177:a8e8:9037]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::9488:e177:a8e8:9037%7]) with mapi id 15.20.3370.019; Thu, 17 Sep 2020
 14:15:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
CC:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next v2] dpaa2-eth: Convert to DEFINE_SHOW_ATTRIBUTE
Thread-Topic: [PATCH -next v2] dpaa2-eth: Convert to DEFINE_SHOW_ATTRIBUTE
Thread-Index: AQHWjPBTL0pvGCXY6kmuFwdzssdIm6ls4BiA
Date:   Thu, 17 Sep 2020 14:15:26 +0000
Message-ID: <20200917141525.eyjlmkvdy53myjio@skbuf>
References: <20200917124508.102754-1-miaoqinglang@huawei.com>
In-Reply-To: <20200917124508.102754-1-miaoqinglang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2344c444-04c1-40bf-555d-08d85b141ff6
x-ms-traffictypediagnostic: VE1PR04MB7422:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB7422373FCA50A31C4EA63F37E03E0@VE1PR04MB7422.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vC+/DOZ+U8yBwpobeuTTrOCTeKGc2YqHPe6bsXyB70fb57DTkXPQP0CoV0Wfnggd6N6Uw8jG0sknROjfAlPuKqBSUQLhI43SBg2AuuGozQg9UUOL40sC/lUcDlQllOxpIcEIsOlXFnKVy1QsJ4SZzbTpI7cuaxJGqlfl7KNHtfgj/r+mRw5PrJf0nWYnpPHQzlbAGIFZKopGD21OSodvDkoqFvr/+lw5AdB7R1sHQCT8qH7ST04QBUEMV8nh5jPyAoboK120eodv3urEy7QIqK0tPo8oR2o61ui+4YDb3TitmIWmdkjkuzD9BY5zlr1H9j5caaFugim1fbVDegZCFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(64756008)(4744005)(5660300002)(8936002)(8676002)(54906003)(44832011)(26005)(186003)(316002)(478600001)(66476007)(66946007)(4326008)(1076003)(6512007)(2906002)(76116006)(66556008)(6916009)(66446008)(91956017)(9686003)(6506007)(71200400001)(86362001)(6486002)(83380400001)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Ax2KxagO/3GnL6IAPtotpRMYk/V+NkewLr5WcLWv+TSnYONhyj0JD0viHegg1oMwtmBuehw8WwElW1x5tpawZayDowzm3vk0w0G4a7byXSs9Af12YlJXj5GtQDP/IXylsCwtHgiVmiNGm+8doNE/5WI93t8UgZK1fPLM76TmuYFXZ7QvAYE1PCKeSeP8/iQvMsCJ8lIu/9wyzVq4yvXcpQKyRGEM4Lz7y9zmFcMuz4FsWsZcCDbZv1n3Fl1adLJ6m2y2JNPD6ujnRpuHscCjOgHJdV6us+gjDGWBBfv5ACdqXhdVFP1AV/abw9xjkLj5f0EnOSGvSGWYXY9L6GN3UmbaTx0lCPz2j9oxzDqrXgjAP97fM/4MYD2QbYWOxdZr4dJ+4+bUVyKiQUHQ8QNjLLghli4H+w+ibeV8UR6xtWbVhAqD1PSuS2XwP2gpxKz7QjsASvhpQ2FV7TE30JRmMLbxJCjYbRj8dAgJPhYoxxVZkp+0fGqQjEVPG7mc5DOdDXYHtw6V5kEvToaxcWZjqRB5ZDCt5H8o6LnsHE7OAD4kx4lsd+lx8iZeP50Y1ybFXxybFvpMnDXg0khc5RlEl+38E9ugq0Jn9+1ZzOY3Ooo0qi2EmD3f570XQjV812MshkNUGMJYmsd1KBWS+aYTXQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A336A06675DF13478C9182908E590A39@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2344c444-04c1-40bf-555d-08d85b141ff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2020 14:15:26.5876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VODrbFh+s5RKF/AZAuaACO0xzdpGcLByIzPKalZT6/VuGCIb3YSdzbHIyIUHtVAAPdGbRrCju6oeP9NwMeIvIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7422
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 08:45:08PM +0800, Qinglang Miao wrote:
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

> ---
> v2: based on linux-next(20200917), and can be applied to
>     mainline cleanly now.
>=20
>  .../freescale/dpaa2/dpaa2-eth-debugfs.c       | 63 ++-----------------
>  1 file changed, 6 insertions(+), 57 deletions(-)
> =
