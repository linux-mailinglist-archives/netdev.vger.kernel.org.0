Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B010BB7482
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 09:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387955AbfISH6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 03:58:55 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:40422 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727033AbfISH6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 03:58:55 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 23CFEC016D;
        Thu, 19 Sep 2019 07:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568879934; bh=7ZGib0D6tQJI8IyzmFat7Pl5E7J1svJZvRVe4/3leF0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=c4bkFuuVe4rfNIiU3CM7u6shL9nbIdCHB/PGghjwoRwQ9zuZ/xoB4cLwFlHHAGlaY
         JFbePRkgSzHF541Jv2mVn/OZsEpJBNsIqSfeyNkEm1EIGGqYPPjG7ioRaLqhkGnFP9
         7f/cLtjvNQChufNtqYiNk/Dk3gCKzxa3SuFTwv56VdkabATBtrAM/njrJMTKr0BxZj
         /D0B04Qzv1DUR7wBcp01iByfNsrYIWWPhnYxInXCtE3+1SKy+A+v6HjwtAh10Bjo2p
         n3m9UgGC2s0KnNwcn8VDv7B9nG1N3MtxCdRljvjxkwlU977DUsbGKrzdkxI7xWJfbq
         Bdy6gthc7OkSw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id BFB16A0079;
        Thu, 19 Sep 2019 07:58:52 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 19 Sep 2019 00:58:51 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 19 Sep 2019 00:58:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOyiOi4bUWLUR4Kcb7pJXHkb2FumuJoIfNaCtOFSA1OSXU0c+4b06Tlfm5PS12Mgc399CbdOaO0CN2PbxBTJhF+gOOiARv14bcowaXoXuXi68FCkbho2dq80iueJw1qtQLpXZfP+iyfUlhbyGHYh9Wq868N2pGtvju4GNH0j6uNGDb0Zn0mDxzplahVWoc5h7m/Df4NCY+OckskBiY3zKl/cH+AwuSraq2q6S4x8ayihpnHrJLOWdgA3ckOXWPPAn0TtdUVGRO5/iz45Oy4+aXcYLNKOg0xQzfg9AXtZpM75PHJfCDDDW/l8ghrtsqMknyG/e0FCkjeQZYOc8GVDOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAiZj6E/4uUxoV0CfK9XKfh4VlJGHU1UExUKSlc6wXk=;
 b=M+1Mo6N9yu0O4xHtAoq+uU7VaEpBhHQtQKTeTD0CJ55Q5zyOM+lufpVs162oFdNcSCxLmRPMRW5wVQ7WT5HH1tfgjVFfVl6VxnvYgJLL+/IEqJ9CiKlctYTWZW0oSzOd9wG/b9jVJeAagg3SE9Xh9L+otsjprhRo/L/SOCOp7AzfrV3a+0PVr9o7bJoe64q7ascwSakLqWf6nqzc//snkdJeII4/B3H4OKOlgH7fkv6jB2SE9FGUdZHWOLLmxDMJFq1y3yDGVWWydlA4Yu8/Xv2+v+Jar5IlbBF2v7TgVoX3kbedXGcTcgzflq/wPSihNlRgMuTYi+cz7v4SlwoDog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAiZj6E/4uUxoV0CfK9XKfh4VlJGHU1UExUKSlc6wXk=;
 b=Yjib9lZjkwy1oxYPzaxGqxEF//jJ2TxnBfGgiHmk7pEsNQJP+m/F+3lHvuzq51jPpC2mHqvcpDPjaMiVLUo7gjMa62OPViE5Xma62AxHaYraRQ4Fs0c2zMJWibD7aNBRZmgeybHNs3KD8eTchTKsuUwGyE29AK48G2Dc0ftFaQc=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2947.namprd12.prod.outlook.com (20.179.67.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Thu, 19 Sep 2019 07:58:50 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.023; Thu, 19 Sep 2019
 07:58:50 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] stmmac: selftest: avoid large stack usage
