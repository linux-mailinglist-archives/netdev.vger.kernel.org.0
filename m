Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C19C1E11F2
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404229AbgEYPlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:41:44 -0400
Received: from mail-vi1eur05on2063.outbound.protection.outlook.com ([40.107.21.63]:37056
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404002AbgEYPlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 11:41:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADgy64uPpnftadeO4Gex39UasUhx9MRMBTkYZIPXB8CmJNwM9ughoZneAdowrHfcbaAKVU4QBYWeCs4SXLku8j7K06ZbVtouUNUcMuybWvI66eD2ux+qRNnCdY2vHAT3Y2+ItDDD16u1Km9H9Z4ZTA2JCcXnkajNtoTUDLVTA+6SIFhTImoOKFd4uTGU4N6iwr/UsrJ99ZnzyNNz0AUDFmh8lky4Yc/FSTrNiwns6V+6nVJYMfZ+xtpgfB/N+zdRgZU+iiciWM/U6RF2xsS4A2yic1Q0A9N9D1gM0ylGNkXdjxVLwMYRNpldRSFxeno7Wbocrc8khuBA90dvlLfmWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qm8owt2LbOfRXb3wMAHGy0A4eBQUxtbzO9NcrK/bRMQ=;
 b=dlKa+bx4DwF3sfLOhryBGBcl5AJgpUtGNoCDY5Z4ohrLnmUohxgVYTgwA/IqDk3aVARKg7+JbM16NKnDIewmt2LOImd5Dcg5kQeLVzbdzmqAw4D1yKfOq6R19xserwgczED4tdvrpcIQmERYGAPyxc9laGq2dAVTtxxtoQSW+Po/4vrP3Cc7kQOXv5A1+xEVUPtM53btJtMF7+tDxbXEbqN0l+mAt67GNsTvT3cOLMqFaZ4vqbBv/OXX5nJjxS/SLkgpCq+/0fgGerpWaVFwm8bxx0eIZtnsvocuAQYE2TJvYD1mlaMVwnz5dCF3JJXnwG5ivN0IjA1HZ8t8Sv81ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qm8owt2LbOfRXb3wMAHGy0A4eBQUxtbzO9NcrK/bRMQ=;
 b=Ts8RXt7IONrtXR8h1l8rNF3zrRiDUi8W1Z5Z274LE84emchSGvrQBoVg2DF9PudKQwgy4H/D0Gp0SI7PQjRbZKYNY3m5GCO6mdWkGMzlYkvtUcdIN9p+ARabhKNMDd3tHJai8XsAZ9MmLDlY52/HoT5N43KWudmyeev85QzfQJ4=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3400.eurprd04.prod.outlook.com
 (2603:10a6:209:3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 15:41:40 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 15:41:40 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "martin.fuzzey@flowbird.group" <martin.fuzzey@flowbird.group>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [EXT] Re: [PATCH net v2 0/4] net: ethernet: fec: move GPR
 reigster offset and bit into DT
Thread-Topic: [EXT] Re: [PATCH net v2 0/4] net: ethernet: fec: move GPR
 reigster offset and bit into DT
Thread-Index: AQHWMmQZlaL31WXVCEyjTrjOYIQ80Ki400GAgAAdkWA=
Date:   Mon, 25 May 2020 15:41:40 +0000
Message-ID: <AM6PR0402MB3607362AAEB1B5B5182F190BFFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
 <20200525135433.GD752669@lunn.ch>
In-Reply-To: <20200525135433.GD752669@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d5ad6cbf-11de-4cc0-4886-08d800c21e51
x-ms-traffictypediagnostic: AM6PR0402MB3400:
x-microsoft-antispam-prvs: <AM6PR0402MB34009E4EE42FEA394319E645FFB30@AM6PR0402MB3400.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 87JG6AleLfGeZghYS7y6Ae2PxzdinhpqSHVPDS2feBvWChoeR8q0zvp4xL5+C3y+SYVUDDccxrefBQnWyCPkJpmy+dDaMKiZwmy5xJ0Zm9XG8AWD83v23U/9oi35WqBb2/dMsoHuodlscU42JuL55kaqGFaZMB+WNfRp7JgVS2Sype6u+cJ2lQTn7eIKE3rco662QkKijAJPKLmAN1FpiaIkcM/ZjXSy/TCJEmOESow9vL0MrGklBupgaHo70JSM0VHaQ71uCXvMTSpl2cYUZWSxPX9GfA/FlaRV8CgMIRUJ0jhau+lCd1NFdcGu0+JK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(5660300002)(86362001)(2906002)(33656002)(4326008)(66946007)(6916009)(66476007)(9686003)(55016002)(76116006)(66556008)(66446008)(478600001)(64756008)(8676002)(71200400001)(52536014)(8936002)(316002)(7696005)(54906003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DEj/DGUTWY2eTFJTV1XBlw58d/6YCmh9FMowcfXqZqEBTSp3SGyrKJOhpl7q816hecl/oHntkCnoL2ECOMbXQAy+HTLRHOAxNy+gZpIoWxKMjImQvfv5dViQ7Buuoo5f9aikgtpDhqaEVBKwCYDyfDJ0/SaKno4NiNjiQJUwzD2BtFuCLvgh1qG/WKd8x+dImi0bPt5a4jAWU3q3KDnGH45EngreSZ7y/0M8hpIpncyanfZEGg07ewBwxg6znFkyJKrBRT5ql6iY40lX4tCf3CFUw+n63jVwZaf+4pPU6VEMMOOc6Tu8SdoP4iJE5LDtlzciM8hV/L+atQpGUf1S2u3mgi0rfLupT+yVssWGovM7VpeUobVliEFMjXQwA6SqEUYxU3UrtLL3+V6b73xXs2n2L41sP/aosxUFEeXA+83eZbN6sQjdN4IZxKcV4zIRA2TC1DaPd1erTMRBJwvespu22utw1h1V17TbKKQH0q5bp/u6EryEuF7McAZwJMgi
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ad6cbf-11de-4cc0-4886-08d800c21e51
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 15:41:40.4614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DgirErORgdOYrqJ4YOM8EGl01QO+ZE1E1FwUqUb6wRl4sCSGJBNnvQDpMcqZMIAcX/Nl8jVJ/Bs8XsT5Z5jqAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3400
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Monday, May 25, 2020 9:55 PM
> On Mon, May 25, 2020 at 03:09:25PM +0800, fugang.duan@nxp.com wrote:
> > From: Fugang Duan <fugang.duan@nxp.com>
> >
> > The commit da722186f654 (net: fec: set GPR bit on suspend by DT
> configuration) set the GPR reigster offset and bit in driver for wol feat=
ure.
>=20
> The cover letter gets committed as the merge commit message. So please
> wrap long longs.
>=20
> > It bring trouble to enable wol feature on imx6sx/imx6ul/imx7d
> > platforms that have multiple ethernet instances with different GPR bit
> > for stop mode control. So the patch set is to move GPR reigster
>=20
> register
>=20
Got it, will correct the typo in v3.

> > offset and bit define into DT, and enable
> > imx6q/imx6dl/imx6sx/imx6ul/imx7d stop mode support.
>=20
>=20
> >
> > Currently, below NXP i.MX boards support wol:
> > - imx6q/imx6dl sabresd
> > - imx6sx sabreauto
> > - imx7d sdb
> >
> > imx6q/imx6dl sarebsd board dts file miss the property "fsl,magic-packet=
;",
> so patch#4 is to add the property for stop mode support.
>=20
> sabresd?
>=20
>         Andrew

Thanks, I will correct the typo in v3.
