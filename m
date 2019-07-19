Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDF86E1F5
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 09:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfGSHvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 03:51:32 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:42318 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726036AbfGSHvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 03:51:32 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0D6BFC0AEF;
        Fri, 19 Jul 2019 07:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563522691; bh=HxqED4y9EylyQ+j0jlMmu2gWC2EhaU0l0QwmnH8Ds/Q=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=hgrkQZ3aOQRxDVqJOcJUniIVj2nz85hOXkji0OM/Ndo76NvcdnStre6gTJKNsLEn/
         kZsiAEs7zAZoY8Vi2z5Kto2IND/OOsuQWTzvrfLyGTIgrzhPy/YTY22G9qKyQMPNqA
         5l4xfW1DEAQFvpedz4V2JRI0gZOe0yNSmgYsV5yJBvWlKOdctHfB5bFCcGSjzlKKe9
         G0SVMvii8zT8jO4j/IBHpWsh1MkKTmdRZpQvD7pExa4mPMX+JQXBGdlWCgckEHKe+I
         q0oRO64E/8xLU4L+lo5htIaoLtpVOtZDtjEDBX+P5D90z6CMlpsH6t1s6JflzQJJaj
         aLvggx5XHKumg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B4702A023B;
        Fri, 19 Jul 2019 07:51:24 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 19 Jul 2019 00:51:15 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 19 Jul 2019 00:51:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsdAXDobrymd/UTErCKqie0EZ4myVSKXO63qS47iyq3U1HxN7ozoCA8jJV6AOQ/tfR/v4WXZibWkmpm13TYSxb4UhH8NX51BjfgtcZFpoNmHDrysWH0RH5XuS2P7vH6zcyvfE6mumlQVywTMWhRXFrOrCH+j1FCaZpq6sZofKvv/DaPP26MzyQon7WhwbOXI08TuWQ/uu61m3A/Y0bdgId+mt+nR9MolinJQB0OLRDFh8vmeeINI/Wm8MUopvHHbTEX1wOcICuN8JCp6fJoOVflb+L9Ax+fhXsE2Av895dAb3/BqHXa5DCpHOLkvJMKr+gpwdDuPEmQXmiZTUmnXNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxqED4y9EylyQ+j0jlMmu2gWC2EhaU0l0QwmnH8Ds/Q=;
 b=DCNTr7K/49AjOJglqIDXsRK0gr3H/uOrHVRdArQlTItdueXjqwrK2hWNJAS2uAi7aN6pGJvpRQ5Ijqqq3OiVPr4zwI/7wg2vvKYv/yf5KRyWyscepMWBoltm9p9PT8QliD136mEWTcYcRkAVyRu3GtTq1qcqgVqSZ0z5L3lp280ijLRf2iM2y6FVJygfC5AkpD510aBtWovpw3RFLQp9MAr/bTT2Cgtkx1ODej+bZkAAeRPFHYGDjtpYb0hoHy0utk4jQEJINyC0uvkcSrbKekNKL1TZ6++zNTZKcy4RpQWluqGMPbLMme1YCsgZqTenrb4lQZmrJRLf5YyDxVX4ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxqED4y9EylyQ+j0jlMmu2gWC2EhaU0l0QwmnH8Ds/Q=;
 b=fMGqmBAGnhUbQMZOZWalE51VxxScsEup9VQPtnwPXytbhUFilzzeaDFwDmFL0fkjdUm6gO2P8dTURJaDV0SAYR7y+fsd2YRuC1ItESKH4PCDEjq6wEV/iH5UGSOiP1ceFPqGmm+excpfIU4H2uhn5UG85HxhHWvRiZ+DAvwTX3Q=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3426.namprd12.prod.outlook.com (20.178.211.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.11; Fri, 19 Jul 2019 07:51:13 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 07:51:13 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CAABvLAIABeX5g
Date:   Fri, 19 Jul 2019 07:51:12 +0000
Message-ID: <BN8PR12MB3266960A104A7CDBB4E59192D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
In-Reply-To: <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ea94c97-b1a0-44ab-e4c6-08d70c1ddf01
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3426;
x-ms-traffictypediagnostic: BN8PR12MB3426:
x-microsoft-antispam-prvs: <BN8PR12MB34269876D4B8BE437EDF11A5D3CB0@BN8PR12MB3426.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(396003)(136003)(346002)(199004)(189003)(68736007)(305945005)(7696005)(76176011)(316002)(11346002)(66946007)(14444005)(486006)(256004)(446003)(54906003)(110136005)(2906002)(74316002)(66066001)(52536014)(99286004)(5660300002)(4744005)(26005)(33656002)(6506007)(7416002)(6116002)(478600001)(186003)(102836004)(7736002)(81166006)(81156014)(8676002)(25786009)(6436002)(66476007)(4326008)(66556008)(64756008)(66446008)(76116006)(476003)(2501003)(86362001)(53936002)(9686003)(71190400001)(71200400001)(14454004)(3846002)(6246003)(229853002)(8936002)(2201001)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3426;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CVbDGFbkln/9giuEhyX7xLULd2s7WlnW+iyq0ofhYhyDX93vZ2kcM8BfE9zRf0ovt0UxPf2fwct4vKxrpDou/2/Uou4t+N2stznSzVFi8lcDvF5Rc0Yj4pLz/sLkRaA3Jy3BNmVCzwfXQOaVNpZHcYhvhjKsFIFPVLTe+NCb6VHYPEvRPcBrhsjcKiowKPVqyj/P1uZTBBDDRstkPbFLgk8kvyKZfs69/0wR9HMiOvDmcZ+5YuCFodUcBxHR4Oj5dqUaB5lkOUXWwxuBdLjVFZmQT1LZ1IBVKmipJBxPgAKgkZNcXw4iDDcPkhOMJlE8YYieABdxxJLa0JcyGj7kAt4IiJ2Q6l5NFft/IIQBeR3evNMLH2v/aooUZCQM6Fz7lBD7PbqpUDfqDQI0g6oC9gBELGBkLks6phK+SeF4Hik=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea94c97-b1a0-44ab-e4c6-08d70c1ddf01
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 07:51:13.0722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3426
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMTgvMjAx
OSwgMTA6MTY6MjAgKFVUQyswMDowMCkNCg0KPiBIYXZlIHlvdSB0cmllZCB1c2luZyBORlMgb24g
YSBib2FyZCB3aXRoIHRoaXMgZXRoZXJuZXQgY29udHJvbGxlcj8NCg0KSSdtIGhhdmluZyBzb21l
IGlzc3VlcyBzZXR0aW5nIHVwIHRoZSBORlMgc2VydmVyIGluIG9yZGVyIHRvIHJlcGxpY2F0ZSAN
CnNvIHRoaXMgbWF5IHRha2Ugc29tZSB0aW1lLg0KDQpBcmUgeW91IGFibGUgdG8gYWRkIHNvbWUg
ZGVidWcgaW4gc3RtbWFjX2luaXRfcnhfYnVmZmVycygpIHRvIHNlZSB3aGF0J3MgDQp0aGUgYnVm
ZmVyIGFkZHJlc3MgPw0KDQotLS0NClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
