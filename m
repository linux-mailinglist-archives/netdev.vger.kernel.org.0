Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291571428D5
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 12:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgATLH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 06:07:28 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40398 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgATLH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 06:07:28 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3829DC04F8;
        Mon, 20 Jan 2020 11:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579518446; bh=67UELf37HLA7knRcTO9RSHQjeRH2O+VztZCRbvwf8FA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=gqcDDJLHs6ZM599uIyb3SvCVTqUp/P5n8sRHNgIr5wN4hzCBG/X5Bqr+1DYPMj2H7
         pi4x5InIujs3ysVeI3yChWAvn6GJWGPWUXptbeDASEAIf4kBtuZSPYOlNRONinNqIw
         WgX2/ytlCvhUNOJ6dTDknCCGb/EpKPfXqQM9dC37/UCaoiu4Hpxqun2vJemlEkeWP3
         30oXwtJiENGtUq2HxlkYQc4jKaeUEPhzEgg5bAlr6eyJ34z6R3dxRgg0Jsb3JmdYZZ
         ErIMQMgSqClKsJ14VCUr87RLnRslQrRAgwse5wl+8C+m7z+7osEDJu0IsUd3qUFs7W
         8mK/fiXWsD9sw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 59D6CA0079;
        Mon, 20 Jan 2020 11:07:25 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 20 Jan 2020 03:07:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 20 Jan 2020 03:07:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLpYrAH37FhBGiBNB+XLU2FmV/wjJ1Lp1rtZ+/30Tw7jJCjZyxbPm+XU1O9AouOQd5X1w4yQ1/yc/dhrrvbq91FLG735wsSU/TDJkDYGKsNkUfXzmJYPy4oZeduQvBoKz+njrfJr2ZQDtoH4FP4thnYc/vEGizx9jQiF/78v9W+GkAlM23sbc1snvMcshDDUBTY4afG9EAVTr0IgIXhyk5H34YKKMN9L/e82mu2nvrM4+zSwXJH7UchO9PP568ZaejvUhruiQ80X4gBBwofQwuwHQlAWh1bov3peZQhhi8y5Ag0u4euruMYtQ9PsOH8yZlnDMKZJnlNyvJLXmqUSZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXyTyKjato9E3MvIR5PaZbMMskgok0GyJmgBcGh0T70=;
 b=mT0HVYclPK/mkms8zBhXcM7XU52QnTIgMX+/CMh8HxklUliisafLCOLKGlUp1ioSa2t6tS6Gs7GOEAjGg/wy2VtCOqp4PyEAG9MbbLWIOy72v4+GAPTUgToqvQ/8sQ7+wSXiKLg9qbCslKS1qwtXOMoZMzG0ThvoK+7B6BmyqA6skriokhegPJwM3x38SqoC/fEh2uDRgP+uMvshhi7GAg2sbMpQQWWpAeOPKx96FGO2cTWl8tzNMYDmGdsgg+tDDnJ+EuK9byx36xFaz6q7iKjZojktijJz8qlVCyeYjsGZOOyKRZawwVn7DOP/d8Ttn4gD1zIiss8dr91ZSGaCvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXyTyKjato9E3MvIR5PaZbMMskgok0GyJmgBcGh0T70=;
 b=Zjzj5Mss3HVwIM6HaEXvwQ9I8yklNwHqTdClFQ9LIshu1HpZd2lFgIodBaLqWephwczh4HMiaIPKs2IdGinK4lTK5iktcSETMci/GQB7RWFEawGJV/+bEDtjh1mN7+d311G8DfIdZW282cy984dvAoQJXUnSljyt3AMiXiJIw0M=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3268.namprd12.prod.outlook.com (20.179.67.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Mon, 20 Jan 2020 11:07:23 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 11:07:23 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Topic: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Index: AQHVyhMHPh1TkUf6pU+JUVzLFdFzk6fomWeAgAAAjSCAAAp/gIAKvyCAgAAHGACAAANl4A==
Date:   Mon, 20 Jan 2020 11:07:23 +0000
Message-ID: <BN8PR12MB32663612E58060077996670ED3320@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch>
 <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200113141817.GN25745@shell.armlinux.org.uk>
 <BN8PR12MB3266EC7870338BA4A65E8A6CD3320@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200120105020.GB25745@shell.armlinux.org.uk>
In-Reply-To: <20200120105020.GB25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dead3062-a74b-46e7-1b4b-08d79d98ed30
x-ms-traffictypediagnostic: BN8PR12MB3268:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3268C2A9EBCE8E825DAF1D28D3320@BN8PR12MB3268.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(366004)(396003)(346002)(39860400002)(189003)(199004)(81156014)(81166006)(66446008)(4326008)(316002)(6916009)(54906003)(64756008)(186003)(66556008)(76116006)(6506007)(52536014)(478600001)(8936002)(66946007)(66476007)(26005)(2906002)(33656002)(55016002)(9686003)(5660300002)(71200400001)(7696005)(8676002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3268;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rLZwzqLDcBNhghkE+1hmCKFWb/Rz0Dg6X8UO19WqCUrFrm7kC7PvEqB/AYr6+ldRUzHxswgL6eUav9xd4WT1+qgzXVNJyv1LEd036sS4n7+uGsVLeLaohhdSWnqGeqmsglgberUTiXzQjfBZjPQ6oeNC/IylhK4Y5kJk61N271sK5/EFrxKHEq6SbpgEbxMiw+60Dvvlrcnr2TlHJY+gKiT4iJJWysXHCvBmsxLRj0/EZ/yS0g01Q3/3Jdrn1msTQYcAmQy8h52tNAz5fl57XOQahEsf0c/tbMh8fgRYDRzJzSKzIDeBsVPoZUJFV50NxdYEnBQ28ZpWMtLlb8fWqNJrNGCjsb7/ml/MMGJzmEofIhalUt/830uJqN3Q6y3Pb9jIWSqJgq2lxVW0sGb3dBPqJy3hhR5U12QBo7+UctvuFQ73PCHezyOyYRj/nH8j
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dead3062-a74b-46e7-1b4b-08d79d98ed30
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 11:07:23.4418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Paj8ILY9flkdatAaO/SNRS9idQG4mFN5/pWwNlx1yUTMl452nH9yFAFBHC5xtWC+TqHXFzSQKUVzt0wsZIwfGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3268
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Jan/20/2020, 10:50:20 (UTC+00:00)

> On Mon, Jan 20, 2020 at 10:31:17AM +0000, Jose Abreu wrote:
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Date: Jan/13/2020, 14:18:17 (UTC+00:00)
> >=20
> > > I've recently suggested a patch to phylink to add a generic helper to
> > > read the state from a generic 802.3 clause 37 PCS, but I guess that
> > > won't be sufficient for an XPCS.  However, it should give some clues
> > > if you're intending to use phylink.
> >=20
> > So, I think for my particular setup (that has no "real" PHY) we can hav=
e=20
> > something like this in SW PoV:
> >=20
> > stmmac -> xpcs -> SW-PHY / Fixed PHY
> >=20
> > - stmmac + xpcs state would be handled by phylink (MAC side)
> > - SW-PHY / Fixed PHY state would be handled by phylink (PHY side)
> >=20
> > This would need updates for Fixed PHY to support >1G speeds.
>=20
> You don't want to do that if you have 1G SFPs.  Yes, you *can* do it
> and make it work, but you miss out completely on the fact that the
> link is supposed to be negotiated across the SFP link for 1G speeds,
> and then you're into the realms of having to provide users ways to
> edit the DT and reboot if the parameters at the link partner change.

You may have missed my answer to Andrew so I'll quote it here:

---
[...]

My current setup is this:

Host PC x86 -> PCI -> XGMAC -> XPCS -> SERDES 10G-BASE-R -> QSFP+

The only piece that needs configuration besides XGMAC is the XPCS hereby=20

I "called" it a PHY [...]
---

So, besides not having a DT based setup to test changes, I also don't have=
=20
access to SFP bus neither SERDES ... As you suggested, I would like to=20
integrate XPCS with PHYLINK in stmmac but I'm not entirely sure on how to=20
implement the remaining connections as the connect_phy() callbacks will=20
fail because the only MMD device in the bus will be XPCS. That's why I=20
suggested the Fixed PHY approach ...

---
Thanks,
Jose Miguel Abreu
