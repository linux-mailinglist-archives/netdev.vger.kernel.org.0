Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7A423A8D9
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgHCOub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:50:31 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:60897
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbgHCOrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 10:47:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhyRIKygjnunwEkjUANdS/qWiLTH9ptFWX/MIHXl4Z2tXzMLiQl1kcaKVA7Vc0zYNhZm1DIcjbgKn9/6M8RkmhXUXx2ButdNRpSPhU2JtuJyaRJhIsODyxHylVwqxFjsWjcfReFknpBxN5UGWbG7h422Z26qvkbEBnmpW8yuUFYWRRRFnvDa+XTP33Q7d7CNx0N+8Th4fCiwY3rkJFvi/KolQuKOCySVRCtxPzhtv2Ftufmj8/d4I0RHRehJMTe81M05GMbpR31f3J0wFd6b7mmiOwaq8bCibUbHs0RN7lXpk0k/G+cTGuvfQJ59jIlBWpEQLWjWWwMoL7hc/9h5nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAKxwUMqZGRsFHk7R/uQ4lg8B3mrnJTb98HAlfEGDYE=;
 b=SKtT9d9vW+tX55drxTet+7btkz0D725ZeYeKXaMvd8keOodv8hvDSdhAelkp90IgaJogCY0xX4/9Qs6IGR/sY8TEvE7jW3g2ELUo6xQqAfOwHaagZCvYJ/eelWyTWh52LfozvGGMYQAuD7Jm+bhfuPTfscl4RUQ/JF2HnRkjDC1IoaPjwdTUNIM5gyACdmUKSjPD9grSK+/w/lQBqLtspyusWvVF9FNqtvX8GpMfYeXXwsInCq1V3U2B8yHfXT6qr6GOhhmhRlBA9lAt8WCE56/FPt3aKB4Nzg5qBFEJewSv5IRs9YUQ7+OQxyjhiv1VFAs8Kyc2RlVil29E6wqOAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAKxwUMqZGRsFHk7R/uQ4lg8B3mrnJTb98HAlfEGDYE=;
 b=O1SVSNDK0ncnFfQ7wBfuXXko24O3ccIhxBw3YCpfpryjQzYJyzEYt22NoCPu0B4lCT+JZuCHP2K6+I4+q1mo1L4vPVldeVzbwyormJSSyXNgmhAAOELfQ/0Zs154+Dndf0Vg/fopOkjoPe7lqor4UpSbmAxLWZleXqMLVS3Yyv4=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB6072.eurprd04.prod.outlook.com (2603:10a6:20b:bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 14:47:41 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f%2]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 14:47:41 +0000
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
Thread-Index: AQHWZNiOdpikt9xf+EiwD7SyrSwWH6kc9FCAgAGkTICAAzz5gIAA15EAgABZCQCAAFwWgIACs+VwgAALHACAACsYYIAAKZGAgAAIOOA=
Date:   Mon, 3 Aug 2020 14:47:41 +0000
Message-ID: <AM6PR04MB3976E2DFF6EAC273B7B1BEABEC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
 <20200801151107.GK1712415@lunn.ch>
 <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803090716.GL1551@shell.armlinux.org.uk>
 <AM6PR04MB3976284AEC94129D26300485EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803141017.GM1551@shell.armlinux.org.uk>
