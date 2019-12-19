Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB575126473
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfLSOTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:19:34 -0500
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:53831
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726695AbfLSOTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 09:19:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2nY2Yb6iPyvNfkkLHG8LICY/JQFZAsVFcEFMs1braKjv8bfSDNvssQziWbBltIJU29Av9JBwdE2VEzhOR1JhKoSks6SFaHWv+2fJNbMJLORJCDgMYBgxumZzR7rB3LvkQ6wh/Dq1AdhpCGVpG9wESHALStV+h94d+CSN3wId6QjX36YAe1AYqzQF54josQVUGbGnZwm7TqGoFqwQeiDovOYGdpJxQ8d5Qyu0n8EkYa4eoyJtRgJdTCTb/ReerZkJgMn1HZcRUqlQXE9f1qX43pp1w+nBFV59xOJipq7RbHTR9Me1Y+DBdVGBE7VQPsCzdp2PqKVOsxOscjpyCn+qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfGQMeNZ1GS2BrfmTb156MkCjPPoLRhhwVB83OZNCVs=;
 b=nKR7+RcdrT+YpyW5Geqq7uo4FRbVNgvMnrba23bJbvFpVF7celwZ19xXWK6mPXwjAXt8RMvaf0GNK0j1MJ98VIrGgke5ltM45mCqsMm9IqTvWjxQ264BT+9GMrk8VYmn+FGuZc3b9sr8YcEGgaqP7KXAxJ1J0szdTHx7dTReCNcysDZ/jdteL36/G3JbikG4N/RJ+k2V95aQBP3vLauZsdYLUNvJpkhsjF3DAJ0kFLTsQ0Bi2OEXdbsTcI27A3l/ppratKPFWUG+750nzl81H6zu6w//J2J5bxFNvXRxrJX18uPxM6au/onTWEgGcUEHwQ5HxWzhKtb9dLxofV/WMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfGQMeNZ1GS2BrfmTb156MkCjPPoLRhhwVB83OZNCVs=;
 b=WBgBUe5DoDmyO4CAvj0Q93KzO4qqFSBicBCP++2aqIcoTaxHqqOX6LJF8PzvDmjsdTOELmVn2gvDK8fibJixZP8YLsQuhzf3q/7cYDx+MBz8ZSV0A/2oHdeIEEluPV1VkydVVISP+hdKMx7G/16JwQTXis8VWhKwKoNk173j7YE=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2941.eurprd04.prod.outlook.com (10.175.24.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Thu, 19 Dec 2019 14:19:26 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661%11]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 14:19:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next v4 0/5] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Topic: [PATCH net-next v4 0/5] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Index: AQHVj3h6S20SH1EgGUuv036872AtCKePooGAgDHo4ACAAEPqYA==
Date:   Thu, 19 Dec 2019 14:19:25 +0000
Message-ID: <VI1PR0402MB280023C3F649F5F1BD796DD0E0520@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
 <20191117160443.GG1344@shell.armlinux.org.uk>
 <20191219101456.GZ1344@shell.armlinux.org.uk>
