Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E834418F06B
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 08:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgCWHqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 03:46:47 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:37174 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727422AbgCWHqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 03:46:46 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 63E21401B2;
        Mon, 23 Mar 2020 07:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584949605; bh=zY4v6gkIXM8sd+hrgkVj2SPnVx2+xHLtAfCyBTUStq0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=maqMTIiLx1PgoZFd/Nrur9O7qjAsbUPShIMqksq7Q2A8o6fmvRejy40t1PD6ZeCpA
         MJ0+1xuyBnAU9Z2pwCT7fA2XBI3aRfr2AFnTO8aIWuSfWhX4FxYiqHQ9VrZXo9Rziq
         l/J/njaA/5sJhl5m1nEWGA3nb9CFrtV9rcos1pCjwD2bnNXF47PuObaio6RjCsv2Ni
         9Rrvxw9zeV3ouSsMVh7DiIHVTzdFyq4CLdWtTzBYjrp+afeFeKZq5Eg8cvOmBCRmre
         UCV7zfTiiDhUtwg5s5IpDxTnLDLoYlZtbHq9gOJgMc556K6Q60KR37IOvauOenXAkq
         +4JtdsfzcPE/w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 78A4DA006C;
        Mon, 23 Mar 2020 07:46:41 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 23 Mar 2020 00:46:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 23 Mar 2020 00:46:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PD+y+xSeGJt1Lxn8A7QeUeCzs/WNC3/E/uwQCRuqlrosgZjjNLBunz5IYj3mGsFrW8ZFD1qK57fh5LPkl3Vdhi3dDej0JdJv3mT0+5E4cRqnFMC0bb7mzNRWj7j08dd9y0BsBHExQaQFKn8ltgFSdjeQMmowAwmRGKtTSBZU7I923BYkzPz8u/gHi0Y4ly88G97sjkrI3pLx4YAY1O4MNXa6OcizQNmWMzOAKm+Vv0R7TkXI7scgTBiYBfT3LzX4x2NhFy9n4PZntDyi+agroy2iP8Nd2ynTVauVZHDWVV0DnJwOKYwL9vn5nG4lnJml769NTwUBOP6z6K+zJ57KZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znBL8FCMzfUCfOlXPMEUGibGT+B999s+uBKzRxM6f0o=;
 b=YQUewbnEZEO4htpx02jHpzuT7qwVDAi9vZnELgcJe11yug5X6O5DI0mnnjmwZy3i7HDaP4zuQA/JsuC6ktj2XqQbz6jCKoBO6TMttHXJnZBSMVOc3gSoY400lwckRe7a3SEoGG0Ksmf2tr3HTUG5fJdRZnCoiFrCJpQHyZU/x6ya87XFdRZgN4IimgMnDItFDq08HVMa6i11jQLjUyeGRO7KBikdr5i3hp6A4hp8LwT8Ynf4oRLADHxw9RkLm7lalCu50cgwB/4gmOKt8wds8kDMJJn92LEi3Omg0Y/3s1yqumvlkFeN5TkvNYZ8biq1Hhi8vlQoidyl8S1rinc9mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znBL8FCMzfUCfOlXPMEUGibGT+B999s+uBKzRxM6f0o=;
 b=ANPS+DoQcHNxfEMVAdlmCbOt4nKijtCZBpq4eoXuWTTBRy3v9peTXVmhwo+sAjPY3nko8FB3BQlWaBtPF7D/zv7Cxs+inmV6ySAeGbu9LOQOzN2lg3s+Nf1jffvDnDDUv6zjvOIDzzuI8KVqrTmpWiDCs2kwHPquSQx1Q1n+HTA=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3153.namprd12.prod.outlook.com (2603:10b6:408:69::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Mon, 23 Mar
 2020 07:46:40 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 07:46:40 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: RE: [RFC,net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Topic: [RFC,net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Index: AQHWAE03JZEV2gP9CkiKXaQcDq7OzahVzGeA
Date:   Mon, 23 Mar 2020 07:46:39 +0000
Message-ID: <BN8PR12MB3266ACFFA4808A133BB72F9DD3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200322132342.2687-1-weifeng.voon@intel.com>
 <20200322132342.2687-2-weifeng.voon@intel.com>
In-Reply-To: <20200322132342.2687-2-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [82.155.99.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d97721e-3255-4b3e-45de-08d7cefe52aa
x-ms-traffictypediagnostic: BN8PR12MB3153:
x-microsoft-antispam-prvs: <BN8PR12MB315351C657186FA9C8018F86D3F00@BN8PR12MB3153.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(39850400004)(396003)(376002)(199004)(2906002)(5660300002)(9686003)(55016002)(33656002)(81156014)(81166006)(8676002)(8936002)(478600001)(316002)(71200400001)(110136005)(54906003)(6506007)(26005)(186003)(86362001)(4326008)(66556008)(66476007)(66946007)(66446008)(64756008)(7696005)(76116006)(52536014)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3153;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NJXNLhjffBmzHWO+jXzI/wMfimKn3yRH6QNodJbDrvwpDuotZSM42e5TXWJOMpKx1zlRqcrnLlAFHaw7HzhE3Pm01yleB3TjrKz131X616CRpQ9klu/kwtOFHmnKtbQj5j/Akple9iMWjEMlKgJaG0ylxzwj+PIMVhvuW6pOXTLtzJKtlYoDEkfpnm4xzC6IWO6Cuf6SnSR/R0z39GPM5UNQKfbXYLNovurDeBaZA3P2mXcdm8GlmXOKeyAyTZSzHukfcnSHK9F2iqoPy2UMqlTsmK6OWw8eJFraKm0l3mbMGUambSixVPlswU3RUOF7CX2bLg59xoIlokmJdFR13VpSOkI5Sb9Ak2EBIopACwSCvEiHQKbIVfEEaQ3E5UhOoTbVgj91IHs5NGkgjxRgEOTdWC56MDKZzLQvkqWiRsQOYgvB6CaV5kvgd1iy0/KOAFwHUUL2ucsrckTi5839TUjaL3DRx/x5LW0LFmEYiV23IPCT5zwdvXRZ7XJ317n6
x-ms-exchange-antispam-messagedata: KwmNZHGEvCDlaCAM6Szum+SfOrQbLQoNh4pU9k1zrtAZZsYQAMlEb9eF/qrQg4VNHAUXTmWcvq1mfKhsWJ0Z/gtYURA2qSyuPnccM8BuOZrF/WUC/02znPu6g2Q4Cd15QdJEfNQEX5DY2PLE7FlWCw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d97721e-3255-4b3e-45de-08d7cefe52aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 07:46:39.9230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f8k//LO87II/nejQhcWL/7MkZCcPjTJWemyISI/tW7hAKSGPDhDTEbiX8/zeMBKvsTG0kMhPFNMwIkhwryx5Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3153
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Mar/22/2020, 13:23:42 (UTC+00:00)

> This patch is to enable Intel SERDES power up/down sequence. The SERDES
> converts 8/10 bits data to SGMII signal. Below is an example of
> HW configuration for SGMII mode. The SERDES is located in the PHY IF
> in the diagram below.
>=20
> <-----------------GBE Controller---------->|<--External PHY chip-->
> +----------+         +----+            +---+           +----------+
> |   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> | External |
> |   MAC    |         |xPCS|            |IF |           | PHY      |
> +----------+         +----+            +---+           +----------+
>        ^               ^                 ^                ^
>        |               |                 |                |
>        +---------------------MDIO-------------------------+
>=20
> PHY IF configuration and status registers are accessible through
> mdio address 0x15 which is defined as intel_adhoc_addr. During D0,
> The driver will need to power up PHY IF by changing the power state
> to P0. Likewise, for D3, the driver sets PHY IF power state to P3.

I don't think this is the right approach.

You could just add a new "mdio-intel-serdes" to phy/ folder just like I=20
did with XPCS because this is mostly related with PHY settings rather than=
=20
EQoS.

Perhaps Andrew has better insight on this.

BTW, are you using the standard XPCS helpers in phy/ folder ? Is it=20
working fine for you ?

---
Thanks,
Jose Miguel Abreu
