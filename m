Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C2D60F2E
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 08:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfGFGM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 02:12:57 -0400
Received: from mail-eopbgr40074.outbound.protection.outlook.com ([40.107.4.74]:45986
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbfGFGM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jul 2019 02:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3P/UW7OpiRxyjxk6+MC4odoCaVMIiUHp7Uxju1GoJM=;
 b=V+kNZ6GIueYEPfx964ScaaGA79uMaHG8XijyMoTuynlRXPgmClYtOLp6bOwZe+Z8jUGmCY3u6DgeJEtwJHnFSm+F6KOi4vsWZrYtmy86FTNQ7AOCTLWR8/O5VyaqoNhw46bTpsnubJGEqRAbFoJPCOieNWoJM5NqQ4gyPEuJa/Q=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5715.eurprd05.prod.outlook.com (20.178.115.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Sat, 6 Jul 2019 06:12:53 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.022; Sat, 6 Jul 2019
 06:12:53 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [PATCH net-next v2 1/3] devlink: Introduce PCI PF port flavour
 and port attribute
Thread-Topic: [PATCH net-next v2 1/3] devlink: Introduce PCI PF port flavour
 and port attribute
Thread-Index: AQHVMwSFKCVgLMJSOU6WBhNSekvzoqa8ZoEAgAC2+3A=
Date:   Sat, 6 Jul 2019 06:12:53 +0000
Message-ID: <AM0PR05MB48664EF828674A43BAE78954D1F40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190705073711.37854-1-parav@mellanox.com>
        <20190705073711.37854-2-parav@mellanox.com>
 <20190705121722.269711ed@cakuba.netronome.com>
In-Reply-To: <20190705121722.269711ed@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.16.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca9ace66-2280-4d59-41b6-08d701d8fb2f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5715;
x-ms-traffictypediagnostic: AM0PR05MB5715:
x-microsoft-antispam-prvs: <AM0PR05MB57152A137A7BD1AB34AC9B3CD1F40@AM0PR05MB5715.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(51914003)(13464003)(189003)(199004)(78486014)(6916009)(73956011)(2906002)(66476007)(66446008)(64756008)(66556008)(66946007)(8936002)(99286004)(305945005)(8676002)(81156014)(81166006)(86362001)(54906003)(478600001)(52536014)(6246003)(6436002)(71200400001)(7696005)(316002)(71190400001)(76116006)(256004)(74316002)(14454004)(68736007)(5660300002)(9686003)(33656002)(476003)(53546011)(186003)(55236004)(55016002)(26005)(11346002)(6506007)(25786009)(76176011)(7736002)(107886003)(66066001)(6116002)(486006)(4326008)(446003)(53936002)(3846002)(229853002)(9456002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5715;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n/okhkyzqXapkF90gPCnWVwGF3CZJNbu/if2E9piqjGoScgHv6TvIEkIzDbGffD5bbdw1D2E5g6sQbXwrcO8LS5asLyFZkgWyo5OXSAvVBgAuNNFa5cYn42KuG8P5Vjq2CPrRzvx3Ar0a83eBmo4mi5K0pwabkiORz1aq3zEkhzowu69gLqVS9VAxfZwsmeTHV//fOWYNS1j6rukaK2isfHI/aZsrta8vV4Vs2MY+JSNCKnmyA4onyrBqVnoOktXjwjZOxcMHXD5BclWYrOOGbnLzi2hx/QdA3KOkB7adJe3ACUdaIAZ3MjIP0ZcCFcZUSPCcpwxEhUjOvZtDdGsRlIRvRARdpHdXDO+FKMgLF9Jb2jrJQE5Pr2iukyOmL9Jru/0UvxVgJ1jRpUJYpesQ5IFSPaGGyJSi9qJArdNILA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9ace66-2280-4d59-41b6-08d701d8fb2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2019 06:12:53.3877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5715
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Saturday, July 6, 2019 12:47 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@mellanox.com>; Saeed Mahamee=
d
> <saeedm@mellanox.com>
> Subject: Re: [PATCH net-next v2 1/3] devlink: Introduce PCI PF port flavo=
ur and
> port attribute
>=20
> On Fri,  5 Jul 2019 02:37:09 -0500, Parav Pandit wrote:
> > @@ -38,14 +38,24 @@ struct devlink {
> >  	char priv[0] __aligned(NETDEV_ALIGN);  };
> >
> > +struct devlink_port_pci_pf_attrs {
> > +	u16 pf;	/* Associated PCI PF for this port. */
> > +};
> > +
> >  struct devlink_port_attrs {
> >  	u8 set:1,
> >  	   split:1,
> >  	   switch_port:1;
> >  	enum devlink_port_flavour flavour;
> > -	u32 port_number; /* same value as "split group" */
> > +	u32 port_number; /* same value as "split group".
> > +			  * Valid only when a port is physical and visible
> > +			  * to the user for a given port flavour.
> > +			  */
>=20
> port_number can be in the per-flavour union below.
>=20
Ack.
> >  	u32 split_subport_number;
>=20
> As can split_subport_number.
>=20
Ack.

> >  	struct netdev_phys_item_id switch_id;
> > +	union {
> > +		struct devlink_port_pci_pf_attrs pci_pf;
> > +	};
> >  };
> >
> >  struct devlink_port {
>=20
> > @@ -515,8 +523,14 @@ static int devlink_nl_port_attrs_put(struct sk_buf=
f
> *msg,
> >  		return 0;
> >  	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
> >  		return -EMSGSIZE;
> > -	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs-
> >port_number))
> > +	if (is_devlink_phy_port_num_supported(devlink_port) &&
> > +	    nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs-
> >port_number))
> >  		return -EMSGSIZE;
> > +	if (devlink_port->attrs.flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF) {
> > +		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
> > +				attrs->pci_pf.pf))
> > +			return -EMSGSIZE;
> > +	}
> >  	if (!attrs->split)
> >  		return 0;
> >  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP,
> > attrs->port_number))
>=20
> Split attributes as well, please:
>=20
Ack.
> On Tue, 2 Jul 2019 16:42:52 -0700, Jakub Kicinski wrote:
> > port_number, and split attributes should not be exposed for PCI ports.
>=20
> We have no clear semantics for those, yet, and the phys_port_name
> implementation in this patch doesn't handle split PCI, so let's leave the=
m out
> for now.
Ok. Sending v3.
Thanks for the review.
