Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11113AE596
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfIJIcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:32:41 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:57352 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726735AbfIJIcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 04:32:41 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8D454C2B50;
        Tue, 10 Sep 2019 08:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568104360; bh=IUpg33487Ih/Qgi95y0fFv4z9fYiq0ye2yu+eCLp/Uw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=F8vRm7BIGRN4eteYzcXA7tVEaJWS1HV7dvUI17U+lcGmr7adK1+xsxaCF1d7yEE73
         iwdBa9xa84TAFsRJdV1gYONR35/NSlizREAfaJ59KmLSlnEi6eiQZpo8Lvwuv6fcKq
         Mpr8U8CPe/zID8MhkwQsF02s4kv/ejDtHYXXT7ZSy2pZmMnqv+uJ5y/Aky2Vx8VTU7
         96FN4OecmniROlz+BqxxekamN/ahWADob21nygmIS6fc8csuf0sLOwH4HuJH8GRZoB
         LDM8GRDt1FhEB/JjohmormVXceQggi8fHLeNk7/PMCgqA/ID8LprqTFpJXouznUdo3
         a5eDrIs2PxPug==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 20C1BA005A;
        Tue, 10 Sep 2019 08:32:40 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 10 Sep 2019 01:32:40 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 10 Sep 2019 01:32:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpuzZXAHzsJ1V0XFUkROyznwMSMbdVUz7tK2yme5J8p5B9Gg1V9iMWBiQYbUOsOpINXkkB2s5gfmXw5opIbvOwdai/95LFkt6djMNok3fzOkqq8Rm2wYoi3IgtBRTzDxq0ddw8IuQEhjWwKwge6YAkU2eJZRmwjS1NEusYxsrNZEyC7VJF0yqL9GjW+dCBEfr6UImpj5qHngoRlH2xsvnlhSWL+U7RE6FRpkhhc9yW5K8gepjyI2bbVycy3KqRXAVqDf9dQPspLG75o0x9hz9KWxT0CLMYIc7bqMfws5ZXiMestSkTrio9FscZxoiYpS6ylKYrVZOKlzDaSpdjFuGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fzei+8h/LRHT6bH43MmHY7uQxmy4Qbi4Y5y3YmoJ0Tc=;
 b=Knz9fepLgdDmHXNevFm+XPwAGru7p5itb+bR7dzatQxr35KvSg/0qb1q6aTCuELw4ej+pneuV5MMKyvSH0igsyMJU/l2bLcfFa9MmD1U3tVHTuN3BFuHNzNAjZ85PYuaO8SaZ/VmKrGy2YJG0gdIqkjR8WMl0imLP07bTjnnhklVUfKs3rJkeqjJd3VTiu4B4/9N0FjJqY671MGRk20cVEgqcrud0I/90KK9q+8SrpXvAjDzd9gHdZQpLPuVp1QgZ5FFduzq/Zj3ilsG+kUJqW0C03Ln0NzNG0KVFLMDTaxDfHT45VTd3K5Z2ElR2fTT5dvfDdVUKyQ3i3Qc8O4aCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fzei+8h/LRHT6bH43MmHY7uQxmy4Qbi4Y5y3YmoJ0Tc=;
 b=Tb90Vh6l398evgwdj42SdD5QOB3vIh+T9JJcxLUDFDTJOlzIEge+daGg0XgE86YtpO7MD7gjsXs2OUcp3xh7criXiwDrEgV3Gx0Sf99fvXjIXaKkRh3I3LDq+UzQXe6qP3jOkqUqIwpW+hepUmEXVzI7utcK8ziM5oU7fjtVEMA=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3108.namprd12.prod.outlook.com (20.178.210.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Tue, 10 Sep 2019 08:32:38 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.005; Tue, 10 Sep 2019
 08:32:38 +0000
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
Subject: RE: [PATCH net-next v2 1/2] net: stmmac: Only enable enhanced
 addressing mode when needed
Thread-Topic: [PATCH net-next v2 1/2] net: stmmac: Only enable enhanced
 addressing mode when needed
Thread-Index: AQHVZyLsOFcggZ86CE2HdVeFQfSucacjgrwwgAAzwICAAN9oUA==
Date:   Tue, 10 Sep 2019 08:32:38 +0000
Message-ID: <BN8PR12MB3266850280A788D41C277B08D3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190909152546.383-1-thierry.reding@gmail.com>
 <BN8PR12MB3266B232D3B895A4A4368191D3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190909191127.GA23804@mithrandir>
In-Reply-To: <20190909191127.GA23804@mithrandir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [148.69.85.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b9c0368-3178-45fb-b120-08d735c97033
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3108;
x-ms-traffictypediagnostic: BN8PR12MB3108:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3108E7296474207BD5C2113CD3B60@BN8PR12MB3108.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(366004)(396003)(39860400002)(189003)(199004)(3846002)(6116002)(76116006)(66946007)(66556008)(64756008)(66476007)(33656002)(2906002)(66066001)(71200400001)(71190400001)(229853002)(14454004)(66446008)(6636002)(74316002)(7736002)(8936002)(81166006)(81156014)(8676002)(256004)(966005)(110136005)(478600001)(186003)(6436002)(9686003)(55016002)(6306002)(316002)(305945005)(25786009)(99286004)(4326008)(5660300002)(6506007)(26005)(7696005)(52536014)(102836004)(86362001)(476003)(6246003)(11346002)(76176011)(446003)(486006)(54906003)(53936002)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3108;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3VMc69C75daorr9zuKGL+GRVTnhKiKObY4cSqfEVokwLHJTysMO8f2l5htbegt6/qx3IC/yK721fmx7cemzvqijhYA8wUd5Y0MF8Ti7wbNJkNxPunzlkjekplIu5I2/MjjriqzevnCwz2APXuN86vnvP1cYrodNtkThYjgvFbyKFEzZTNaJLij+/iMOptl6hR7lqqX55jg8Dg1AN/I0y9VFYd651o/Xq+lMKeJXoSiYR+cygPPBxrVZpd6chi5PJ8PZpgFS8fitVrXL0vvZSZ/3cGwEqHtF4/HYkM8jRtFF7qMW3ueMVIAnGe98XBHaNIClzMRGXhxHZOC/8G3ueSW14IPle6fAOB/gx8vKot1ENYimqyRy2JABIBTI5BYxlA0AaWf/MiItWGx4sED3EPc1YBZdHwG2xkKx7GCQfh60=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b9c0368-3178-45fb-b120-08d735c97033
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 08:32:38.1909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Auiy9OcP0dxbjIi8OVu5OZhYf+K3qsxfCPCJSXF/z3agAfRYvFG9w/cTQzJTi04yKpegcvHSwIKjknX/xUWK5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3108
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Sep/09/2019, 20:11:27 (UTC+00:00)

> On Mon, Sep 09, 2019 at 04:07:04PM +0000, Jose Abreu wrote:
> > From: Thierry Reding <thierry.reding@gmail.com>
> > Date: Sep/09/2019, 16:25:45 (UTC+00:00)
> >=20
> > > @@ -92,6 +92,7 @@ struct stmmac_dma_cfg {
> > >  	int fixed_burst;
> > >  	int mixed_burst;
> > >  	bool aal;
> > > +	bool eame;
> >=20
> > bools should not be used in struct's, please change to int.
>=20
> Huh? Since when? "aal" right above it is also bool. Can you provide a
> specific rationale for why we shouldn't use bool in structs?

Please see https://lkml.org/lkml/2017/11/21/384.

---
Thanks,
Jose=20
Miguel Abreu
