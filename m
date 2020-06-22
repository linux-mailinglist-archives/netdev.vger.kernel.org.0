Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E11203873
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgFVNuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:50:18 -0400
Received: from mail-db8eur05on2064.outbound.protection.outlook.com ([40.107.20.64]:9569
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728070AbgFVNuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:50:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wl4pdUObpnS7pihCeGBpIo1Fj5sK3IsJfb3CFEVeYmqJgYrGsu6RSvIk0Y+XZfuiqAGRd3K2HlWoVSvA1DAUSLC3zAkMH9VbMOjptSrIxcXSsX4A3xqFzc0+KaOtolNfXJuqwvjtRSAcaUf/PECkZ9Na1vxnCyUNk5bgTpbOP5WrKXreJkr77CjKxKcito68hROzM/TXQIequQUcOWq1HChz1eF2dKQm4d3qNCyf0JpEap9JV1yTbjyn4ptLgBtoSERmCZ9RSQJAbilq40GpqVAy7Tb6miia4DCW3OzuhM/AVIC2iUh8X7s2jjf8Zgq+8GfS8WpRR8dZPLaYL6XjYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjhwGnD09Ricfrw7Tq6LhUpuHUNJNAsAII19b0RAros=;
 b=E6T7tuP/zvAIBxpkG12tuHptA350DGds+E68u50IJDbGSqKRP/EsUmbNOxUKEWLnkUpXEy2EkBY7Y4X+SDLgAHLjip0o3+0WXylVtqWCIngr0xB/hmraN2Nt0gKKghwS+7oP1dH5kRYmnu9bRoIYZnFzu0h6lh1HyKMNsQ+aOHL5Xfp1KslsRGuvD4mX+Oq6Fw5x0gO/VZjiGjNEsoLAGHOJ70nWfuqnsjCiFmXlS72IKqNGXxpy+Z5VYzHmuHdFmnLdxNM+F/1XTtFwMqwWy9cCzQvuVYqq+pxEfy4MEdSfy0lChZ+ggGWOAWRfmnNekpKKG6mkE2iRhnoc01zgjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjhwGnD09Ricfrw7Tq6LhUpuHUNJNAsAII19b0RAros=;
 b=oV9mxgtiom+tbEqlgsawrvlsmwiZJVTX4/BwVT/X99BiqvKk5/8rJ2vm98MrQ3swelm6GrGOef/llMydbtTsTbcmHpJofFd+H62QKtsgXRCJfywdywB36Z3PPV5ZjB8B/m+m/aaVBhfgHXQU55vcxxQg73gr0lZv7sIheaiXBI4=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB6817.eurprd04.prod.outlook.com (2603:10a6:208:17e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:50:14 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:50:14 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: Recall: [PATCH net-next v2 0/9] net: ethernet backplane support on
 DPAA1
Thread-Topic: [PATCH net-next v2 0/9] net: ethernet backplane support on DPAA1
Thread-Index: AQHWSJwOAno3TgjUZkah2+vhNfRhzA==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 35
X-FaxNumberOfPages: 0
Date:   Mon, 22 Jun 2020 13:50:14 +0000
Message-ID: <AM0PR04MB5443D44627B43E3413BF6D45FB970@AM0PR04MB5443.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.126.7.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d06391c0-58a3-4484-9027-08d816b330dd
x-ms-traffictypediagnostic: AM0PR04MB6817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6817542175EB7F6929C86C98FB970@AM0PR04MB6817.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0442E569BC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hnpGHENa25Km29R2BxnTOxGGkrC+wTUJGjvbgdWC/6OMeFWxKRF/J8/yWtWXMDmpyPEUB/XV3iSmu6dvkbriqwupI+/6fHEtQVpU6JEr52u4v2UIueagYHQTIDaao9488lbWsmV409MEPDjnr1vDCz7hJXM/JIa5P7Y5xyWK7kqEjugJtqG+K6NMy+6i7mw5VnS2rLR6HpEjWrfP4NMH3yyPGgwbefu4GTl5QzK9LsOzBrG3tTf/tPGHZqd/V5Hbf4hZF/vCbQOrqR87qV4FjEmm5ABoFEalI+jMAnvNvC6+2/7p2oSPgOhg1HgTxka6Q7utBS84ZB4QFNhN2TrU9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(8936002)(5660300002)(110136005)(558084003)(54906003)(8676002)(2906002)(4326008)(66556008)(55016002)(9686003)(83380400001)(64756008)(66476007)(66946007)(478600001)(44832011)(7416002)(186003)(33656002)(86362001)(76116006)(7696005)(71200400001)(52536014)(26005)(66446008)(6506007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: kxQz2NRG1exk2vS0SE8qM8v4xkqy/v6UwKe7z1RiDDcuW//OMX8eSpM+YgmLi9kydHlytHFHv+Qz8lNPJjg5jbGxRxJExLFVH0GGWM85YzZyK15WD3IPGpQsanaXKq5otABaC6uvuekF4gsnDFi4LlH+rk9e209/ffibJf1/x3SGrKZCFQGScCO0fvil4aC4nTIV2X/765gmDhGTBPzjOJK9rlApUmsiCtciF6NGnsd0RsHUeAZmbp/psgwpEj4WaV2ehlq7XTHcwqJ41IkFaunhqt1V/RybeyUCrGQf+DIG+M2jpp3nkWk6X4N6pYph+NG3o/nacH3gSR/ZRT+fGG+g9uJyZ+m5yqeUgivFeIIlFQqODg5EEEAxb6Xbj+3Ab4zw1oC4kQjub7ZMFhpNlC2OM3FhgYCCJNssLAPEH8GAFmIFtOA0/B6zaVi4Oe/zuQiU/15awSKki0z7pU139w8wJ5Vgd97ZaWKLbiYk1iQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d06391c0-58a3-4484-9027-08d816b330dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2020 13:50:14.6969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6pI6pq0nYjVzxcSp6om1wi8O18Z7u+Q5q0c++Fe2HHOjLgbbpKc4xz32IEvSBI134umBF2sTbEUQGzrEhGGcljFer9zaI0kNPAkNq5Qbjjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florinel Iordache would like to recall the message, "[PATCH net-next v2 0/9=
] net: ethernet backplane support on DPAA1".=
