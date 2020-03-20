Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D68F18CAE8
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCTJzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:55:24 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42864 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726806AbgCTJzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:55:24 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id ED91FC0F93;
        Fri, 20 Mar 2020 09:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584698123; bh=6Qxa1GHv7r2WAOMLB/iLOh3bNGRW7/doo9x+HddEQDg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=V7C0V3mGABOYUmFF84xNZ6noEm7VJZKHeM36Tjf6J2X+7oil/CVhBff6vsTA8BTR4
         4ArdzTr7YvjnhiVENIhpJI2ScQHiAjNwpdFoorsJy9EFHHlsW1nFqt509gom+ofbQm
         tCwxVxnlSeWfe4AsUXJrEcztDLaz/mESn6gzbyP4a5m2V+4bUqayyHzkjGyPzQwpyE
         uC3dDl3mtXsZi+Yj6+1NpyVrdi4CTxXLodW+tFkNywd/dUZ/IgUYQcgzCIjRJG1e4t
         ToUm2nxIgxRBRqm1JDVppFRSKSOl4rVuD/oNcx0EsloOnsXbnYCzYB5QYTGejKRKvX
         CCkNHiTljE+Jw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 30C60A0071;
        Fri, 20 Mar 2020 09:55:20 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 20 Mar 2020 02:55:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 20 Mar 2020 02:55:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTDZrNYifjLuwrvx+0AJcv2iAiDoQmrFZDy5wCiFH2FxW6SVi6Dt7rSIn1YIDsitiXGGuWbZsuuRC020nRMUYtmCMkqeRG6K1KBMd8aCDqwC2yJrKXvUFd/7DZFu6hu9EL+puIUKtjNxJ+ITDdAZzzxsFyY3jf+cC0l7ZatLUA5a1CV5rAYRMRSsFj19ZWDFjCIIm4Ek88/VO/f8gnkBTG2EbeaWGJZ3jsA+nV0Xz3fYpc+mmVETGgBb92TJmxwq4g+rhyRNvXiu9gaq2CTYHQfCTcHqIBbkSDJKOs+Fe4hV7DcSC3SDMAQPHV91C5yLRFl5Xc+qNr6Jk2yC4c3M2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZIPLDJo5/jzRa5S8phryXv2+PLcjRgjerGhT1RGNAM=;
 b=k+duD1TEVKpiefIiXv3SKNS3f/Mgh6AUkofGaeRVddPQnj+30IjlFvkCMkz5XZMzXMG4MvPEPy0zuzXK3Pj2iyZ/hwqovJEYnrNE30SjXs+Ftn0cozPgZTp+M2ZXFx0ZODqgVs0ujA10RCIQ+BZ2fK92QxSet6HxFiPidVZnP4pcgXhGjzmky6ImElmUoqjCPAyAmZWE6Ry+jyzuhyrp5p9BeQuvAnkQv8HgoG5ndzpxSggd5+4SquuqV2QUBBqmi2B4ipDKbaCwYob08SmD7oflvI842zSVp7javkXMswdHjwCoTC/NETMK1i+PMfWGx2QEKn3Bl2YNS+jUkl/hDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZIPLDJo5/jzRa5S8phryXv2+PLcjRgjerGhT1RGNAM=;
 b=Zkc4mhEPHsiEI/6qQIHwdMHepHvAbNWlJuimTr6dij8vT9y5ISRTfaUimjNN/PLSVm8KWmZfpu21RHD1RI3DIEPFp+OBz/PRpjaQgkL5s3TbIjGpn9Z1JOBRQ4xrL6rvRMaewbwmqhg0qZYYCHRagxicoKlSAwbzCGJt8gDR4o8=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3121.namprd12.prod.outlook.com (2603:10b6:408:40::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Fri, 20 Mar
 2020 09:55:12 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2814.025; Fri, 20 Mar 2020
 09:55:12 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Thread-Topic: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Thread-Index: AQHV/HG4xNUA04fN3kCshkX6WTztf6hM7DowgAAECQCAAAETcIAADpAAgAD4YyCAAc3sgIABe+Vg
Date:   Fri, 20 Mar 2020 09:55:12 +0000
Message-ID: <BN8PR12MB32666C9584E54DE2A7FDAD05D3F50@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <BN8PR12MB3266FC193AF677B87DFC98C2D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200317155610.GS25745@shell.armlinux.org.uk>
 <BN8PR12MB32669A0271475CF06C0008C4D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200317165208.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266F5CB897B16D0F376300CD3F70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200319111425.GC25745@shell.armlinux.org.uk>
In-Reply-To: <20200319111425.GC25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb7863c6-9282-458a-5e51-08d7ccb4c85f
x-ms-traffictypediagnostic: BN8PR12MB3121:
x-microsoft-antispam-prvs: <BN8PR12MB3121545C5720A7228D35E31FD3F50@BN8PR12MB3121.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03484C0ABF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39860400002)(136003)(366004)(376002)(199004)(33656002)(6916009)(81166006)(8936002)(81156014)(2906002)(316002)(8676002)(71200400001)(54906003)(7696005)(4326008)(86362001)(6506007)(186003)(76116006)(52536014)(5660300002)(66556008)(55016002)(66446008)(478600001)(66476007)(66946007)(9686003)(26005)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3121;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XmN4RUCvhwHBlb2/PglmF/AxMfJ65GHr/7KeVWflukCIgMJDtbwbYDJLvaY8euG2GL2KjSGbNoZ1357AZZrwBBk7K/Wm2w1I/ufDc9GacMsRN5UWUieOFOBLm9YQNohSX5VHFQw9dEX/jJ3wNRCqSB/8cEJPcq1ALVNFfK5jCbNi78jz6Tyqu3eD8H4d175/grnpUPKUh6zphSpqeXrobY8wr/Wo0zreTEEstJO8/pTVgh4Q5th1E0thFKI+Dihi8UZ5nnfzDlj6/PqR3mPv07a2aMdVlk3dqYjEJ4JDLssExOIQOfeFdM/hGbuXnYpTwNZ9tX3bfGjgWQJ3Dv102lHrmz3DVXD8EU8eU8ViMsevj98dtxleQZVryaj3JqIEQUSJqDKeXnxeFp4F0uTkZ6SckbXHCV9NMAh+9txdx1C/42E42p60VDd1ji3v3uUq
x-ms-exchange-antispam-messagedata: Tbnc8yGMgYDg77jGxCqf4pampxm9HeSTTfp1QUpSPENSVXK9JbSFF0FCOGC2aSEm5nYlvt5M4zLpIxeYNrmmt7qWL7DbeEeqLoXiHao+sWy+ac+jry247EUGgNueHeeZfATZVwzKfQn2Q1T+Yq4LLw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7863c6-9282-458a-5e51-08d7ccb4c85f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2020 09:55:12.3187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8oxtF8HWMMlxUulRwYx9vREaB/5+YBbnvhpe2IAN1vSYQCzLGBPCazIecTqL4x/QXsbpUroI/zr7fbaFMhjqZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3121
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Mar/19/2020, 11:14:25 (UTC+00:00)

