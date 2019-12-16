Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225631200E9
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfLPJWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:22:18 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:38944 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbfLPJWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:22:18 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7D09342653;
        Mon, 16 Dec 2019 09:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576488137; bh=gG+CYp28qMk6o4TQTw9TopwVmXqYH6tUX5ApCzBHkkk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=lz/LhcD0qsDCAJPjSRkKJaOjXhxv/KlTSdcrmyqcRh5Cxck+opBCJxuvVT/Bu5j3d
         4rj2waP5k6fOX13LdX6TczWQVskmRmfdKVao/45jNpQVJnZUbS4sDGcA7KTMxMXkMM
         sqhKFFFB8Yp51x10ezRC6vydiIyeFBeOYQ/HT3m78B6fO/60z0lQUQSWu11nlageN2
         Jt1sVd2V3FnIlD9o69jY3BFgFF+BPgbVdEZf1+IyBWgpvA+kxVpIKSqfNLcrgCNok4
         w8j6cdJM5iEHKzT/2NIA756VT88/Sd9eS53wiWXE47/sgWEI3x3EaTaoepyrwjEU3M
         si/K9CQILntdg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 9E277A008E;
        Mon, 16 Dec 2019 09:22:15 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 16 Dec 2019 01:22:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 16 Dec 2019 01:22:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXqkMqRxO2rg927+Ck5sJvUJ/GBBoZ9YOr1/3OVRMEcRSN+TbS4+BRrFT7EY0sFZzcvUqQPwtfDhOX6dMrAnlczvBwPu6xUHZdeXc5WIp20g0Rg43E0Fv5TH9pDAF5OPZLF/xT+NSyp2+2e41gTaWkGHPczK2cwseJ4X+8aBsys/hgSUhwnN1BL+RPCBtGg56/pUWGvy+3IV7fBZPqjlMihGoV8VnyCfPOmO1RFeRn46desfbxS2mseBCSk/NiiILz0Fp8/upE6RfmBgigonCP5vsp9cJA2KOCq9mncn+0inOY6/dhwnSHgFeZUQ1+hjGkkfP5wq6QewDdJTDo/wvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJe9hhMUaLNeJo0A6xYkMOCFjzSfU67uyw/xJgyqjRk=;
 b=dyd1rFUu7RYLut4GKU04LPiQrFpu9KvvOjNiRhqGEA7cDuuJF+z8L1j1gUyPNAWwKcDLYIxEAx2pfYkDnaO2PYHmePQ/UPWdybVxdE4ywRFuSrpYe0unXNLHKN2WESmWOWhuDXyFPmkdqWXRsr8zLIoqBgdKXgP2dbha27D8t2KWrUVA//OFuKzzjkkm7fxcp5ZYo8rZn+tHUnOnE56GhCKfXrPF7ACq6A76lB+TlXcQncKeqsDoJi4TAM9bTofhslARlEV9ut9rf+pozu6D+FNrsfI37KyBZ0vh0YvCPvy8yHVuCXot8aOEeBm1gxLIWkE6ms3H83vsP7I4UggxZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJe9hhMUaLNeJo0A6xYkMOCFjzSfU67uyw/xJgyqjRk=;
 b=U/znyOfGQ8G7Ce1PwRZDkxBSXH11+QsomaeuUSihQeSPKAMm4T+ti7HKUVx5OLsEk8DCcS/5U1RxAoCYtuIqmRHL4GwMhFvV00pzNlUuDASeGr58Z8+o/LdjEYkOzLko2FkbNYea0qU9iXscMYUckkqZlcXTZBUINmtH/dn07gI=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3284.namprd12.prod.outlook.com (20.179.64.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 09:22:13 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 09:22:13 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Xu Wang <vulab@iscas.ac.cn>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] stmmac: platform: Remove unnecessary conditions
