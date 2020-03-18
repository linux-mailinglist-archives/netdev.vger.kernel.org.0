Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2EF189651
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 08:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCRHq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 03:46:56 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:44290 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725298AbgCRHq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 03:46:56 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2841140363;
        Wed, 18 Mar 2020 07:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584517615; bh=1pJsWyNYb2h4Ax9HJo6rxefTmr1YoAUFn9PCL8BYetE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=bozh/8f9zgPExcheS9oTcqDeobXUSWit6GQ+UajaT2cM2dGmSueppG+oMGPB7i9Ns
         Wg0Xl/dI52eDzxFvWeH2ZewXdESuq+4CW5sKLvx8VooKCwHT/uL2LPe9w4HjDukh2c
         NbfWtpLSci2hxXkA5TYiqpQyPP4LsOyZsWBWm7b5aXAKBXoRQAJVY2x16fVnSOD+Km
         SXEmJFfiysVILiieLeZwo/tZ9aGqCYLaUl0Y2hvqqh01a5QwDLIaqeWnFuzEG8RxnJ
         7IYkINZGPbhbD7QMLiNpezidck6RSWm3n+H/kus4KFZnyAQtIMPrIkVlPJazNZJjPl
         y1GxEUX2QpZng==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 91DBBA0079;
        Wed, 18 Mar 2020 07:46:52 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 18 Mar 2020 00:45:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 18 Mar 2020 00:45:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElBMPFaEWGQ0ipZetWKd2JpOXRvsJCDUwDo2UUui7shKAf/TpYHihvOUitQmsQqLSxdSsfrTPmkuUjFnMlzvAAeuPRjW52/v5mgtNTSA9GMLxhyTqwuqunng/zAQVJOC4Rr/1r/lVTI6TLTMFGew8DobIWsqEluKCoqJ13YfI9TCkPfEraRSzvZ4/SAzkA3+iIzFstdAwXByi0IoEHUIxqx215rLWrDoeaQFQ4AHiUb7JwBA6m9zR58F0Pz+pcIHL5yTmPJXyIZK73AaAg+DLGirT3ojsiemxvfL5S78H5daLihKcAAWbkJsvBTybzkcv9AalJyGXZajYYdD6lJxrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzHgB28v0KYPDDkd3l33Jm6MkfC/7r4kl0sjRqWEcxU=;
 b=NQxizngoaOFwC0zjGv75tBMZQD5suJRti/s5+SNSEIHfH58j41p0l6sXyShKg+OkUMJzPWsgfixSFn7TBX3lEOHtutQNQ5azhfCZzKXFcke15y7ZGUVR3jKRkDlquWH+z6eJFn/ondMphrJApZSlOoCxhrS0vE2LwW/h0Couee2fysxblw0bn17vMiTcf1jgLMu0Mpc2Uvj0QVkhcFzVpOIpbIDJIAiZ6m9IKtpRsAl649cSIC2WhU2/AwrjjDBmXDSsd7aiTYnXhRYtCmM96krLofjnbM/peypqsyiAlWWBUa9nPSyvvZRwf/x6xT4YnuEYG7dV9Dh0xXljL0hxcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzHgB28v0KYPDDkd3l33Jm6MkfC/7r4kl0sjRqWEcxU=;
 b=niji/7uyltjZ2UogsXodf7OfeeRHaBex6uV1BigHAQyVtLh+T3cm4QUnBA5ieKA6ZAqDUDk6HcS7k2BHyyiS9EDw62IVmT7ZuzsrPCL1CK2NH43yM0wTOdUPGCMK8VAf1MUt6wMrqxsZ9jBNQRea6k/rWlYwTo23bK4wslF9QMs=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3073.namprd12.prod.outlook.com (2603:10b6:408:66::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21; Wed, 18 Mar
 2020 07:45:53 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 07:45:53 +0000
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
Thread-Index: AQHV/HG4xNUA04fN3kCshkX6WTztf6hM7DowgAAECQCAAAETcIAADpAAgAD4YyA=
Date:   Wed, 18 Mar 2020 07:45:52 +0000
Message-ID: <BN8PR12MB3266F5CB897B16D0F376300CD3F70@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <BN8PR12MB3266FC193AF677B87DFC98C2D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200317155610.GS25745@shell.armlinux.org.uk>
 <BN8PR12MB32669A0271475CF06C0008C4D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200317165208.GT25745@shell.armlinux.org.uk>
In-Reply-To: <20200317165208.GT25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3567f30-47bd-42d1-211b-08d7cb1062d8
x-ms-traffictypediagnostic: BN8PR12MB3073:
x-microsoft-antispam-prvs: <BN8PR12MB30733F2E3E58EF530B6026EBD3F70@BN8PR12MB3073.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(136003)(346002)(376002)(199004)(7696005)(6506007)(316002)(54906003)(5660300002)(71200400001)(2906002)(478600001)(26005)(186003)(86362001)(6916009)(76116006)(66946007)(8936002)(66476007)(81156014)(81166006)(8676002)(66556008)(9686003)(52536014)(4326008)(33656002)(66446008)(55016002)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3073;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 66/ekYay02sawrlxKIwbCrxEMtXtHchRGAQmcOntKWY8tfj/aW/K2FIwejRSQGgqeBiIm8z9yvJ/yN3vVAaBOmxAXZ2sEe8Tcuff0eZf8xiPnC1DLHrmRs36KezBJ9udrPA+i5Etck5il6ILt08t7eYyLSQoInw8ipXWsmXSlIXVrRGMjK1aZFyBOzQyoQAmQR6OOJQVtkkdJB9cN2d7O9vVqWh7NiQ8+NrU0MJmfoN0fXAky/MzF/mXM/QuKu8BLibkUUBfxQ4Cslxugktsjus0VkvM+nuW4K4jnZ1/owdOkPleUKOWtIyaRBO3DoaKgiezJI/RXwkvQqx1oMGFFhXRDj+qIMeAn4KLrivLnRckWonhLfYCWOlONF9Y+i97PjymRB8LMfzBY8H+tRXVLRfVRSuYDuNbhdpzg69oOJXC4qvcLmyq8WodyJ7u5hll
x-ms-exchange-antispam-messagedata: qHRZiFnawLaVwde39mjEm2zNOIkXePE9Su6VmCJy+jJOjMc+it6kG2GJOhmfsg0iXIAh4cbxnvdGG0xMxdYZb3O5t8+K4Fk88zoeP2Z+EAGG9fx95i9mppLODD9lezIg0WuBi+EgVTi7fNSPT3ZuCA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d3567f30-47bd-42d1-211b-08d7cb1062d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 07:45:53.3022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m4jTGXG0jzdS9LvUeM8CKxv9j9U6pZlxrETolbQ5cOEsgqydhYyV+xrlYtsstcdgFBsaBvFjpSSCuEOV2l8Wsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3073
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Mar/17/2020, 16:52:08 (UTC+00:00)

> On Tue, Mar 17, 2020 at 04:04:28PM +0000, Jose Abreu wrote:
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Date: Mar/17/2020, 15:56:10 (UTC+00:00)
> >=20
> > > > Please consider removing this condition and just rely on an_enabled=
 field.=20
> > > > I have USXGMII support for Clause 73 Autoneg so this won't work wit=
h=20
> > > > that.
>=20
> Do you really mean USXGMII or XLGMII that you recently contributed?
> XLGMII makes more sense for clause 73.
>=20
> > > That is actually incorrect.  SGMII can have an_enabled being true, bu=
t
> > > SGMII is not an autonegotiation between the MAC and PHY - it is merel=
y
> > > a mechanism for the PHY to inform the MAC what the results of _its_
> > > negotiation are.
> > >=20
> > > I suspect USXGMII is the same since it is just an "upgraded" version =
of
> > > SGMII.  Please can you check whether there really is any value in try=
ing
> > > (and likely failing) to restart the "handshake" with the PHY from the
> > > MAC end, rather than requesting the PHY to restart negotiation on its
> > > media side.
> >=20
> > I think we are speaking of different things here. I'm speaking about=20
> > end-to-end Autoneg. Not PHY <-> PCS <-> MAC.
>=20
> What do you mean end-to-end autoneg?  Let's take a simple example for
> SGMII, here is the complete setup:
>=20
> MAC <--> PCS <--SGMII--> PHY <--MEDIA--> PHY <--SGMII--> MAC
>=20
> Generally, asking the PCS to "renegotiate" will either be ignored, or
> might cause the PCS to restart the handshake with the PHY depending on
> the implementation.  It will not cause the PHY to renegotiate with the
> remote PHY.
>=20
> Asking the PHY to renegotiate will cause the link to drop, which
> updates the config_reg word sent to the PCS to indicate link down.
> When the link is re-established, the config_reg word is updated again
> with the new link parameters and that sent to the PCS.
>=20
> So, just because something is closer to the MAC does not necessarily
> mean that it causes more of the blocks to "renegotiate" when asked to
> do so.
>=20
> In SGMII, the PHY is the "master" and this is what needs negotiation
> restarted on "ethtool -r" to have the effect that the user desires.
>=20
> I believe (but I don't know for certain, because the USXGMII
> documentation is not available to me) that USXGMII is SGMII extended
> up to additionally include 10G, 5G and 2.5G speeds, and otherwise is
> basically the same mechanism.
>=20
> So, I would suggest that USXGMII and SGMII should be treated the same,
> and for both of them, a renegotiation should always be performed at
> the PHY and not the PCS.
>=20
> There is another reason not to try triggering renegotiation at both
> the PHY and PCS.  When the PHY is renegotiating, the state machines
> at both the PHY and PCS end are in the process of changing - if we
> hit the PCS with a request to renegotiate, and the hardware isn't
> setup to ignore it, that could occur in an unexpected state - the risk
> of triggering a hardware problem could be higher.
>=20
> So, based on this, I don't think it's a good idea to restart
> negotiation at the PCS for SGMII and USXGMII modes.
>=20
> For the 802.3z based protocols, it makes complete sense to do so,
> because the PCS are the blocks involved in the actual media negotiation
> and there is no place else to restart negotiation:
>=20
> MAC <---> PCS <----fiber 1000base-X----> PCS <---> MAC

That's kind of the setup I have, hence the need for me to restart ... I=20
have this:

MAC <-> PCS <-> SERDES <-> Copper <-> SERDES <-> PCS <-> MAC

So, no PHY to restart Autoneg.

>=20
> > I'm so sorry but I'm not an expert in this field, I just deal mostly wi=
th=20
> > IP.
> >=20
> > Anyway, I'm speaking about end-to-end Clause 73 Autoneg which involves=
=20
> > exchanging info with the peer. If peer for some reason is not available=
 to=20
> > receive this info then AutoNeg will not succeed. Hence the reason to=20
> > restart it.
>=20
> Clause 73 covers backplane and copper cable, and isn't USXGMII.
> In the case of copper, I would expect the setup to be very similar
> to what I've outlined above for the SGMII case, but using USXGMII
> instead of SGMII, or automatically selecting something like
> 10GBASE-R, 5GBASE-R, 2500BASE-X, or SGMII depending on the result
> from copper negotiation.  Depending on the Ethernet PHY being used,
> it may or may not have the in-band control_reg word even for SGMII.
> In any case, what I've said above applies: to provoke end-to-end
> renegotiation, the PHY needs to be restarted, not the MAC's PCS.
>=20
> For backplane, things are a little different, and that may indeed
> require the MAC's PCS to be restarted, and for that case it may be
> reasonable to expand the conditional there.

Yes, I think it makes sense due to the setup I outlined above.

> However, note that for the purposes of this patch, no change of
> behaviour over the current behaviour is intended; a change to this
> will need to be a separate patch.
>=20
> Thanks.

Understood. Thanks for such thoughtfully explanation!

---
Thanks,
Jose Miguel Abreu
