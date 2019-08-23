Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD50C9B454
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436527AbfHWQON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:14:13 -0400
Received: from mail-eopbgr10063.outbound.protection.outlook.com ([40.107.1.63]:59709
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732570AbfHWQOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 12:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+54c9AMVFKvJc3Ya63dMizB96bRcOZAmU7PXCubg37+E73Fv4FnAL7wN99z4enpeRDmqzjOkf/LlqQe3hQNwSsYFSLyNhzKeA0H9UT+Z+pHsNUWw7EwgIIsHG+/bX4UYzULdDO7oMHDt2cHVSGYOCmq0FFITtdh5EvVLxKmWjy3uHy2fyZA8bBaBROinIttqB+1ap+DK66ZbvEYwTkflfQzbONHCPncv/i9zIj/mUokNRU3tQPy9eU1hUPRX5R92N+Yt9RTnVmGZ/1HG9EKrYApDLWu1hLLyPsqLQYlDzgloTeWOW5sPIhHkVCzQ2xVbbnVZDwzznYFtUnb5BBzow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DfYB40nPSM01RiwopLN+VfvJeLrmquS8btNwHwWllUA=;
 b=LqG9gbtmmMXG/U5rJ9Wsda8Gy7SbNvNv09NLJA5/V+wYU7E3cnKwNr8LQNFl3UZwRiHrtdRKyQWeIKA8zoUZ2jQDCHz1a4pS0EOZWyrVilasqijdQhWRcGTsEH6v4yic6NGx6hrM1l5Fk2IOwhjUWi5PKORGhEjyFgw+q+oROWDed5335A+gHkIA+tZhdErN5RiLggPJtec38zswGbsPcHYspHTu3jiJtTHLpir3Bq6M3cC3LCClRy4eCrQ3onntF4PkEPjdy8tAB0GDS+hKW9qjyziaYS/yz32Li5tO0ELRvQ22nnTSCRvubwIjxPoa4jNycqUB7Fd2rmqy568Atw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DfYB40nPSM01RiwopLN+VfvJeLrmquS8btNwHwWllUA=;
 b=kx3AVsuXUHPSzTNkV9k/XXsOhg4I5pDMYKbpOg68YLFdeiL9qAxEICEbhp7KoWJxwBOqeEG7x27xKVsZAhXLPBDlf7I/ss4mGBgFHowuTJTFl49TpbO5BLZNu9YJMcWzNZsWPpsI00RcW+IGyeVzMLo67E8C/A+StpV+Lwt0OiE=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6675.eurprd05.prod.outlook.com (10.141.190.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 23 Aug 2019 16:14:05 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 16:14:05 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrCAAAfEAIAADNCggAHJU4CAAAIMEIAABiaAgAAA2ACAACadAIAAFGdwgAE42YCAAABasIAAaLIAgAAC1QCAABSugIAAA+pA
Date:   Fri, 23 Aug 2019 16:14:04 +0000
Message-ID: <AM0PR05MB4866E33AF7203DE47F713FAAD1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190820225722.237a57d2@x1.home>
        <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820232622.164962d3@x1.home>
        <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822092903.GA2276@nanopsycho.orion>
        <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822095823.GB2276@nanopsycho.orion>
        <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822121936.GC2276@nanopsycho.orion>
        <AM0PR05MB4866F9650CF73FC671972127D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823081221.GG2276@nanopsycho.orion>
        <AM0PR05MB4866DED407D6F1C653D5D560D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823082820.605deb07@x1.home>
        <AM0PR05MB4866867150DAABA422F25FF8D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190823095229.210e1e84@x1.home>
In-Reply-To: <20190823095229.210e1e84@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b005a01-294e-4f92-0b02-08d727e4eb62
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6675;
x-ms-traffictypediagnostic: AM0PR05MB6675:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6675924EC74E5654C5A2CF65D1A40@AM0PR05MB6675.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(13464003)(189003)(199004)(76176011)(486006)(7696005)(229853002)(53946003)(53936002)(6436002)(55016002)(446003)(9456002)(11346002)(6246003)(81166006)(81156014)(86362001)(8676002)(54906003)(8936002)(9686003)(99286004)(476003)(14444005)(256004)(316002)(102836004)(186003)(25786009)(55236004)(53546011)(26005)(4326008)(6506007)(30864003)(3846002)(66066001)(561944003)(33656002)(71200400001)(14454004)(52536014)(74316002)(305945005)(71190400001)(76116006)(6916009)(66946007)(66476007)(66556008)(64756008)(66446008)(478600001)(2906002)(6116002)(7736002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6675;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kb0rVVobBZpQM7yxQB42uVXnDiwzk82B8Xqvo/zpwuWsUrySThyA8YcnCTu4nxYeQpiwXQptcao3DrrS8z1DES48+993U3XrDl9CNk5+77Knm8PcpnQ+ATReCJ/UVvDcbT6c6S+GLKgBFQ+KfJYSyufsTIn5sckum8SmZW7/mS5SOCNzSw0FAJkLYPJYJ1sEjDYOMGJ89Pd+VhmMJD+zLDmKWbwiOU3xAOjUMqmyOKNkzSZW6RHJpYPdCrmdN3sqnUt0khT32MWG7d+FQNu7/x3o602KYiAZkzVwKvLRyQNbhXZtFHnmxWrLaiiJ1CWnxUnoZHP+st13TbcX7a1zMX9LWL88UZjp8As3Lm7Hmt5qoIDi01z11zE4jMeDUp7RaVfgvOofMAa+h5HYDmBE4MNRS42KHy6Lc1Yk6L/zquE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b005a01-294e-4f92-0b02-08d727e4eb62
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 16:14:04.9773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zvtBFhTeVH1KhreQxFtje0MfvHwbezREecZwbbwtucv0mI6png4EiShmoBPR+aJlUr8Bg1v5fQnctkHF4sEjlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6675
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 23, 2019 9:22 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>; David =
S . Miller
> <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>; Cornelia
> Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Fri, 23 Aug 2019 14:53:06 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, August 23, 2019 7:58 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>;
> > > David S . Miller <davem@davemloft.net>; Kirti Wankhede
> > > <kwankhede@nvidia.com>; Cornelia Huck <cohuck@redhat.com>;
> > > kvm@vger.kernel.org; linux- kernel@vger.kernel.org; cjia
> > > <cjia@nvidia.com>; netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > > On Fri, 23 Aug 2019 08:14:39 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > Hi Alex,
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Jiri Pirko <jiri@resnulli.us>
> > > > > Sent: Friday, August 23, 2019 1:42 PM
> > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> > > > > <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>;
> > > > > Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> > > <cohuck@redhat.com>;
> > > > > kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > > > <cjia@nvidia.com>; netdev@vger.kernel.org
> > > > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > > >
> > > > > Thu, Aug 22, 2019 at 03:33:30PM CEST, parav@mellanox.com wrote:
> > > > > >
> > > > > >
> > > > > >> -----Original Message-----
> > > > > >> From: Jiri Pirko <jiri@resnulli.us>
> > > > > >> Sent: Thursday, August 22, 2019 5:50 PM
> > > > > >> To: Parav Pandit <parav@mellanox.com>
> > > > > >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
> > > > > >> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>;
> > > > > >> Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> > > > > <cohuck@redhat.com>;
> > > > > >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > > > >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > > > >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev
> > > > > >> core
> > > > > >>
> > > > > >> Thu, Aug 22, 2019 at 12:04:02PM CEST, parav@mellanox.com wrote=
:
> > > > > >> >
> > > > > >> >
> > > > > >> >> -----Original Message-----
> > > > > >> >> From: Jiri Pirko <jiri@resnulli.us>
> > > > > >> >> Sent: Thursday, August 22, 2019 3:28 PM
> > > > > >> >> To: Parav Pandit <parav@mellanox.com>
> > > > > >> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri
> > > > > >> >> Pirko <jiri@mellanox.com>; David S . Miller
> > > > > >> >> <davem@davemloft.net>; Kirti Wankhede
> > > > > >> >> <kwankhede@nvidia.com>; Cornelia Huck
> > > > > >> <cohuck@redhat.com>;
> > > > > >> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > > > >> >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > > > >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev
> > > > > >> >> core
> > > > > >> >>
> > > > > >> >> Thu, Aug 22, 2019 at 11:42:13AM CEST, parav@mellanox.com
> wrote:
> > > > > >> >> >
> > > > > >> >> >
> > > > > >> >> >> -----Original Message-----
> > > > > >> >> >> From: Jiri Pirko <jiri@resnulli.us>
> > > > > >> >> >> Sent: Thursday, August 22, 2019 2:59 PM
> > > > > >> >> >> To: Parav Pandit <parav@mellanox.com>
> > > > > >> >> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri
> > > > > >> >> >> Pirko <jiri@mellanox.com>; David S . Miller
> > > > > >> >> >> <davem@davemloft.net>; Kirti Wankhede
> > > > > >> >> >> <kwankhede@nvidia.com>; Cornelia Huck
> > > > > >> >> <cohuck@redhat.com>;
> > > > > >> >> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
> > > > > >> >> >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > > > >> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and
> > > > > >> >> >> mdev core
> > > > > >> >> >>
> > > > > >> >> >> Wed, Aug 21, 2019 at 08:23:17AM CEST,
> > > > > >> >> >> parav@mellanox.com
> > > wrote:
> > > > > >> >> >> >
> > > > > >> >> >> >
> > > > > >> >> >> >> -----Original Message-----
> > > > > >> >> >> >> From: Alex Williamson <alex.williamson@redhat.com>
> > > > > >> >> >> >> Sent: Wednesday, August 21, 2019 10:56 AM
> > > > > >> >> >> >> To: Parav Pandit <parav@mellanox.com>
> > > > > >> >> >> >> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
> > > > > >> >> >> >> <davem@davemloft.net>; Kirti Wankhede
> > > > > >> >> >> >> <kwankhede@nvidia.com>; Cornelia Huck
> > > > > >> >> >> >> <cohuck@redhat.com>; kvm@vger.kernel.org;
> > > > > >> >> >> >> linux-kernel@vger.kernel.org; cjia
> > > > > >> >> >> >> <cjia@nvidia.com>; netdev@vger.kernel.org
> > > > > >> >> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and
> > > > > >> >> >> >> mdev core
> > > > > >> >> >> >>
> > > > > >> >> >> >> > > > > Just an example of the alias, not proposing h=
ow it's
> set.
> > > > > >> >> >> >> > > > > In fact, proposing that the user does not
> > > > > >> >> >> >> > > > > set it, mdev-core provides one
> > > > > >> >> >> >> > > automatically.
> > > > > >> >> >> >> > > > >
> > > > > >> >> >> >> > > > > > > Since there seems to be some prefix
> > > > > >> >> >> >> > > > > > > overhead, as I ask about above in how
> > > > > >> >> >> >> > > > > > > many characters we actually have to work
> > > > > >> >> >> >> > > > > > > with in IFNAMESZ, maybe we start with
> > > > > >> >> >> >> > > > > > > 8 characters (matching your "index"
> > > > > >> >> >> >> > > > > > > namespace) and expand as necessary for
> > > > > >> >> >> disambiguation.
> > > > > >> >> >> >> > > > > > > If we can eliminate overhead in
> > > > > >> >> >> >> > > > > > > IFNAMESZ, let's start with
> > > > > >> 12.
> > > > > >> >> >> >> > > > > > > Thanks,
> > > > > >> >> >> >> > > > > > >
> > > > > >> >> >> >> > > > > > If user is going to choose the alias, why
> > > > > >> >> >> >> > > > > > does it have to be limited to
> > > > > >> >> >> >> sha1?
> > > > > >> >> >> >> > > > > > Or you just told it as an example?
> > > > > >> >> >> >> > > > > >
> > > > > >> >> >> >> > > > > > It can be an alpha-numeric string.
> > > > > >> >> >> >> > > > >
> > > > > >> >> >> >> > > > > No, I'm proposing a different solution where
> > > > > >> >> >> >> > > > > mdev-core creates an alias based on an
> > > > > >> >> >> >> > > > > abbreviated sha1.  The user does not provide
> > > > > >> >> >> >> > > > > the
> > > > > >> >> >> >> alias.
> > > > > >> >> >> >> > > > >
> > > > > >> >> >> >> > > > > > Instead of mdev imposing number of
> > > > > >> >> >> >> > > > > > characters on the alias, it should be best
> > > > > >> >> >> >> > > > > left to the user.
> > > > > >> >> >> >> > > > > > Because in future if netdev improves on
> > > > > >> >> >> >> > > > > > the naming scheme, mdev will be
> > > > > >> >> >> >> > > > > limiting it, which is not right.
> > > > > >> >> >> >> > > > > > So not restricting alias size seems right t=
o me.
> > > > > >> >> >> >> > > > > > User configuring mdev for networking
> > > > > >> >> >> >> > > > > > devices in a given kernel knows what
> > > > > >> >> >> >> > > > > user is doing.
> > > > > >> >> >> >> > > > > > So user can choose alias name size as it fi=
nds
> suitable.
> > > > > >> >> >> >> > > > >
> > > > > >> >> >> >> > > > > That's not what I'm proposing, please read ag=
ain.
> > > > > >> >> >> >> > > > > Thanks,
> > > > > >> >> >> >> > > >
> > > > > >> >> >> >> > > > I understood your point. But mdev doesn't know
> > > > > >> >> >> >> > > > how user is going to use
> > > > > >> >> >> >> > > udev/systemd to name the netdev.
> > > > > >> >> >> >> > > > So even if mdev chose to pick 12 characters,
> > > > > >> >> >> >> > > > it could result in
> > > > > >> >> collision.
> > > > > >> >> >> >> > > > Hence the proposal to provide the alias by the
> > > > > >> >> >> >> > > > user, as user know the best
> > > > > >> >> >> >> > > policy for its use case in the environment its us=
ing.
> > > > > >> >> >> >> > > > So 12 character sha1 method will still work by =
user.
> > > > > >> >> >> >> > >
> > > > > >> >> >> >> > > Haven't you already provided examples where
> > > > > >> >> >> >> > > certain drivers or subsystems have unique netdev
> prefixes?
> > > > > >> >> >> >> > > If mdev provides a unique alias within the
> > > > > >> >> >> >> > > subsystem, couldn't we simply define a netdev
> > > > > >> >> >> >> > > prefix for the mdev subsystem and avoid all
> > > > > >> >> >> >> > > other collisions?  I'm not in favor of the user
> > > > > >> >> >> >> > > providing both a uuid and an alias/instance.
> > > > > >> >> >> >> > > Thanks,
> > > > > >> >> >> >> > >
> > > > > >> >> >> >> > For a given prefix, say ens2f0, can two UUID->sha1
> > > > > >> >> >> >> > first 9 characters have
> > > > > >> >> >> >> collision?
> > > > > >> >> >> >>
> > > > > >> >> >> >> I think it would be a mistake to waste so many chars
> > > > > >> >> >> >> on a prefix, but
> > > > > >> >> >> >> 9 characters of sha1 likely wouldn't have a
> > > > > >> >> >> >> collision before we have 10s of thousands of
> > > > > >> >> >> >> devices.  Thanks,
> > > > > >> >> >> >>
> > > > > >> >> >> >> Alex
> > > > > >> >> >> >
> > > > > >> >> >> >Jiri, Dave,
> > > > > >> >> >> >Are you ok with it for devlink/netdev part?
> > > > > >> >> >> >Mdev core will create an alias from a UUID.
> > > > > >> >> >> >
> > > > > >> >> >> >This will be supplied during devlink port attr set
> > > > > >> >> >> >such as,
> > > > > >> >> >> >
> > > > > >> >> >> >devlink_port_attrs_mdev_set(struct devlink_port *port,
> > > > > >> >> >> >const char *mdev_alias);
> > > > > >> >> >> >
> > > > > >> >> >> >This alias is used to generate representor netdev's
> > > phys_port_name.
> > > > > >> >> >> >This alias from the mdev device's sysfs will be used
> > > > > >> >> >> >by the udev/systemd to
> > > > > >> >> >> generate predicable netdev's name.
> > > > > >> >> >> >Example: enm<mdev_alias_first_12_chars>
> > > > > >> >> >>
> > > > > >> >> >> What happens in unlikely case of 2 UUIDs collide?
> > > > > >> >> >>
> > > > > >> >> >Since users sees two devices with same phys_port_name,
> > > > > >> >> >user should destroy
> > > > > >> >> recently created mdev and recreate mdev with different UUID=
?
> > > > > >> >>
> > > > > >> >> Driver should make sure phys port name wont collide,
> > > > > >> >So when mdev creation is initiated, mdev core calculates the
> > > > > >> >alias and if there
> > > > > >> is any other mdev with same alias exist, it returns -EEXIST
> > > > > >> error before progressing further.
> > > > > >> >This way user will get to know upfront in event of collision
> > > > > >> >before the mdev
> > > > > >> device gets created.
> > > > > >> >How about that?
> > > > > >>
> > > > > >> Sounds fine to me. Now the question is how many chars do we
> > > > > >> want to
> > > have.
> > > > > >>
> > > > > >12 characters from Alex's suggestion similar to git?
> > > > >
> > > > > Ok.
> > > > >
> > > >
> > > > Can you please confirm this scheme looks good now? I like to get
> > > > patches
> > > started.
> > >
> > > My only concern is your comment that in the event of an abbreviated
> > > sha1 collision (as exceptionally rare as that might be at 12-chars),
> > > we'd fail the device create, while my original suggestion was that
> > > vfio-core would add an extra character to the alias.  For
> > > non-networking devices, the sha1 is unnecessary, so the extension
> > > behavior seems preferred.  The user is only responsible to provide a
> > > unique uuid.  Perhaps the failure behavior could be applied based on
> > > the mdev device_api.  A module option on mdev to specify the default
> > > number of alias chars would also be useful for testing so that we
> > > can set it low enough to validate the collision behavior.  Thanks,
> > >
> >
> > Idea is to have mdev alias as optional.
> > Each mdev_parent says whether it wants mdev_core to generate an alias
> > or not. So only networking device drivers would set it to true.
> > For rest, alias won't be generated, and won't be compared either
> > during creation time. User continue to provide only uuid.
>=20
> Ok
>=20
> > I am tempted to have alias collision detection only within children
> > mdevs of the same parent, but doing so will always mandate to prefix
> > in netdev name. And currently we are left with only 3 characters to
> > prefix it, so that may not be good either. Hence, I think mdev core
> > wide alias is better with 12 characters.
>=20
> I suppose it depends on the API, if the vendor driver can ask the mdev co=
re for
> an alias as part of the device creation process, then it could manage the=
 netdev
> namespace for all its devices, choosing how many characters to use, and f=
ail
> the creation if it can't meet a uniqueness requirement.  IOW, mdev-core w=
ould
> always provide a full sha1 and therefore gets itself out of the
> uniqueness/collision aspects.
>=20
This doesn't work. At mdev core level 20 bytes sha1 are unique, so mdev cor=
e allowed to create a mdev.
And then devlink core chooses only 6 bytes (12 characters) and there is col=
lision. Things fall apart.
Since mdev provides unique uuid based scheme, it's the mdev core's ownershi=
p to provide unique aliases.

> > I do not understand how an extra character reduces collision, if
> > that's what you meant.
>=20
> If the default were for example 3-chars, we might already have device 'ab=
c'.  A
> collision would expose one more char of the new device, so we might add
> device with alias 'abcd'.  I mentioned previously that this leaves an iss=
ue for
> userspace that we can't change the alias of device abc, so without additi=
onal
> information, userspace can only determine via elimination the mapping of =
alias
> to device, but userspace has more information available to it in the form=
 of
> sysfs links.
>=20
> > Module options are almost not encouraged anymore with other
> > subsystems/drivers.
>=20
> We don't live in a world of absolutes.  I agree that the defaults should =
work in
> the vast majority of cases.  Requiring a user to twiddle module options t=
o make
> things work is undesirable, verging on a bug.  A module option to enable =
some
> specific feature, unsafe condition, or test that is outside of the typica=
l use case
> is reasonable, imo.
>=20
> > For testing collision rate, a sample user space script and sample mtty
> > is easy and get us collision count too. We shouldn't put that using
> > module option in production kernel. I practically have the code ready
> > to play with; Changing 12 to smaller value is easy with module reload.
> >
> > #define MDEV_ALIAS_LEN 12
>=20
> If it can't be tested with a shipping binary, it probably won't be tested=
.  Thanks,
>=20
It is not the role of mdev core to expose collision efficiency/deficiency o=
f the sha1.
It can be tested outside before mdev choose to use it.

I am saying we should test with 12 characters with 10,000 or more devices a=
nd see how collision occurs.
Even if collision occurs, mdev returns EEXIST status indicating user to pic=
k a different UUID for those rare conditions.
