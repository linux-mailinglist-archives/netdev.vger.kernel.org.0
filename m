Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2546EFFF7B
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfKRHZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:25:07 -0500
Received: from mail-eopbgr40051.outbound.protection.outlook.com ([40.107.4.51]:9029
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbfKRHZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 02:25:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vz1V5ZOXiEPJ6JCFbqzfGgEXC8DMwGfS7Z+6NOm5c8AAhX3Xg4/zLQqTTzkTL1f8SOYIA5qvhxQUKxQIuG8SWJt0z5AIz5m5j59Ps1RNnHsdZVf8WDclPTqrqZvFJFh+W0yw8h0oz18urrGVw6vRVns6j+oLTce1WHDnW4ehSDA4SJ7Hm6OH/b6ElPNbiSduDI9YWGcvoynxKDKSv7JRLcM4M08XbZ5Y+D9IKVrPpmKGHgnhAH5z5bqfBExdEkOovtg8DsHJfFI0v5Yon3GBdyjvG/uTzS8HXAeJmasiaWiKoVkV1JCnymdGfwRyWbRR7dcPZK5XE7Rx9W/nA+IT2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQhuJwiuDpZxiXaw+VLqu2vIT6Oa3ui6z5mq/ZsDeh4=;
 b=lZ15gJWklqtPwiJY4WMyFfrseIqIoJmqdo0vG4/A+Bk95JH8mn0ZaMZZgwe7iItjIpUV2p6sBXzBLBeDJXWNlXwbC2xd9r/oznc1IQazIweDQVhvx04i3yTapW3eyl+4SzUmScj8XhQIB6lRwB326PgCqcxBoyatniGRlDQPJ7ga3rsT0VdEHt03hGjOSMpxJbBWdantTBLyLJrRSkMyhblYh5e1Sn/AXOCb4lVN4KFua4AnvnM3GDzVl1a+IZwvKr6zz3TxU+6+yBEfBgjGugPWWU3M83sYj+ebRQJJXPX+O5tMGr9BnQoE0EcpNPan1bLHAsccKOOz5llZOV6k1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQhuJwiuDpZxiXaw+VLqu2vIT6Oa3ui6z5mq/ZsDeh4=;
 b=FyNUSUHXaKk45jl9p35md6jrmGBIyXi3voKsWrRK5o9Osdosa0dG4viJHgbe+C4QtXlbqx/RCT63W+uP1LqLzKR0TCWT25PUuszeJb0+e3AikntTH5C83frw8npfOpbjZXYdJPKGovV3qdCxGxvpjHG6ZEuBam3iS+Zv7qaTFS4=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3395.eurprd05.prod.outlook.com (10.171.188.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Mon, 18 Nov 2019 07:25:02 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::70c3:1586:88a:1493]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::70c3:1586:88a:1493%7]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 07:25:02 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/4] Get IB port and node GUIDs through
 rtnetlink
Thread-Topic: [PATCH rdma-next 0/4] Get IB port and node GUIDs through
 rtnetlink
Thread-Index: AQHVmu/Vfdk+oqiBkUy0e40m6XWwa6eQjLIA
Date:   Mon, 18 Nov 2019 07:25:02 +0000
Message-ID: <20191118072500.GI4716@unreal>
References: <20191114133126.238128-1-leon@kernel.org>
In-Reply-To: <20191114133126.238128-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0060.eurprd05.prod.outlook.com
 (2603:10a6:208:be::37) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.29.147.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0e7614d4-2fa7-4246-dd33-08d76bf86d37
x-ms-traffictypediagnostic: AM4PR05MB3395:|AM4PR05MB3395:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3395D978A93E33065AF959E1B04D0@AM4PR05MB3395.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(366004)(376002)(396003)(39860400002)(346002)(136003)(199004)(189003)(256004)(81166006)(81156014)(4326008)(66446008)(66476007)(66556008)(64756008)(6486002)(66066001)(86362001)(33716001)(5660300002)(1076003)(6246003)(99286004)(8936002)(6512007)(316002)(54906003)(9686003)(8676002)(14454004)(2906002)(76176011)(386003)(6506007)(11346002)(52116002)(229853002)(6436002)(446003)(66946007)(33656002)(186003)(102836004)(7736002)(6916009)(305945005)(478600001)(26005)(476003)(25786009)(6116002)(71200400001)(71190400001)(3846002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3395;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MOXb8K6VJpxrsaAX9Oqm6ZOC0aIrfkQXjCz2wougoul24wEO07R8PRbEFxi6Qdom0r2pdLsmymvCIxE7AzcdCJ2yYIKVaBVclpZUK6PTfAWe2KNZItS/9zWQvuM/DNEkSQEyjt+hBWTNdBXU6uYpcwXzbeG6HZpKhZGjpcJOfCLEthGW8uhzSwN19vgaOGPT9/MFNNhUddFuWGleyAuJEjs5/E8AMDxLzzBd6y9DXdM02tnh80RYrdG1pIzvujoZ/iLahUD9nwT4+0yf0xVeN7Yr+2e0s4luCvPiEUwgpW9wML/N3227TQH1KqMP/jd/QD6zdShr7iyJS6LGK6IfWgbYuw5cK9tsOlNlcItfiedhOHC2CWRy/R16L0P0wtOxT6tX8N/dZrGTqnMm+eVP+/dTsYwr7l6dfSwxGV0FqMBQKgTNyW3+7Cm+DGROGMUK
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C5D491281E1C6D48800D75E4F4F8254C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7614d4-2fa7-4246-dd33-08d76bf86d37
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 07:25:02.7478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/DjxYAAt6jOanPhxXmZWwJEt/Wguhl4BoysqL8CiSRDGWbaXpZ3A8PheA+jp30UOAevbxkwqBLUp7eg500utw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3395
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 03:31:21PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> This series from Danit extends RTNETLINK to provide IB port and node
> GUIDs, which were configured for Infiniband VFs.
>
> The functionality to set VF GUIDs already existed for a long time, and he=
re
> we are adding the missing "get" so that netlink will be symmetric
> and various cloud orchestration tools will be able to manage such
> VFs more naturally.
>
> The iproute2 was extended too to present those GUIDs.
>
> - ip link show <device>
>
> For example:
> - ip link set ib4 vf 0 node_guid 22:44:33:00:33:11:00:33
> - ip link set ib4 vf 0 port_guid 10:21:33:12:00:11:22:10
> - ip link show ib4
>     ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFAUL=
T group default qlen 256
>     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44=
:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a=
:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:f=
f:ff,
>     spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10:2=
1:33:12:00:11:22:10, link-state disable, trust off, query_rss off
>
> Due to the fact that this series touches both net and RDMA, we assume
> that it needs to be applied to our shared branch (mlx5-next) and pulled
> later by Dave and Doug/Jason.
>
> Thanks
>
> Danit Goldberg (4):
>   net/core: Add support for getting VF GUIDs
>   IB/core: Add interfaces to get VF node and port GUIDs
>   IB/ipoib: Add ndo operation for getting VFs GUID attributes
>   IB/mlx5: Implement callbacks for getting VFs GUID attributes

Dave,

I see that you marked these patches as "not applicable" in patchworks.

Can I assume that you are OK with them and we can take them through RDMA
tree? If yes, can you give your Ack on the first patch?

Thanks
