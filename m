Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A1B14A58E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgA0N5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:57:40 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:49180 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgA0N5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:57:39 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 623DE4016D;
        Mon, 27 Jan 2020 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1580133458; bh=jJy8tk5qmv70Jk1LSAs4Y9W7p+kjmzT77aBpwXOF2nk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=CwZwzh91MRSI59PbU+uus21FSOOB9tWhiXp09BoDy60G0ENnOmt39ztMHd1W/M57L
         BYXBuhp16Kuba3wTp8fYppz/I7jnE/6gx7NYPH7DkAS/UxdLjyhNu9GqqIGUttPFul
         O2iY6CCofIpk5vmADlmIhCunhnunBgjCjgqNAWbN4p1VlesDzf2hYYfx4s1Vl0wZYr
         ssIpsoi33K7ZFkD5ZfO+xAd2K8AgNXPDHRj9GiP4qz2atRWI/WDbVT5a37eAzuaxun
         7gOOgwN9ppjWUhutoD4XlGXw+APXIvp6QCp1Aa8qSvOi2ra0x+SKUuL2gtE05OwEs7
         ezB7YAx/XkLKQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8D67CA008A;
        Mon, 27 Jan 2020 13:57:36 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 27 Jan 2020 05:57:36 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 27 Jan 2020 05:57:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHvBKUT4OGymRW01nFbYn2LYU4FW2mFZ3Zy1BkGTKuqBkLj4ngqiIqgMDubjFf04P2OyF1JbIBBpaXFdQ6HkOU8wcaaPClUY/8Nq5hHAxdOIHRYm0CZ/IpWRRDig45SNCU3BhPCivZN2Q/OXunloX4fDnCtSr8/XMeX60oc+W+lDOjU3WH51oLRh1G4c0OXIKNN6x9azoNQ2NQvYpFF4NQ0V9XYZr6ctPJM+iR6f0XbVATl0gdtQSHlU7xxmYaEQwPSgoJAoVnTj9ewf0P8c2v7g2vbQGW8AEqdur+fG4bxE58KeGCaJIAkZQJNgYWU/eyt7/z3uAe6XLL2xY5cLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji/r14uDI0vCFO0RGoIJMI6UkHFhssswRRJ/aD97RRY=;
 b=EVXZQF7Y/yrCrG0MIJFEUPX0B9JvcN1icW5/i6Q3kKpioEUNEJpWTQGs0TkglzYaB29um2GvJY+HWi17v9StGxJorgOIszZjfT4HGLD39ThWZ7lFa93ekPezAlQhOcxXJZy2Iw4fwAlRpC1SHA0G3AHwz1r5ProjSkdNZV7BvGlnddypt2gm40nwT2IY88xUFX3V57kKgeFmlY55gbunfnEK1JeKs22/gKmHDmA5IFtrEgATyCV6ve44dkVG1pkzSAl2RsBbJHBXOtVVl8jSDwVO2JcTVmNubsW4b1wS6OJWMygjoDBQ9+m8riWk6UDs+trWh8jxmn0642j6K3u4Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji/r14uDI0vCFO0RGoIJMI6UkHFhssswRRJ/aD97RRY=;
 b=LHK2YJ6vF4YwGkFoutyV2Jo4R26Uawvx7u8svwgQQzhWL+PvhyWI0fdd2F0n8cpr7Qh8zQT0Mb7lyOB3Kr16Gylb2kSftzWETkr/gvWMmsnaiUjsdfa9xi1vai4pPB4HhVqsSgapy8C/+IJnqKgGH98nRimnyJHlwUafOGBcynY=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3426.namprd12.prod.outlook.com (20.178.212.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Mon, 27 Jan 2020 13:57:34 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 13:57:34 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Thread-Topic: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Thread-Index: AQHV1QJR/2IdLzxcIUOq2qgDmVwJ/6f+XbIAgAAEH1CAAALaAIAADuwwgAAQVgCAAAHg8A==
Date:   Mon, 27 Jan 2020 13:57:34 +0000
Message-ID: <BN8PR12MB326690B31B35F4B655185A28D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
 <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127114600.GU25745@shell.armlinux.org.uk>
 <BN8PR12MB3266A7C976B4E63466B5FA35D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127133752.GV25745@shell.armlinux.org.uk>
In-Reply-To: <20200127133752.GV25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a06f67e-4b38-44f6-b00e-08d7a330dc47
x-ms-traffictypediagnostic: BN8PR12MB3426:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB342609D1008D50B4E9A32E88D30B0@BN8PR12MB3426.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(39860400002)(366004)(346002)(199004)(189003)(316002)(6916009)(54906003)(478600001)(8936002)(7416002)(66446008)(66556008)(64756008)(81156014)(55016002)(8676002)(81166006)(71200400001)(33656002)(66476007)(9686003)(4326008)(7696005)(2906002)(76116006)(66946007)(26005)(5660300002)(52536014)(6506007)(186003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3426;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X/VerNwGhDJvzukWf3Vx3Yo5M6UVOb+7bvcXByUTSGjL7VxX+7014pTcUpgeOWdyNUKEjqatxoOE+BB0dv7CYpihGxLdxoLivrqR3LcGu7XyDyYD3JRRJPTGweccEM3YgE73lFyXMgBvlFTRi6f9ynT74qccxQbSa7CKiRxe6TOCXhngkj2CbYrEUAEQMY240wdd0tbYTPmMTW0gtfBN4Ke0BLo0Hcpyv0QRqj7MRgCU+Ulv/8sNL+XaF7PzMZlbhTr+qHF7O0K1C8o0v6qVx+JmpJu9x7Xvb3LgFPp44T8DKiPAxeKL6QcWKSf90ohQGfFQs0VKZoe4BjApBih7g+ygeSdlStbaYSsUeZ8gcZbpqhOtmk20ANbgjtB5ah8kb/+8Ha3RkCF3vnhIqKT6xeS6O90bkOvZV1E50c5C0+k+HcEyqTSnxR5fyL3sPiEN
x-ms-exchange-antispam-messagedata: CYEr+U/bR+kyeKdrNqpgJzWuaVq4ci11mSoQnUqakc+6DyHBNIUQqiX+HADzIn9hTyjjRVinE9Yx09ToIIASz7DTV98UzD2y4K1cOK0hcMB+c+Edncyv6E/+LDhAF4hyXTxAuW5hNVaJuX7fENPBAg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a06f67e-4b38-44f6-b00e-08d7a330dc47
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 13:57:34.4468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x0LLX3yrAR4VjqlvirU/4PS7yuXqtLR3l8AeE9W1dWoH1A4+lDQ1O3unp15O1uVQpn+WBFpGPtnLWV4UaXTQsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3426
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Jan/27/2020, 13:37:52 (UTC+00:00)

> On Mon, Jan 27, 2020 at 12:50:54PM +0000, Jose Abreu wrote:
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Date: Jan/27/2020, 11:46:00 (UTC+00:00)
> >=20
> > > On Mon, Jan 27, 2020 at 11:38:05AM +0000, Jose Abreu wrote:
> > > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > Date: Jan/27/2020, 11:21:02 (UTC+00:00)
> > > >=20
> > > > > On Mon, Jan 27, 2020 at 12:09:11PM +0100, Jose Abreu wrote:
> > > > > > When we don't have any real PHY driver connected and we get lin=
k up from
> > > > > > PCS we shall configure MAC and PCS for the desired speed and al=
so
> > > > > > resolve the flow control settings from MAC side.
> > > > >=20
> > > > > This is certainly the wrong place for it.  Please hold off on thi=
s patch
> > > > > for the time being.  Thanks.
> > > >=20
> > > > This is actually the change that makes everything work ...
> > > >=20
> > > > I need to configure PCS before Aneg is complete and then I need to=
=20
> > > > configure MAC once Aneg is done and link is up with the outcome spe=
ed and=20
> > > > flow control.
> > >=20
> > > Yes, I realise that, but it comes with the expense of potentially
> > > breaking mvneta and mvpp2, where the settings are automatically
> > > passed between the PCS and MAC in hardware. I also believe DSA
> > > works around this, and I need to look at that.
> >=20
> > OK so there is one alternative solution for this that's just saving the=
=20
> > last link status on stmmac internal structure (if applicable ofc,=20
> > something like an_complete is true and link is true) and then just use=
=20
> > that info in mac_link_up() callback to configure the MAC when PCS is in=
=20
> > use.
>=20
> I'm not disagreeing that something needs to be done - the assumption
> in phylink that the MAC and PCS talk to each other is one that comes
> from the hardware which it was developed on, but is not true for all
> hardware.  The IEEE 802.3 model doesn't include that behaviour.
>=20
> So please, don't try to come up with an alternative solution; this
> problem _does_ need solving in phylink, but it needs to be done in a
> way that doesn't regress the existing users.
>=20
> I've already started to split the current set of MAC operations into
> a purely MAC set of operations and a set of PCS operations, but still,
> the problem of how to sensibly deal with mvneta and mvpp2 remain.
>=20
> The problem is that both these use two registers to control both the
> PCS and MAC.  One is a control register, which controls what is
> advertised, whether AN is used, what is negotiated and what is forced,
> including whether the link is forced up.
>=20
> The other is a status register that gives the status of the MAC -
> whether tx pause and/or rx pause is enabled, what speed and duplex the
> MAC is running at, whether the link is in sync, whether the link is up
> etc.
>=20
> Essentially, the PCS and MAC are tightly integrated together in this
> hardware, so splitting this into separate PCS and MAC control blocks is
> very problematical.
>=20
> As I say, this is something that needs solving.  A solution needs to be
> found, rather than having lots of drivers working around this issue in
> their own special ways, and my fear is that the more workarounds we
> have, the more the phylink core will become unmaintainable.
>=20
> So please, no workarounds.

I'm not trying to rush and I do agree with you. I just thought this was a=20
particular case but I did tried to fix it in this commit.

I'm not familiar with mvneta HW but thanks for the description. Indeed,=20
for XPCS and stmmac they are independent but MAC still needs to know the=20
speed at least. My main problem here is USXGMII. This needs to know the=20
speed negotiated taking into account MAC limitations and then use it to=20
configure XPCS.

So, another possible solution is just to pass phylink_link_state struct to=
=20
mac_link_up() and mac_link_down(). From the comment on the function and=20
it's usage in phylink it seems this could be a good fit ?

Another thing I could solve here (while I'm at it), is PCS that sit in a=20
MII bus: Instead of having stmmac saving all that private data of XPCS I=20
could just pass it to phylink and save it there ? Something like you=20
proposed in ("net: axienet: Fix SGMII support") ?

---
Thanks,
Jose Miguel Abreu
