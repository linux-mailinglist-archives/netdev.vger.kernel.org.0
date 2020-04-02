Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FB619BDD5
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387805AbgDBIr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 04:47:26 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:44888 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728612AbgDBIr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 04:47:26 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A0CBD43B8F;
        Thu,  2 Apr 2020 08:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1585817245; bh=CaINlGi23bNbQCPiqG4hTFVNa3myp/r7lwLxBr7cgi0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=kW4gnNy0mYDEexf4Fqpyy/5bcyuiALY+97oCmjRztxWkdVLL7bl4GR8Slr05Meb9j
         4Q3PgM+chPItqNuRVuE2kMOKAzaQ9yO9IQb03eb1khfYnH5u7rYdKI9+3VwtNRZCyx
         VqbajeHF5Um/Ba1g8sPIMz2IdjAG3ZMHTDfqr4q4+4c20PdFLGY63/aFpFdLSQnqyH
         mskwJ0ERq13d1DM0yMWJ3LVDRVYSJePTXBpOruGoC5Cb7i4vvJjKJWiYalSE5HCXuv
         6Iy2VEG5WZ0mQPKAFoJNdbpLmx1FDLeoETyu4D6ae6Kex3Sx+BYxnqGldhO7aiOblt
         c6sHsmGUEFvkw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C475AA006F;
        Thu,  2 Apr 2020 08:47:21 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 2 Apr 2020 01:47:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 2 Apr 2020 01:47:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXGDiCbc7ewn8hVIK651WFay1ogwyBMkhJBJsd1R6zhOGWzhlEYAEgD44j/WUemAZbaVFmhPnfC4STAMXB5zCm1O1biZWdPSXeDlACB4e0d70VhOjDxrHwza6OyXXfEPuoWgNOpe4xU8MzIpIMldj7vbWhu5gx+HBx+AggS7iLk+kqyeEN26T4g1BNQwqKiUAZqjLOmcp78UzGO+58rfN+JIl8GykAXWvieJ9ETPvFjaMHypLu9uNVac8aF2sPVZtO2V8fnOqvk1RiBfBiwP9bp9Fv7l0HQFPRsA5DhOhzyXH/JCpzVLZrWZl5f4cMdh6qgDsvIJzeWI0wD/uMnBjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P23z2v1OauJc6AvIdXWF2WCDeNFto71PSMaYlOhb40Q=;
 b=AiuxVgXsm3P/6C1hvUFmIX3sWV8wBAJ6VH1xqMTgQ16D9hqRvmVmyfXal0bO6tk4JZmUMpAXYq86BQAzGRBPKxNpURbqmnjC8mfUH3kIrlFQgaE+hFp7v4q3SRIHJKESfyTEverHrusTadl3+Zm+68Jpdp4udSY80tLy5CA9s1T/M/EPSMcbxRMra8hiFll7l2jhAdPrYF9iEOcvZiwfVXFDzdpTMPSqUX5E3kbI09sWj4X3x5eSRDi+CT+k/6Cp1Ds2oh1vusGCADNH6k/XTus63egMw12KUKfhHzoRQ5ok977sMVuz5Qkz3cBRdhGIOPIcrD21sZWVkappO5l5bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P23z2v1OauJc6AvIdXWF2WCDeNFto71PSMaYlOhb40Q=;
 b=aJ5EC5iLunzUrQioy+vtUjL3/+Kv3K5yv0UCxttfhKXi01kyoz6EA64ADwpNmYucuoEBqPK+SAq2+ZW8H9723sQPdFtDTB22a1omIPka19wACgbTlyoTBmGc2lhIjMHsK2LNuufSF42RcUGG4Yb0Fiin2aIjFLBChnYNSl6yyGc=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3091.namprd12.prod.outlook.com (2603:10b6:408:44::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Thu, 2 Apr
 2020 08:47:19 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 08:47:19 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [RFC,net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Topic: [RFC,net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Index: AQHWAE03JZEV2gP9CkiKXaQcDq7OzahVzGeAgAAJs4CAAAleQIAAdfeAgA4MGYCAATPU0A==
Date:   Thu, 2 Apr 2020 08:47:19 +0000
Message-ID: <BN8PR12MB326674C44D4D44C3D2B86C73D3C60@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200322132342.2687-1-weifeng.voon@intel.com>
 <20200322132342.2687-2-weifeng.voon@intel.com>
 <BN8PR12MB3266ACFFA4808A133BB72F9DD3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BYAPR11MB27575EF05D65A8AA9AF4128488F00@BYAPR11MB2757.namprd11.prod.outlook.com>
 <BN8PR12MB326606DE1FEB055B7361A939D3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BYAPR11MB2757B80101035B9A599E357B88F00@BYAPR11MB2757.namprd11.prod.outlook.com>
 <BYAPR11MB3125359A86ECE3A845595E3888C90@BYAPR11MB3125.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB3125359A86ECE3A845595E3888C90@BYAPR11MB3125.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [82.155.99.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c101dfb-54be-4a6f-c844-08d7d6e2740e
x-ms-traffictypediagnostic: BN8PR12MB3091:
x-microsoft-antispam-prvs: <BN8PR12MB30915FE3B8CA0FBA29E2E7BED3C60@BN8PR12MB3091.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(39860400002)(136003)(366004)(346002)(376002)(8676002)(186003)(5660300002)(66556008)(86362001)(52536014)(71200400001)(8936002)(81166006)(4326008)(478600001)(66446008)(26005)(33656002)(9686003)(6506007)(2906002)(76116006)(66476007)(81156014)(55016002)(64756008)(316002)(66946007)(7696005)(54906003)(110136005)(142933001);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XkpQcCnxa79t7ARjE+9m7MabWmH0v8/1RO3OdUOxMGHrhqS1SIZFGTNxU6rY4d9Ih812JNhVjnpP9QDoxjjFnZ3w/+XC0VJWhngiX3zZw+gpWU0JTP4j9HifMPxPz+k22tvuzzIMjqVyRUUmsNcyvzieeZO0Ta2IAgDvspEtH4iXcSZxqblRgafCAZbfFaFn4JEwAQCKTNMVNtOk09IL0lkUAB1o4IfqZvckETmVH6VhPSBIPQGX47rUM+6VCAueEXBrCpJ1sosnzam/a1jTxKxzWurQhjsQCUiDsayPplA7RVN0vxoeXQiGpW1HIGsIVHcdIllPkH/GCbRi9yYPEMG+wdDrzNAfTvYyrhfEEdM9ud7WHinyOZd30JyI61Brc/A/duup8IV1A2Eg0opOQlDYxoMVaxi45KibvMmUDqMniIKxCHI9AP0fO1OugHuQEyDbLKhgtTvNimGi1wvEeM99EMCmg26mAb6ujhuj3W8Ptkt0eTmfQy0WzrZZzzPt
x-ms-exchange-antispam-messagedata: UlsjHtf6TVqSDduiIOX4jIFMnhjOyKT3da2M0QIrGYFun2t+c4mHslTK3mxwA7+skz1bwuHAcxsebIcoOWnZVoz8yG6huexdOGJZ8DE5NJ2sR1q34xf89WZ+8MXbcRTUUbSIo1IOs3gojT3KfPEqCQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c101dfb-54be-4a6f-c844-08d7d6e2740e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 08:47:19.3024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /vYqAOI8RIoPbiUv/qqNf+lol7fIpwzMZt/8Tlwur30/k8QzPOsjk6B9/rSczfJyg8l/LXfGJbVp/O4x5DuVDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3091
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon, Weifeng <weifeng.voon@intel.com>
Date: Apr/01/2020, 15:23:09 (UTC+00:00)

> > > > > > This patch is to enable Intel SERDES power up/down sequence. Th=
e
> > > > > > SERDES converts 8/10 bits data to SGMII signal. Below is an
> > > > > > example of HW configuration for SGMII mode. The SERDES is
> > > > > > located in the PHY IF in the diagram below.
> > > > > >
> > > > > > <-----------------GBE Controller---------->|<--External PHY
> > > > > > chip-->
> > > > > > +----------+         +----+            +---+           +-------=
-
> > --
> > > +
> > > > > > |   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> |
> > External
> > > |
> > > > > > |   MAC    |         |xPCS|            |IF |           | PHY
> > > |
> > > > > > +----------+         +----+            +---+           +-------=
-
> > --
> > > +
> > > > > >        ^               ^                 ^                ^
> > > > > >        |               |                 |                |
> > > > > >        +---------------------MDIO-------------------------+
> > > > > >
> > > > > > PHY IF configuration and status registers are accessible throug=
h
> > > > > > mdio address 0x15 which is defined as intel_adhoc_addr. During
> > > > > > D0, The driver will need to power up PHY IF by changing the
> > > > > > power
> > > state to P0.
> > > > > > Likewise, for D3, the driver sets PHY IF power state to P3.
> > > > >
> > > > > I don't think this is the right approach.
> > > > >
> > > > > You could just add a new "mdio-intel-serdes" to phy/ folder just
> > > > > like I did with XPCS because this is mostly related with PHY
> > > > > settings rather than EQoS.
> > > > I am taking this approach to put it in stmmac folder rather than ph=
y
> > > > folder as a generic mdio-intel-serdes as this is a specific Intel
> > > > serdes architecture which would only pair with DW EQos and DW xPCS
> > HW.
> > > > Since this serdes will not able to pair other MAC or other non-Inte=
l
> > > > platform, I would like you to reconsider this approach. I am open
> > > > for
> > > discussion.
> > > > Thanks Jose for the fast response.
> > >
> > > OK, then I think we should use the BSP init/exit functions that are
> > > already available for platform setups (.init and .exit callback of
> > > plat_stmmacenet_data struct). We just need to extend this to PCI base=
d
> > > setups.
> > >
> > > You can take a look at stmmac_platform.c and check what's done.
> > > Basically:
> > > 	- Call priv->plat->init() at probe() and resume()
> > > 	- Call priv->plat->exit() at remove() and suspend()
> > >
> > I have 2 concern if using the suggested BSP init/exit function.
> > 1. Serdes is configured through MDIO bus. But the mdio bus register onl=
y
> > happens in stmmac_dvr_probe() in stmmac_main.c.
> >=20
> > 2. All tx/rx packets requires serdes to be in the correct power state.
> > If the driver power-down before stopping all the dma, it will cause tx
> > queue timeout as packets are not able to be transmitted out. Hence, the
> > serdes cannot be power-down before calling the stmmac_dvr_remove(). The
> > stmmac_dvr_remove() will unregister the mdio bus. So, the
> > driver cannot powerdown the serdes after the stmmac_dvr_remove() too.
>=20
> I went through the code again, I understand that your intention is to kee=
p the
> platform specific setup in its own file and keep the main dwmac logic cle=
an.
> But, I did not see any way to separate this SERDES configuration from the=
=20
> stmmac_main logic cleanly.=20
> Hope to get more ideas and discussion. Thanks.

Sorry for the late reply!

Yes, that's exactly my intention. Maybe we can add a new set of callbacks=20
for BSP. Something like ->start(), ->stop() ?

---
Thanks,
Jose Miguel Abreu
