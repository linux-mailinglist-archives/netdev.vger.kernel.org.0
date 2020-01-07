Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05B91329C8
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgAGPQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:16:55 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:55958 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727880AbgAGPQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:16:55 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4845EC0523;
        Tue,  7 Jan 2020 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578410213; bh=mdQ/yBeK9bUWRKbYsJ2tly65JN1U7xaPFxPx7scy4gk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=jk6ux+S/Sq0/iHKfKHfwE4XRAEzemIbMYAr019UzNNat0BH/KpxVMXjuNtp/A63b4
         UeJRfQMBkRHUl3sW/KAt8SlirwOj9ifLGLaBPDSWQ0NV7L76CyD5Y63+SC/WUT+2/8
         i+SwhdP6UUeHCSIUbhJ4m51+uFrgGfgRYYDajoPBseWQX1ahM7fZWY5zT6BBJwEHFp
         kAng5cv6lal4+eyMBOZq9CdXDZss1OtCCtk8Hz93KI/yT65A0tAzLGIQcLe9sI9cfb
         M6jnUlJ1icDm8vjaZxGqakwivQtex6zXm3BiAxJ4o6wuqfZ4jnSy//oI9DSc/1OLUp
         9Lpq0oC0Iremw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 03608A0091;
        Tue,  7 Jan 2020 15:16:52 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 7 Jan 2020 07:16:13 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 7 Jan 2020 07:16:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl5WNSud2MLmBBr39AlsiPDfMiDLtjpp8uuLRvrcfDKf52QMSVL3nZDiRj+9D+lmZuvInx1pb3JCynB/zrnjmqm3RmeE1WKVfoiSCOzI2Jez1jz4jzfpeUeh1EDNvM6rjAB9UoI06m4Z6d5RxI//UGrDUJBDVho6CJc4/u6YOSHADyPvm7KZ3uMrvCz3QCsJrCU5U78FCqr5yc1xn48jcjnXzZqbz/4MgycRq0mxtg4sy3JiE/EBXpHE98JhpCMfYfpnRNLggT6N3CfOS2YjaH2USIsOk9IXORPDKLra9qpmgdeAqNj8kna+KgYv1xsFZS6SNJQMEz1O6nH3gphX+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdQ/yBeK9bUWRKbYsJ2tly65JN1U7xaPFxPx7scy4gk=;
 b=mpoNRhKz1ehulWMCz/n1FzCcapXSp3JYRMMHo7aPWFeeHOTeN2I/hfkGkLY7L22qPwtQYdNNPR2fFP2+87KwvZ6KoptZqIqg7C/Ze/7lpnsgfx5Ea5qednUjf/RUhTip0cbIBZrsbt81oMtZn6wqFmvjHuFpTxUherW9EnhbVu7MiK+BjmMpTwGRXb4cIVchZrIK+GmToSgKK6YK5yboyzu4P+YAbn+YJz1eu7Lwy4/oIOjYy17dwk3CGsgKISfmPD4GBxsgZGHLLcIsEWg/uaBpb85VFUZb4844Ll1oKoimVm+B2OscdOU/PKlaGTzuU9eQazu5NJYhfOmIpfGZ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdQ/yBeK9bUWRKbYsJ2tly65JN1U7xaPFxPx7scy4gk=;
 b=QaLJSIBwke3e03PiPLYByseT243ltS1FR4C2QU6PhMJ6PlpzpLpnvbmYXGkhnhLKJD94mMe14aCcuHbWAY+BQNwSv15HkGudC1eB2pUSd1VNu8ZBnIW+++q+YBl7VNGp681j6ByoQcbUCP/zXorAZfYKDHmUvOfU/5BQdgBBYZo=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3075.namprd12.prod.outlook.com (20.178.209.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Tue, 7 Jan 2020 15:16:11 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 15:16:11 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Dejin Zheng <zhengdejin5@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Documentation: networking: device drivers: sync
 stmmac_mdio_bus_data info
Thread-Topic: [PATCH] Documentation: networking: device drivers: sync
 stmmac_mdio_bus_data info
Thread-Index: AQHVxWu8HCBvQawx2keDnKRUvVjBJaffT7zg
Date:   Tue, 7 Jan 2020 15:16:10 +0000
Message-ID: <BN8PR12MB3266661B136050259B5F7FD7D33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200107150254.28604-1-zhengdejin5@gmail.com>
In-Reply-To: <20200107150254.28604-1-zhengdejin5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68a8d26a-9626-4dda-5d7a-08d79384873f
x-ms-traffictypediagnostic: BN8PR12MB3075:
x-microsoft-antispam-prvs: <BN8PR12MB30755121E653487CD4C5BC39D33F0@BN8PR12MB3075.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(396003)(136003)(346002)(199004)(189003)(7416002)(966005)(52536014)(86362001)(5660300002)(9686003)(4744005)(2906002)(316002)(55016002)(81156014)(81166006)(8676002)(8936002)(54906003)(110136005)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(71200400001)(4326008)(186003)(478600001)(7696005)(33656002)(6506007)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3075;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S3BfeeOPIQDMT5SalaXjSKfbECWOHd/t1vmrgpyaejSB1yGB0LA1U4guuTnAG1kA839fw7pLs/xOhogpRUv8+egjzlbormSiu82utnYBlvvC9wMD4uG5GlbQZpJgqdF3RomBTexAyfoZvxSCyOueP7GKeTSmWIFACH8rni7qzhdk0zWlC4HBT8IVGucmt8hbyP30z18D5plYXgEnzXVBrexdTS92sKFk9m5fo9dkAyCpef705uIRyqWumzI8g6HDciy+uBDmYXZOm96OqcDmSQ8UsFMPkzT2yOqqVvJ4rhoo/UWg/g0orOQyhvmueW3MlM2gwp83pPb6tWoiOZLcllZ5gVISVqr6NyR44fR8844RL/Otu3ne/Nna40rOHX5k7XQf1LZWOYbDW6eT8ei+NPKZZgAaeWVQVUfP4wGYSQh+jEDN2agvWAlmmO9Aii/oOxsBOTN31kO+eNPLhH1DUf1n0U7cwtASelUbtnKskBmMglIbRK6wK28jfNmxipB8njeh/GFZBjNEWUZUEvDwfA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a8d26a-9626-4dda-5d7a-08d79384873f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 15:16:10.6849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8omyEPkpn1d1VuuunIl5x/7FajoFFp0QmIMzGPXzTv/UhUmpthgdJB+mrE3VeIbBM5QmhOoAUfwpSH+RvlXDEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3075
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Jan/07/2020, 15:02:54 (UTC+00:00)

> Recent changes in the stmmac driver, it removes the phy_reset hook
> from struct stmmac_mdio_bus_data by commit <fead5b1b5838ba2>, and
> add the member of needs_reset to struct stmmac_mdio_bus_data by
> commit <1a981c0586c0387>.

This will file be no longer maitained as we are moving to RST format.=20
Please see [1].

[1] https://patchwork.ozlabs.org/project/netdev/list/?series=3D151601

---
Thanks,
Jose Miguel Abreu
