Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB08276908
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 08:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgIXGga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 02:36:30 -0400
Received: from mail-eopbgr10064.outbound.protection.outlook.com ([40.107.1.64]:34469
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726883AbgIXGg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 02:36:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Des6GC92Zmb0QXgGdm6speyqFWD9RYT2NefuimfqlLDtSAJXyQCu2Z6OqxfaR3L/z4pfIzEDb4Fqo4tBnZ/KQLtnbOdyjpAJHFnCfr9DLmMvOwoboR28EtEv8kjCbYg0a9tEUnqiLkisn3EDvvQu8V266pePkHguL1iPiXZt1orWIqgia5gh7+tSwdR77pos5UhUA08hTM/eLOwEPi7w78cXlnRopZNMISvnQB6rIGnnMvM2TWyMBPepqglqJ6lR+qcGzTVB8FZXu+o1RqkzNOLfL4Vujbfy1vltv7eZiHd68kC9EZ9uN+JNlQxwL25NC6anUr842XPyG7ASTCkH/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LWMfHw2H6XWIGPMGs1NHqKL2t5/48/X0u6ZR235v6k=;
 b=j6LGnEd7xZIjYFM6LTtstshHqaFCoerJoMNniq6LSJjPESgTdtjHnlF9usApbwwuQBjhibOd8yX2L4V9Nx+zWTwpuF1YjWgntAUarlNQBOPH9W9ce2qf6E6aIZzDGqMQVeoJGXuagLrQ8ab/zbfrsJVZPm4fsMs/ktKTNvUuQdu4GnhSyuwX363DV8+nIn9stRGy4Y5didt8dMbbV1dmDNmyMVTCgLqLP6TbrO9S1gih8zrlYkqOEQ3ethzm3frMspd+85xTkJ3SSUUwQ8HISI4YwFm4BNYlrsXRdWotqqeX1C55GmYmwQVqiiPC0Pp8DbL5MCzpzN4AiOrZBkyKJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LWMfHw2H6XWIGPMGs1NHqKL2t5/48/X0u6ZR235v6k=;
 b=oe8dqcsgsEltZt6VwStbaRXeDrIS+q+p6/rHN7riujUqeNEuO7BaQ6BZUKJcg2/yinevO5xAARzgxXmefz1+KZSmT688614oPyBuCnPSULF+DDkwazzfhPWIU/zYp7XVZbPtEUSe942DBu50lQhHlAS2nX7mKG79ytcBNh8I+Y8=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR04MB5300.eurprd04.prod.outlook.com (2603:10a6:208:ce::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Thu, 24 Sep
 2020 06:36:24 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3391.027; Thu, 24 Sep 2020
 06:36:24 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "s.riedmueller@phytec.de" <s.riedmueller@phytec.de>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "c.hemp@phytec.de" <C.Hemp@phytec.de>
Subject: RE: [EXT] Re: [PATCH] net: fec: Keep device numbering consistent with
 datasheet
Thread-Topic: [EXT] Re: [PATCH] net: fec: Keep device numbering consistent
 with datasheet
Thread-Index: AQHWkeiSkXIST9DqEkyz5X1b6oJps6l3VTrw
Date:   Thu, 24 Sep 2020 06:36:23 +0000
Message-ID: <AM8PR04MB73153F8A9E3A4DB0F7AA8003FF390@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <20200923142528.303730-1-s.riedmueller@phytec.de>
 <20200923.133147.842604978902817779.davem@davemloft.net>
In-Reply-To: <20200923.133147.842604978902817779.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 47d3a35b-cadd-4faf-f611-08d860542832
x-ms-traffictypediagnostic: AM0PR04MB5300:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <AM0PR04MB5300077CA6206B9F859E818FFF390@AM0PR04MB5300.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:287;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vTm+lNkWv5MKUK5u1qCcCoTQsPVvwJ1hnimlIcby3HmTEsThMICX9yHUmwEO3O/p6KkyhbuAHCNseAkhMVrgoF/EfINIvk/He70jUZLBcUKmZ5XHN1ZCaQp0mqomP+0DN1uMMl67MJH8XZFQItqjyva23xn1PeMd4sYNcPOyL4fp/qe/gVWZvXTMPa6bZgteyBN7tSrwOqhtIZufiaG/TBa+FrZDmq6V0AOFvHQ8q42pF7+YKuArnmn5VOR7l44V9e66TGTdFQroI8dvm0cNXFMAzwWfhU7ab6fKd4Drr59ZTd5+EH0st2KrXTWbXh2Y2bWL4ZExjtJnldHe4L1BTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(6506007)(4326008)(26005)(52536014)(64756008)(186003)(71200400001)(54906003)(316002)(110136005)(7696005)(8936002)(8676002)(76116006)(66446008)(5660300002)(66946007)(66556008)(33656002)(478600001)(66476007)(83380400001)(9686003)(86362001)(2906002)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7Bv/iXOE/CKLfFdA4O02srAfUmrtVvXKZTRdJ9I0HaJISJbuGnCxLUrSgJ2TPjPq+kt1vMQcv/jbQHxKF+RMDOMd+D+kzWWuZeXrTLJZxhxjxUQojvgfyExq4qxSb2jagb96BGLm2/SgKdAMNo0y/F3SIkB13bTbeu+5GfcCw8rbcr5Af9dn8nuqem6S7Dio6gF4idRYSv0UUlgayi32kI3/lDWlCZdvYIbhPdY58JUGyrh/FnY+6fU1T12czQ9tz/8TAcf8havKPtB4lGnfCvNRAVnujlHckxRTQw8D2u3Jq4uidS9Y53NLXVwvGUp6XdpqgCyyp22ThGKzlMDzsf4fOLQxXkSSY+Q7wG3eUpOhS5gbG381A0z7G08QTSlrzlpiRDW1yWEI+R7dyyMbKsxAktv2NGCxpC2qJ+KslKh3XUn48XY2aoIjo4zXHmdaIxLlIA7ZZuDdX5JJnER6WZ2CbkCQ4q+KGtH5QWdPo6O0TcDGM67CsTOBnlbGms5gIjRIt9cQpgJew1ht8+hAGFDkF0hPqT8N5XMs3Sqk0xFlslPMfefri3NZ3+j0xdLGebTMLBC/11CMaQ+oqcM7I9yhJa2VYQ1cvNITavm3f+ALTnHf0lkuKtin1rUpjoFVvk3xkTyaViryBGL4IyTuqA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d3a35b-cadd-4faf-f611-08d860542832
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 06:36:23.9598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gfI3fvLH9TIIBMxFoGnHXFoLGc8DXTFlpqjdUdpZ0zL4+S2BLceT/F4/JdwaWRVVay25rqyMspluoeCs/FFZHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5300
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Thursday, September 24, 2020=
 4:32 AM
> From: Stefan Riedmueller <s.riedmueller@phytec.de>
> Date: Wed, 23 Sep 2020 16:25:28 +0200
>=20
> > From: Christian Hemp <c.hemp@phytec.de>
> >
> > Make use of device tree alias for device enumeration to keep the
> > device order consistent with the naming in the datasheet.
> >
> > Otherwise for the i.MX 6UL/ULL the ENET1 interface is enumerated as
> > eth1 and ENET2 as eth0.
> >
> > Signed-off-by: Christian Hemp <c.hemp@phytec.de>
> > Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
>=20
> Device naming and ordering for networking devices was never, ever,
> guaranteed.
>=20
> Use udev or similar.
>=20
> > @@ -3691,6 +3692,10 @@ fec_probe(struct platform_device *pdev)
> >
> >       ndev->max_mtu =3D PKT_MAXBUF_SIZE - ETH_HLEN - ETH_FCS_LEN;
> >
> > +     eth_id =3D of_alias_get_id(pdev->dev.of_node, "ethernet");
> > +     if (eth_id >=3D 0)
> > +             sprintf(ndev->name, "eth%d", eth_id);
>=20
> You can't ever just write into ndev->name, what if another networking dev=
ice is
> already using that name?
>=20
> This change is incorrect on many levels.

David is correct.

For example, imx8DXL has ethernet0 is EQOS TSN, ethernet1 is FEC.
EQOS TSN is andother driver and is registered early, the dev->name is eth0.
So the patch will bring conflict in such case.

Andy
