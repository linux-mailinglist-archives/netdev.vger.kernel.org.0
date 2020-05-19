Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989F91D912E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgESHjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:39:01 -0400
Received: from mail-eopbgr30058.outbound.protection.outlook.com ([40.107.3.58]:43502
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbgESHjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 03:39:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hI+A7SqgUD7O653UFjGn01EEer8kKbaFO8Vc89kj0N86BCSEvAo+x9mQxu/EWJ7b9Ffhhno07U+05hLB0hLnVD9Q1Bi0J6LmYq0QA07o+7LS3tqJAghTW5PgFaI29gAkVFtp3521cHHakEbdw0hqcN2ts2n8KnbfsDNba0FaMjTvQwKHs8Ogq5an4YOarbzpFOEZZ2Rc3sPme4ZGUsHe4RG+budLPWLOmhvMZvrZ3216LuIEl3WKX//miMYVUfeknGNBjAD+i52jQwbw3tc4eugUOcJ50DPiXF9lnFmJk1gwii8jWoKWlwgdQD3v2HPQsEsurpUkPG1YprW0gt1VKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9WDi62XlokfVe4Eh7F4qPXsvEJSOxa6cWTpIrb3Xd0=;
 b=g7hcZSymN91JTt7S1fG55HiRfSCKv87svmoDeDAATmBAURMMZBrOHmLBGTUUAuytNHrJ40X3fWa05wr34FH116k5/2iQ/iEGomUflm1crGKWoQkDmFAnHqR9CzF95ePO3EuwV7xe+HVMdIbhERG+y/+3u7/HktItsGsPKvU4lKnQe9SSOlpcS9RfHjmojlPyYGtImHFCRHw5LtSdON2uv0EBt8ZoV4Dl0GXrp/pMW5PzGk8nOUC4zMiN9jeLGnxRCFFdt+O4sUSKYOxnME5T4RKcgiQwW/0ZNKp8UQiGlLCx8T4Pc8deEepQPunhJRSm8e2g1B4PQICNs5DD0TtAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9WDi62XlokfVe4Eh7F4qPXsvEJSOxa6cWTpIrb3Xd0=;
 b=HaWTYpuO7v9kFjsUHydxCDPivr1fKyI1fRXhq3xaypVQ+wvnTZJlLnyAvq5DDv74QblUlwj5A7nqRg9hUPkIWBLbLajp8MN6oD38V/Nq6ogpCHVSqPSfs4pXZKpc88tGTI6A3VYRfV8RhjXy5ETNGcEZXIulrh8KG6MXTBRlkks=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2942.eurprd04.prod.outlook.com
 (2603:10a6:800:b5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Tue, 19 May
 2020 07:38:57 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3000.033; Tue, 19 May 2020
 07:38:57 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Topic: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Index: AQHWKulbmiq87o7Yx0yuJ8Tm2Q7xY6iphgOAgAACOECAAAN2gIAAEXFggAAcYgCAAKFaYIAD5lUAgADH7GA=
Date:   Tue, 19 May 2020 07:38:57 +0000
Message-ID: <VI1PR0402MB387101A0B3D3382B08DBE07CE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 081d2d72-ff4a-43be-3e26-08d7fbc7b0b9
x-ms-traffictypediagnostic: VI1PR0402MB2942:
x-microsoft-antispam-prvs: <VI1PR0402MB29421DF3D4B585A000B1B8A3E0B90@VI1PR0402MB2942.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 040866B734
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5RoN6iYbSbCbYxgzsrqiuJclaLcBBx/iSDiIt2+/MTkPjQFMB2qoluLLVe/cehVqQSJOAiKNk3gyqKVQB8B0p83XMxPK7xQMqAD5pGJPDEv8L3llDYJqk6RBw715oqp62EPfGn16LCBO1VDVpBmrL8sDX4BpMbuazLmqkCYwveIh0QbvsA/4h1PVAT4hRpLAarpd2h4s+gMTgjEgS9xRD57nZ/9suQfTLM8OrhJ/9jH/+AZANXKUUWuD/I9DfAtBt4vYBqOyCaYV35yupVIGc0SM2LEbL5LnclrH0xE/YDXJWxJAxiCn1IJIdvGtVPbuxB2//tO5EjpnVYoxdE1P0yA+gqAoxZyx2R3lhngXNodidD2Qz2BCsBWGgprQN/iJEqD/9bMXerVqPWDt6VgXaDUXTbxvQ7rmFCTjNnJwtXstGsnumMTsTAr5BUiAHnDe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(44832011)(8936002)(9686003)(55016002)(316002)(54906003)(33656002)(2906002)(86362001)(8676002)(52536014)(6916009)(7696005)(71200400001)(6506007)(66556008)(4744005)(66446008)(64756008)(76116006)(66946007)(186003)(26005)(66476007)(5660300002)(4326008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7Z6QNHBYPwY0L6fiKocvmT+Q6lQd3Pwda+Ai8DnQxoMwcTmLmK+e6ee6/ZQBQyIVlKw4GUW3G8bYH3OoHkexNyx4qVmlcq+a2b+BCx44GMjKIFgJibAJTOH9Cq5jNGFamcq385UbRxvc7dKgsV1s4n2ll2XbFlKNZrqYCn5YNQcCC0o7Gfm3BhyRqHbwsUbeRNC7w+ciICw7rG3B0VeQ3F6SVcH1g8BhrsxdE8SqvvrdwA3Lvw/Pc7D5tMUozCNfA12oyzWfQPKja87Taftpm6QNsnpvmwkUHX2vZWuKpUa1K40U0gQRF07pBVmc+SErY80C/X1O2fgnZ/+0+jdJJIRRgy/o15lNya6h6I44nrDJPrNV1bZv4jbbDb1kJMUzhy/zcGYT7IGvoHGlq0OreyChFgQdLI0X8Qokd2DuvHBgGGsRyW+Y6IVCLQKg4ong8ctg4N3c4rMwN/0+TNRm+1jm3miPKgCIURqlP14MCqW+CZQWtyRBYLmHQVJUkCaE
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 081d2d72-ff4a-43be-3e26-08d7fbc7b0b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2020 07:38:57.7118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tMMjuU6EmRJ+Ka5NCMI/0YHQdi+Ec3qCkT4Pt9LFGF4mJDoY+M9MO0nLI4CDrgCwpV9TdoSBO9975yMaezZISw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2942
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffi=
c
> classes
>=20
> On Sat, 16 May 2020 08:16:47 +0000 Ioana Ciornei wrote:
> > > With the Rx QoS features users won't even be able to tell via
> > > standard Linux interfaces what the config was.
> >
> > Ok, that is true. So how should this information be exported to the use=
r?
>=20
> I believe no such interface currently exists.

I am having a bit of trouble understanding what should be the route for thi=
s feature to get accepted.

Is the problem having the classification to a TC based on the VLAN PCP or i=
s there anything else?

Regards,
Ioana
