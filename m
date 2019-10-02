Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 656DFC4934
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfJBIJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:09:59 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:38936 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726137AbfJBIJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:09:59 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5452FC2FDF;
        Wed,  2 Oct 2019 08:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570003797; bh=vn0G241cd27H583bR7iMZeAnN8UsIjqOFTSq7kbzAyM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=FuSM9rPLb3h+YBjIh2oHYOUd1ivD6KX9ZjDrjtVslXSH0hW68/cw95y1dkbmxTCJE
         D/ww+Mz9HIPYD0Ppp3nzO8J6OU00jjGm2Qndxf7X80aZyWciZu6DR5s8MZQf7IlUOl
         dvI4d+rB+xOlQWk/vQSpFR4HIU++rbZI7ts8sWO4c6BlFPGSHJ9o/D6UR8mahjfquN
         GD+TTfOIByY0NGJ5QlBWMAd8uMyWe8PxdUYeV3GksDWKKEJ6hyMmc1Hnv2eUfhjE8A
         eXF7vPFdc8oYgsbsVLneGe8urSKuNc9eDdiZ9MWTBsWgrsq4Q4Qmh6mar8knm3hgQg
         XnWnW/QV9ti0A==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D3EA2A0067;
        Wed,  2 Oct 2019 08:09:50 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 2 Oct 2019 01:08:42 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 2 Oct 2019 01:08:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/obS/QMtvtt/yhHasQLCqGuKs17MN1q6ilIk5AY3mlP6nAAvsvZY/0OXHfEekh+olGqHB44GiunFx0efFYGlW4Bzm/ltmAfhW0lLi1G3gTgXYbikC24j8H1+d0GjTiMq4Ns/C3QCk8WiIbE0HyjOTzB+WKk6XV68cLP2YqyrDAGsgdgA6aIRnJ4ec59uUL5m9apZ2Ch4k0JzkIp80E5vsmDEMhuftsCCHwYDFyJBEBpiwJZgE+dQeqLH3jvoL2XMRRpGCIIVQBGV534SM/jFou5TIyu2QaznwTy+DqgPPgRO/4og8RrHHeuGstraOL2sApR9XlOiWMtIfv20uEJiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vn0G241cd27H583bR7iMZeAnN8UsIjqOFTSq7kbzAyM=;
 b=fbdd3/ZsAGSR01oERHuzgoKGzrdCyirbcUvsUv2KB/CDoT2Qbw/3GtEdgvo8RGNzCezQSKbhUh99z4oceVLQF99LgKNR02jn5W7Wmo9FqrQgM4GeG572kROW4nUx1hJQJIkAHInfF09bo7fSZrPsmWDS5Ii0n5e3Q4VheJc+WfMzzoK+Wm/jfYkeL4LuLO5/O2E8BBSWlkB13f8+qCPatIIouv6bxXAJQPBo4UjDJzeGndPGF/ovCDe5MnqvpX5w/vGZg2eJ4+QH4998b/4C8LxE+ey8dPVJK2pnZB5cHmzvTwSUpYC88y5+7tn9GawwLRgSL10Xy00QNSFStO2ZyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vn0G241cd27H583bR7iMZeAnN8UsIjqOFTSq7kbzAyM=;
 b=kHhkPBaA/fVfDpHgaTyYCOhWV9SEtO+tmGv1RAP3BX6xIYh/KoyvluG6LABygYN43EnCXM1e7jKO15kes0ksNCi/54Ss+Zkmr9Q7+16XBjdjGvD7S4R4DWuSuqM7R3saVfNupMP2DciNkOAoZEskoHCF2lGI9KnANNCFYyG6N14=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3507.namprd12.prod.outlook.com (20.179.67.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Wed, 2 Oct 2019 08:08:40 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2305.023; Wed, 2 Oct 2019
 08:08:40 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Hans Andersson <Hans.Andersson@CELLAVISION.SE>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: Read user ID muliple times if needed.
Thread-Topic: [PATCH] net: stmmac: Read user ID muliple times if needed.
Thread-Index: AQHVePAsjhS3U+43VE+DGhKYpgL3F6dG8LMAgAAMxQCAAAG8IA==
Date:   Wed, 2 Oct 2019 08:08:40 +0000
Message-ID: <BN8PR12MB3266CE04997F30E3ED74E9AFD39C0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20191002070721.9916-1-haan@cellavision.se>
 <BN8PR12MB3266ED591171A79825090BE0D39C0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <e878e0e4036a4d69b05dcee717fd7ac5@DRCELLEX03.cellavision.se>
In-Reply-To: <e878e0e4036a4d69b05dcee717fd7ac5@DRCELLEX03.cellavision.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73b84679-e7bd-4d27-5d96-08d7470fbc83
x-ms-traffictypediagnostic: BN8PR12MB3507:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB35073FAC9BA3BF1F17697116D39C0@BN8PR12MB3507.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(346002)(396003)(376002)(136003)(189003)(199004)(66476007)(66556008)(3846002)(6116002)(33656002)(66066001)(316002)(99286004)(256004)(7696005)(76176011)(102836004)(6506007)(4326008)(6246003)(11346002)(486006)(446003)(476003)(2501003)(186003)(86362001)(2906002)(55016002)(6436002)(9686003)(229853002)(305945005)(7736002)(74316002)(25786009)(54906003)(71190400001)(71200400001)(110136005)(26005)(8936002)(4744005)(52536014)(14454004)(478600001)(5660300002)(8676002)(66446008)(81156014)(64756008)(81166006)(66946007)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3507;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T2isTynuu0ElCFk1SZFEhUwYPqAcOVNCe5ZEkC2sW4HiyVC8v+KXyqAOYDmCFy0VeYe4VEKbiocnGN7ywoEkoxsPv7VUEqsYNAO3ix2rOra4CuJDFzYPvAU96b+r9G1ZnsA33gfz26s/Ux8j7p/YCCqzu4gVrzTdPACoKX0ltRrhMt4wogM8GJCqh/v7q+d34LvM6xTcoM4vXZjNIsfBU754loOvR4vKtiTEQMAKtD4+egstZO6EUPy2y5MWsYRPeGSf7GiKvUz4xXQ16ZV0hbDcR1OIsmGoMivJqiAT3UFmSpLu34LyGZTyXqKVDCwdtUc6b6vhpQIpXF762mwTKCTOwDO85/z6eeRuuUz4Wbez/HyQSHSOKJx1R06+eZG3eAylC9VW+vXhs431c3qIAWe0biQeZCz5eoShvcsRh98=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b84679-e7bd-4d27-5d96-08d7470fbc83
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 08:08:40.8222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZvHI4Dv5YAVsrkkpzYESICwc6zUympdk4Wb1l/QRs238UoSEgTC9DS0qmMSeSb7kcNbMje8empGXWd1nCWgmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3507
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Andersson <Hans.Andersson@CELLAVISION.SE>
Date: Oct/02/2019, 09:02:02 (UTC+00:00)

> We assert / de-assert the reset line, but the CPU is too fast and the IP =
is still=20
> in reset when we later try to read user ID / Synopsys ID. Another option =
would
> be to add a delay after we reset.

Then I think you should fix the reset driver to only return when the=20
reset is fully done.

---
Thanks,
Jose Miguel Abreu
