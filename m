Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91C21DC587
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 05:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgEUDPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 23:15:33 -0400
Received: from mail-vi1eur05on2084.outbound.protection.outlook.com ([40.107.21.84]:42049
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727825AbgEUDPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 23:15:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiVOtAH4GwtOxE4Bu5wapqrZRYRUbZpmiW4Owe/sowBxg1/aEAaByBokZ9it4WnrF2tYRpmGElDRQEVqvRVHIWDpRpX1FZdK9mxOYTFdaye8tPMeldxhdcP35Q0WVyL8JfAFz3YNSecjl164KCsiZJqGCx+0Vr5J60GRiPfGfCfRtJTgfWHFen/zmB7ls28nHcIpFmr09KLMEo0BfqlNsui0DYFNlcWoGvR5PwiYN9eQOW7NZq4x9YaGO/38hrd8j6HHrPjWw9xfHB/6wsmhUbqPaKJz3kZwW3odxi49TJwpoYRAEEGQOChi3IMUXBe+rME7zz28sJDfezih6AVVsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOtUJWlJX11pxQ5QRNBfkL8QsrXMq1HqwrpHHAjdgFw=;
 b=Y2L2rMts2ub5RUji9sxSKRXVoNKocSLWGKpoh5auMTp1UX/XzgmAed30BIyNBz9Bi8TuIJhzTpMaj7mwCDFDkJJt4+3eKRsjXouZR88HNQJYNNdYpDMdEVYVLYs8L/hoB/Id4JEpIOmyphX24/7I26vUqeblcFbKCr6JYKg1aFrfmCFBKok6EkH9sXNCEAnL5RdXPPNBgYglWgkii3EEekEJKdz8+eLGZydX14c5Ymmg0buuslQm2j1J8GDJQz8HGkxxQoAqaKe9MLfIiGiTNPKhc6dMmMXbRjKa57Q9sH9/zVvHG+HHIjvAXoMFQaNQ8LQVd7FskjW6ZZSuqPJrmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOtUJWlJX11pxQ5QRNBfkL8QsrXMq1HqwrpHHAjdgFw=;
 b=a3Pt5HQYThGJxdUmktibj5vFqi7RoTRd6SaL6C0exS3mxtx1/KULj/HdnTVnIgN8Kg56eJPexpxrlKwCF7HJCikOXDN6AzlSKf80X093sTKGedk7mXHjIgz5HsQM7sdlLb12C8BUIj9U1lf9SjiJK4bWGd+4eHueoh+d3iB0OJk=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3431.eurprd04.prod.outlook.com
 (2603:10a6:209:e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 21 May
 2020 03:15:28 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3000.034; Thu, 21 May 2020
 03:15:28 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.fuzzey@flowbird.group" <martin.fuzzey@flowbird.group>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr property
 to match new format
Thread-Topic: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr
 property to match new format
Thread-Index: AQHWLoHSZsTKfn2KY0W5vmilgDZ/AqixNB4AgACoEqA=
Date:   Thu, 21 May 2020 03:15:28 +0000
Message-ID: <AM6PR0402MB3607541D33B1C61476022D0AFFB70@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
 <1589963516-26703-4-git-send-email-fugang.duan@nxp.com>
 <20200520170322.GJ652285@lunn.ch>
In-Reply-To: <20200520170322.GJ652285@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a5c45306-47d5-43a5-d331-08d7fd353672
x-ms-traffictypediagnostic: AM6PR0402MB3431:
x-microsoft-antispam-prvs: <AM6PR0402MB3431996F8985CE56BE037CB3FFB70@AM6PR0402MB3431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 041032FF37
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XtYRkWEWPGxUpp4WzP3taUqUwGJOxs5gT+gcCYn9RXH4Cdt9hXnX9PjYdwW4vsQC8HM5Byz0QXnRZduFibS3ILdg4J5/DcwghguesMsJOFDh6GHiq20NUBoU3Yyz0000Yjyj3zfTKXqzot8OV4SghWmDIxiDWOGaRBOMrr36rcnHb99sfVD1jLzFFNXfAogzPhyFWr7uVCHeb0CHz56ssIPYCl6c+Xz4RZKX/ohAXRt/CFkFXEsa3IMNNxrF+K9e0hesYQvzz8i75hQEmUMxY3XVosj0gX1ThY2ANN7c/Qe7s5OaRgAUix+DvRpzdCD8jh4Zd4duVxQ3z635wLetAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(76116006)(66476007)(66946007)(66556008)(64756008)(71200400001)(55016002)(15650500001)(66446008)(8676002)(9686003)(86362001)(7696005)(54906003)(186003)(478600001)(316002)(2906002)(26005)(33656002)(6506007)(5660300002)(52536014)(4326008)(6916009)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2dPA+oYbKn3hXghtEwy6sRIAD0o5exQqP+QoCLBmZ47HLGoz5YqXjiSZK3qmmzfxBvSVbeQeTE8ByB/Zoiwgyr+qSbWQ3df5jDYvnpQPj7Iwr0XP2k1zm7OHZ3InXVx6WLe/+guAefV/eN6aguI+aT3SL7CqSIMg2G+Ndm2zmszoszftAt7M8dGFg50B1z+4E0zg7nJo1dlvcIo34itO3yDlDZQKwizcRBXV36Rcs2y/JhwB+Y8CC1RaE0+YWWzDIGxJOXNk7obnQR6cEpNOR1OyN1rBKvTPfgbiDOV44njqHrxRqUTDpYA8z9yrtu6zVrCzkdFKwZDKwDdyD91kz+6AK3HbOfsezyx6AW9zDi1mrRX/qBj/H05bXu5ubz9azXrnAU2qnYe2xJrs2Mk3HaF30GUjUyeuJhCOnqpS1RqIkPRBjp36rUZwDb0IiHHtBXJioj8MO4S6WU6cIdOIDR2I8U7tLEm3xdJIM9w6AViviIeUrnX3BmnerenA2sRM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c45306-47d5-43a5-d331-08d7fd353672
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2020 03:15:28.3753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J8CPhIlxmQcgdw6rDljly3bWZfYJ0GpT4A52cVYiuguhI/JMiYTrdtH9oR18nc4HVXMELwUIc04UumsOvKycng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3431
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Thursday, May 21, 2020 1:03 AM
> On Wed, May 20, 2020 at 04:31:55PM +0800, fugang.duan@nxp.com wrote:
> > From: Fugang Duan <fugang.duan@nxp.com>
> >
> > Update the gpr property to define gpr register offset and bit in DT.
> >
> > Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> > ---
> >  arch/arm/boot/dts/imx6qdl.dtsi | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/boot/dts/imx6qdl.dtsi
> > b/arch/arm/boot/dts/imx6qdl.dtsi index 98da446..a4a68b7 100644
> > --- a/arch/arm/boot/dts/imx6qdl.dtsi
> > +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> > @@ -1045,7 +1045,7 @@
> >                                        <&clks
> IMX6QDL_CLK_ENET>,
> >                                        <&clks
> IMX6QDL_CLK_ENET_REF>;
> >                               clock-names =3D "ipg", "ahb", "ptp";
> > -                             gpr =3D <&gpr>;
> > +                             gpr =3D <&gpr 0x34 27>;
> >                               status =3D "disabled";
> >                       };
>=20
> Hi Andy
>=20
> This is the same values as hard coded, so no change here.
>=20
> The next patch does not use grp at all. So it is unclear to me if you act=
ually
> make use of what you just added. I don't see anywhere
>=20
> gpr =3D <&gpr 0x42 24>;
>=20
> which is the whole point of this change, being able to specify different =
values.
>=20
>       Andrew

Andrew, patch#1 in the series will parse the property to get register offse=
t and bit.
Patch#2 describes the property format as below:
       <&gpr req_gpr req_bit>.
        gpr is the phandle to general purpose register node.
        req_gpr is the gpr register offset for ENET stop request.
        req_bit is the gpr bit offset for ENET stop request.

All i.MX support wake-on-lan, imx6q/dl/qp is the first platforms in upstrea=
m to support it.
As you know, most of i.MX chips has two ethernet instances, they have diffe=
rent gpr bit.

gpr is used to enter/exit stop mode for soc. So it can be defined in dtsi f=
ile.
"fsl,magic-packet;" property is define the board wakeup capability.

I am not sure whether above information is clear for you why to add the pat=
ch set.

Andy
