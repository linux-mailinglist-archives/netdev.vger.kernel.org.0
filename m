Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9708211BD89
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLKT5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:57:43 -0500
Received: from mail-eopbgr50067.outbound.protection.outlook.com ([40.107.5.67]:50933
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726568AbfLKT5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 14:57:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8CBfehL1gaAClQzsyr1J0KONfajqGHrAgv/G0SmO7EHE84rX6H98KW4gV1S5FS6p8/2VrnVmFpiqfxRGqYQpH86KduacI/aT1K+8VsEg5VHuqpu76+d/lA/5w3Xwt0eUJUzOXbDi6tfA25/DhunyC15qQiyPlxJdhVNNIHuF7dOVtK8ti7DU//qo6/pvUV59yOmaMMUYuj2Y2ThWRxDXj6wW+XN9I3bWqmkQ9MpxhW+tB7YJoxpxZFULs5naLFcUW/fAGQAznvjJUYXNZfKT5kHlAu9JFjxqVcQz4+jRJGWG324KLLsNL+6EZ6GwtBAIlCUQqKkpy/9GutcjrCmAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lze/LZZC1oFrb/OSkXqyla7Pn7Vk+LC/x3dcukNec4I=;
 b=Wslq5/I3OhU48ufyKKYQK/U9hwYLEpxtaw9KnX+Hbn9Hvp1pT0OJxQu4u0ZakNt9ajTCPyJMqDoRZqMq1rhwb39pHTfbg/IhDDuBVdRUVlFEQKEqcGbKrJS1ja29gGj5OEXisrZRx5Ya7B+mDz/FNC9CWDjopLxNk6OyA7ipHujXhgUBvQ3rBILSgoujFX1rzsO8CIS+u7ZXoNnUyQ1SfNauCsOvso/oFInJA2MFpDSs+JKorFIP4fR7j4kPGCcTVu0RCc3+wMBKOwj0D3+eXqlAt1T64h9WqhkE/TOcIX1VzgOl36u6Or0X/xl8rPiarrfH3V23zadTvX6zvSXmCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lze/LZZC1oFrb/OSkXqyla7Pn7Vk+LC/x3dcukNec4I=;
 b=phT/LMQDr547nEGN8WLC+rfsGsbevioP7icZAyP4H7rwtspAN3UD9iRwF7xPAAsiVdSMhOJkuhadoFjd8emMNki4PN1Nu4EJk6SZe60lrDlgPmUlbwnG63pQlwFCWAbUFw7exwuzVRlmXUZPTzFn8uXd6DCur9TwR+rN2F6UrH8=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB5160.eurprd05.prod.outlook.com (20.177.191.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Wed, 11 Dec 2019 19:57:34 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd%6]) with mapi id 15.20.2538.016; Wed, 11 Dec 2019
 19:57:34 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Topic: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Index: AQHVr871nDBB5hrvy0ak2C7+9Ay1lae1Oa8AgAAB1gCAABOZgIAACO8Q
