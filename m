Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F53F23A37D
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgHCLqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:46:44 -0400
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:10287
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726600AbgHCLqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:46:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FznvlagVW9DK9iWdNSItq+K+M5zYtKd3zniy71ipijD0Z8211Rk/X+m9ZlZJWoqQTYX1da9CHZaIPO5rThtAB2/IDkqM1wBMUurI3YQ25agPf+EGsJMfzBfQaIKVcOz90WstdcUDzehzRW2B58cDrW0BXd/tO3Gm5D2cPi6Ba5+RiBcFa5iaq1uYB4Rm6c8Zpm49ZY9oWjRvGyWhVDoFZwwXGiV4FzheJGXwCHlPF0T5DSBq71TT6wXUz03dcdt/q7cvQ7APCwFAnQZg8XrYTOMw5XMzHTDwnsvTQ39c4rOQEvOh2p87NpCw0FKGREKC6ga8a0uxHL0WXZ8KAcr+Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5yQ+bzh53V9kUy6pCUKOz5VgQFNIfP9krmfrslVQl4=;
 b=AXRt3j8XnoRCu7A2npaJ6ZAhL7sBfatJeWwvotKyFKCXWWRpd1MmOnbiU/zosYsns0iyBBCGq8qq8W0NELBDIy1TAqCbl6C/uv4jj8ThbTcRgtfskFMwXzp/UBsy/aQ8Di8WTimn/z8XkrJHxyqpXnTwFoBrnydsa/t32w9So5Jxh2yUaWs3cC76cBo68rQAnwHCRlDyIE/XWZg/C+PcW/RPx+47Q2SF1XxBORATyUYK6IxPy0c1RyeHXCN+hVWtzx71Uh5UGH1w7xTXuM8Cz/t3CWqW5SYplpGaj5LSfGPDiHz16YOKA2ApgZz0vTNTGemqy52NL0YnkMiNwTvCcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5yQ+bzh53V9kUy6pCUKOz5VgQFNIfP9krmfrslVQl4=;
 b=lzyJ2G0Rxoas+mIlBTmT8Z4d38smrRmxDPN7zqVUjS7pjWHQg/vTdAIVhRzbfmoczSAKLZrhYCiw8n8Sacq+qaBVBsNpzb/IqGufkyrxYqlNZ0ylhq3KJb4G98rOHTeknpU+m9g+su5doRoKCaQVyIaZMIFHiTE814uwJAbSbI8=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR0402MB3446.eurprd04.prod.outlook.com (2603:10a6:209:6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Mon, 3 Aug
 2020 11:45:55 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f%2]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 11:45:55 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vikas Singh <vikas.singh@puresoftware.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        kuldip dwivedi <kuldip.dwivedi@puresoftware.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: RE: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Thread-Topic: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Thread-Index: AQHWZNiOdpikt9xf+EiwD7SyrSwWH6kc9FCAgAGkTICAAzz5gIAA15EAgABZCQCAAFwWgIACs+VwgAALHACAACsYYA==
Date:   Mon, 3 Aug 2020 11:45:55 +0000
Message-ID: <AM6PR04MB3976284AEC94129D26300485EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
 <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
 <20200801151107.GK1712415@lunn.ch>
 <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803090716.GL1551@shell.armlinux.org.uk>
