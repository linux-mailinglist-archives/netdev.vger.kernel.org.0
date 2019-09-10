Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9C4AE5A3
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfIJIfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:35:08 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:50606 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbfIJIfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 04:35:08 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C7C36C1DA2;
        Tue, 10 Sep 2019 08:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568104507; bh=dHpz86eIAJxOpRLHiDrCekhz8OjLypZ8V9tYFqxa+XQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=O3XYjxmoFfYab/XnKNSbFErTN2ZihPCgrMiUk5z58rTb+PXIV9XDrWynNVu444OKk
         cq72Lb8wGDU5a3+VcSLPbySdNxOiIqraL7ADNu18e69KREYG69jyUnFFSb33bTlzP3
         2iG/v+UbeC9X3JTVpuU6XxezSyZ379j73r7fRM6JcL/ARCbtyg4mfh9Ti2orJ6m4uk
         ckle1JCTHoKKbxhP3MRHkO+xeobvFj9KBDfzgQfraBiTkj3kibeV7GrD2ckRR1LgdT
         f7wQwaoBnkq4ZrPgt8clt1GsicY9clnDrCvgqXPZdYA6taLgHfyQR17nNzrkzGTefE
         ngDk6M9fzEhrw==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8DD92A005A;
        Tue, 10 Sep 2019 08:35:07 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 10 Sep 2019 01:35:07 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 10 Sep 2019 01:35:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4fz2wt9sdQ0HY//EozvEeuFoX/xw2bp9nIr0imA/snHwaJ9rbYR87ImqNl6ts+5FBpBz+rMY3b+80OknT7bZrEbgqHL0YkxrJY8N6RS/UwIRvZ9EtIlOkYxMLDADu7mL16lkrBAOAjOH2cv0gFSdSP1cmSE6ajDOXhLhjb0WSI9zPBHnAkamZZca/PLjoIFiRuI+jiWe6TSjFriZDt88EP7Hf9Q5FMDUq3HgYRByqdtGZeoGH1y8XgPOrQYpmZqEomFySDGhqKvDRmzaUZre8lJo/ORALMWUlzF0G7Hyp+JGIsop74d/VTGG+AtPFTkc0RMPxC/sFPKuGEUy80tuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T73cWL8Z+YeeaVLixJQl+T6Udzr9v+Qkp1cEVexoaZc=;
 b=C0hCAmVrIK1tnsMLbFIP7IRtscKMqs+VedZPG8FgjpzncwfNJBSc52AyB0MeogVaI3GX4yk/IGX1M5jdicB3pGcIZyofK2Vx4hYwNKj8/xrbEpBkrgfydsZJ8ohIOBMhlqRLbiaXKxLHcHldhXKGt9Xiw/IzwM+qEhD7AhEQ05As45fmLXNOmE2PHJhA7C+BZShgMGNT5W7IhbKPGqUey9rxoz2ANNHtbJv0yhy6ywHGGYvQLfD58/Qkutj4ukw3iXGf54FnGJOiVZXOTQ8ayYk09T0pvEOwqZvIl3Z69XgdtCoiWXH0QIgSUjdEQPSIXVwyTVjBCKxR3BNMFLZWjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T73cWL8Z+YeeaVLixJQl+T6Udzr9v+Qkp1cEVexoaZc=;
 b=HqrlGyj7ABe2zvGcKSyaNuzhqZNXVp+EnZAp63zo446bPZ/NezGbMJZP3kQ/LmGHerbAGjv9PB9zRkmDTYe6tPnZ938ZnsxxvhMl40xAwUR0ekSHz9oOh8nVBM3v2m+tbCQ/2kU2rd+vF8PnWfa/57XLbnnmraafzgWI+//Ixog=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3348.namprd12.prod.outlook.com (20.178.211.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Tue, 10 Sep 2019 08:35:05 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.005; Tue, 10 Sep 2019
 08:35:05 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/2] net: stmmac: Support enhanced addressing
 mode for DWMAC 4.10
