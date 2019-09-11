Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2923EB0011
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 17:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfIKPap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 11:30:45 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:26315
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728385AbfIKPao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 11:30:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eujU0MAWH6jiTJT8SozHYPRL8WAZBDbcAfVUdxkBmxqvKKErtmEoihuYov13sSFormOBhjpib0PlmC4O47SkPfAMtjPIiIIgjs3Cdonym5Ki86PQro1jfs8kl2xiC3Fh4v/YWW9yhMOtdSHnGqIrjViCy0NJ0AzDP5wPPAb7KupA5oedGnJZsWRGnafZkB5lbYDjznBj5HhHFbdFLLO5P+mPRzWszA5XpoyDQ6deWrJYvsYUMV19nEqyekAa2uFpFDaO+EO5LBlKre67cZuxLX9Wr5pa7ePGmUL0ZAjqXXDI/+SUDiRbCPuZIeVTw044FEdw0PK58qFjQy0G+EiHGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQUVO7eImhDYW9CJvxffN3GRPzuT15tU3eJaDPOBYyg=;
 b=A3o9eOAXv1VUAVJwd7FEKjL+ZVDebE+elE0AxeFP+rlX6AU3pbnHa+ZbejKavo8Z6TeTI155A0FM2mgj1a/WUu4pl8EmJwUM+Zj9Sqd5pZ6W7LaNUwYQteJ6LeowiDkh0z1DxTit9O6ERTWoIIzh2f5XCv5Lu02HM6qsRnJodKu3j1F/5x4BmlBdyPMQSmD905SGdzckr3yWaJWkdKhg1S5ZyyvJADd/YPekTJDvbxVgFtNI387IfTHdcKxZwjy/VlgJGpQCS7TOpepqpJgsbUQCDfRvPgFBG/BCvdxPJeDqjIqLB0tT3jM+KbpNBxKWI6Yhg49zCi6xLhMDDR7lSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQUVO7eImhDYW9CJvxffN3GRPzuT15tU3eJaDPOBYyg=;
 b=LX9/70/sChqmTRZaiiC8ba4AOE8EmzmAQLj017F+24OzFeCj0pt5k0ku1jY1kDSqoayvzYp1urAj2TJsH9zEq3S5lcvYJEDu5AJk8dsskFmcnRGzmxMt49QqVC8f78p+auw8MXdsfSlP2SmXXTxAnSwLsBH+APuAI8iUJObRx9k=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5025.eurprd05.prod.outlook.com (52.134.89.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 15:30:40 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 15:30:40 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Topic: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Index: AQHVYUZdAS6KYIr8SUO1vQ8myuXcNacjy68wgALDGQCAABfpQA==
Date:   Wed, 11 Sep 2019 15:30:40 +0000
Message-ID: <AM0PR05MB48668DFF8E816F0D2D3041BFD1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <AM0PR05MB4866F76F807409ED887537D7D1B70@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190911145610.453b32ec@x1.home>
In-Reply-To: <20190911145610.453b32ec@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88583fb9-e32f-42f8-7c14-08d736cd00d0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5025;
x-ms-traffictypediagnostic: AM0PR05MB5025:|AM0PR05MB5025:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5025B019B5C92707178ECAC4D1B10@AM0PR05MB5025.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(54534003)(13464003)(189003)(199004)(2906002)(81166006)(8936002)(81156014)(8676002)(7736002)(74316002)(305945005)(64756008)(5660300002)(66476007)(76116006)(66946007)(7696005)(54906003)(33656002)(71200400001)(71190400001)(99286004)(316002)(6306002)(3846002)(66066001)(6916009)(229853002)(256004)(25786009)(478600001)(66556008)(66446008)(14444005)(6116002)(86362001)(52536014)(76176011)(446003)(11346002)(486006)(9686003)(55016002)(186003)(6436002)(53936002)(6246003)(53376002)(4326008)(6506007)(26005)(53546011)(966005)(102836004)(14454004)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5025;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: feOfqoVgQpT/nXY1fwOJsu9MxwoSbZEyY03on0NO2s/+tSego12puBsQNyLBLbPMfTGuEKhDNnkwhrPk35q+LJNfVKw25QdRbeGFEqP2FIw9f548a2uycru+yIOrfj3iFLOA59ss1PUhEy87Llhc03gpq8z10YYSS6f7AQpzMmTAPeZJun3ST0m594CH2t8O6tNfTMdSCwiiklvqCPLr7PQjZv+qo7/a0ox5VeeOQPB3XAfIKGLDYTLzZtczR/Ly/xT6tld8b/rIBA1Lu7T4sAnhSLUO38J7jxqKwHovHRClbki7ATASlTiJzbuNgPzEemFHJmXDe+yEB2FgtKllALRcXr1CICSct8dmeeYZZ0b+CpRcz5xwTI5tkEJUkHMHNeghevF7EPLLH+CwIBnBhf7xrf+SWaiEwLFUtCKfJCw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88583fb9-e32f-42f8-7c14-08d736cd00d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 15:30:40.5683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +4Ueha/UbWAM2PufX4W71oPthIaq62C2NwnvG/U69lgZbYEfNghKHzREYr4YXhbs2WkmnyGCQVwQmxsK6XfgQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5025
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, September 11, 2019 8:56 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
>=20
> On Mon, 9 Sep 2019 20:42:32 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Hi Alex,
> >
> > > -----Original Message-----
> > > From: Parav Pandit <parav@mellanox.com>
> > > Sent: Sunday, September 1, 2019 11:25 PM
> > > To: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > kwankhede@nvidia.com; cohuck@redhat.com; davem@davemloft.net
> > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> > > Subject: [PATCH v3 0/5] Introduce variable length mdev alias
> > >
> > > To have consistent naming for the netdevice of a mdev and to have
> > > consistent naming of the devlink port [1] of a mdev, which is formed
> > > using phys_port_name of the devlink port, current UUID is not usable
> > > because UUID is too long.
> > >
> > > UUID in string format is 36-characters long and in binary 128-bit.
> > > Both formats are not able to fit within 15 characters limit of netdev
> name.
> > >
> > > It is desired to have mdev device naming consistent using UUID.
> > > So that widely used user space framework such as ovs [2] can make
> > > use of mdev representor in similar way as PCIe SR-IOV VF and PF
> representors.
> > >
> > > Hence,
> > > (a) mdev alias is created which is derived using sha1 from the mdev
> name.
> > > (b) Vendor driver describes how long an alias should be for the
> > > child mdev created for a given parent.
> > > (c) Mdev aliases are unique at system level.
> > > (d) alias is created optionally whenever parent requested.
> > > This ensures that non networking mdev parents can function without
> > > alias creation overhead.
> > >
> > > This design is discussed at [3].
> > >
> > > An example systemd/udev extension will have,
> > >
> > > 1. netdev name created using mdev alias available in sysfs.
> > >
> > > mdev UUID=3D83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> > > mdev 12 character alias=3Dcd5b146a80a5
> > >
> > > netdev name of this mdev =3D enmcd5b146a80a5 Here en =3D Ethernet lin=
k m
> > > =3D mediated device
> > >
> > > 2. devlink port phys_port_name created using mdev alias.
> > > devlink phys_port_name=3Dpcd5b146a80a5
> > >
> > > This patchset enables mdev core to maintain unique alias for a mdev.
> > >
> > > Patch-1 Introduces mdev alias using sha1.
> > > Patch-2 Ensures that mdev alias is unique in a system.
> > > Patch-3 Exposes mdev alias in a sysfs hirerchy, update Documentation
> > > Patch-4 Introduces mdev_alias() API.
> > > Patch-5 Extends mtty driver to optionally provide alias generation.
> > > This also enables to test UUID based sha1 collision and trigger
> > > error handling for duplicate sha1 results.
> > >
> > > [1] http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > > [2] https://docs.openstack.org/os-vif/latest/user/plugins/ovs.html
> > > [3] https://patchwork.kernel.org/cover/11084231/
> > >
> > > ---
> > > Changelog:
> > > v2->v3:
> > >  - Addressed comment from Yunsheng Lin
> > >  - Changed strcmp() =3D=3D0 to !strcmp()
> > >  - Addressed comment from Cornelia Hunk
> > >  - Merged sysfs Documentation patch with syfs patch
> > >  - Added more description for alias return value
> >
> > Did you get a chance review this updated series?
> > I addressed Cornelia's and yours comment.
> > I do not think allocating alias memory twice, once for comparison and
> > once for storing is good idea or moving alias generation logic inside
> > the mdev_list_lock(). So I didn't address that suggestion of Cornelia.
>=20
> Sorry, I'm at LPC this week.  I agree, I don't think the double allocatio=
n is
> necessary, I thought the comment was sufficient to clarify null'ing the
> variable.  It's awkward, but seems correct.
>=20
> I'm not sure what we do with this patch series though, has the real
> consumer of this even been proposed?  It feels optimistic to include at t=
his
> point.  We've used the sample driver as a placeholder in the past for
> mdev_uuid(), but we arrived at that via a conversion rather than explicit=
ly
> adding the API.  Please let me know where the consumer patches stand,
> perhaps it would make more sense for them to go in together rather than
> risk adding an unused API.  Thanks,
>=20
Given that consumer patch series is relatively large (around 15+ patches), =
I was considering to merge this one as pre-series to it.
Its ok to combine this with consumer patch series.
But wanted to have it reviewed beforehand, so that churn is less in actual =
consumer series which is more mlx5_core and devlink/netdev centric.
So if you can add Review-by, it will be easier to combine with consumer ser=
ies.

And if we merge it with consumer series, it will come through Dave Miller's=
 tree instead of your tree.
Would that work for you?
