Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25EA272C05
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 12:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfGXKET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 06:04:19 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:43394 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726070AbfGXKES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 06:04:18 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 235A0C0BB2;
        Wed, 24 Jul 2019 10:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563962658; bh=aP3K0n56iD2GV2tMKqRDC9jDRRcIFwnGZY13HJrLpg0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=I+IX9dGszn2NEfy6ojNUoQcyKVn4Nj9DHuhUAygKM2IfDTlF5s8GRC0/Y4pdjFODQ
         +4sjqkCmlS1lnCTM19SD+1NYnQwDydeH5J2NBwLy775hQiPbJ9aOTo45Hb4jAw7Dnw
         ubDh7JFMCkaStcroLvBcJcDNq1NtGnPWCOSGmAPjyQxFk3OHuOuW14FEzxDJauocPV
         l3DtD1MpoYJJKkfV7vlxlnabRzs0AyNRwfLGK9tzRXXFc0GpyLDsLNofXTMFXQrI97
         UnOSqBD1eZF0IXadpOdZvRoBf5rb2ZpuTGmj9BnIdxX9OmkTntAdd1SB12YNF3zcRN
         kBlxqPInoJjYA==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 66FDCA006B;
        Wed, 24 Jul 2019 10:04:14 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 24 Jul 2019 03:04:10 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 24 Jul 2019 03:04:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCPQ/8sf/1oyS7DUkhmS7F8DQ/WTdWVAV1h+j+13nzeibOQjHt2XaEQSDTONFbSYCyuE2wfL+SV5vGO0j4/9Xrf2ECwfWIhalBfYMravZ9xjsZchZM1AzFmTqhZ04x4A0Si0zfTc9hDNFf6k9/QrlVTvDJJdrcfsymZC+RaztaFwYY10Cpo0M3yHUBXR3plo8dVsNLFLF6B1RBOv4GCmytpfe3dT10pOXdDEKJRZ+sPYXQWh5xoINGhPak93m96A0LC4RdlHOL/HSfxMV9i3d7I2s2QhlIY0NBUxN6pcarFG28N/o/7poIEzXN3o6pwkX2oY1FbS4TwX1EYtjCrp4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6p8o2QeT7yDcrfLoA3KDOGJicYtqtsnGWtqbb/I9TM=;
 b=LmduNuAJ5AWso6mc0tWoHvIz6tA/I/aH/ezqrEKLoaJrC8ZYr17kXrnna/fBJcj6/O4idUL2cr4DskK4LK77Y4la4bAj+1HzxBA3+PB+4DiyPljKXNX7QW1HtGErxrhg3DyS+INpxCWkSsO7SZKzWG359Hfm9CqOdKBeHEipvX/ouP5k0yjUMdCWhu6dyT84/nd58BTKT0cdZW9ZxfsHl0jiMDLkkyIqOEwwhl7LvnQqUlq8U8OqF+mOfJoK7KIIfWB0iN1SXrK7Pv7Dq4SN7cjZGEPK5a5dRCPv3tlQUHGLhres7uFCmS+yznPWsZiD59WlQQAJzenUF+TjYZ6cSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6p8o2QeT7yDcrfLoA3KDOGJicYtqtsnGWtqbb/I9TM=;
 b=ScGzKo97ust2yC5YOynzTuZdAGeh8+u+NRngOMntOcQoAuxCpTMx2JlxAT/Mpd4qMWImvLTQNHCoqNlwdwPBv4d1IG6erftvzsjEbnnH/pXGjzi+Y9oi1zrnbsLSbftqs6vD4vitJuZXkYiEhc+pAAbhJ78/4/9LWd2Gq5G+t1w=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB2645.namprd12.prod.outlook.com (20.176.255.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 10:04:08 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Wed, 24 Jul 2019
 10:04:07 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     David Miller <davem@davemloft.net>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "lists@bofh.nu" <lists@bofh.nu>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "wens@csie.org" <wens@csie.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CABnZ9AIAADuYAgAAFQOCAAAnIAIAABLTAgAFMy7CAAB4gAIAAAO7wgAAG6gCAABvPAIAAcGAAgADrmoCAAA0XIIAAA1AAgAAAhFA=
Date:   Wed, 24 Jul 2019 10:04:07 +0000
Message-ID: <BYAPR12MB3269C5766F553438ECFF2C9BD3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
 <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
 <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
 <20190723.115112.1824255524103179323.davem@davemloft.net>
 <20190724085427.GA10736@apalos>
 <BYAPR12MB3269AA9955844E317B62A239D3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <20190724095310.GA12991@apalos>
In-Reply-To: <20190724095310.GA12991@apalos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1f1d3e2-1896-419d-aa05-08d7101e4474
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB2645;
x-ms-traffictypediagnostic: BYAPR12MB2645:
x-microsoft-antispam-prvs: <BYAPR12MB26459B116217C0BF431AEA88D3C60@BYAPR12MB2645.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(346002)(39860400002)(366004)(199004)(189003)(20864003)(9686003)(7736002)(8676002)(14454004)(19627235002)(14444005)(81166006)(53936002)(71190400001)(81156014)(8936002)(229853002)(7416002)(71200400001)(99286004)(33656002)(256004)(74316002)(5660300002)(4326008)(305945005)(486006)(6506007)(6246003)(68736007)(66066001)(316002)(102836004)(7696005)(76116006)(66946007)(66476007)(66556008)(64756008)(6436002)(478600001)(476003)(76176011)(446003)(11346002)(186003)(2906002)(26005)(54906003)(25786009)(3846002)(6116002)(66446008)(86362001)(110136005)(6636002)(52536014)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB2645;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OZqbdMxTlt7QJYLKK6EZGH0CUqWGDLdRs/JKF0m5N+sCiOYcg8LDz/+hCiZ15pFYU2h/ZnyjoXuZahYMIZ3G2lgS/GqwtsxYAWW2O9v/2KYVOT6Kq4YstGXRzbBm0QQ4Om1H7kOYe9dc0U0LCPRPat62okJgd3h41mAGa5ib+cAPPuY4WTsPJ2NHQybOCQ8E8AaA7pRuiMo7B6iB68eValYx5V7rL0WW3R2BTuUyuqAb8NXUTLtWaW7zhbqm9RdscOTwfzPUiIhghP6YA1na9nTxlGigOjixrOiEstQN73yf1j68qBIvb7JnIpnQp6JZyhEPHBHj6vHZLAv11Xag21MoWOahNVSmPJzpj/iCDEJvLu2FwQGGZKblEuPyMirm6gVdzp0Nkz/URUC7LfT+G1lXonV0R5bwiO6gF2GRB0w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f1d3e2-1896-419d-aa05-08d7101e4474
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 10:04:07.8864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2645
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Jul/24/2019, 10:53:10 (UTC+00:00)

> Jose,=20
> > From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Date: Jul/24/2019, 09:54:27 (UTC+00:00)
> >=20
> > > Hi David,=20
> > >=20
> > > > From: Jon Hunter <jonathanh@nvidia.com>
> > > > Date: Tue, 23 Jul 2019 13:09:00 +0100
> > > >=20
> > > > > Setting "iommu.passthrough=3D1" works for me. However, I am not s=
ure where
> > > > > to go from here, so any ideas you have would be great.
> > > >=20
> > > > Then definitely we are accessing outside of a valid IOMMU mapping d=
ue
> > > > to the page pool support changes.
> > >=20
> > > Yes. On the netsec driver i did test with and without SMMU to make su=
re i am not
> > > breaking anything.
> > > Since we map the whole page on the API i think some offset on the dri=
ver causes
> > > that. In any case i'll have another look on page_pool to make sure we=
 are not
> > > missing anything.=20
> >=20
> > Ilias, can it be due to this:
> >=20
> > stmmac_main.c:
> > 	pp_params.order =3D DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
> >=20
> > page_pool.c:
> > 	dma =3D dma_map_page_attrs(pool->p.dev, page, 0,
> > 				 (PAGE_SIZE << pool->p.order),
> > 				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> >=20
> > "order", will be at least 1 and then mapping the page can cause overlap=
=20
> > ?
>=20
> well the API is calling the map with the correct page, page offset (0) an=
d size
> right? I don't see any overlapping here. Aren't we mapping what we alloca=
te?
>=20
> Why do you need higher order pages? Jumbo frames? Can we do a quick test =
with
> the order being 0?

Yes, it's for Jumbo frames that can be as large as 16k.

From Jon logs it can be seen that buffers are 8k but frames are 1500 max=20
so it is using order =3D 1.

Jon, I was able to replicate (at some level) your setup:

# dmesg | grep -i arm-smmu
[    1.337322] arm-smmu 70040000.iommu: probing hardware=20
configuration...
[    1.337330] arm-smmu 70040000.iommu: SMMUv2 with:
[    1.337338] arm-smmu 70040000.iommu:         stage 1 translation
[    1.337346] arm-smmu 70040000.iommu:         stage 2 translation
[    1.337354] arm-smmu 70040000.iommu:         nested translation
[    1.337363] arm-smmu 70040000.iommu:         stream matching with 128=20
register groups
[    1.337374] arm-smmu 70040000.iommu:         1 context banks (0=20
stage-2 only)
[    1.337383] arm-smmu 70040000.iommu:         Supported page sizes:=20
0x61311000
[    1.337393] arm-smmu 70040000.iommu:         Stage-1: 48-bit VA ->=20
48-bit IPA
[    1.337402] arm-smmu 70040000.iommu:         Stage-2: 48-bit IPA ->=20
48-bit PA

# dmesg | grep -i stmmac
[    1.344106] stmmaceth 70000000.ethernet: Adding to iommu group 0
[    1.344233] stmmaceth 70000000.ethernet: no reset control found
[    1.348276] stmmaceth 70000000.ethernet: User ID: 0x10, Synopsys ID:=20
0x51
[    1.348285] stmmaceth 70000000.ethernet:     DWMAC4/5
[    1.348293] stmmaceth 70000000.ethernet: DMA HW capability register=20
supported
[    1.348302] stmmaceth 70000000.ethernet: RX Checksum Offload Engine=20
supported
[    1.348311] stmmaceth 70000000.ethernet: TX Checksum insertion=20
supported
[    1.348320] stmmaceth 70000000.ethernet: TSO supported
[    1.348328] stmmaceth 70000000.ethernet: Enable RX Mitigation via HW=20
Watchdog Timer
[    1.348337] stmmaceth 70000000.ethernet: TSO feature enabled
[    1.348409] libphy: stmmac: probed
[ 4159.140990] stmmaceth 70000000.ethernet eth0: PHY [stmmac-0:01]=20
driver [Generic PHY]
[ 4159.141005] stmmaceth 70000000.ethernet eth0: phy: setting supported=20
00,00000000,000062ff advertising 00,00000000,000062ff
[ 4159.142359] stmmaceth 70000000.ethernet eth0: No Safety Features=20
support found
[ 4159.142369] stmmaceth 70000000.ethernet eth0: IEEE 1588-2008 Advanced=20
Timestamp supported
[ 4159.142429] stmmaceth 70000000.ethernet eth0: registered PTP clock
[ 4159.142439] stmmaceth 70000000.ethernet eth0: configuring for=20
phy/gmii link mode
[ 4159.142452] stmmaceth 70000000.ethernet eth0: phylink_mac_config:=20
mode=3Dphy/gmii/Unknown/Unknown adv=3D00,00000000,000062ff pause=3D10 link=
=3D0=20
an=3D1
[ 4159.142466] stmmaceth 70000000.ethernet eth0: phy link up=20
gmii/1Gbps/Full
[ 4159.142475] stmmaceth 70000000.ethernet eth0: phylink_mac_config:=20
mode=3Dphy/gmii/1Gbps/Full adv=3D00,00000000,00000000 pause=3D0f link=3D1 a=
n=3D0
[ 4159.142481] stmmaceth 70000000.ethernet eth0: Link is Up - 1Gbps/Full=20
- flow control rx/tx

The only missing point is the NFS boot that I can't replicate with this=20
setup. But I did some sanity checks:

Remote Enpoint:
# dd if=3D/dev/urandom of=3Doutput.dat bs=3D128M count=3D1
# nc -c 192.168.0.2 1234 < output.dat
# md5sum output.dat=20
fde9e0818281836e4fc0edfede2b8762  output.dat

DUT:
# nc -l -c -p 1234 > output.dat
# md5sum output.dat=20
fde9e0818281836e4fc0edfede2b8762  output.dat

---
Thanks,
Jose Miguel Abreu