Thread-Topic: [PATCH net-next v2 2/2] net: stmmac: Support enhanced addressing
 mode for DWMAC 4.10
Thread-Index: AQHVZyLugLltb0ZW10+a6Fka6Re0xKcjgeswgAA1IoCAAN9LkA==
Date:   Tue, 10 Sep 2019 08:35:05 +0000
Message-ID: <BN8PR12MB3266F021DFC2C61CDEC83418D3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190909152546.383-1-thierry.reding@gmail.com>
 <20190909152546.383-2-thierry.reding@gmail.com>
 <BN8PR12MB3266AAC6FF4819EC25CB087BD3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190909191329.GB23804@mithrandir>
In-Reply-To: <20190909191329.GB23804@mithrandir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [148.69.85.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9eaf66fb-06eb-4263-8637-08d735c9c7d0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3348;
x-ms-traffictypediagnostic: BN8PR12MB3348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3348611673576042FF64FAFED3B60@BN8PR12MB3348.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(81156014)(81166006)(6246003)(7736002)(305945005)(256004)(99286004)(9686003)(476003)(229853002)(6436002)(74316002)(316002)(2906002)(478600001)(55016002)(11346002)(446003)(6506007)(6636002)(7696005)(14454004)(71190400001)(25786009)(71200400001)(6116002)(3846002)(26005)(8676002)(33656002)(86362001)(5660300002)(4326008)(4744005)(66066001)(66946007)(66476007)(66556008)(52536014)(53936002)(76176011)(486006)(186003)(64756008)(66446008)(14444005)(8936002)(110136005)(54906003)(76116006)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3348;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iFI1DLX5fcO3Kigg8OHHGOO/9mr5ygF4FWYfhncR1DuDwVrVNKHdmH0BDf6Q3afyMPCXqVW8ivcMROUQYmkvRsw1E26/sKp+Nr1prGRQ11C4wSYsq0+ZnWG4Uuw/Fv8bChmJur4XMy7ATfhL81fTLKJDi8Zz4P6fjJLvq/WIqnjaKBFuOtwIFZcgK2T2RNot+yqJ+Q2LmhDYTStvkzFnqLGBr4itr/BlcJ5Xg2S1GkXLaFLBVKbicZ8M8drzGuWnXhWFDysNFJ8/1SqO8ieEdqjqDBTB5pu8x4y2TqtELbyb1yK6FZFcPieYPStUkxSryJo7Cm+PAxgSmNrKzIbTZpsnD6VkHUxYDzuJk/p1hbTB5jhFZTW7TEgZ/a70xeD4bUlgyqnhS1Mtc5YHCNUsgaVNakHsRjAmSKCK3bmclVA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eaf66fb-06eb-4263-8637-08d735c9c7d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 08:35:05.1855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pji2Y+Np6QP+EV7ZK0YWWDJQddz7JugGYdxZzQNG7lnDSu2ZQuKap4KgVBcAs86Z2Asf+qjO8HlsrNO71+Ll0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3348
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Sep/09/2019, 20:13:29 (UTC+00:00)

> On Mon, Sep 09, 2019 at 04:05:52PM +0000, Jose Abreu wrote:
> > From: Thierry Reding <thierry.reding@gmail.com>
> > Date: Sep/09/2019, 16:25:46 (UTC+00:00)
> >=20
> > > @@ -79,6 +79,10 @@ static void dwmac4_dma_init_rx_chan(void __iomem *=
ioaddr,
> > >  	value =3D value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
> > >  	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
> > > =20
> > > +	if (dma_cfg->eame)
> >=20
> > There is no need for this check. If EAME is not enabled then upper 32=20
> > bits will be zero.
>=20
> The idea here was to potentially guard against this register not being
> available on some revisions. Having the check here would avoid access to
> the register if the device doesn't support enhanced addressing.

I see your point but I don't think there will be any problems unless you=20
have some strange system that doesn't handle the write accesses to=20
unimplemented features properly ...

---
Thanks,
Jose Miguel Abreu