> On Wed, Mar 18, 2020 at 07:45:52AM +0000, Jose Abreu wrote:
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Date: Mar/17/2020, 16:52:08 (UTC+00:00)
> >=20
> > > On Tue, Mar 17, 2020 at 04:04:28PM +0000, Jose Abreu wrote:
> > > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > Date: Mar/17/2020, 15:56:10 (UTC+00:00)
> > > >=20
> > > > > > Please consider removing this condition and just rely on an_ena=
bled field.=20
> > > > > > I have USXGMII support for Clause 73 Autoneg so this won't work=
 with=20
> > > > > > that.
> > >=20
> > > Do you really mean USXGMII or XLGMII that you recently contributed?
> > > XLGMII makes more sense for clause 73.
> > >=20
> > > > > That is actually incorrect.  SGMII can have an_enabled being true=
, but
> > > > > SGMII is not an autonegotiation between the MAC and PHY - it is m=
erely
> > > > > a mechanism for the PHY to inform the MAC what the results of _it=
s_
> > > > > negotiation are.
> > > > >=20
> > > > > I suspect USXGMII is the same since it is just an "upgraded" vers=
ion of
> > > > > SGMII.  Please can you check whether there really is any value in=
 trying
> > > > > (and likely failing) to restart the "handshake" with the PHY from=
 the
