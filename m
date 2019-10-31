Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5109CEB1B7
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfJaN6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:58:23 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:33454
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727567AbfJaN6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 09:58:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVHC09jt6/PbQwRA+4gG3kt//MHcuqETIhBON6WvW5aBTWhpRFOzOEHLsUvUUhjojS8fD60Gn+sr3B3tNsbdY35YBN8TQ6ZEU3o77asAGnQQOwfaENOP1ZhcinTnN4m7sY+d9EpCSIJZRiPpvw3nx7pMOecg3S0a/xnCWzHUf+HeZf94oLPqPqIKUs1RAHiZFhJhzCWZzAjq9KzRnrlr5haj9Kmss5pbXeBuCdXORuAV1jiNnUJmFJ2cboVWXdFzAK5aHaJ+rMWVHEuTiLXMy+isw/0Onaqv6GawjEyEiEWwhs+PixhS8P52PtH2qetT7WvaZCQVvFsWgrLQDHVeSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYDYTQWSb44NQ88eNFVsUs9pq/ivf6AC0qFG2oDl+8U=;
 b=A7lgGVuD8kDWxoZOZIHqYL1j3vq3r3faKaXzpnI41XZVDwFZC7fBeQFAVRBM07ZSbaI33GF1pR1HRuyZG6cDY5Dq9Jeud2bmbo2EpnSvquSFLQu5Ny2ZzIKqKD5MgNHqLHs2ufhQQV9PjtfpE22cWWZWiC+JudE1X7LDG/ib1bVyy8v1Rc0JIhlknLFhFwWz++W6O33y3CZOATBUY6efgEATNJrN3SOFmHLydhIxgpQdKmx31rgwCFSNkoBOvQEhH8FgRdmCg/hc6dH4eDIIhvUyTj+Ce11cDOKXcouPlVREjYeJ2c3GcBWSSAFifi1fRyj0pkXE7o/m++MilNTPoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYDYTQWSb44NQ88eNFVsUs9pq/ivf6AC0qFG2oDl+8U=;
 b=sgDmREQjNS0sicB/Yz4KKaJG9S1rTsnBLrifYnrL3bys/tXAW3ELkK+ID2BfVJvt+F2aI7ucCz/iX2ip7N3mjUkBhHzY8RMdwiYhGAgqx1M/Prz7V6H3VsY/Rgrr1U5hq+pv9wBqDVCp3+VXBrEPYcUpNm4ZXdvGtLZtaLbaWi4=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5359.eurprd04.prod.outlook.com (20.178.120.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 31 Oct 2019 13:58:18 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2387.027; Thu, 31 Oct 2019
 13:58:18 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Joe Perches <joe@perches.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Roy Pledge <roy.pledge@nxp.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: RE: [net-next 10/13] dpaa_eth: remove netdev_err() for user errors
Thread-Topic: [net-next 10/13] dpaa_eth: remove netdev_err() for user errors
Thread-Index: AQHVj9+JMEfAPVN9j0OMYib1I/XpVad0olSAgAAkSlA=
Date:   Thu, 31 Oct 2019 13:58:18 +0000
Message-ID: <VI1PR04MB5567583F09439DC9545D0AB1EC630@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
         <1572521819-10458-11-git-send-email-madalin.bucur@nxp.com>
 <78c289a25faaa5dab2975f050199c93142718ab6.camel@perches.com>
In-Reply-To: <78c289a25faaa5dab2975f050199c93142718ab6.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e7a4a6f9-7d57-47a8-d8bc-08d75e0a6235
x-ms-traffictypediagnostic: VI1PR04MB5359:|VI1PR04MB5359:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5359CF198349C2798402A390EC630@VI1PR04MB5359.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(189003)(199004)(13464003)(476003)(6436002)(33656002)(86362001)(64756008)(110136005)(81166006)(53546011)(6116002)(54906003)(3846002)(2906002)(6506007)(11346002)(2501003)(25786009)(446003)(305945005)(229853002)(26005)(6246003)(102836004)(8676002)(186003)(44832011)(55016002)(4001150100001)(81156014)(486006)(9686003)(76116006)(8936002)(14454004)(4326008)(7736002)(66946007)(99286004)(66446008)(66476007)(316002)(66066001)(66556008)(74316002)(7696005)(71190400001)(478600001)(52536014)(71200400001)(2201001)(5660300002)(256004)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5359;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6m+h0mW8UAiR3HKfc442dUjP1XevmPWpRYVXAXS7GCyEwuhsP9C1V2iNmOs0bdLySJDvUFdQyC+oYFzccFrTRk1ifqVxLE8OSrQ1YZCxqbIx9Sch42ho5bvhoCP/DS1bmZjwNE/bgVApd4V4am+879ofQCOJxDlq1dz+VXQlEodzL64m8DwVKKI231C360lWRz1glml6Pp7g84Odmybdq206gNVYSL0MrfZ1QuJzSHIzGb5VtZLo6+l1ejyE+WcPvpAlXguQsCn8tWgAP+g2FAL0lJsJDwYZOAx8tRNt9OVOw9WdqQisgpQullJMS2QrMS3o92vMMI+d8UtLOAvn73mMJH/S3Y7RKhRDml2xauoJFn+dIYVKozn8weIlFA6Ipd25eifJKzom65lLh6CKXhqP3GfDJaV0fNTD2anO9tMyiUuBO/qZkEPS62dU+Yjm
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a4a6f9-7d57-47a8-d8bc-08d75e0a6235
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 13:58:18.5635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7zgyBT6INjwYXLinKpgyq7ytS35l48CAYyENaigy35b98QxpB2bKLEd5LpfvmZfXF+QvcX+WflkGhfpkq1S73g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Thursday, October 31, 2019 1:48 PM
> To: Madalin Bucur <madalin.bucur@nxp.com>; davem@davemloft.net;
> netdev@vger.kernel.org
> Cc: Roy Pledge <roy.pledge@nxp.com>; jakub.kicinski@netronome.com
> Subject: Re: [net-next 10/13] dpaa_eth: remove netdev_err() for user
> errors
>=20
> On Thu, 2019-10-31 at 13:36 +0200, Madalin Bucur wrote:
> > User reports that an application making an (incorrect) call to
> > restart AN on a fixed link DPAA interface triggers an error in
> > the kernel log while the returned EINVAL should be enough.
> []
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
> []
> > @@ -81,7 +81,6 @@ static int dpaa_get_link_ksettings(struct net_device
> *net_dev,
> >  				   struct ethtool_link_ksettings *cmd)
> >  {
> >  	if (!net_dev->phydev) {
> > -		netdev_dbg(net_dev, "phy device not initialized\n");
> >  		return 0;
> >  	}
>=20
> ideally the now excess braces would be removed too.

You're right, I'll send a v2
=20
> > @@ -96,7 +95,6 @@ static int dpaa_set_link_ksettings(struct net_device
> *net_dev,
> >  	int err;
> >
> >  	if (!net_dev->phydev) {
> > -		netdev_err(net_dev, "phy device not initialized\n");
> >  		return -ENODEV;
> >  	}
>=20
> etc...
>=20

