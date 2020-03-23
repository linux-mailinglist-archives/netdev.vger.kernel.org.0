Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05E118F235
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 10:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgCWJyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 05:54:47 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:33396 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727737AbgCWJyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 05:54:46 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F061EC04CE;
        Mon, 23 Mar 2020 09:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584957285; bh=OXX0CLAiESutixt4vvsP5RxceHVf/uXL+RPkEt+wnuc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=WMZPh9ZMpF1wHv+02kYp1ys5v+5rMhY7Ky1hOCHN4xqxYKAVuJHOwCc9dtlW7DH3S
         ykBQH8IvMK/MHdhWPijk9zIM1xcBbBHyqf+JPoOr+HyjJ/Bd5wg1I922fVyYn1N7tq
         En7s9AmOG1+0KeZ1cZKvBypwNQt2Yo+q/Or50UrUD0iYuMmmOy1p3VgHuWJsxdnv+/
         XR0IYk9MeoIrMakBZh3ET9qV4gola4ryc/sP7VO1LQb4GGmZanAbVJnYdYbnvtouoj
         MJD+d4IzyOPO/4p2ewYwjoTx9KoWH9sc1qjsBNm65n4GsOzassskG8N+GG8NTrDdNK
         SI1QL+KwFaldQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B256AA0085;
        Mon, 23 Mar 2020 09:54:39 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 23 Mar 2020 02:54:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 23 Mar 2020 02:54:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiGPr06UdJlTkQhk00P+VinaDE+iVTK/6LGM878d/O9wQs2TmGxuWeTYDVGrDp4yNsh7dK+LwB+XJOy87nqS8cNVFV1ifunKPLmOj+X2V6/uHUNSELYvekXWWqapExu54+8uyEg2MgYO1vUGeUsXWHPqIpJPyOrDYQD2c5qmB/3smi/fYilqYm/XxbKwgUPoZGnJf8iJDqua+cI3ir0alFZhQw/6c2qg/n4YpvoZog0WUfVfaG+TWGv2CgBoeWF0te7PpfO9xUkNnmRkL61voJUeRWT5jn/O6C4mZScr8c/i5Ta5qg8BKQu5UfgSnYaUwzLTHZCI+8Ci1BZOMNpOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXX0CLAiESutixt4vvsP5RxceHVf/uXL+RPkEt+wnuc=;
 b=Y18nQfnBXQeGQfb0Ds34HTeXqmpKTJZjdpoo1CHG0zm+0y1jujRtdDWHcaHBNdSrwfFDVy2NqlttwTMqYLrdBufTUYwC+AdI5UWNHNcXVJgW2WCUH4HyoNZw9RTgxobWGbpO9dRUQH6D0U8M24TMV6nwDJRI+VEvWGr7LgyUbWKBZSS08xPRpQI1HP7hJh8DvmXz8qaPh3rkIY/05pU6FgPeoH79QeInmDg633BrKf1xEnGhViop40TG7mmfpJFeAkWQBrn7NjqcdwWX192tzrXB08CO6t1C9gp/Xtf4wvcwwjZ7hLsRQoWo4K1MlVBnaIFQrnPeMWt1VWAhRquqMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXX0CLAiESutixt4vvsP5RxceHVf/uXL+RPkEt+wnuc=;
 b=RCfcRfvxlppLc4plC4Nf7jnUqYqq5tnZLp2tZBpU5gyhCZ5Tyq8A2vTRgXdLNu2od58KusUAzpb4DwoMcLPf3OMXBXtxcSzDiMjTyZ032+endan5hUve1CA3uLR8KOkQjCUuXOyJNcdfGClEODdqzElb5IMW9P/iKM3ujlNDXY0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3571.namprd12.prod.outlook.com (2603:10b6:408:62::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Mon, 23 Mar
 2020 09:54:37 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 09:54:37 +0000
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
Subject: RE: [net-next,v1, 0/3] Add additional EHL PCI info and PCI ID
Thread-Topic: [net-next,v1, 0/3] Add additional EHL PCI info and PCI ID
Thread-Index: AQHV/td2/oAH68ZDTEGE4kkUdhEJt6hV8/OQ
Date:   Mon, 23 Mar 2020 09:54:37 +0000
Message-ID: <BN8PR12MB3266C3C3CE39D141DF15AA76D3F00@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200320164825.14200-1-weifeng.voon@intel.com>
In-Reply-To: <20200320164825.14200-1-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 623ddfff-c1ce-46af-9ff2-08d7cf1032f2
x-ms-traffictypediagnostic: BN8PR12MB3571:
x-microsoft-antispam-prvs: <BN8PR12MB3571E79B1C9DEE971C80F111D3F00@BN8PR12MB3571.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(396003)(39850400004)(346002)(199004)(4744005)(64756008)(66556008)(66476007)(66946007)(26005)(66446008)(2906002)(76116006)(33656002)(478600001)(86362001)(71200400001)(7696005)(4326008)(8936002)(52536014)(110136005)(8676002)(186003)(54906003)(316002)(6506007)(9686003)(81156014)(5660300002)(55016002)(81166006)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3571;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nlRp6lq+wJKKUXd+KCOCBeCZltyeO13pdK3D084KYFzUCJhXCOaV523s3djIY6Fhx6jMACx3KJvKsEfuE8t+OTpeLb17qpqlX46zD4f+NSJQlJcqiPd57FY2TrFSpGzx8YwnN94+b/tnYPQ1XuH+d9sc2swA+gLK9SK4dE+tMDuii59XIgLAJMHIKNNYc/vS+PquG8+o5kEMdctdYQdyv8u5kjA+hLRwJFsbHX8o8T3tJjImjfnW7VWnsqqmwLkxJKQxGPP9nujDiIX5w/1VterwSGQ/w9Va0xLKirTud+MghqUtYjgJEOi42iZcCdtJWqPkHAn9mxqj3V3I56VjnGC0+UBGTP/1kDuBMVRs5I78XF9ya+uj/tLv3VVpjUtAytV1EEcW2+DHsIY6qVmblmpQ9xtW8kuh1l19MROscR0J8Rp0omVs4NjtXiOc4P/sYZywLRPSUsYQYoVFDP6eEsBCwRxXTkVsSVIyOhJWa+akkQaZUvCQEFb0lBgvi+S3
x-ms-exchange-antispam-messagedata: aireonCaBXdzVNlO9zpe1pA86wqRJq5E06npndnUeWO1x2sWwhYLMZAkaVWIjJq2L52cRi1B0vVtnnoOityDPasPIaLjYesFuTfFaD9uvTSuK2ewxr8G9zdRxZAeHURTUkir2baclIGYKFVx+uoYDw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 623ddfff-c1ce-46af-9ff2-08d7cf1032f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 09:54:37.6402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nkM/mNF8TbKf8S7BNuVF/STd0dEJcCaf3nIQQaI3eYS7KviSPnizxoSJAgsY+8o9WJSuM02FzcsBArHCJNh7iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3571
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Mar/20/2020, 16:48:22 (UTC+00:00)

> Intel EHL consist of 3 identical MAC. 2 are located in the Intel(R)
> Programmable Services Engine (Intel(R) PSE) and 1 is located in the
> platform Controller Hub (PCH). Each MAC consist of 3 PCI IDs which are
> differentiated by MII and speed.

This stmmac_pci.c is getting bigger and bigger ... Can you consider adding=
=20
your own PCI driver (dwmac-intel.c) to stmmac tree ?

You could even submit a patch for MAINTAINERS for this particular driver=20
as it's already done for others.

---
Thanks,
Jose Miguel Abreu
