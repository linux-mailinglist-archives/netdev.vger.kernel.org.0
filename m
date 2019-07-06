Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEB1612B0
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 20:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfGFSiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 14:38:07 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:23008
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726743AbfGFSiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jul 2019 14:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSIepDd7G42DM1m8sEQPeUAM4ulP/nBMmtu+BPtEKAc=;
 b=O32vkWkXzgfhT5yIAAEtIudVtpV94kuIlW6S/TeE0oW8y9DQSyThBLsCt/w4IUGYCZIuW4wSc4uDZym9pByH/W3yVVblZZ2YezNfHNh/mwzqZPgjCo9644UJeTgd7FNHnxQd24azE5ce1DSFtu7snrNe5YWaLEvyxPO/uGLAnQI=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6130.eurprd05.prod.outlook.com (20.178.119.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Sat, 6 Jul 2019 18:38:02 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2052.019; Sat, 6 Jul 2019
 18:38:02 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: RE: [PATCH net-next v3 1/3] devlink: Introduce PCI PF port flavour
 and port attribute
Thread-Topic: [PATCH net-next v3 1/3] devlink: Introduce PCI PF port flavour
 and port attribute
Thread-Index: AQHVM8JfW1WGPsgA30iIdq73vxbm7qa9H+OAgADMF5A=
Date:   Sat, 6 Jul 2019 18:38:01 +0000
Message-ID: <AM0PR05MB486635A0A38EA7F69B9B9E8AD1F40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190706061626.31440-1-parav@mellanox.com>
 <20190706061626.31440-2-parav@mellanox.com>
 <20190706062611.GA2264@nanopsycho>
In-Reply-To: <20190706062611.GA2264@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.16.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c594f1c1-b7d0-487f-2d65-08d7024113a8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6130;
x-ms-traffictypediagnostic: AM0PR05MB6130:
x-microsoft-antispam-prvs: <AM0PR05MB6130E4F85C0E0DF7D748BF85D1F40@AM0PR05MB6130.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(39850400004)(396003)(376002)(366004)(136003)(346002)(199004)(189003)(13464003)(54534003)(66946007)(81156014)(7736002)(76116006)(8676002)(73956011)(86362001)(9686003)(55016002)(6246003)(6436002)(64756008)(305945005)(66556008)(66446008)(66476007)(53936002)(76176011)(6506007)(53546011)(7696005)(478600001)(54906003)(5660300002)(52536014)(186003)(102836004)(316002)(55236004)(25786009)(26005)(3846002)(6116002)(446003)(11346002)(68736007)(8936002)(33656002)(99286004)(4326008)(66066001)(229853002)(71190400001)(71200400001)(81166006)(74316002)(6916009)(9456002)(256004)(2906002)(14454004)(14444005)(78486014)(486006)(476003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6130;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rI/djpWSe8KxcgaFOnIvn5COb81KBGGYls13pOBNs7ytJSRjCxmtWqFExetZ8EEcYqQkqrK1VjNCOBDoQFxddaNHDKf6QJmxit+yJQlE8KY/rV7967JIg3DGv+pZrmyVlaVzkzK6Yy+f4a/YB2WcHNwps5mqoZzeOgDzRAANQor85jjgO51WrzoDP1PPsVPr1oEuDQxCcmCXMpR5KRIFS0X/ZCItH/XD/865jFJ0b3OLhNlUkxahI30t6ageZiBZHabLC8iODh0fuPtfz/E4w9M65wj6e3T0sx/VxPelw2PBhaLDVdjTqdcstxrn7biwUjQFg9UOLN6NOzl0UrupTysxpKTFjEaW3x3QtsUTVH8BikzKwBwCRwCRVU9XgNWTxhFuKUKi3qcjf/D+slX9oPJ+uve/6/toLV6TMks1Fx8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c594f1c1-b7d0-487f-2d65-08d7024113a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2019 18:38:02.0663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Saturday, July 6, 2019 11:56 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@mellanox.com>; Saeed Mahamee=
d
> <saeedm@mellanox.com>; jakub.kicinski@netronome.com
> Subject: Re: [PATCH net-next v3 1/3] devlink: Introduce PCI PF port flavo=
ur and
> port attribute
>=20
> Sat, Jul 06, 2019 at 08:16:24AM CEST, parav@mellanox.com wrote:
> >In an eswitch, PCI PF may have port which is normally represented using
> >a representor netdevice.
> >To have better visibility of eswitch port, its association with PF and
> >a representor netdevice, introduce a PCI PF port flavour and port
> >attriute.
> >
> >When devlink port flavour is PCI PF, fill up PCI PF attributes of the
> >port.
> >
> >Extend port name creation using PCI PF number on best effort basis.
> >So that vendor drivers can skip defining their own scheme.
> >
> >$ devlink port show
> >pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
> >
> >Signed-off-by: Parav Pandit <parav@mellanox.com>
> >
> >---
> >Changelog:
> >v2->v3:
> > - Address comments from Jakub.
> > - Made port_number and split_port_number applicable only to
> >   physical port flavours by having in union.
> >v1->v2:
> > - Limited port_num attribute to physical ports
> > - Updated PCI PF attribute set API to not have port_number
> >---
> > include/net/devlink.h        | 21 +++++++-
> > include/uapi/linux/devlink.h |  5 ++
> > net/core/devlink.c           | 97 ++++++++++++++++++++++++++++--------
> > 3 files changed, 100 insertions(+), 23 deletions(-)
> >
> >diff --git a/include/net/devlink.h b/include/net/devlink.h index
> >6625ea068d5e..1455f60e4069 100644
> >--- a/include/net/devlink.h
> >+++ b/include/net/devlink.h
> >@@ -38,13 +38,27 @@ struct devlink {
> > 	char priv[0] __aligned(NETDEV_ALIGN);  };
> >
> >+struct devlink_port_phys_attrs {
> >+	u32 port_number; /* same value as "split group".
>=20
> "Same" with capital letter.
>=20
Done in v4.

> >+			  * A physical port which is visible to the user
> >+			  * for a given port flavour.
> >+			  */
> >+	u32 split_subport_number;
> >+};
> >+
> >+struct devlink_port_pci_pf_attrs {
> >+	u16 pf;	/* Associated PCI PF for this port. */
> >+};
> >+
> > struct devlink_port_attrs {
> > 	u8 set:1,
> > 	   split:1,
> > 	   switch_port:1;
> > 	enum devlink_port_flavour flavour;
> >-	u32 port_number; /* same value as "split group" */
> >-	u32 split_subport_number;
> >+	union {
> >+		struct devlink_port_phys_attrs phys_port;
> >+		struct devlink_port_pci_pf_attrs pci_pf;
>=20
> Be consistent in naming: "phys", "pci_pf".
>=20
Done in v4 as "physical".

>=20
> >+	};
> > 	struct netdev_phys_item_id switch_id; };
> >
> >@@ -590,6 +604,9 @@ void devlink_port_attrs_set(struct devlink_port
> *devlink_port,
> > 			    u32 split_subport_number,
> > 			    const unsigned char *switch_id,
> > 			    unsigned char switch_id_len);
> >+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
> >+				   const unsigned char *switch_id,
> >+				   unsigned char switch_id_len, u16 pf);
> > int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
> > 			u32 size, u16 ingress_pools_count,
> > 			u16 egress_pools_count, u16 ingress_tc_count, diff --
> git
> >a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h index
> >5287b42c181f..f7323884c3fe 100644
> >--- a/include/uapi/linux/devlink.h
> >+++ b/include/uapi/linux/devlink.h
> >@@ -169,6 +169,10 @@ enum devlink_port_flavour {
> > 	DEVLINK_PORT_FLAVOUR_DSA, /* Distributed switch architecture
> > 				   * interconnect port.
> > 				   */
> >+	DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
> >+				      * the PCI PF. It is an internal
> >+				      * port that faces the PCI PF.
> >+				      */
> > };
> >
> > enum devlink_param_cmode {
> >@@ -337,6 +341,7 @@ enum devlink_attr {
> > 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
> > 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
> >
> >+	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
> > 	/* add new attributes above here, update the policy in devlink.c */
> >
> > 	__DEVLINK_ATTR_MAX,
> >diff --git a/net/core/devlink.c b/net/core/devlink.c index
> >89c533778135..9aa36104b471 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -506,6 +506,14 @@ static void devlink_notify(struct devlink *devlink,
> enum devlink_command cmd)
> > 				msg, 0, DEVLINK_MCGRP_CONFIG,
> GFP_KERNEL);  }
> >
> >+static bool
> >+is_devlink_phy_port_num_supported(const struct devlink_port *dl_port)
> >+{
> >+	return (dl_port->attrs.flavour =3D=3D DEVLINK_PORT_FLAVOUR_PHYSICAL
> ||
> >+		dl_port->attrs.flavour =3D=3D DEVLINK_PORT_FLAVOUR_CPU ||
> >+		dl_port->attrs.flavour =3D=3D DEVLINK_PORT_FLAVOUR_DSA); }
> >+
> > static int devlink_nl_port_attrs_put(struct sk_buff *msg,
> > 				     struct devlink_port *devlink_port)  { @@ -
> 515,14 +523,23 @@
> >static int devlink_nl_port_attrs_put(struct sk_buff *msg,
> > 		return 0;
> > 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
> > 		return -EMSGSIZE;
> >-	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs-
> >port_number))
> >+	if (devlink_port->attrs.flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF) {
> >+		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
> >+				attrs->pci_pf.pf))
> >+			return -EMSGSIZE;
> >+	}
> >+	if (!is_devlink_phy_port_num_supported(devlink_port))
>=20
> Please do the check here. No need for helper (the name with "is" and
> "supported" is weird anyway.
>=20
Done in v4.
>=20
> >+		return 0;
> >+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
> >+			attrs->phys_port.port_number))
> > 		return -EMSGSIZE;
> > 	if (!attrs->split)
> > 		return 0;
> >-	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP, attrs-
> >port_number))
> >+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP,
> >+			attrs->phys_port.port_number))
>=20
> Better to split this into 2 patches. One pushing phys things into separat=
e struct,
> the second the rest.
>=20
Done in v4.
>=20
> > 		return -EMSGSIZE;
> > 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_SUBPORT_NUMBER,
> >-			attrs->split_subport_number))
> >+			attrs->phys_port.split_subport_number))
> > 		return -EMSGSIZE;
> > 	return 0;
> > }
> >@@ -5738,6 +5755,30 @@ void devlink_port_type_clear(struct devlink_port
> >*devlink_port)  }  EXPORT_SYMBOL_GPL(devlink_port_type_clear);
> >
> >+static void __devlink_port_attrs_set(struct devlink_port *devlink_port,
> >+				     enum devlink_port_flavour flavour,
> >+				     u32 port_number,
> >+				     const unsigned char *switch_id,
> >+				     unsigned char switch_id_len)
> >+{
> >+	struct devlink_port_attrs *attrs =3D &devlink_port->attrs;
> >+
> >+	if (WARN_ON(devlink_port->registered))
> >+		return;
> >+	attrs->set =3D true;
> >+	attrs->flavour =3D flavour;
> >+	attrs->phys_port.port_number =3D port_number;
> >+	if (switch_id) {
> >+		attrs->switch_port =3D true;
> >+		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
> >+			switch_id_len =3D MAX_PHYS_ITEM_ID_LEN;
> >+		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
> >+		attrs->switch_id.id_len =3D switch_id_len;
> >+	} else {
> >+		attrs->switch_port =3D false;
> >+	}
> >+}
> >+
> > /**
> >  *	devlink_port_attrs_set - Set port attributes
> >  *
> >@@ -5761,25 +5802,34 @@ void devlink_port_attrs_set(struct devlink_port
> >*devlink_port,  {
> > 	struct devlink_port_attrs *attrs =3D &devlink_port->attrs;
> >
> >-	if (WARN_ON(devlink_port->registered))
> >-		return;
> >-	attrs->set =3D true;
> >-	attrs->flavour =3D flavour;
> >-	attrs->port_number =3D port_number;
> >+	__devlink_port_attrs_set(devlink_port, flavour, port_number,
> >+				 switch_id, switch_id_len);
> > 	attrs->split =3D split;
> >-	attrs->split_subport_number =3D split_subport_number;
> >-	if (switch_id) {
> >-		attrs->switch_port =3D true;
> >-		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
> >-			switch_id_len =3D MAX_PHYS_ITEM_ID_LEN;
> >-		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
> >-		attrs->switch_id.id_len =3D switch_id_len;
> >-	} else {
> >-		attrs->switch_port =3D false;
> >-	}
> >+	attrs->phys_port.split_subport_number =3D split_subport_number;
> > }
> > EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
> >
> >+/**
> >+ *	devlink_port_attrs_pci_pf_set - Set PCI PF port attributes
> >+ *
> >+ *	@devlink_port: devlink port
> >+ *	@pf: associated PF for the devlink port instance
> >+ *	@switch_id: if the port is part of switch, this is buffer with ID,
> >+ *	            otwerwise this is NULL
> >+ *	@switch_id_len: length of the switch_id buffer
> >+ */
> >+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
> >+				   const unsigned char *switch_id,
> >+				   unsigned char switch_id_len, u16 pf) {
> >+	struct devlink_port_attrs *attrs =3D &devlink_port->attrs;
> >+
> >+	__devlink_port_attrs_set(devlink_port,
> DEVLINK_PORT_FLAVOUR_PCI_PF,
> >+				 0, switch_id, switch_id_len);
>=20
> Please have this done differently. __devlink_port_attrs_set() sets
> attrs->phys_port.port_number which does not make sense there.
>=20
Changed in v4.

>=20
> >+	attrs->pci_pf.pf =3D pf;
> >+}
> >+EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
> >+
> > static int __devlink_port_phys_port_name_get(struct devlink_port
> *devlink_port,
> > 					     char *name, size_t len)
> > {
> >@@ -5792,10 +5842,12 @@ static int
> __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
> > 	switch (attrs->flavour) {
> > 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
> > 		if (!attrs->split)
> >-			n =3D snprintf(name, len, "p%u", attrs->port_number);
> >+			n =3D snprintf(name, len, "p%u",
> >+				     attrs->phys_port.port_number);
> > 		else
> >-			n =3D snprintf(name, len, "p%us%u", attrs->port_number,
> >-				     attrs->split_subport_number);
> >+			n =3D snprintf(name, len, "p%us%u",
> >+				     attrs->phys_port.port_number,
> >+				     attrs->phys_port.split_subport_number);
> > 		break;
> > 	case DEVLINK_PORT_FLAVOUR_CPU:
> > 	case DEVLINK_PORT_FLAVOUR_DSA:
> >@@ -5804,6 +5856,9 @@ static int
> __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
> > 		 */
> > 		WARN_ON(1);
> > 		return -EINVAL;
> >+	case DEVLINK_PORT_FLAVOUR_PCI_PF:
> >+		n =3D snprintf(name, len, "pf%u", attrs->pci_pf.pf);
> >+		break;
> > 	}
> >
> > 	if (n >=3D len)
> >--
> >2.19.2
> >