In-Reply-To: <20191219101456.GZ1344@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6a9ed01-1712-44a2-9252-08d7848e73e1
x-ms-traffictypediagnostic: VI1PR0402MB2941:|VI1PR0402MB2941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB29416F5B42BCA8D7DA54E43CE0520@VI1PR0402MB2941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(199004)(189003)(71200400001)(66446008)(8936002)(316002)(6916009)(6506007)(64756008)(66476007)(76116006)(52536014)(66946007)(2906002)(9686003)(55016002)(54906003)(7696005)(33656002)(81156014)(66556008)(478600001)(5660300002)(8676002)(44832011)(4326008)(26005)(186003)(81166006)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2941;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wMO7Xci26vdvFOZC9cAYtegwBzSb4Pz7L7jEY8/zlbZALD1BzFFaZjFVfMI13LZ3tcB/5Iakoh7gN338NE7gVtzP9WzrbFPDziliq44EABfz/0TylFhr3tYuAWQHAhqOlCzUXO57XXZjGx+MQTyy5KDxBvy4pCAY0PeoE0vMmonEEdcWpOFu4la5tJp35CJQD6mvSCPpxiD8jzL6Ass9aJnQDuysHBCVtSI3xzmNrHqdWa7p4IU9p9Zwrq/D9+xHNs5Z2fZp2iSLE7na22BoGefRTL8Lu1L6n+6+2AAM9FJIPDAh1reMXBfVsiJ2Zz58TgFas6ktSQ6utYns7gnoOYX0laNANQ8/g8gyc9LjCjdYqcooBdVyoMWRxevNMJ77LZbvu3k2yI3Zvm7dMYyFEaqefNK2x6tJZ77HG+2YfpXvkao0/RsbB9GYXwa1Ub54
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a9ed01-1712-44a2-9252-08d7848e73e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 14:19:25.9440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lpYPO4m0FofVJjwSLp3CrhDkb8sETfeWuJ/sUmbs3dNc6GuRqHZJtuV31GAkfP6HrWmm8LJaTHAQPRF1h+i1Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next v4 0/5] dpaa2-eth: add MAC/PHY support throu=
gh
> phylink
>=20
> On Sun, Nov 17, 2019 at 04:04:43PM +0000, Russell King - ARM Linux admin
> wrote:
> > The other thing I see is that with dpmac.7 added, I get all the iommu
> > group messages, and buried in there is:
> >
> > fsl_dpaa2_eth dpni.1: Probed interface eth1
> >
> > as expected.  When I issue the dpmac.8 command (which is when all those
> > warnings are spat out) I see:
> >
> > fsl_dpaa2_eth dpni.2: Probed interface eth1
> >
> > So dpni.1 has gone, eth1 has gone to be replaced by dpni.2 bound to eth=
1.
> >
> > Looking in /sys/bus/fsl-mc/devices/dpni.[12]/ it seems that both
> > devices still exist, but dpni.1 has been unbound from the dpaa2 eth
> > driver.
>=20
> I'm seeing this again, it's very annoying because it means one of the
> interfaces vanishes and can't then be resurected.
>=20
> [  161.573637] fsl_mc_allocator dpbp.2: Adding to iommu group 0
> [  161.579289] fsl_mc_allocator dpmcp.36: Adding to iommu group 0
> [  161.668060] fsl_mc_allocator dpcon.32: Adding to iommu group 0
> [  161.752477] fsl_mc_allocator dpcon.37: Adding to iommu group 0
> [  161.757221] fsl_mc_allocator dpcon.36: Adding to iommu group 0
> [  161.761981] fsl_mc_allocator dpcon.35: Adding to iommu group 0
> [  161.766704] fsl_mc_allocator dpcon.34: Adding to iommu group 0
> [  161.771453] fsl_mc_allocator dpcon.33: Adding to iommu group 0
> [  161.932117] fsl-mc dpcon.2: Removing from iommu group 0
> [  161.936171] fsl-mc dpcon.1: Removing from iommu group 0
> [  161.940239] fsl-mc dpcon.0: Removing from iommu group 0
> [  161.945283] fsl_mc_allocator dpcon.44: Adding to iommu group 0
> [  161.950074] fsl_mc_allocator dpcon.43: Adding to iommu group 0
> [  161.954807] fsl_mc_allocator dpcon.42: Adding to iommu group 0
> [  161.959513] fsl_mc_allocator dpcon.41: Adding to iommu group 0
> [  161.964236] fsl_mc_allocator dpcon.40: Adding to iommu group 0
> [  161.968933] fsl_mc_allocator dpcon.39: Adding to iommu group 0
> [  161.973642] fsl_mc_allocator dpcon.38: Adding to iommu group 0
> [  162.051949] fsl_dpaa2_eth dpni.1: Adding to iommu group 0
> [  162.206770] fsl_dpaa2_eth dpni.1: Probed interface eth1
> [  162.211811] fsl_mc_allocator dpcon.47: Adding to iommu group 0
> [  162.216544] fsl_mc_allocator dpcon.46: Adding to iommu group 0
> [  162.221260] fsl_mc_allocator dpcon.45: Adding to iommu group 0
> [  162.227232] fsl_mc_allocator dpcon.2: Adding to iommu group 0
> [  162.231864] fsl_mc_allocator dpcon.1: Adding to iommu group 0
> [  162.236497] fsl_mc_allocator dpcon.0: Adding to iommu group 0
>=20
> [  167.581066] fsl_mc_allocator dpbp.3: Adding to iommu group 0
> [  167.586802] fsl_mc_allocator dpmcp.37: Adding to iommu group 0
> [  167.592368] fsl_mc_allocator dpcon.51: Adding to iommu group 0
> [  167.597120] fsl_mc_allocator dpcon.50: Adding to iommu group 0
> [  167.601869] fsl_mc_allocator dpcon.49: Adding to iommu group 0
> [  167.606604] fsl_mc_allocator dpcon.48: Adding to iommu group 0
> [  168.304644] fsl-mc dpcon.4: Removing from iommu group 0
> [  168.308710] fsl-mc dpcon.3: Removing from iommu group 0
> [  168.312783] fsl-mc dpcon.2: Removing from iommu group 0
> [  168.316828] fsl-mc dpcon.1: Removing from iommu group 0
> [  168.320874] fsl-mc dpcon.0: Removing from iommu group 0
> [  168.325946] fsl_mc_allocator dpcon.59: Adding to iommu group 0
> [  168.330682] fsl_mc_allocator dpcon.58: Adding to iommu group 0
> [  168.335393] fsl_mc_allocator dpcon.57: Adding to iommu group 0
> [  168.340105] fsl_mc_allocator dpcon.56: Adding to iommu group 0
> [  168.344816] fsl_mc_allocator dpcon.55: Adding to iommu group 0
> [  168.349530] fsl_mc_allocator dpcon.54: Adding to iommu group 0
> [  168.354256] fsl_mc_allocator dpcon.53: Adding to iommu group 0
> [  168.358981] fsl_mc_allocator dpcon.52: Adding to iommu group 0
> [  168.435784] fsl_dpaa2_eth dpni.2: Adding to iommu group 0
> [  168.600151] fsl_dpaa2_eth dpni.2: Probed interface eth1
> [  168.605298] fsl_mc_allocator dpcon.63: Adding to iommu group 0
> [  168.610023] fsl_mc_allocator dpcon.62: Adding to iommu group 0
> [  168.614751] fsl_mc_allocator dpcon.61: Adding to iommu group 0
> [  168.619470] fsl_mc_allocator dpcon.60: Adding to iommu group 0
> [  168.625990] fsl_mc_allocator dpcon.4: Adding to iommu group 0
> [  168.630614] fsl_mc_allocator dpcon.3: Adding to iommu group 0
> [  168.635251] fsl_mc_allocator dpcon.2: Adding to iommu group 0
> [  168.639890] fsl_mc_allocator dpcon.1: Adding to iommu group 0
> [  168.644539] fsl_mc_allocator dpcon.0: Adding to iommu group 0
>=20
> Any ideas?
>=20

Hi Russell,

Let me investigate a bit and I will get back with more info.

Ioana
