Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752D4B4BA9
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 12:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfIQKNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 06:13:00 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:37174 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726250AbfIQKNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 06:13:00 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 55028C1E10;
        Tue, 17 Sep 2019 10:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568715180; bh=55hIxEwLvgs5kLSQrU/U2eQwuEULqggG0gGoikcEBKs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=fXJJsD1tUVSXbBGUShcWX6UlSB8nFUhNpl1+9LiFA+JT5Dv6vEYr4e8pZmCoNGIoE
         JbA8s4KaK1extzrMqAnmsDcLR7c4vxletcRc3Eb1m7Llmbx+W2VIK9nLDMUf2aAQe9
         qT7QXNF24S3zf7eYwckon+FduvKbHNqgECJIXhEh/yshBRU0eAokikguba3yar6apF
         9JSixAp72vF4QLho58auqzRWIdrn/DM9Xua8jWFRwZtMMIpvO5ydxWUPGfvGc9Oux9
         /rfYCLGhKD7VP50wEZRCKgDzjX464wV884rQSYwlc32l02BJoXZ2akml5veg7Y+UOd
         H3EWihHerEVrw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 9304AA0083;
        Tue, 17 Sep 2019 10:12:57 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 17 Sep 2019 03:12:57 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 17 Sep 2019 03:12:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vi0VVVLOQ+R83YkAgwIJKkPeWX+I4zPlK17ebRc2psQ39g0BzeRD+fERRCuDKGQ7kPUpekh2r9HJKcf7lpcfVCOSAIKosqASrAHwNbv7a3KLNB+aVgwaF3BowoxnegQjEQsUodqTRs4n95+2fns7RHghFGU5UWFufeIjKJMZwIgDSeXBbgYEP+fUxBv+OwzvaQPUzB8fsVnBS5ar8LEDoWmjay4etMlsOHP/T4W/ZMbdGRHwrUbaKJUu202piqZIS181ry+p3r0e1/Bx6XLtorfp1MgkBd2rxqk8/cZ324+DjFfSxUxbI/fYbDr6gKbvbOzXL3jzX9atpT8oX3UOXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55hIxEwLvgs5kLSQrU/U2eQwuEULqggG0gGoikcEBKs=;
 b=GLY+ypWKmzgH3mKrb2W5cX+xFH6qZa7my3gTuqwt/kAZ2FMwWaB5XNPJIvZd2z971l1kP5Fb7QEQaZ8IvSVs7C31C0oVxgkkWhN30yyis7GKi83yZinMObjHEFs6bcRdpYj2+o5gl+iQ6cbdvYH6NWylzQ3Hab/dQBLUFEDNBvuj81fhAnvIT9THVTi9yoBKOwjQcTXb/OU418GHAsYWBoEBEla1D8wPy9xJsbQ+/FxT7jmwifyW5zpznYKlWMQK2+BpIgKn16AQz7RJziZ4LAf2+NZdU1uWurullDTmOebZU2ZO4JTrk2ghfPr+/rGHRX6lFngJQOtQ0vI7v1Bdaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55hIxEwLvgs5kLSQrU/U2eQwuEULqggG0gGoikcEBKs=;
 b=fUenzcXwPHJmURL3QMeulHQ1EI1z6HJl6roZfFU2cZODtgq3wTHB9+luRlGC/aEvcgsui+evlFXf80yJXPuouHVzvkeG/QHOsIs9ep/q79lDUUEgWszJZiFhjjPKhDWE+10TqWv1DTSnZgGtPcynpppDnpghHCiA1VPUSvtZ+b0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3265.namprd12.prod.outlook.com (20.179.66.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.24; Tue, 17 Sep 2019 10:12:55 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.023; Tue, 17 Sep 2019
 10:12:55 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Loys Ollivier <lollivier@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: Fix ASSERT_RTNL() warning on suspend/resume
Thread-Topic: [PATCH] net: stmmac: Fix ASSERT_RTNL() warning on suspend/resume
Thread-Index: AQHVbT8k5mxtCRmP9kOirH5PqJ0Ndacvpi6w
Date:   Tue, 17 Sep 2019 10:12:55 +0000
Message-ID: <BN8PR12MB3266A4C33D234165A0F2A978D38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <1568714556-25024-1-git-send-email-lollivier@baylibre.com>
In-Reply-To: <1568714556-25024-1-git-send-email-lollivier@baylibre.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99540496-cd53-4879-0fb8-08d73b579bdb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB3265;
x-ms-traffictypediagnostic: BN8PR12MB3265:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN8PR12MB3265C35AD2A6E6DE893E1393D38F0@BN8PR12MB3265.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(189003)(2906002)(6506007)(229853002)(26005)(186003)(8676002)(76176011)(76116006)(4326008)(446003)(476003)(6306002)(9686003)(11346002)(966005)(55016002)(81166006)(66066001)(102836004)(25786009)(6436002)(498600001)(486006)(110136005)(5660300002)(256004)(3846002)(6116002)(6246003)(86362001)(7736002)(81156014)(305945005)(14444005)(33656002)(71190400001)(4744005)(71200400001)(52536014)(99286004)(66946007)(64756008)(66446008)(66476007)(66556008)(8936002)(14454004)(54906003)(7416002)(7696005)(74316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3265;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wv8eaTGV9maZAmjnxs1kK+yVfD3r9rtl0tJcH4beavReyZ2R+o5A6vlTYuhHXeK/O1VwxbrCaVKvgQKbJWJyZ1HhnYhIz3/7w1I/RQ17z3Aj+mi+zx5SOLFKvjtZS5neO9LJnvCB0W+fJfa4VOaWZtwR+vnDtFRgrr0GXdDr8hTKPe5Gvc6vnhPkYtepljOp6xO/tCxf1gNeotcL+u18XATCWtgnhpNwdTiowWy1swq/mt3ZE0fZI1nCNukRKkdFeqwQhlquG2B1XJF4LTkwpFzCA7+f9xyggmPSr71mLMfL6/m++R1AvQ/XULCgdpWu2Z7mnIX37SdOZlq1jJgqI7y/NP4jbU2M9yeB3SQ4cTOh0WhO4Q+2Hydjgpv2dD/UsLpHasjCYNtThI4NfAaYlmWNXTkhpOSipv6dEx/FtNY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 99540496-cd53-4879-0fb8-08d73b579bdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 10:12:55.8113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8T5i1n6OKKjp56dwg+hs19XpTv0OHRSjuLb6KvVMgH06+c4GaRO2TSHEwehegru3AQRGfVSSd/qlYJtQpA3uuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3265
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Loys Ollivier <lollivier@baylibre.com>
Date: Sep/17/2019, 11:02:36 (UTC+00:00)

> rtnl_lock needs to be taken before calling phylink_start/stop to lock the
> network stack.
> Fix ASSERT_RTNL() warnings by protecting such calls with lock/unlock.
>=20
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib l=
ogic")
> Signed-off-by: Loys Ollivier <lollivier@baylibre.com>

I already sent a fix for this. Please see in -net:

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/driv
ers/net/ethernet/stmicro/stmmac?id=3D19e13cb27b998ff49f07e399b5871bfe5ba7e3
f0

---
Thanks,
Jose Miguel Abreu