In-Reply-To: <20200803141017.GM1551@shell.armlinux.org.uk>
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
x-ms-office365-filtering-correlation-id: dd28ce70-6f9a-41e2-eef3-08d837bc2c99
x-ms-traffictypediagnostic: AM6PR04MB6072:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB6072491924099E223E04BDB2AD4D0@AM6PR04MB6072.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +T6dsjrj/lmLjI0LST8PSoNkM2+zBc4ggevqMZlXh70NfRmQli9zshDBXFDAkpzU/J9U3SndeHfRsTUMZP5fUWddtQpnlaluw+G+t4f9f8tGQHROi93bpRLLfT2k13tN3c/TiUk1b6EjlSuBwZ8LcFLpOHeOMtIS0Tb3VzQQFtDklZOKx+wS0CdPHvxTyQ3P4/llYsumjy9Y/hXUQc27k71KRg9nMNi7KH8gmZjyyMOH2iYmqjuvxEK62BFrPmsyQZE+XLV9IF2j0yhySMjfnOz+rhLyGdC3IztiQ9KdYmTkRaEs701eVoBXKjnOYBwp+KYyaInVGJVx87OFWDVWGn0lv9DXnT3OLEepylyr0zgpzXlaEXrD8A73+pAf0SQ0ku9vNqjK/pPkA6YRUPdo7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(26005)(966005)(186003)(55016002)(66446008)(53546011)(86362001)(52536014)(71200400001)(2906002)(33656002)(54906003)(66556008)(8936002)(4326008)(64756008)(66476007)(8676002)(7696005)(5660300002)(316002)(9686003)(6506007)(110136005)(478600001)(66946007)(76116006)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: uLkoRNtwCyXj3ta4xcyHTLHEHs5NWKJKnSyhMExt9QQWKf1ex97cYRGMtlN/dQrn7XtMs3dR0a/abnoqjC/yOqRlkS4rdK+qnrHToTZMb6emp2Nd4JsoicN6zS3kVPbylIfqeadX9WW8HRpBUYAq6SwqH48G4Q/U/QLZbZNLVi7DFbS7HYLH9l04nGYdap9Irp8f1JQ2v7WsjGjiYGHeZKNiyreNg0TJqDTXqv/da2vdYNMDaPnZOCdHXrau/lIf8DXWj/EhXcfUvLKHhH/YxcfX7Ox+hH/6Lsegd6/UYXHjL9FVzTROPzgOU8WiryLH4lSGLti7T5tNMjtHTK0tHfqj8uPyeQdR3WqE5ECyGzpvSsecsiVXQGHATzdq5CxJgD5oVnmFneo5TBNptQu1cz5RzZG8tTDPnTINNmvYdT57lcM0vqM3jejQPg4B8oRXoj+JwLuNL0P9y76cwZrwX41vCNH6UUzRAQrY8YvTO4UplVVq8y0rQkYrVbsMyzKxJMOj7lGKa6CrH4wHS25HYAi/4vTlFPz6fu7J9Uc98xdNaQ1yiLHBIyOuXMoDRB+PAx0MoH/wqqjw7zzlsr7s3Bo3yJ3kb3T8wo5dEgnEd4Gzz8zl9qEGY2jH0j3/6iMM0ygaVKfDLMVZGnkaqpPTKw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd28ce70-6f9a-41e2-eef3-08d837bc2c99
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 14:47:41.3900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SjQcwypFSjaUdv2SO+HE3wDdxX1o/+axKDdRXawoGKA48/F6BMLKkkG1gTYWjJDrNDroazwfpyizHJ7Pgpe7Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: 03 August 2020 17:10
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
> On Mon, Aug 03, 2020 at 11:45:55AM +0000, Madalin Bucur (OSS) wrote:
> > > -----Original Message-----
> > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Sent: 03 August 2020 12:07
> > > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > > Cc: Andrew Lunn <andrew@lunn.ch>; Vikas Singh
> > > <vikas.singh@puresoftware.com>; f.fainelli@gmail.com;
> hkallweit1@gmail.com;
> > > netdev@vger.kernel.org; Calvin Johnson (OSS)
> <calvin.johnson@oss.nxp.com>;
> > > kuldip dwivedi <kuldip.dwivedi@puresoftware.com>; Vikas Singh
> > > <vikas.singh@nxp.com>
> > > Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed
> PHY
> > >
> > > On Mon, Aug 03, 2020 at 08:33:19AM +0000, Madalin Bucur (OSS) wrote:
> > > > > -----Original Message-----
> > > > > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On
> > > > > Behalf Of Andrew Lunn
> > > > > Sent: 01 August 2020 18:11
> > > > > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > > Cc: Vikas Singh <vikas.singh@puresoftware.com>;
> f.fainelli@gmail.com;
> > > > > hkallweit1@gmail.com; netdev@vger.kernel.org; Calvin Johnson (OSS=
)
> > > > > <calvin.johnson@oss.nxp.com>; kuldip dwivedi
> > > > > <kuldip.dwivedi@puresoftware.com>; Madalin Bucur (OSS)
> > > > > <madalin.bucur@oss.nxp.com>; Vikas Singh <vikas.singh@nxp.com>
> > > > > Subject: Re: [PATCH 2/2] net: phy: Associate device node with
> fixed
> > > PHY
> > > > >
> > > > > On Sat, Aug 01, 2020 at 10:41:32AM +0100, Russell King - ARM Linu=
x
> > > admin
> > > > > wrote:
> > > > > > On Sat, Aug 01, 2020 at 09:52:52AM +0530, Vikas Singh wrote:
> > > > > > > Hi Andrew,
> > > > > > >
> > > > > > > Please refer to the "fman" node under
> > > > > > > linux/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > > > > > > I have two 10G ethernet interfaces out of which one is of
> fixed-
> > > link.
> > > > > >
> > > > > > Please do not top post.
> > > > > >
> > > > > > How does XGMII (which is a 10G only interface) work at 1G speed=
?
> Is
> > > > > > what is in DT itself a hack because fixed-phy doesn't support
> 10G
> > > > > > modes?
> > > > >
> > > > > My gut feeling is there is some hack going on here, which is why
> i'm
> > > > > being persistent at trying to understand what is actually going o=
n
> > > > > here.
> > > >
> > > > Hi Andrew,
> > > >
> > > > That platform used 1G fixed link there since there was no support
> for
> > > > 10G fixed link at the time. PHYlib could have tolerated 10G speed
> there
> > > > With a one-liner.
> > >
> > > That statement is false.  It is not a "one liner".  fixed-phy exposes
> > > the settings to userspace as a Clause 22 PHY register set, and the
> > > Clause 22 register set does not support 10G.  So, a "one liner" would
> > > just be yet another hack.  Adding Clause 45 PHY emulation support
> > > would be a huge task.
> > >
> > > > I understand that PHYLink is working to describe this
> > > > Better, but it was not there at that time. Adding the dependency on
> > > > PHYLink was not desirable as most of the users for the DPAA 1
> platforms
> > > > were targeting kernels before the PHYLink introduction (and last
> I've
> > > > looked, it's still under development, with unstable APIs so we'll
> > > > take a look at this later, when it settles).
> > >
> > > I think you need to read Documentation/process/stable-api-nonsense.rs=
t
> > > particularly the section "Stable Kernel Source Interfaces".
> > >
> > > phylink is going to be under development for quite some time to come
> > > as requirements evolve.  For example, when support for QSFP interface=
s
> > > is eventually worked out, I suspect there will need to be some furthe=
r
> > > changes to the driver interface.  This is completely normal.
> > >
> > > Now, as to the stability of the phylink API to drivers, it has in fac=
t
> > > been very stable - it has only changed over the course of this year t=
o
> > > support split PCS, a necessary step for DPAA2 and a few others.  It
> has
> > > been around in mainline for two years, and has been around much longe=
r
> > > than that, and during that time it has been in mainline, the MAC
> facing
> > > interface has not changed until recently.
> > >
> > > So, I find your claim to be quite unreasonable.
> >
> > I see you agree that there were and there will be many changes for a
> while,
> > It's not a complaint, I know hot it works, it's just a decision based o=
n
> > required effort vs features offered vs user requirements. Lately it's
> been
> > time consuming to try to fix things in this area.
>=20
> No, it hasn't been time consuming.  The only API changes as far as
> drivers are concerned have been:
>=20
> 1. the change to the mac_link_up() prototype to move the setup of the
>    final link parameters out of mac_config() - and almost all of the
>    updates to users were done by me.
>=20
> 2. the addition of split PCS support, introducing new interfaces, has
>    had minimal impact on those drivers that updated in step (1).
>=20
> There have been no other changes as far as users are concerned.
>=20
> Some of the difficulty with (1) has been that users of phylink appeared
> initially with no proper review, and consequently they got quite a lot
> wrong.  The most common error has been using state->speed, state->duplex
> in mac_config() methods irrespective of the AN mode, which has _always_
> since before phylink was merged into mainline, been totally unreliable.
>=20
> That leads me on to the other visible "changes" for users are concerned,
> which may be interpreted as interface changes, but are not; they have
> all been clarifications to the documentation, to strengthen things such
> as "do not use state->speed and state->duplex in mac_config() for
> various specific AN modes".  Nothing has actually changed with any of
> those clarifications.
>=20
> For example, if in in-band mode, and mac_config() uses state->speed
> and state->duplex, then it doesn't matter which version of phylink
> you're using, if someone issues ethtool -s ethN ..., then state->speed
> and state->duplex will be their respective UNKNOWN values, and if you're
> using these in that situation, you will mis-program the MAC.
>=20
> Again, that is not something that has changed.  Ever.  But the
> documentation has because people just don't seem to get it, and I seemed
> to be constantly repeating myself in review after review on the same
> points.
>=20
> So, your assertion that the phylink API is not stable is false.  It
> has been remarkably stable over the two years that it has been around.
> It is only natural that as the technology that a piece of code supports
> evolves, so the code evolves with it.  That is exactly what has happened
> this year with the two changes I mention above.
>=20
> Now, if you've found it time consuming to "fix things" (unspecified what
> "things" are) then I assert that what has needed to be fixed are things
> that NXP have got wrong.  Such as the rtnl cockups.  Such as abusing
> state->speed and state->duplex.  None of that is because the interface
> is unstable - they are down to buggy implementation on NXPs part.
>=20
> Essentially, what I'm saying is that your attempt to paint phylink as
> being painful on the basis of interface changes is totally and utterly
> wrong and is just an excuse to justify abusing the fixed-link code and
> specifying things that are clearly incorrect via DT.

Thank you for the distilled phylink history, it may be easier to comprehend
with these details. I was not referring to phylink, but PHY related issues
on the DPAA 1 platforms.

> I will accept that the interface that had existed up until the
> mac_link_up() change was confusing - it clearly was due to the number
> of people getting mac_config() implementations wrong.  That is actually
> another of the reasons why the mac_link_up() change was made.  These
> problems are _only_ found by people making use of it.  If people don't
> use stuff, then problems aren't found, and nothing changes.
>=20
> So, I think you can expect a NAK for the patch at the top of this
> thread on the basis that it is perpetuating an abuse not only the
> legacy fixed-link code, but also DT.  However, I will leave Andrew to
> make that call.
>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
