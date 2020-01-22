Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7805B1452A6
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgAVKbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:31:52 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:48998 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729260AbgAVKbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 05:31:51 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DC1494064D;
        Wed, 22 Jan 2020 10:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579689111; bh=TpBvhcq0e0QKCHbKp1nIql75IZbIWHuxSSbnqHbX4kM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=lh2oKx9ajk7oQABBOSuPkzB9JjmRvQiv4OnO8qaxevkuxFqnQBX/U0bqIKLaGmEBa
         OJjYlUldIK8dUzDUGnnXZ36u9Bkq+jZ3I/ztXxPzkW+ZaaOFWH2iupdu2goz3qa9xp
         yXEeHzwoCQ0D+V5Mk3GdHmvNSEgrbmPbp6fAccf/J8bU1vsMZqk3dquJFRinm68hRn
         dfcZezdPNDjd8URlovToJ5TId0qST/KnpKc7cbVqOTZ799NPgm5kH7OuHusljtxPlb
         iuqsjv3fTaImMYI07/QxvOia6bPAQd4p2oDBF8KCyStlaorSbnwk6qWI+bvycI3ASK
         XDZBszDgbEzEA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 13BFAA0083;
        Wed, 22 Jan 2020 10:31:49 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 22 Jan 2020 02:31:37 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 22 Jan 2020 02:31:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMvOLMuk+dY8rMG8n+fr/t0XCeFbh82666kFbW5cFJ3UZxu8XBuB0DTqf1mR9O0AB3PTCB6ayVwK0NgNTEUy9VI+H9DxGxQxwdDqZmjPGT1x5em6DaTlKMpBzl/X9nWhcWOWhIHni4FBiV5U8DDDFvD6ibN1KGbsqTPb89vEoMA9B1L8e7Ag/pmOY6N1Rz7RQ2osN5HOGNqtxdZqeXIuoPt4foNz3PkkGrqkErClEsL2OXjc2dIHQPqZBxyAFwAxBjGjNuC1mJ1sOyDeZlHUmYKFT9CP72uwmESXocw5FF7vND+3vk7FWMHWixX85B1Kgu6XAoaxG1tDT8fGhqkuQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpBvhcq0e0QKCHbKp1nIql75IZbIWHuxSSbnqHbX4kM=;
 b=c44Kv4my60hqA9wa2Q8YkHgEPcawTr4SKjVoCm049mxkzo8t98MsmlL/U6XG2EUZfC3RDjv91X8IdV9VDqubY8UlAksEhM1tb4+HYAentzfv+n7M63kCG3oMqMgYbBWE+zu+BiKvhznmLciP9GB01bcKlTcJthkQ02nR4LSZqpj7UakWMLUevlKkHyMPSN2cfp3efck+DiMtNBvb+L9DabSfmZBHSRRch0RBuBZLomNYlhkt4M8z37jJB9wjFyF1xjHUpRpzX+aE5C+XZM5kqYdmagwpltre/tHlv7XJs1D8TZ/Ffhp5akX6c2H0s7KZCq90M7qnCUqRXhCs0Bfz5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpBvhcq0e0QKCHbKp1nIql75IZbIWHuxSSbnqHbX4kM=;
 b=gU8NPLYybKICL2jPOjbhSqJ7GX7NS00dc1LLOuel2squ1EAkwbUzwhYeJSoTrV8pPQ5ZXn+ClzdYow/yz8lApPYrhodrcG0tbWdgT7tPvKm1sN9KmQCgogmswZ8VfdYmwd/MaCBn6JJK24svGTlov8eR354Y9iXJASgULkMJ7zU=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3332.namprd12.prod.outlook.com (20.178.209.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 22 Jan 2020 10:31:36 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 10:31:35 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Tan Tee Min <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Joao Pinto" <Joao.Pinto@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Alexandru Ardelean" <alexandru.ardelean@analog.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v3 2/5] net: stmmac: fix incorrect GMAC_VLAN_TAG
 register writting in GMAC4+
Thread-Topic: [PATCH net v3 2/5] net: stmmac: fix incorrect GMAC_VLAN_TAG
 register writting in GMAC4+
Thread-Index: AQHV0QPeIdIQkFuhA0e0QyofmiZPfqf2e+IA
Date:   Wed, 22 Jan 2020 10:31:35 +0000
Message-ID: <BN8PR12MB326699D4E4CD49804F2E5097D30C0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200122090936.28555-1-boon.leong.ong@intel.com>
 <20200122090936.28555-3-boon.leong.ong@intel.com>
In-Reply-To: <20200122090936.28555-3-boon.leong.ong@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adcf4088-de43-4ba8-97ec-08d79f2641e6
x-ms-traffictypediagnostic: BN8PR12MB3332:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3332C4ECB31FA0BECAF5DB08D30C0@BN8PR12MB3332.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(136003)(366004)(376002)(199004)(189003)(6506007)(8676002)(81166006)(81156014)(7696005)(55016002)(66476007)(71200400001)(66556008)(186003)(86362001)(64756008)(26005)(9686003)(478600001)(4326008)(33656002)(66446008)(7416002)(8936002)(66946007)(76116006)(5660300002)(52536014)(54906003)(110136005)(4744005)(2906002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3332;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kgu80RqPPncafBNpBGXNnH/9+34arbsEKVMdpvkFqS9QS1RD3VY6WoRL29+BaQnI54xJDtrP+w6Smn4W56/zdfWupgt3FsoIkb7kJKzWW3ZD3btnyM1rzd63YTvrwqbmS5mAhrQDvwCi6bHjOKKZq7mJ55W9VyJaIH5JGFx8OHIZyb9Gz9oX7EhpJSDo/cNCMqOPrI8q5XsVUbbpG+tf6Fgc+1OgSoCcgkiYdvshEsR4UpfDGveA3aQuR8tkHElqx40cdYDJP59qn61nfEwMjAQx9FjLGKCbXe8K8kBPU2NulkeWiMBCOCCS110fHqwj5pzqSXwGUa/f/hWwJW3r1TsA+P1ZEPX6ms5umNgdS2HBGMaUgXKaDa/zBTeFNx6GCLoPE+Oibql+5HMzbMOmuXL5ClUQEl3ntU7w2psAKlrquB9CSgq1xiWTlFj80Vmh
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: adcf4088-de43-4ba8-97ec-08d79f2641e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 10:31:35.7760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SrcGpDgnxDzqFii3kxN/pbL3RyILjBGNy9wzOXuDtczcFu8esfmC6Sk4TPj89DIMiFcgg31cFkZiT3tINBsZRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3332
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>
Date: Jan/22/2020, 09:09:33 (UTC+00:00)

> It should always do a read of current value of GMAC_VLAN_TAG instead of
> directly overwriting the register value.

Thanks for adding patch 4/5 but I meant in previous reply that this patch=20
should also go for XGMAC cores ...

---
Thanks,
Jose Miguel Abreu
