Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528435C859
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 06:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfGBE0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 00:26:53 -0400
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:8999
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbfGBE0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 00:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiSjfsXyxWCpmSWgpk646mEAu5Xb+SY6ggHpGWCaSRY=;
 b=RKOYiUEkWFmZk9+YVk1aqm4wesbC6SLXwZnU6V2FVCSWo6CBTTOnZ6pbexwaPiKEFsRsj/44zGO6AHCoEA5XXoM89b1eldGsgAeSdMh1ny4bjwChRT22INtHK2RrOEFmR3Vzs526GhjlHac9x1zaux0DlWLModlEpdHcqA72NCc=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4658.eurprd05.prod.outlook.com (52.133.61.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 04:26:47 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 04:26:47 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Topic: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Index: AQHVMAhn8T46v1pXDUi3XMXT/4YtI6a2aNkAgABHFVA=
Date:   Tue, 2 Jul 2019 04:26:47 +0000
Message-ID: <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190701122734.18770-2-parav@mellanox.com>
 <20190701162650.17854185@cakuba.netronome.com>
In-Reply-To: <20190701162650.17854185@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 675b99e9-c978-4a2d-2e82-08d6fea57f57
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4658;
x-ms-traffictypediagnostic: AM0PR05MB4658:
x-microsoft-antispam-prvs: <AM0PR05MB4658711C44B1E6CBD1067321D1F80@AM0PR05MB4658.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(13464003)(189003)(199004)(14444005)(8936002)(81166006)(81156014)(33656002)(74316002)(102836004)(55236004)(7696005)(53546011)(8676002)(7736002)(76176011)(305945005)(6116002)(3846002)(55016002)(6506007)(256004)(53936002)(9456002)(9686003)(6436002)(86362001)(229853002)(186003)(2906002)(26005)(11346002)(6246003)(446003)(52536014)(478600001)(486006)(76116006)(25786009)(6636002)(4326008)(66476007)(66556008)(64756008)(66446008)(110136005)(54906003)(14454004)(316002)(71190400001)(476003)(68736007)(5660300002)(99286004)(66946007)(66066001)(78486014)(107886003)(73956011)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4658;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 83o1QcVbHNA6sr9NSJu79xqTcWsczdIEIJRTssHqjVatINJ2wvgWdUt4lNCRD/ej1hfk5HB+iql+jkNcSaIGFG+8rP/YrwlZf+mK4Zo7itJhq+BdNt2eZARiN4xHQa3Dclj7dvdIfEomo9aSdPiv3DRsutCqX9MS0iyoS47/fB3nSGx0OoyG+W1h6A3aZx/1DGb9frfoLD7CoiSNJshKHA7OyJEhfv5mpdV2XBmunxBBYTLNOF2S7fMPOXsf4OyOrRoY1jgYbOhbHUdIHlgl0BAZjvOG4a7FiSnr9QHmWM0nAEnzNphkNsKR/H3B0n7ns2NV625c4RdIzmyKhwFWDTlw4hjnoaya8zxSbW86PX4UMHwgTfN2E2ZnGoFy0dCt8zwRulzJirBTyoAjKnLp1osag1ztuqtzB1aqPe6pThM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 675b99e9-c978-4a2d-2e82-08d6fea57f57
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 04:26:47.7763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4658
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Tuesday, July 2, 2019 4:57 AM
> To: Jiri Pirko <jiri@mellanox.com>
> Cc: Parav Pandit <parav@mellanox.com>; netdev@vger.kernel.org; Saeed
> Mahameed <saeedm@mellanox.com>
> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour =
and
> port attribute
>=20
> On Mon,  1 Jul 2019 07:27:32 -0500, Parav Pandit wrote:
> > In an eswitch, PCI PF may have port which is normally represented
> > using a representor netdevice.
> > To have better visibility of eswitch port, its association with PF, a
> > representor netdevice and port number, introduce a PCI PF port flavour
> > and port attriute.
> >
> > When devlink port flavour is PCI PF, fill up PCI PF attributes of the
> > port.
> >
> > Extend port name creation using PCI PF number on best effort basis.
> > So that vendor drivers can skip defining their own scheme.
> >
> > $ devlink port show
> > pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
> >
> > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  include/net/devlink.h        | 11 ++++++
> >  include/uapi/linux/devlink.h |  5 +++
> >  net/core/devlink.c           | 71 +++++++++++++++++++++++++++++-------
> >  3 files changed, 73 insertions(+), 14 deletions(-)
> >
> > diff --git a/include/net/devlink.h b/include/net/devlink.h index
> > 6625ea068d5e..8db9c0e83fb5 100644
> > --- a/include/net/devlink.h
> > +++ b/include/net/devlink.h
> > @@ -38,6 +38,10 @@ struct devlink {
> >  	char priv[0] __aligned(NETDEV_ALIGN);  };
> >
> > +struct devlink_port_pci_pf_attrs {
>=20
> Why the named structure?  Anonymous one should be just fine?
>
No specific reason for this patch. But named structure allows to extend it =
more easily with code readability.
Such as subsequently we want to add the peer_mac etc port attributes.
Named structure to store those attributes are helpful.
=20
> > +	u16 pf;	/* Associated PCI PF for this port. */
> > +};
> > +
> >  struct devlink_port_attrs {
> >  	u8 set:1,
> >  	   split:1,
> > @@ -46,6 +50,9 @@ struct devlink_port_attrs {
> >  	u32 port_number; /* same value as "split group" */
> >  	u32 split_subport_number;
> >  	struct netdev_phys_item_id switch_id;
> > +	union {
> > +		struct devlink_port_pci_pf_attrs pci_pf;
> > +	};
> >  };
> >
> >  struct devlink_port {
> > @@ -590,6 +597,10 @@ void devlink_port_attrs_set(struct devlink_port
> *devlink_port,
> >  			    u32 split_subport_number,
> >  			    const unsigned char *switch_id,
> >  			    unsigned char switch_id_len);
> > +void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
> > +				   u32 port_number,
> > +				   const unsigned char *switch_id,
> > +				   unsigned char switch_id_len, u16 pf);
> >  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index=
,
> >  			u32 size, u16 ingress_pools_count,
> >  			u16 egress_pools_count, u16 ingress_tc_count, diff --
> git
> > a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h index
> > 5287b42c181f..f7323884c3fe 100644
> > --- a/include/uapi/linux/devlink.h
> > +++ b/include/uapi/linux/devlink.h
> > @@ -169,6 +169,10 @@ enum devlink_port_flavour {
> >  	DEVLINK_PORT_FLAVOUR_DSA, /* Distributed switch architecture
> >  				   * interconnect port.
> >  				   */
> > +	DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
> > +				      * the PCI PF. It is an internal
> > +				      * port that faces the PCI PF.
> > +				      */
> >  };
> >
> >  enum devlink_param_cmode {
> > @@ -337,6 +341,7 @@ enum devlink_attr {
> >  	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
> >  	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
> >
> > +	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
> >  	/* add new attributes above here, update the policy in devlink.c */
> >
> >  	__DEVLINK_ATTR_MAX,
> > diff --git a/net/core/devlink.c b/net/core/devlink.c index
> > 89c533778135..001f9e2c96f0 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -517,6 +517,11 @@ static int devlink_nl_port_attrs_put(struct sk_buf=
f
> *msg,
> >  		return -EMSGSIZE;
> >  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs-
> >port_number))
> >  		return -EMSGSIZE;
>=20
> Why would we report network port information for PF and VF port flavours?
I didn't see any immediate need to report, at the same time didn't find any=
 reason to treat such port flavours differently than existing one.
It just gives a clear view of the device's eswitch.
Might find it useful during debugging while inspecting device internal tabl=
es..

>=20
> > +	if (devlink_port->attrs.flavour =3D=3D DEVLINK_PORT_FLAVOUR_PCI_PF) {
> > +		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
> > +				attrs->pci_pf.pf))
> > +			return -EMSGSIZE;
> > +	}
> >  	if (!attrs->split)
> >  		return 0;
> >  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_SPLIT_GROUP,
> > attrs->port_number))
