Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505BB1E11E8
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404201AbgEYPki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:40:38 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:18010
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404002AbgEYPkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 11:40:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDAoZ+AN9G0d1JHtX2Vn9v4a9dTaN/8bb74IaTiWwG0RZ4cce1RY1FUYzGVPQONKzR1LAq734ymD9+9FZlBOFx81lED7QUbrwKby19kWah8NOrnB6a57Y0IrfQ5KMIq9Yh/y4ByFa17o/fFTp25SD7j8fB9K0j0RH26Bow5b7+8nAfMh6FzYunwEo+TfkPDcWfC3mLsMiYxfdJf0Bu7RwteFrLb26QIUq/K2IXumHe2dFztPz/A2u7FBbS25J7BKj/tw5nLz4RNo1fiJv9Hi4lu8PgngQASuqja+jIG9RHohdI0WnAuJs/e/FS9zDgEdo+3op38H7NLYYLFR2Kd/kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yTeShbG1vl7ppkvrI4ooRYtpNd2QhydxDuu8xC+ZMY=;
 b=U3q8J4H4B+ijfJH1x+usIuCUuGfoogQ/SRbS/fZwj6wjD3SFeGgSBFPHTucL3eCZ4T2B4wVWm6IlNeBur7yBXm2cnOKQtb7BlIuSXb2tbK1WXepFTQgW9CM0ct9xrYqmsBgrhv1CqPlSJKDD6xJq2I0KjDQQPiFwjWgRqQotHL8ucNERNaTUDcQZVYqTRf87VR4JmMVSLx8Ir30k69pSjVRmi5OXrOQ18g8h7gvkPQoyspS28Ix8i0o2YXJBBRqEuBI/3kzLxxXQqYiFWsLdVHbjS3bfhFaKe+nR1XtYfYfpuhVgUTwZGhH520S3xgdJzKCqQ9KSltQGzmjt9AbJnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yTeShbG1vl7ppkvrI4ooRYtpNd2QhydxDuu8xC+ZMY=;
 b=Qq+wtxPNKFh+uClXxoRlXSTXtgTP2fma6S1F63UcyEOwG3CMjD9LnEAkwt6BRD5QbozKUj8NSNEcITPoh/rBnLe3x2+M0a4PiVFpLT+eQLYXSjUharF4jqIhb9MehgkihPazOSQmysnaUWvbUaKfqVjQ9m/h/WieYup+bENuR64=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3543.eurprd04.prod.outlook.com
 (2603:10a6:209:6::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 15:40:34 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 15:40:34 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "martin.fuzzey@flowbird.group" <martin.fuzzey@flowbird.group>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [EXT] Re: [PATCH net v2 4/4] ARM: dts: imx6qdl-sabresd: enable
 fec wake-on-lan
Thread-Topic: [EXT] Re: [PATCH net v2 4/4] ARM: dts: imx6qdl-sabresd: enable
 fec wake-on-lan
Thread-Index: AQHWMmQg7s8fETvz7EKyqkR8ZpxW5qi40nMAgAAeMRA=
Date:   Mon, 25 May 2020 15:40:34 +0000
Message-ID: <AM6PR0402MB36076176E0B57764A8058605FFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
 <1590390569-4394-5-git-send-email-fugang.duan@nxp.com>
 <20200525135140.GC752669@lunn.ch>
In-Reply-To: <20200525135140.GC752669@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 204dd6dd-30ba-4ac6-a31c-08d800c1f71c
x-ms-traffictypediagnostic: AM6PR0402MB3543:
x-microsoft-antispam-prvs: <AM6PR0402MB354359D158EAE85F97447A4BFFB30@AM6PR0402MB3543.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VeyriMjzVSjtMj2xn6F7CYWHqfwK445WgktOY2SkOkGbFRoyB3O2JaE11eOZThHZ+5YXq+plizHVSpHblLccEH3htX+G9yB5EfW5S5M6E0ipmCyJeFGchox4nOJs5Tsr7P0AP6mbXvvAnn3+KiP6LhoYiebP9uIr4a0NAvzZuV0BffQYj5e4rmhXlcGMt7FCuBMgrH6XpLiKKyCR1lRh6P5r6nKXx5IA2FAqrhMBTl9kiqwtuyAYnJY+fLAGXexxZb7qLQiTjAnrf6puyDpMfeLsWSSQ/hqmIdzvOOJfFf4fM12iBqKq6UOMTWSBrjQx04GgoU38uLoOGOD0Ydb7u7UDd7HqiosVilemwGHeHA02xXZrkVjRy2ZxroZbwOQ5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6916009)(54906003)(316002)(33656002)(478600001)(9686003)(8676002)(8936002)(52536014)(4326008)(5660300002)(4744005)(2906002)(71200400001)(86362001)(186003)(66476007)(55016002)(66946007)(66556008)(6506007)(64756008)(76116006)(66446008)(7696005)(26005)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NnV6ME5vwyPXKUyiXTqOhUG6/6k6Y7wjmfIUsLWxvZx+J0N4/fk9j9sTXhOgHnuorGnvBb+qQ1Ww6Ra3WJl1PK6qU+zE6nLPjr4U5F2z+PN7Iwj79YxSpvGCtO8lXjKX4Ltna19XiDwLVf9FNgIQkp1+/BlO8LE4sQMqKZgT/vTznSLtwlBzy/KyTfBmVc8uOR7hP67hYjbv0rdLEcqqkxTe+CN2HJjI5sdtQqCtFhTrEw42cmt1+aBVej2XNFuKbsTWT6+mLiqc+cSafkhqnrRglluJOi/w7Wz9tPxnNPFz7S4M4zvXhiwjj4mlY5KJBT8HgHQo4+ttzp+S+GNSiacJXoJG2ImKjjIvrQh5uU8y9Plvg7/rHFme3daM4M3f9h9i7bASIKFOgRaLLkuALwchyzm6lOHlbZZooLdcZnifYXsvwVq2lbfYxjiBfvlUDrjLrxBJzYUcHlmzVYQm82o8K0sUkFYkPZCsBhYkcXtI6EUMwgZxv1MeV9ZVfgM2
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204dd6dd-30ba-4ac6-a31c-08d800c1f71c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 15:40:34.6582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lXi1/SPZi6TbmObYOHK3XN658Z9A5Mi6P7qwL04A7SP6hT3JZpHXShdiITFVJR1wNSAmwroHj2YjZ408mwJmxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3543
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Monday, May 25, 2020 9:52 PM
> On Mon, May 25, 2020 at 03:09:29PM +0800, fugang.duan@nxp.com wrote:
> > From: Fugang Duan <fugang.duan@nxp.com>
> >
> > Enable ethernet wake-on-lan feature for imx6q/dl/qp sabresd boards
> > since the PHY clock is supplied by exteranl osc.
>=20
> external
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
>     Andrew

Andrew, thanks for your review.
Will send v3 by correct the typo.
