Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DC8107952
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 21:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKVUPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 15:15:42 -0500
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:21320
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbfKVUPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 15:15:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmOWcr7UFLgGMuz257YJ/3HNxLwioCiyLlhlZq0GnM5B7eRQwayJMEln4HdBqlQ3IDfSrZIKXZFwCK4W//PPT0AF8IJzCn/JyKWRJXKFeRJVOWQjO+5luwqQZsr+zTHvZEzMGtUejojuhgz6KFldx+4Sv+dzM35sXvK4bbinjKWfK5ggVuashHyD6/eIzDVMiQaPAVj3fSfU+hnpo6Mjs61TfmBPWwaqaFfgyUQ+xngNJSVFlFkYTBNP2C9gZec3YDXJD3zxjtYNoLq5jScPvJ15gFQGhuNG1YyEu10zu9aH8y06XhfgckEeJOG4+jFGxzU22UdbkOOAhxxRtr9HEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGl59mBHxOs9lReCN6F5H5vE0SMDtvSvz4hWg/bpY3Q=;
 b=i/xsC4AQLjOb2cn/SInRamR5oNURZPek5EXuJk+x9nqryxLgbArvsVacTLIK/H3cFY+QwOxAoeoJ8s0XJm34lc4I3+YMgl4dmWLAScSlBlyJ9JPniLlA/UUcolfXDN+If5ykZC+vJk9ljzxGyo2qjokH8M4ytCOtnPgnDXROuTYWB5LnRyTZFyU/P/AfS3S/XkHxklo2ZzT1JL+lrGvoX/mZ2e3VTW4f0dpby/xzbUrhCE6MEHZ7px+NGsCHtG/OMOJKZW7Dm5fvdiiF58fDNnMPuXdAKCkbLRqIDs//Oie3ECnOyDLpeDciF7OKWtEmH1yKeSA/OAXXuj0CGRfMsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGl59mBHxOs9lReCN6F5H5vE0SMDtvSvz4hWg/bpY3Q=;
 b=RLZgg5Gekoy/9Hc7FEpQXjKW+bAPmw937jhG7hvK7OBOOz4WNYYeMIQPvwA9yCSv+Yd7/VYdh55ZCIeHxpWJAGAcPQdHQ/xSkcr8ULMA6jlDQ03q8erPyxWXvs2EYKzWaCfX62gxex+/chmmhGzRLK8MOwzaFaodnIN+zltoReM=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5598.eurprd05.prod.outlook.com (20.177.201.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 20:15:36 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::b179:e8bf:22d4:bf8d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::b179:e8bf:22d4:bf8d%5]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 20:15:36 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     Doug Ledford <dledford@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/4] Get IB port and node GUIDs through
 rtnetlink
Thread-Topic: [PATCH rdma-next 0/4] Get IB port and node GUIDs through
 rtnetlink
Thread-Index: AQHVmu/VidtZI1C/oEW5L41u4D2OO6eXa9CAgABBfYA=
Date:   Fri, 22 Nov 2019 20:15:35 +0000
Message-ID: <20191122201531.GZ7481@mellanox.com>
References: <20191114133126.238128-1-leon@kernel.org>
 <20191122162104.GE136476@unreal>
In-Reply-To: <20191122162104.GE136476@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:208:d4::21) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.162.113.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 55f9cb62-72e4-4b90-0392-08d76f88bc04
x-ms-traffictypediagnostic: VI1PR05MB5598:|VI1PR05MB5598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5598FC172B66CC7EDA13E549CF490@VI1PR05MB5598.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(199004)(189003)(54906003)(229853002)(6862004)(6246003)(7736002)(4326008)(305945005)(6512007)(256004)(6116002)(66946007)(6436002)(6486002)(3846002)(25786009)(86362001)(66446008)(66556008)(71200400001)(71190400001)(186003)(102836004)(36756003)(1076003)(8936002)(6636002)(66476007)(478600001)(26005)(81166006)(81156014)(14454004)(2616005)(11346002)(446003)(386003)(316002)(37006003)(76176011)(52116002)(66066001)(5660300002)(8676002)(99286004)(64756008)(33656002)(6506007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5598;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zzMioTLNFWplEuWbdDEU6xl9e1UAYYfbT2ZHkw3DX6ScgwU4DohQSjoBXlK2eEACVgSTzAOgej7ADF0ukLwkXagJb0EpLDYMe9WgrXxg6FnlIlm73xHeZyOYkGse6qiDmZ3RcUoNT+bkOVicfAzTXVY4i6/tZgOwEcr8814WFrb9y/A9s85p1/uwmLVTmSseGuOYT1W5J4F5pHaJ1eWGA40qCkMmpTY9sm1oEIsw8IdXqG8I/lx+lgzeMseJUL7hWL5zlX3TEiA3O4xRvtsexboncaGAyjTW8tRVSK8EjwR8kH2w/7qMDm0mjRRTWTBrwcGReO+iLH/7hCHBPH3Z6CWYNWA0FHlaTXiLKQNjrU6Vp95FHTKDZwG2t240m6Dam1Jee9rWSWQ8fOxnrntNjd+JdJvyLjI6i3EoD9kCHKPAk5cLQiYvtgFkcy9/h2ZG
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5DEB2C5DF4ADEF44AD2400768D2B7D46@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f9cb62-72e4-4b90-0392-08d76f88bc04
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 20:15:35.8328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AUGiUldH99KYGWoVCSvgDarIqZdP9pHNmbPl93uEarMI3kMZeUwquOTYWvsM/Kp3kak/gq5V2KZ8T4T5iPHjog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5598
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 04:21:07PM +0000, Leon Romanovsky wrote:
> On Thu, Nov 14, 2019 at 03:31:21PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > This series from Danit extends RTNETLINK to provide IB port and node
> > GUIDs, which were configured for Infiniband VFs.
> >
> > The functionality to set VF GUIDs already existed for a long time, and =
here
> > we are adding the missing "get" so that netlink will be symmetric
> > and various cloud orchestration tools will be able to manage such
> > VFs more naturally.
> >
> > The iproute2 was extended too to present those GUIDs.
> >
> > - ip link show <device>
> >
> > For example:
> > - ip link set ib4 vf 0 node_guid 22:44:33:00:33:11:00:33
> > - ip link set ib4 vf 0 port_guid 10:21:33:12:00:11:22:10
> > - ip link show ib4
> >     ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFA=
ULT group default qlen 256
> >     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:=
44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
> >     vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:=
9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff=
:ff:ff,
> >     spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10=
:21:33:12:00:11:22:10, link-state disable, trust off, query_rss off
> >
> > Due to the fact that this series touches both net and RDMA, we assume
> > that it needs to be applied to our shared branch (mlx5-next) and pulled
> > later by Dave and Doug/Jason.
> >
> > Thanks
> >
> > Danit Goldberg (4):
> >   net/core: Add support for getting VF GUIDs
> >   IB/core: Add interfaces to get VF node and port GUIDs
> >   IB/ipoib: Add ndo operation for getting VFs GUID attributes
> >   IB/mlx5: Implement callbacks for getting VFs GUID attributes
>=20
> Applied to mlx5-next,
> Doug, Jason please pull.
>=20
> 9c0015ef0928 IB/mlx5: Implement callbacks for getting VFs GUID attributes
> 2446887ed226 IB/ipoib: Add ndo operation for getting VFs GUID attributes
> bfcb3c5d1485 IB/core: Add interfaces to get VF node and port GUIDs
> 30aad41721e0 net/core: Add support for getting VF GUIDs

Okay, done.

Jason