Thread-Topic: [PATCH] stmmac: selftest: avoid large stack usage
Thread-Index: AQHVblsKA5f8SYRfDU6spEieG1UuDacyof5w
Date:   Thu, 19 Sep 2019 07:58:50 +0000
Message-ID: <BN8PR12MB3266E044DDF00F227B9B191CD3890@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190918195454.2056139-1-arnd@arndb.de>
In-Reply-To: <20190918195454.2056139-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 963955c0-40e0-4e63-e081-08d73cd73548
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB2947;
x-ms-traffictypediagnostic: BN8PR12MB2947:
x-microsoft-antispam-prvs: <BN8PR12MB29475914B34EF6102BD8070AD3890@BN8PR12MB2947.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(396003)(376002)(346002)(136003)(189003)(199004)(11346002)(446003)(486006)(476003)(4326008)(71200400001)(66476007)(64756008)(66556008)(6246003)(316002)(71190400001)(110136005)(54906003)(66446008)(5660300002)(81166006)(81156014)(8676002)(4744005)(256004)(6436002)(55016002)(9686003)(52536014)(86362001)(229853002)(8936002)(478600001)(66066001)(99286004)(33656002)(305945005)(7736002)(3846002)(6116002)(74316002)(14454004)(2906002)(76116006)(102836004)(6506007)(66946007)(186003)(26005)(7696005)(25786009)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2947;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L1tzPgt02GhDOi7hwMEfUsdgXJqOHy4r5KxqkvdPijflMgYIBFaDvu/FqTxU5wtwRvU9JQb0Fn0foyvh7KphH5Zu215dPVGPwOViG+wjY+ebTbYO2Ls4zRo12PgAyTbtHWXLI3nYvtN5Thhjr/FL6+kC/7Jym1kkTIWyIkeG65y4k5xbFB27SWLgXkOHEYyhL6xYTRdzfddDiui33qalWoLT5O3VEjv7srAuJ2Ct9YoxKS6QiLAOeIm9D+tzNYLiXJ1WBPfqNaEfab+xoSNDpkZw0AUQD3fhQZG3FTWnsH00g+blm9yMuu9AJNBZXZbmI2MdRp0FziD48UpXqFZXf/m6Mb+aF71im8s8Ldtm3VYRdCFs1Q7wpCQ9Xpi+nTi3AODdWwubSMeUXf0oRC2fkleW1b3LDzBPuLEaxJ4eSRU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 963955c0-40e0-4e63-e081-08d73cd73548
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 07:58:50.4808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XsYVCUGVKfufyGrw50SAxyg5TXB72mrdURze05f8e74+4/SLe/YawNP9qyZed8ZndSR8ZE16iVh+AJnTaXH4OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2947
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Sep/18/2019, 20:54:34 (UTC+00:00)

> +	if (!cfg || !cfg->enable) {
>  		value &=3D ~XGMAC_RSSE;
>  		writel(value, ioaddr + XGMAC_RSS_CTRL);
>  		return 0;
>  	}
> =20
>  	for (i =3D 0; i < (sizeof(cfg->key) / sizeof(u32)); i++) {
> -		ret =3D dwxgmac2_rss_write_reg(ioaddr, true, i, *key++);
> +		if (cfg)
> +			ret =3D dwxgmac2_rss_write_reg(ioaddr, true, i, cfg->key[i]);
> +		else
> +			ret =3D dwxgmac2_rss_write_reg(ioaddr, true, i, 0);
> +
>  		if (ret)
>  			return ret;
>  	}
> =20
>  	for (i =3D 0; i < ARRAY_SIZE(cfg->table); i++) {
> -		ret =3D dwxgmac2_rss_write_reg(ioaddr, false, i, cfg->table[i]);
> +		if (cfg)
> +			ret =3D dwxgmac2_rss_write_reg(ioaddr, false, i, cfg->table[i]);
> +		else
> +			ret =3D dwxgmac2_rss_write_reg(ioaddr, false, i, 0);
> +

I don't get these "if (cfg)" checks. You already check earlier if cfg is=20
NULL and return if so. I don't think you need these extra checks.

Also, your subject line should be something like: "net: stmmac:=20
selftests: ..."

---
Thanks,
Jose Miguel Abreu
