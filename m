Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBDC7024B
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 16:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbfGVO0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 10:26:49 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:42190 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725907AbfGVO0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 10:26:49 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A2CD7C0BEB;
        Mon, 22 Jul 2019 14:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563805608; bh=yf4ny+/hsZlJfNHrMFejK+0BN2OuzmeE+srXkH6X24Q=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DcmH5FOQ9FGLIHrcLoOfY0MnUz0o4EJZaZLlHzHYR6zxVe77V6w9GoVtYHYGaybBW
         E6NvKUxX7i1rnbfiyk7g20uZI3W7309/9QxBsoOMefAvilXkD+dCImhm9ymhdQKf7q
         uHjoSERflfFDLaMJF4eATdiIGtC8Zvdw0rghaEczBIau9L5gEaeWCsf4uvtsug+tap
         e+roaeHiGZ3A+bSEYdJZ1eELKgLii7ivxLLOfDFL/bjnaxRDjfkrtulM/7zmv539mn
         ccyCWFrrcwkMIRwXjr0un7mkr12WY3y1v/XFQcURCKw6ZkRV2GcCTXpwcE9FyppWDF
         8ozlrESHOnFhA==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 62BC1A023B;
        Mon, 22 Jul 2019 14:26:48 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 22 Jul 2019 07:26:48 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 22 Jul 2019 07:26:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgKV+skFisrtNGUoGNWvnT3HCEEekdjLTFQErV2nRruqs8aDUNDvsPKAVxOe/9ySqLeRjZxnLYkJMsKP1EgGw7jx3krSZ6OocbbPn88UJKW0nsoK68sUX9MtYWUh45de59QL5BKzTtLK0AkzRjAmZ3Q7kFepILI5W/pK8GKaMOGbPzmAOPWskJi+OzBIU0gvF47oN2swmo3ietHCsw2O/jNhz4DE42h/ogxUa+pSPdCuS0eulNWCOASZpnwOPLgTDEXLC5y9YEk6aw8cJSdR3JPtT04A+i2j/XBYoiL60mrI5DKDfL2uqwdZXRQ/WKqtqKG8b05inSTZWnU5b8ryfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yf4ny+/hsZlJfNHrMFejK+0BN2OuzmeE+srXkH6X24Q=;
 b=dYe1yE2UkNweoD5PDUIE7Esk9QI7Ou2F7YAJ2ibCAWzmh/FwTEWT1uMrHRkoLutGYAqQKnlU9LiwfO0zpTdzv/BHouvd4likXa6Eha34jKSgLnxOsPpVxixEgmDFahdz3KCzveDtqxxb7hNTfnr75mhJMWurjrD/x4x9oKNA4xRD/eyOKycQfakKhIakzxvZospo6gMihqCrqcAtaf5a7nyLRdSYllEjKOzyZfHLXmSFgfIdihAvVwLKFSE0kWFb/bty1L1Fz/pWzpjv0miGIMkIW/hDkCAsvn/kkKF4Zk43P00+yr3dSBuLjr5sR7LJzJoix8D99LxOFiCZbpYX8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yf4ny+/hsZlJfNHrMFejK+0BN2OuzmeE+srXkH6X24Q=;
 b=urhKwHuLkuaVwYG1F7obdqq6Ki8KH1KdaS98YhGRHNWPsWs7x1ig5dBWrRNdRCV8Oq97s1AmDihLv3D+5XSsVJSFaGYe4Au1Qf6V3wDGEXveOZHfsIW4GWRECcBL1pXUKeo+A3KL68uMJr0PoZq1hvb7XtaA+nUU7toaCHVXSY0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3427.namprd12.prod.outlook.com (20.178.211.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Mon, 22 Jul 2019 14:26:46 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 14:26:46 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     =?iso-8859-2?Q?Ond=F8ej_Jirman?= <megi@xff.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Topic: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Index: AQHVIGkCReoXsI1ev0mBbW+MAvwZAqbW1RMAgAALU8CAAATNgIAAAL0ggAAKQYCAAAF88A==
Date:   Mon, 22 Jul 2019 14:26:45 +0000
Message-ID: <BN8PR12MB3266BEC39374BE3E9CD2647DD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <20190722124240.464e73losonwb356@core.my.home>
 <BN8PR12MB32660B12F8E2617ED42249BBD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722134023.GD8972@lunn.ch>
 <BN8PR12MB3266678A3ABD0EBF429C9766D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722141943.GE8972@lunn.ch>
In-Reply-To: <20190722141943.GE8972@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d056a55a-5b60-4d4a-8e27-08d70eb0a02b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3427;
x-ms-traffictypediagnostic: BN8PR12MB3427:
x-microsoft-antispam-prvs: <BN8PR12MB3427021A0DB21D4F8F8C0BE3D3C40@BN8PR12MB3427.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(346002)(136003)(396003)(189003)(199004)(54906003)(486006)(110136005)(71190400001)(14454004)(71200400001)(81166006)(81156014)(8676002)(33656002)(68736007)(99286004)(66066001)(9686003)(6436002)(55016002)(316002)(7416002)(256004)(7736002)(305945005)(74316002)(446003)(11346002)(6116002)(3846002)(86362001)(229853002)(6636002)(476003)(53936002)(4326008)(25786009)(478600001)(186003)(6246003)(66476007)(64756008)(66446008)(66556008)(76116006)(66946007)(8936002)(6506007)(102836004)(52536014)(2906002)(76176011)(7696005)(26005)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3427;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gCAWwKWZ537NjSgWiEKKOGAvqVgVIe/M+PfCANbYBvmM5hsJKlPPEqEa+3377XCxMC7rfCIth2nMFa62lqEoa9SeP+fKiI5USM4c9jSuj9+sVaS1tt8ssZ2MwYC6y5KMRj8NYuFFNZXNsrS9bgV0+5lgtRaXGk0wTQHqrnbHRAUMLvJcQTvLWwpHB/JrT5ggt4Tiqk1RuMa70S2OO2SRtZmlqTr+Fd4EVFl0a7ySWDTy5s+Ix5Z73NS/QSARbON93+c19RJGxLG0pQ8MEF9geRCjTJlYuKD3T+w+SSMLuKtwo70hz6BgNCzMxJ3evURySrXtU+3h79c5PxSLPd2mWFiVZrqwJRAHf2sXQbkRWwqxdEbu2vkrnZ/vzMU6NH9h2Fmruw5fGD8evt5jfso6xVrywO5bd+sqLjYJad9XhTI=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d056a55a-5b60-4d4a-8e27-08d70eb0a02b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 14:26:45.8857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3427
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Jul/22/2019, 15:19:43 (UTC+00:00)

> On Mon, Jul 22, 2019 at 01:58:20PM +0000, Jose Abreu wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > Date: Jul/22/2019, 14:40:23 (UTC+00:00)
> >=20
> > > Does this mean that all stmmac variants support 1G? There are none
> > > which just support Fast Ethernet?
> >=20
> > This glue logic drivers sometimes reflect a custom IP that's Synopsys=20
> > based but modified by customer, so I can't know before-hand what's the=
=20
> > supported max speed. There are some old versions that don't support 1G=
=20
> > but I expect that PHY driver limits this ...
>=20
> If a Fast PHY is used, then yes, it would be limited. But sometimes a
> 1G PHY is used because they are cheaper than a Fast PHY.
> =20
> > > I'm also not sure the change fits the problem. Why did it not
> > > negotiate 100FULL rather than 10Half? You are only moving the 1G
> > > speeds around, so 100 speeds should of been advertised and selected.
> >=20
> > Hmm, now that I'm looking at it closer I agree with you. Maybe link=20
> > partner or PHY doesn't support 100M ?
>=20
> In the working case, ethtool shows the link partner supports 10, 100,
> and 1G. So something odd is going on here.
>=20
> You fix does seems reasonable, and it has been reported to fix the
> issue, but it would be good to understand what is going on here.

Agreed!

Ondrej, can you please share dmesg log and ethtool output with the fixed=20
patch ?

---
Thanks,
Jose Miguel Abreu