In-Reply-To: <20200803090716.GL1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b422a126-a950-433f-05e4-08d837a2c824
x-ms-traffictypediagnostic: AM6PR0402MB3446:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB34460A5C8ED255EB94611944AD4D0@AM6PR0402MB3446.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zlJsrGrMxhd9ZcmtNe3/O+z5eS64J2jWICkEq/hC5dvz0fvRVPMe6/OgNguZUWbQ8FzGidOtL5cgWsa9LVXauecWFISfrWWYyUWjthc/lh4EFFkI7m8Anu1MAGDasocZZdQfB1tk08VcEosq7WIou+ShwjKP3uwNy8Qtsz0JukwEtC6MuGhoPKljgVmCpeDyEbtHH6bi2lZzXVJVOz1suDUA4p6NOF9mMZQWcECpsgMKC+Jy3WCBLJrUEYSrhMZZtagPlXbJkQEHu6wGgDVeR7b6F0YPacE2k/wl44kV5363IR4EX52h6xF/dNT42E3kcVxtWKuw1UOvHbv1321tBmjFXI61fpcMCnMNyZqcacdSqkPnYy+NHXhS3P1BjXcgei+gbfCW4K0cfKmp9X8Uog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(71200400001)(5660300002)(26005)(52536014)(54906003)(64756008)(66556008)(76116006)(6506007)(53546011)(83380400001)(186003)(66446008)(66476007)(66946007)(33656002)(316002)(110136005)(8676002)(966005)(9686003)(86362001)(4326008)(7696005)(55016002)(478600001)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: q2WFyTTLatwGdz8NI+CNdsdG4x3ouaMvFd21aRiIlYRRUzXkMdlCEJbsSAigQ+5eGha0MhAPJNrjDTJGuRnFG35agcJVReH8sB5NnllYsEsmYZ15972DJcqm7ra09LHot5PoASQierY1qg5w470GsYjAygQYkrFcBLMWo/yG2XZR4vsK9j5DWGGLiluTSG9rSAtymj0bnHvfGPJ8oftbOwzykZoJsh/QjlYPcgxCH3M7JVcRMkRaMkoGVjfrLT+tkFBem4RH/8bmtpxdDOGRzNfxKm9BNy5VInicMtEb4sv78gRkpHXJFDyCrLg/8wEnCjghMKb9/lvjnpQ/Z8CgejTlbVdAdGy6Ftoutwcvp/bA2We4aHm761xvpI6DrQX16ysVLUlWHoZDwUPZwyWbxU2cF+8Uq9wpepqK5TZEgwzJt8EAhzRqD5NMhbDBg44ZgBhU6/kg0DaCFOtS1YJuXJQP3FcT6vxkN0BLiwPuRzW1mw74Mgm17ItnYtuiXq1yBEZkuXJFWHGXIsCxKU6bQyPp8kjs60taKXF3BfXDG50OtBzfDH+Y/u3NeQ7LtnH67kRVUFnKAJJ57otZScKP6QHBF0EeFpmxCsSTlB05aYxYWQ72PnWARVh2vApA/Zhq240kyLdQ90y0V5Bl2ad+ig==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b422a126-a950-433f-05e4-08d837a2c824
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 11:45:55.4169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uDk19T3S7JxPEQCPLIWfAoeDYLg9HFauBb+c8PmzIttCm5HS/Fbfzvu2YmCWKLQF/5YjLr3RH6oeaYVcXoxITg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3446
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: 03 August 2020 12:07
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Vikas Singh
> <vikas.singh@puresoftware.com>; f.fainelli@gmail.com; hkallweit1@gmail.co=
m;
> netdev@vger.kernel.org; Calvin Johnson (OSS) <calvin.johnson@oss.nxp.com>=
;
> kuldip dwivedi <kuldip.dwivedi@puresoftware.com>; Vikas Singh
> <vikas.singh@nxp.com>
> Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
>=20
> On Mon, Aug 03, 2020 at 08:33:19AM +0000, Madalin Bucur (OSS) wrote:
> > > -----Original Message-----
> > > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > > Behalf Of Andrew Lunn
> > > Sent: 01 August 2020 18:11
> > > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Cc: Vikas Singh <vikas.singh@puresoftware.com>; f.fainelli@gmail.com;
> > > hkallweit1@gmail.com; netdev@vger.kernel.org; Calvin Johnson (OSS)
> > > <calvin.johnson@oss.nxp.com>; kuldip dwivedi
> > > <kuldip.dwivedi@puresoftware.com>; Madalin Bucur (OSS)
> > > <madalin.bucur@oss.nxp.com>; Vikas Singh <vikas.singh@nxp.com>
> > > Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed
> PHY
> > >
> > > On Sat, Aug 01, 2020 at 10:41:32AM +0100, Russell King - ARM Linux
> admin
> > > wrote:
> > > > On Sat, Aug 01, 2020 at 09:52:52AM +0530, Vikas Singh wrote:
> > > > > Hi Andrew,
> > > > >
> > > > > Please refer to the "fman" node under
> > > > > linux/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > > > > I have two 10G ethernet interfaces out of which one is of fixed-
> link.
> > > >
> > > > Please do not top post.
> > > >
> > > > How does XGMII (which is a 10G only interface) work at 1G speed?  I=
s
> > > > what is in DT itself a hack because fixed-phy doesn't support 10G
> > > > modes?
> > >
> > > My gut feeling is there is some hack going on here, which is why i'm
> > > being persistent at trying to understand what is actually going on
> > > here.
> >
> > Hi Andrew,
> >
> > That platform used 1G fixed link there since there was no support for
> > 10G fixed link at the time. PHYlib could have tolerated 10G speed there
> > With a one-liner.
>=20
> That statement is false.  It is not a "one liner".  fixed-phy exposes
> the settings to userspace as a Clause 22 PHY register set, and the
> Clause 22 register set does not support 10G.  So, a "one liner" would
> just be yet another hack.  Adding Clause 45 PHY emulation support
> would be a huge task.
>=20
> > I understand that PHYLink is working to describe this
> > Better, but it was not there at that time. Adding the dependency on
> > PHYLink was not desirable as most of the users for the DPAA 1 platforms
> > were targeting kernels before the PHYLink introduction (and last I've
> > looked, it's still under development, with unstable APIs so we'll
> > take a look at this later, when it settles).
>=20
> I think you need to read Documentation/process/stable-api-nonsense.rst
> particularly the section "Stable Kernel Source Interfaces".
>=20
> phylink is going to be under development for quite some time to come
> as requirements evolve.  For example, when support for QSFP interfaces
> is eventually worked out, I suspect there will need to be some further
> changes to the driver interface.  This is completely normal.
>=20
> Now, as to the stability of the phylink API to drivers, it has in fact
> been very stable - it has only changed over the course of this year to
> support split PCS, a necessary step for DPAA2 and a few others.  It has
> been around in mainline for two years, and has been around much longer
> than that, and during that time it has been in mainline, the MAC facing
> interface has not changed until recently.
>=20
> So, I find your claim to be quite unreasonable.
>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

I see you agree that there were and there will be many changes for a while,
It's not a complaint, I know hot it works, it's just a decision based on
required effort vs features offered vs user requirements. Lately it's been
time consuming to try to fix things in this area.

Regards
Madalin