Date:   Wed, 11 Dec 2019 19:57:34 +0000
Message-ID: <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191211111537.416bf078@cakuba.netronome.com>
In-Reply-To: <20191211111537.416bf078@cakuba.netronome.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9cc46e15-47c9-4b62-a095-08d77e745d45
x-ms-traffictypediagnostic: AM6PR05MB5160:|AM6PR05MB5160:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB51609C801FA10C825817D5AFC55A0@AM6PR05MB5160.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(51914003)(13464003)(199004)(189003)(55016002)(66446008)(64756008)(66556008)(66476007)(52536014)(4326008)(71200400001)(9686003)(5660300002)(76116006)(66946007)(316002)(54906003)(2906002)(8936002)(81156014)(81166006)(186003)(478600001)(8676002)(26005)(7696005)(6506007)(53546011)(86362001)(6916009)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5160;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EU9kFpYYe2kEN6lawnLjAjCjWVsn58rsrHOAQNt8/d+3v1m4YNeZkx4dampwIQAy7byjYXP8z/2bczYSwRPtaqwLkidxYi1xppGlu75V9fgJtQUaonbZWCn2QZihxuexdk3hfHA537cA1wL/XIWf1LnaG1NCQ5ZTqOU2nd9anlv3OyWNylL1uT8apyQx9vjKKc8+SYbGralxFOarAUmMH/4Aaz469yit7VssZifzkMr46Bu1NoHREGOw3h9fpjFCjDmxIiSmVFjTq0HEFH0PnnqXwZLG/yRxMIcLmsEEAgswVyTzbgioThyw62ufIJc4GBbar0iQlrRur7h/2XmkrYYZEuqHrSN+Q2G4fNtPRDFwIqbzHRmVdjDUvNUBn1pevytaDiXdxQM7JU+oNxe1p510W2XWPivfjFssadZs4CcUUW6fvFZpFoc4AGb4Pb+6+8g1fHdoe/+JFDlObJ3Vkvsno/BUNCZi79ZqWj12OdeZq/FnWk9pEqD+uFIeRbeglbleEjrXzcBG5jOb/i2UVQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc46e15-47c9-4b62-a095-08d77e745d45
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 19:57:34.1215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ScFmuPDrPs9MPDXO86jr6gHNty7YmKuG3RQL+j/fiBDmzYnqzL4TYiNdsMfp/btZzp0zjXOFPezsYzyb6S8UVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Wednesday, December 11, 2019 11:16 AM
> To: Yuval Avnery <yuvalav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
>=20
> On Wed, 11 Dec 2019 18:19:56 +0000, Yuval Avnery wrote:
> > > On Wed, 11 Dec 2019 04:58:53 +0200, Yuval Avnery wrote:
> > > > Currently there is no limit to the number of VFs netdevsim can enab=
le.
> > > > In a real systems this value exist and used by driver.
> > > > Fore example, Some features might need to consider this value when
> > > > allocating memory.
> > >
> > > Thanks for the patch!
> > >
> > > Can you shed a little bit more light on where it pops up? Just for my
> curiosity?
> >
> > Yes, like we described in the subdev threads.
> > User should be able to configure some attributes before the VF was
> enabled.
> > So all those (persistent) VF attributes should be available for query
> > and configuration before VF was enabled.
> > The driver can allocate an array according to max_vfs to hold all that
> > data, like we do here in" vfconfigs".
>=20
> I was after more practical reasoning, are you writing some tests for subd=
ev
> stuff that will depend on this change? :)

Yes we are writing tests for subdev with this.
This is the way mlx5 works.. is that practical enough?

>=20
> > > > Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
> > > > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > > >
> > > > diff --git a/drivers/net/netdevsim/bus.c
> > > > b/drivers/net/netdevsim/bus.c index 6aeed0c600f8..f1a0171080cb
> > > > 100644
> > > > --- a/drivers/net/netdevsim/bus.c
> > > > +++ b/drivers/net/netdevsim/bus.c
> > > > @@ -26,9 +26,9 @@ static struct nsim_bus_dev
> > > > *to_nsim_bus_dev(struct device *dev)  static int
> > > > nsim_bus_dev_vfs_enable(struct nsim_bus_dev
> > > *nsim_bus_dev,
> > > >  				   unsigned int num_vfs)
> > > >  {
> > > > -	nsim_bus_dev->vfconfigs =3D kcalloc(num_vfs,
> > > > -					  sizeof(struct nsim_vf_config),
> > > > -					  GFP_KERNEL);
> > >
> > > You're changing the semantics of the enable/disable as well now.
> > > The old values used to be wiped when SR-IOV is disabled, now they
> > > will be retained across disable/enable pair.
> > >
> > > I think it'd be better if that wasn't the case. Users may expect a
> > > system to be in the same state after they enable SR-IOV, regardless
> > > if someone else used SR-IOV since last reboot.
> >
> > Right,
> > But some values should retain across enable/disable, for example MAC
> address which is persistent.
> > So maybe we need to retain some values, while resetting others on
> disable?
> > Would that work?
>=20
> Mmm. That is a good question. For all practical purposes SR-IOV used to b=
e
> local to the host that enables it until Smart/middle box NICs emerged.
>=20
> Perhaps the best way forward would be to reset the config that was set vi=
a
> legacy APIs and keep only the MACs provisioned via persistent devlink API=
?
>=20
> So for now we'd memset, and once devlink API lands reset selectively?

Legacy is also persistent.
Currently when you set mac address with "ip link vf set mac" it is persiste=
nt (at least in mlx5).
But ip link only exposes enabled VFS, so driver on VF has to reload to acqu=
ire this MAC.
With devlink subdev it will be possible to set the MAC before VF was enable=
d.

I think we need to distinguish here between:
- PF sets MAC to a VF - persistent.
- VF sets MAC to itself - not persistent.

But is the second case relevant in netdevsim?


>=20
> > > Could you add a memset(,0,) here?
> > >
> > > > +	if (nsim_bus_dev->max_vfs < num_vfs)
> > > > +		return -ENOMEM;
> > > > +
> > > >  	if (!nsim_bus_dev->vfconfigs)
> > > >  		return -ENOMEM;
> > >
> > > This check seems useless now, no? We will always have vfconfigs
