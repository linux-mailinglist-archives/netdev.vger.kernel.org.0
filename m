Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDD24FA96
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 09:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfFWHJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 03:09:55 -0400
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:41262
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfFWHJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 03:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2lI4gKZ37DmL9ZofRDxlrBrEV2O7m4WLTJjaDeKUxU=;
 b=E6/CGmTwZn0Qnum8lsOGmHsmzH5xnANL70HOcvet2B6bhLRV3HBWPI6ELdgdPDekyVcvycaZQ0O4NvbZESCUkoOlEKGMFokBriyiK0mJG4uZuobpIO9gYoOreHUJZc448wwbGW8rPvye7N6vze2AgArlN27VZ6ihwEoXUM79bZg=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB5196.eurprd05.prod.outlook.com (20.178.41.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Sun, 23 Jun 2019 07:09:52 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::8117:4e6b:da4a:b15a]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::8117:4e6b:da4a:b15a%6]) with mapi id 15.20.1987.014; Sun, 23 Jun 2019
 07:09:52 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Thread-Topic: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Thread-Index: AQHVJ8PhRAFcpJgH8Em8x841rflAZKalYXWAgAE/7wCAAjRegA==
Date:   Sun, 23 Jun 2019 07:09:52 +0000
Message-ID: <20190623070949.GB13466@splinter>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190621172952.GB9284@t480s.localdomain>
In-Reply-To: <20190621172952.GB9284@t480s.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0402CA0003.eurprd04.prod.outlook.com
 (2603:10a6:203:90::13) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4517a70-fdca-4928-9352-08d6f7a9c973
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB5196;
x-ms-traffictypediagnostic: DB7PR05MB5196:
x-microsoft-antispam-prvs: <DB7PR05MB51967FE19BA24D4AF2AB80A2BFE10@DB7PR05MB5196.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39850400004)(376002)(136003)(396003)(346002)(366004)(199004)(189003)(5660300002)(71200400001)(66066001)(81156014)(256004)(6116002)(68736007)(66946007)(6916009)(66476007)(486006)(6512007)(76176011)(33716001)(25786009)(6506007)(4326008)(11346002)(73956011)(99286004)(386003)(446003)(66556008)(66446008)(64756008)(6486002)(14444005)(476003)(9686003)(229853002)(2906002)(8936002)(305945005)(52116002)(86362001)(7736002)(26005)(316002)(14454004)(3846002)(71190400001)(1076003)(8676002)(81166006)(53936002)(186003)(478600001)(33656002)(54906003)(6436002)(6246003)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5196;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XgU+peG+hnb1vVGijVU3cCJFekGgoYFS5Jl2G+EHPOWBL85TWGacdRgflEfftmXyoX+EGXqDbpIrjQ6j6hB/378ESVDe+fHiJy4f4bnlci7GHan5vsWmChPmFeHN1X2XCXnmAabX7zOyy+Mlm+7AxXHhrph9CVKwSXcflO4/ZuXZEjNHDmRVT3M1KnVVQvOMuLtBKTzDXRfBFe5knyTAKDgLsedWVCc4wyvc7vZ9SiwEeJEPfi6aSFboVrUlo5FLlDWQ/FWzO2GTwL30EgRxNxkPcCtgV0qAt2yosc7xQSeahLvVHQuLjX5CLE1izyQgNAUhyLRczMwRYEpeV9cDG7izdasmRT60ZhuHDl6/wM8n1+1wXMnbs6NhuyKBw+rcxrEe/lMDZrKmvyKbGRVZiuWT9GwaYDjCSb+kKh2KLls=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FB44DE082ED07843A56849C1ACA0CE98@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4517a70-fdca-4928-9352-08d6f7a9c973
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2019 07:09:52.3860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idosch@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 05:29:52PM -0400, Vivien Didelot wrote:
> On Thu, 20 Jun 2019 19:24:47 -0700, Florian Fainelli <f.fainelli@gmail.co=
m> wrote:
> > > This patch adds support for enabling or disabling the flooding of
> > > unknown multicast traffic on the CPU ports, depending on the value
> > > of the switchdev SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED attribute.
> > >=20
> > > This allows the user to prevent the CPU to be flooded with a lot of
> > > undesirable traffic that the network stack needs to filter in softwar=
e.
> > >=20
> > > The bridge has multicast snooping enabled by default, hence CPU ports
> > > aren't bottlenecked with arbitrary network applications anymore.
> > > But this can be an issue in some scenarios such as pinging the bridge=
's
> > > IPv6 address. Setting /sys/class/net/br0/bridge/multicast_snooping to
> > > 0 would restore unknown multicast flooding and thus fix ICMPv6. As
> > > an alternative, enabling multicast_querier would program the bridge
> > > address into the switch.
> > From what I can read from mlxsw, we should probably also implement the
> > SWITCHDEV_ATTR_ID_PORT_MROUTER attribute in order to be consistent.
> >=20
> > Since the attribute MC_DISABLED is on the bridge master, we should also
> > iterate over the list of switch ports being a member of that bridge and
> > change their flooding attribute, taking into account whether
> > BR_MCAST_FLOOD is set on that particular port or not. Just paraphrasing
> > what mlxsw does here again...
>=20
> Ouch, doesn't sound like what a driver should be doing :-(
>=20
> Ido, I cannot find documentation for multicast_snooping or MC_DISABLED
> and the naming isn't clear. Can this be considered as an equivalent
> of mcast_flood but targeting the bridge device itself, describing
> whether the bridge is interested or not in unknown multicast traffic?

Not really, you're only looking at one aspect of this, but there is
more. For example, when multicast snooping is disabled, the MDB is not
considered.

> > Once you act on the user-facing ports, you might be able to leave the
> > CPU port flooding unconditionally, since it would only "flood" the CPU
> > port either because an user-facing port has BR_MCAST_FLOOD set, or
> > because this is known MC traffic that got programmed via the bridge's
> > MDB. Would that work?
>=20
> You may want the machine or network connected behind a bridge port
> to be flooded with unknown multicast traffic, without having the
> CPU conduit clogged up with this traffic. So these are two distinct
> settings for me.
>=20
> The only scenario I can think of needing the CPU to be flooded is if
> there's a non-DSA port in the bridge maybe. But IMHO this should be
> handled by the bridge, offloading or not the appropriate attribute.
>=20
> > On a higher level, I really wish we did not have to re-implement a lot
> > of identical or similar logic in each switch drivers and had a more
> > central model of what is behaviorally expected.
>=20
> I couldn't agree more, ethernet switch drivers should only offload
> the notified bridge configuration, not noodling their own logic...

Please see my comment to Florian. The driver is doing what needs to be
done in order to comply with the behavior of the bridge driver. As I
wrote to Florian, we can probably move some logic up the stack and
simplify drivers.

> Russell, Ido, Florian, so far I understand that a multicast-unaware
> bridge must flood unknown traffic everywhere (CPU included);
> and a multicast-aware bridge must only flood its ports if their
> mcast_flood is on, and known traffic targeting the bridge must be
> offloaded accordingly. Do you guys agree with this?

When multicast snooping is enabled unregistered multicast traffic should
only be flooded to mrouter ports.