Thread-Topic: [PATCH] stmmac: platform: Remove unnecessary conditions
Thread-Index: AQHVsA5CUTI48SjyD0mYPORwzDNYyqe6FQuAgAJvIdA=
Date:   Mon, 16 Dec 2019 09:22:13 +0000
Message-ID: <BN8PR12MB32666747FFF4AFD047F19EA5D3510@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <1576060284-12371-1-git-send-email-vulab@iscas.ac.cn>
 <20191214121049.266b656f@cakuba.netronome.com>
In-Reply-To: <20191214121049.266b656f@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73394f70-1f02-4ed1-73e5-08d782096f8f
x-ms-traffictypediagnostic: BN8PR12MB3284:
x-microsoft-antispam-prvs: <BN8PR12MB3284538866648F662B1C9C87D3510@BN8PR12MB3284.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(136003)(366004)(189003)(51914003)(199004)(186003)(76116006)(66556008)(54906003)(110136005)(66946007)(6506007)(55016002)(71200400001)(26005)(316002)(64756008)(66446008)(7416002)(7696005)(81156014)(81166006)(4326008)(2906002)(478600001)(8936002)(5660300002)(52536014)(9686003)(8676002)(66476007)(33656002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3284;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qqyO/Jmz5JiHzb9bAt0XC35FQgt0JxfrUOAyG9i5oFniGKG5IKY1ekfsVnKCyMnl6dO8yK1Tvy9bXKErBfquBjdeDYUUyB6jOuwZ4YPvSgxJE9kPjKoDS5hFCaE781jWG0RkBTqkoV7RGj9vX10/8ZDsjgiLkaYELYcfpd9oi0lfkq7H98aW0ru3VJSEMSlDdqYC19EQOHLKmZeA2cF/yUIc/qViuHtVlgUw26KoPgQKLvpsbm2MDe/yrliVSny2gE0XUvRdWbFJNi2VekPXZLhpBS7QrcsPc9C0xiFTjIeZU4MXvS4dleszMTYE2R7zpHoYtXIYGDZmg3baLmKikTwiqJtDBaiyEfFu6q4LuKh9Fsx/YAn4uidSxhKR1yO1KQkyfsJVGKMAfRlQkBxMibE+WDVLA6275q5v6K21S+TUX0xT7qhHF+XA/Ub8iVRV42DQMn9YyMnTyavxNdSmtTjscPHh4g8wS2RES136dowunb2nAV5aVJCfbpfpLNoj
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 73394f70-1f02-4ed1-73e5-08d782096f8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 09:22:13.2374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QwHwuDxEej63IeYjsYsJ9S1rWSnKnCynJZaDJUloMfIuG1adrevnOHbON1wEM0xewTIYEjyQtAPalAx1bGHr0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3284
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Dec/14/2019, 20:10:49 (UTC+00:00)

> On Wed, 11 Dec 2019 10:31:24 +0000, Xu Wang wrote:
> > Remove conditions where if and else branch are identical.
> > This issue is detected by coccinelle.
> >=20
> > Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 --
> >  1 file changed, 2 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/dr=
ivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > index bedaff0..1d26691 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > @@ -229,8 +229,6 @@ static int stmmac_mtl_setup(struct platform_device =
*pdev,
> >  		plat->tx_sched_algorithm =3D MTL_TX_ALGORITHM_WFQ;
> >  	else if (of_property_read_bool(tx_node, "snps,tx-sched-dwrr"))
> >  		plat->tx_sched_algorithm =3D MTL_TX_ALGORITHM_DWRR;
> > -	else if (of_property_read_bool(tx_node, "snps,tx-sched-sp"))
> > -		plat->tx_sched_algorithm =3D MTL_TX_ALGORITHM_SP;
> >  	else
> >  		plat->tx_sched_algorithm =3D MTL_TX_ALGORITHM_SP;
> > =20
>=20
> Thanks for the patch but in this case it looks like this code is
> intentionally written this way to enumerate all options. Maintainers -
> please speak up if you prefer to have the patch applied, otherwise=20
> I'm dropping it.

I rather prefer having all options clearly enumerated so I agree with=20
Jakub on this.

---
Thanks,
Jose Miguel Abreu