> > > > > MAC end, rather than requesting the PHY to restart negotiation on=
 its
> > > > > media side.
> > > >=20
> > > > I think we are speaking of different things here. I'm speaking abou=
t=20
> > > > end-to-end Autoneg. Not PHY <-> PCS <-> MAC.
> > >=20
> > > What do you mean end-to-end autoneg?  Let's take a simple example for
> > > SGMII, here is the complete setup:
> > >=20
> > > MAC <--> PCS <--SGMII--> PHY <--MEDIA--> PHY <--SGMII--> MAC
> > >=20
> > > Generally, asking the PCS to "renegotiate" will either be ignored, or
> > > might cause the PCS to restart the handshake with the PHY depending o=
n
> > > the implementation.  It will not cause the PHY to renegotiate with th=
e
> > > remote PHY.
> > >=20
> > > Asking the PHY to renegotiate will cause the link to drop, which
> > > updates the config_reg word sent to the PCS to indicate link down.
> > > When the link is re-established, the config_reg word is updated again
> > > with the new link parameters and that sent to the PCS.
> > >=20
> > > So, just because something is closer to the MAC does not necessarily
> > > mean that it causes more of the blocks to "renegotiate" when asked to
> > > do so.
> > >=20
> > > In SGMII, the PHY is the "master" and this is what needs negotiation
> > > restarted on "ethtool -r" to have the effect that the user desires.
> > >=20
> > > I believe (but I don't know for certain, because the USXGMII
> > > documentation is not available to me) that USXGMII is SGMII extended
> > > up to additionally include 10G, 5G and 2.5G speeds, and otherwise is
> > > basically the same mechanism.
> > >=20
> > > So, I would suggest that USXGMII and SGMII should be treated the same=
,
> > > and for both of them, a renegotiation should always be performed at
> > > the PHY and not the PCS.
> > >=20
> > > There is another reason not to try triggering renegotiation at both
> > > the PHY and PCS.  When the PHY is renegotiating, the state machines
> > > at both the PHY and PCS end are in the process of changing - if we
> > > hit the PCS with a request to renegotiate, and the hardware isn't
> > > setup to ignore it, that could occur in an unexpected state - the ris=
k
> > > of triggering a hardware problem could be higher.
> > >=20
> > > So, based on this, I don't think it's a good idea to restart
> > > negotiation at the PCS for SGMII and USXGMII modes.
> > >=20
> > > For the 802.3z based protocols, it makes complete sense to do so,
> > > because the PCS are the blocks involved in the actual media negotiati=
on
> > > and there is no place else to restart negotiation:
> > >=20
> > > MAC <---> PCS <----fiber 1000base-X----> PCS <---> MAC
> >=20
> > That's kind of the setup I have, hence the need for me to restart ... I=
=20
> > have this:
> >=20
> > MAC <-> PCS <-> SERDES <-> Copper <-> SERDES <-> PCS <-> MAC
> >=20
> > So, no PHY to restart Autoneg.
>=20
> And the protocol over the copper is USXGMII?

No, I don't think so. I can check with HW team but I think its 10GKR (not=20
sure though).

---
Thanks,
Jose Miguel Abreu
