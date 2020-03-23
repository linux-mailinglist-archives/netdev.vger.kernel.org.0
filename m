Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E9718F146
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 09:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgCWIxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 04:53:32 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:39324 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727477AbgCWIxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 04:53:32 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4A343401B2;
        Mon, 23 Mar 2020 08:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584953611; bh=3pcpo8tKaOfmK9PsHGy0VLzvPd4772acmLVnZ6/k1LA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=N9kHsRptdb1bGOXq2Ob3Xlg92L4urbKIAOea5j0sQtLvuUDF7Q/E3CV/V1qAI+vG6
         kBnB2RK9lxCqtuBEedsHxOqpkNbdJjbrDmO/t1fUQCmcChYTMGGR1tOM48XOXPGSvO
         JOXf+K/3vpybRrBMGo9fI1jNznMvkF991cxLm2+/6XycF+urw/PSgZmEcUQopY/Eiv
         OwwXuT1tLaBqCqnq4BLvqqI+8qsqrfG0n2yU9zbR1NVEV5hdTPPFqpfNnXKRz4CCgX
         dLeijc4qeO3gwjTe/uNfSqhmbKNmkg2dUr1qZyacRumTxB/Zj5N+iwEkHlJcINwwcT
         Yb6QMnvKfp74w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C2E05A0072;
        Mon, 23 Mar 2020 08:53:30 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 23 Mar 2020 01:53:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 23 Mar 2020 01:53:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mszk+KAo6i+vPrqV8WdrJjuMqqMrG+n84PkFQEimNrljvNkF8IRIthluVoNFj8CAoEdYFM7yIwXHzwMXk/fbm5wP6Q+pDUDu9glK6QiLRAxIIHu95EbNET1t9mjJ5FXzDzj8rnpi3bPsjIk+1BvBtb7RPs03f0FiugVAK4XxwNNrUvyPEKNCf1vuAKrdjCR0ywIl+cwUH0CVUolVJamy9mO4OxVETLBWi4g4X9If9uqRlJKxcYtmJkkhfvNi7Yli7YHiyWVC8uCE7cAQiD9dTciXI2Pl84GN4h97H5D5sgJ6OWrX8ToYl8dIVYBQURBthPxolrTx8unsG3DgrBa6rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4ffSTRJme18Kk+LMToOCvBD0xJ8cv3asiMiReVzlws=;
 b=NtTM5TgJ01MMSbkWwzqsSId/7cyU6g9ir5YsZ5Zmi/UZM+YRkwLNgeo3h1VW3bOAISVNISW1SZwRHt62uNoxQ3zeoG3euXJKQ7E6zTcJRwkypANomY5dRjKS3AMI7UvGnsSijecQ9fiSPCyGXTTk1Th4chyj4AcsX4H7N1ecviqA+29XiJPHMJ6svgPV+6Nr1dMvtc/T9M/6aUOc9k+VwUMvwVhGKLvNN+LKIp2M9lCFKlv9Z+Am26MPqGPX6m0z5rryRJRJP2KELY1zc88WJntS8pxH9vSEmGPkwv1w1sB1e3k/VXs4B7kM/BSXe4wZxMGYsRDJnCJywduI2/vW/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4ffSTRJme18Kk+LMToOCvBD0xJ8cv3asiMiReVzlws=;
 b=jjNE5jFYCayYlg85/yYDjv4aiVEBSwdrye7w+eIlxBkh3HkfcFWcb3Emz6ECla7gJaBenG8R6GjPCp9/IYpbwm23V6rVsBBncVhwL7e4gU092VcZS0p6PKlio7B57nLviHwWMk+IXk5VsJRpqeO8mX8CuEY5kzAtNxf78cWjHvE=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3588.namprd12.prod.outlook.com (2603:10b6:408:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Mon, 23 Mar
 2020 08:53:28 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 08:53:28 +0000
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
Thread-Index: AQHWAE03JZEV2gP9CkiKXaQcDq7OzahVzGeAgAAJs4CAAAleQA==
Date:   Mon, 23 Mar 2020 08:53:28 +0000
Message-ID: <BN8PR12MB326606DE1FEB055B7361A939D3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200322132342.2687-1-weifeng.voon@intel.com>
 <20200322132342.2687-2-weifeng.voon@intel.com>
 <BN8PR12MB3266ACFFA4808A133BB72F9DD3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BYAPR11MB27575EF05D65A8AA9AF4128488F00@BYAPR11MB2757.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB27575EF05D65A8AA9AF4128488F00@BYAPR11MB2757.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fef1f1f5-0a01-45c2-0e2e-08d7cf07a803
x-ms-traffictypediagnostic: BN8PR12MB3588:
x-microsoft-antispam-prvs: <BN8PR12MB35888D7FB2A391521708B314D3F00@BN8PR12MB3588.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(396003)(39860400002)(199004)(316002)(81156014)(8676002)(81166006)(6506007)(76116006)(52536014)(4326008)(26005)(8936002)(7696005)(186003)(5660300002)(66556008)(66446008)(66476007)(64756008)(9686003)(110136005)(33656002)(66946007)(71200400001)(2906002)(55016002)(54906003)(478600001)(86362001)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3588;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BMw3R85bUJVtKSqag43Tma4EX991e2DMTeH0XtBvCsNVCFHxCArH6mm3XuMWhlUbIG6JIfht53TQn2ddi1XX5kouenm6VPurDtbpnLSERRC+5Q43Mun7p2QKclxvcwoeb7IwBblKLWcIzmxQI4s7Utt/1ejpiaIUrK4LFKXC5BaTNwbuntghrz0nRlRpUc6trMhkHEAMSC08GgDKR5b/sOpNRIiLCVnqY1SRTSpOsf2kxR+7JMDZoqibFd9Y4LrVgVAaBGRBZ6TOggvbJeWU99l69H5AB1W90wDPw0/DJWJUP3e1IUMkQ4vrnQzKbzOG0fICgFdrvn770Nm8LIpXB5Jjx0bwhmXQmHv4uWhxaoi+3RfQzH2BvbD4IomnJTnrhaKjhzHwMvDQFtKVhxpx5hKc5cJrATd1u+NyZf1+yNkyhiVrVa+wU91CZIUB3fjWR+LADkMC0zKXT36oj++urZ4LARMVraUh3Rnc6Da3neIMv+nRyMJI8DsDCVMenrpt
x-ms-exchange-antispam-messagedata: IOYk6znIa9GyAMVpeaEf+/WdGChCtBxTnxZT8gSdIbo9Ky6H5BPbqSmdiN5V3x6PdgvBatt5SvLMCzIV5DLmq0NW7MFXzCvLfU+195I7aOkanYrbK5ptXlg1WbbNoC6ME7XGcjnce8RklQ4jTYhRDg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fef1f1f5-0a01-45c2-0e2e-08d7cf07a803
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 08:53:28.4898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDclYXwqLQRFkq+js8T0VqQSRvJLP+kfCtZC5GvR0rBYlLVFSv48bZb0SHoaUUAg+wEW5WGb2ZJDcyZxQ0Ee1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3588
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon, Weifeng <weifeng.voon@intel.com>
Date: Mar/23/2020, 08:16:29 (UTC+00:00)

> > > This patch is to enable Intel SERDES power up/down sequence. The
> > > SERDES converts 8/10 bits data to SGMII signal. Below is an example o=
f
> > > HW configuration for SGMII mode. The SERDES is located in the PHY IF
> > > in the diagram below.
> > >
> > > <-----------------GBE Controller---------->|<--External PHY chip-->
> > > +----------+         +----+            +---+           +----------+
> > > |   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> | External |
> > > |   MAC    |         |xPCS|            |IF |           | PHY      |
> > > +----------+         +----+            +---+           +----------+
> > >        ^               ^                 ^                ^
> > >        |               |                 |                |
> > >        +---------------------MDIO-------------------------+
> > >
> > > PHY IF configuration and status registers are accessible through mdio
> > > address 0x15 which is defined as intel_adhoc_addr. During D0, The
> > > driver will need to power up PHY IF by changing the power state to P0=
.
> > > Likewise, for D3, the driver sets PHY IF power state to P3.
> >=20
> > I don't think this is the right approach.
> >=20
> > You could just add a new "mdio-intel-serdes" to phy/ folder just like I
> > did with XPCS because this is mostly related with PHY settings rather
> > than EQoS.
> I am taking this approach to put it in stmmac folder rather than phy fold=
er
> as a generic mdio-intel-serdes as this is a specific Intel serdes archite=
cture which
> would only pair with DW EQos and DW xPCS HW. Since this serdes will not a=
ble to
> pair other MAC or other non-Intel platform, I would like you to reconside=
r this
> approach. I am open for discussion.=20
> Thanks Jose for the fast response.

OK, then I think we should use the BSP init/exit functions that are=20
already available for platform setups (.init and .exit callback of=20
plat_stmmacenet_data struct). We just need to extend this to PCI based=20
setups.

You can take a look at stmmac_platform.c and check what's done.=20
Basically:
	- Call priv->plat->init() at probe() and resume()
	- Call priv->plat->exit() at remove() and suspend()

---
Thanks,
Jose Miguel Abreu
