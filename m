Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF4B17E0FA
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 14:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgCINVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 09:21:21 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:62209
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbgCINVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 09:21:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwrFUvO6SkW0okYneronPCCh/EHfbhgJwSq9ofGM2Y8zDAgnssI9NntsytQw3lVGzSDLgQZcXHcV+F9Cav8v7B51q+WQNhrNmQvmb60aOo6xp0PA7rKxhGCiDP4lDEVjdtG9euosWs7lgfUVygG5kjOL3iqG9AOmidba5fzngo46e1Mp+vZnlgWS9DfrsokqBV/cg95OCfpnSiUEwDL2jj0cVoj6anraE/YFp32QIq49b4LIFHT0RM0Ii+f8YV5gasrlRHkOjqJQKD3QNcRdVhCgozGvi5dVW+Kj7he71xfKFO/3lHp3U+NUjnFQf2PiPNqFWjQ4+WNaivthDnzjiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4EI7csRz41xx0k3DpmA6ScMUgCPC+13tpBzn9/f3UM=;
 b=VoJUhhGkq8lwhexmXDRkoaPgMFQcGYlGn7jsyiJ+Uq1lKIwP5AC2IdXDBwJky+tSrCjfpuGmrbb7EfvkFWTXodQ7M2BHtwuFBQgjeiTCtOtMmi8Esa7CFTQiqjUHy99XI9av6OU7jA+V0K1fxbf9zFv5GCB9MAhjyvolvvtLxjslxMnSB99BrjEvH6l6AcfvXLBF3/CWQ6oIvgnu6k8E024Q1YPF9h0/84UHSeo1DVyJDhpIpg2uYsj7YcFhdYCMVnBM81VN/hYADgLVfBg4eCMrRdxSkHH1l5NnN2tvJsLByW+YLP0OuHmZyCzO/m6HsbPjRLMfMzJHOpdFt2oeSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4EI7csRz41xx0k3DpmA6ScMUgCPC+13tpBzn9/f3UM=;
 b=gAIF9fJi82xEXjU3iJi/F72UKIrZnEJkrL2Ovpo0ZFkQ9SaIlETmoSVYkAip4xt1Ukg5vEZM35icrMJlVez0I/wARezCh83XnTV+WacGJBJwf6zhh72B2+CqNNV+qHJwRQsHG0pXNBYl7Sb4LpyL5+nV8M/0SYGycKOblLrB2Tw=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6553.eurprd04.prod.outlook.com (20.179.251.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Mon, 9 Mar 2020 13:21:17 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 13:21:17 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC address in
 device tree
Thread-Topic: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC address
 in device tree
Thread-Index: AQHV8xDKCmlsCwFVDU66wdJgWzXM/qg/1tGAgAA6gLCAADCsAIAAAs7w
Date:   Mon, 9 Mar 2020 13:21:16 +0000
Message-ID: <DB8PR04MB698525B2380A452FADDF9D81ECFE0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1583428138-12733-3-git-send-email-madalin.bucur@oss.nxp.com>
 <20200309064635.GB3335@pengutronix.de>
 <DB8PR04MB6985A0B6A4811DCD5C7B8A6AECFE0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200309131010.GM3335@pengutronix.de>
In-Reply-To: <20200309131010.GM3335@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4d21519a-e5e8-459c-8158-08d7c42cbfc7
x-ms-traffictypediagnostic: DB8PR04MB6553:|DB8PR04MB6553:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB65535BF632B06BE58632853EADFE0@DB8PR04MB6553.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(199004)(189003)(5660300002)(76116006)(71200400001)(55016002)(33656002)(26005)(316002)(66446008)(66556008)(64756008)(66476007)(4326008)(9686003)(66946007)(2906002)(7696005)(8936002)(6506007)(53546011)(81166006)(81156014)(478600001)(8676002)(86362001)(52536014)(54906003)(186003)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6553;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tfY4MBksPupG4kRgFsK+LyhTEglnBau6A7Ftp/9E8zQV2U9X7SjeZeQ/xuAL+exNr3Sg17h325DeTTLLLhxngjuKjccoIDrO946Xk5hoUl8Gj9p072oRepdTAhzM6jxgdlV5LC/AUeOZVBsYMOHrIE/LeDFIQeIx5q+o9RxdcE5/A790MHzX5I+FhrcpqxSY1nu18lCiDwQqgsLZKZypDN+opJZ29/emA2zCjN3E8mYCTWMcBdjiIKWdXJIURdvtk8q2waR91xEFRXyxCttskW+TgickjN2PVchlPpBhDhTp9LcJfDuQ9c9+HXUhkVFtF6vAoyGRUnW/5Co1Lw1HRDj3Ie+/GDA1lJX5bK091Ec27tTW2geqoqSiM/spUUDvb6AW9E5gTRNikYJcq6GZ4vqwCRDvQgvQNLcsJphlNmxkP7Azvsqeb+4Sf4wuZTiH
x-ms-exchange-antispam-messagedata: IfdghW6BtS+qPVauima9WmwsOBeP5rdZ+iy7T6R/PbJm5o5KIY3jk9aPKnYKTvOkMhbSGfFbnbUZ48bFFmGKpsToWW03GZI6JL5ccdHpwQsU7qJVH/fqk9nxiAulHqcVQgrpqoGpuOU4hoKqLTXhMw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d21519a-e5e8-459c-8158-08d7c42cbfc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 13:21:17.0605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o1F3/6sRHul5lADmc4Yt9oZ0rm1L1VPmF3MM4c8S/4jI7x8k/krzoF+x6nU3B9gx1IPTDK1D5vLzrBcmIVK+7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Monday, March 9, 2020 3:10 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC
> address in device tree
>=20
> On Mon, Mar 09, 2020 at 10:17:36AM +0000, Madalin Bucur (OSS) wrote:
> > > -----Original Message-----
> > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > Sent: Monday, March 9, 2020 8:47 AM
> > > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > > Cc: davem@davemloft.net; netdev@vger.kernel.org
> > > Subject: Re: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC
> > > address in device tree
> > >
> > > On Thu, Mar 05, 2020 at 07:08:57PM +0200, Madalin Bucur wrote:
> > > > Allow the initialization of the MAC to be performed even if the
> > > > device tree does not provide a valid MAC address. Later a random
> > > > MAC address should be assigned by the Ethernet driver.
> > > >
> > > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > > Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > > ---
> > > >  drivers/net/ethernet/freescale/fman/fman_dtsec.c | 10 ++++------
> > > >  drivers/net/ethernet/freescale/fman/fman_memac.c | 10 ++++------
> > > >  drivers/net/ethernet/freescale/fman/fman_tgec.c  | 10 ++++------
> > > >  drivers/net/ethernet/freescale/fman/mac.c        | 13 ++++++------
> -
> > > >  4 files changed, 18 insertions(+), 25 deletions(-)
> > > >
> > <snip>
> > > >  	/* Get the MAC address */
> > > >  	mac_addr =3D of_get_mac_address(mac_node);
> > > > -	if (IS_ERR(mac_addr)) {
> > > > -		dev_err(dev, "of_get_mac_address(%pOF) failed\n",
> mac_node);
> > > > -		err =3D -EINVAL;
> > > > -		goto _return_of_get_parent;
> > > > -	}
> > > > -	ether_addr_copy(mac_dev->addr, mac_addr);
> > > > +	if (IS_ERR(mac_addr))
> > > > +		dev_warn(dev, "of_get_mac_address(%pOF) failed\n",
> mac_node);
> > >
> > > Why this warning? There's nothing wrong with not providing the MAC in
> > > the device tree.
> > >
> > > Sascha
> >
> > Actually, there is, most likely it's the result of misconfiguration so
> one
> > must be made aware of it.
>=20
> In my case it's not, that's why I wanted to allow random MACs in the
> first place ;)
>=20
> On our hardware the MAC addresses are stored in some flash in a special
> format. There's no need to port parsing of that format into the
> bootloader, the existing userspace code does that well and sets the
> desired MAC addresses, but only if the devices do not fail during probe
> due to the lack of valid MAC addresses.
>=20
> Sascha

What MAC address does the bootloader use then?
