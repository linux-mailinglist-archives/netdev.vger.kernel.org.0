Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625E84FA8A
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 08:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfFWGsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 02:48:45 -0400
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:30240
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfFWGsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 02:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOMo6BuhHZrqSo3jf7TkmzMAVlSPCTtrz/POdG39H1Y=;
 b=IFiGmkWGIy/69COwndF1Y3l8a0A1JzAFAvPnMsXWDemOHczfvpQEHxhN9p8ZWxIL7mWNPDhgOA/xW4hB2c1tAu8lViAK+DoPwTJZJKPMHozs6dLdkOQsQNh9+00jMrhyq37gQWJVhprNDMtyt9Ye3Jb2jPlyaJNu/1mMHMpdN1k=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB5371.eurprd05.prod.outlook.com (20.178.42.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Sun, 23 Jun 2019 06:48:41 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::8117:4e6b:da4a:b15a]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::8117:4e6b:da4a:b15a%6]) with mapi id 15.20.1987.014; Sun, 23 Jun 2019
 06:48:41 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Thread-Topic: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Thread-Index: AQHVJ8PhRAFcpJgH8Em8x841rflAZKalYXWAgANuYgA=
Date:   Sun, 23 Jun 2019 06:48:41 +0000
Message-ID: <20190623064838.GA13466@splinter>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
In-Reply-To: <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0202CA0014.eurprd02.prod.outlook.com
 (2603:10a6:209:15::27) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84e6e53b-727a-4729-e3c2-08d6f7a6d3ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR05MB5371;
x-ms-traffictypediagnostic: DB7PR05MB5371:
x-microsoft-antispam-prvs: <DB7PR05MB5371DF7E7668DE4C8BA8CF5EBFE10@DB7PR05MB5371.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(366004)(136003)(396003)(346002)(39850400004)(189003)(199004)(66556008)(99286004)(14454004)(26005)(86362001)(256004)(53546011)(102836004)(14444005)(6506007)(76176011)(52116002)(6486002)(4326008)(9686003)(6916009)(53936002)(6246003)(2906002)(316002)(33716001)(33656002)(25786009)(6512007)(6116002)(54906003)(3846002)(229853002)(66476007)(64756008)(66946007)(71200400001)(8676002)(71190400001)(66066001)(6436002)(386003)(81166006)(81156014)(1076003)(476003)(305945005)(186003)(7736002)(486006)(478600001)(8936002)(5660300002)(73956011)(66446008)(446003)(68736007)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5371;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oUO1sqQ11L+79AEkdls+aW4oFgBPu8QoRbEx/8I+8qfCmL5RR5/MyRDZ2P+TiOF9BEc++CnqyKJ8M64rLGDWVhEfeEEVtBzVHrbxDdeaCq66xVmjlRaEaOaXNgg4iVpGCLp8iiqC5s8mbzkqfS54F3ZtxqNiQIw/pSw1g/wl03w9JVM1e6PP+tmzvTacbwYk8r9pIBPeGF9DFchVccpfnBerVfNigNxQKqz36mZYltHTGsFMYxcbQdW4foE++iHArBshoo6q0gb5ZrqNknKwKDbbzo1YjXQ3ADSL92EqzAltEd0Zs9c+GqTScnNzbU3un5mxpzKYB8dm4RAD7D0xTHY1y26/dVJyQVGxRobpeIMDxZ+SW8AXPm+078zETzO4dqA8bVEhRaDc3oLSpcdJJRLN7YUqIfgUfmrGloy49bY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E06F02ABD328AB4BB8435EA41600E9DA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e6e53b-727a-4729-e3c2-08d6f7a6d3ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2019 06:48:41.1136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idosch@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5371
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 07:24:47PM -0700, Florian Fainelli wrote:
> On 6/20/2019 4:56 PM, Vivien Didelot wrote:
> > This patch adds support for enabling or disabling the flooding of
> > unknown multicast traffic on the CPU ports, depending on the value
> > of the switchdev SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED attribute.
> >=20
> > This allows the user to prevent the CPU to be flooded with a lot of
> > undesirable traffic that the network stack needs to filter in software.
> >=20
> > The bridge has multicast snooping enabled by default, hence CPU ports
> > aren't bottlenecked with arbitrary network applications anymore.
> > But this can be an issue in some scenarios such as pinging the bridge's
> > IPv6 address. Setting /sys/class/net/br0/bridge/multicast_snooping to
> > 0 would restore unknown multicast flooding and thus fix ICMPv6. As
> > an alternative, enabling multicast_querier would program the bridge
> > address into the switch.
> From what I can read from mlxsw, we should probably also implement the
> SWITCHDEV_ATTR_ID_PORT_MROUTER attribute in order to be consistent.
>=20
> Since the attribute MC_DISABLED is on the bridge master, we should also
> iterate over the list of switch ports being a member of that bridge and
> change their flooding attribute, taking into account whether
> BR_MCAST_FLOOD is set on that particular port or not. Just paraphrasing
> what mlxsw does here again...

When multicast snooping is enabled, unregistered multicast traffic
should be flooded to mrouter ports only. Otherwise, it should be flooded
to all ports.

> Once you act on the user-facing ports, you might be able to leave the
> CPU port flooding unconditionally, since it would only "flood" the CPU
> port either because an user-facing port has BR_MCAST_FLOOD set, or
> because this is known MC traffic that got programmed via the bridge's
> MDB. Would that work?
>=20
> On a higher level, I really wish we did not have to re-implement a lot
> of identical or similar logic in each switch drivers and had a more
> central model of what is behaviorally expected.

Well, that model is the bridge driver... But I agree that we can
probably simplify the interface towards drivers and move more code up
the stack.

For example, two things mlxsw is doing when multicast snooping is
enabled:

1. Writing MDB entries to the device. When multicast snooping is
disabled, MDB entries are ignored by the bridge driver. Can we agree to
have the bridge driver generate SWITCHDEV_OBJ_ID_PORT_MDB add / delete
for all MDB entries when multicast snooping is toggled?

2. Flooding unregistered multicast traffic only to mrouter ports. The
bridge driver can iterate over the bridge members and toggle
BR_MCAST_FLOOD accordingly. It will not actually change this value. Only
emulate this change towards drivers.

I will try to come up with a more detailed list later this week. I
really want to start moving more logic out of drivers.
