Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E997C1451BE
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 10:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgAVJ4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 04:56:06 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:36478 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730120AbgAVJ4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 04:56:02 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 12D84C059F;
        Wed, 22 Jan 2020 09:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579686960; bh=KLrHdFY/H//p/H0YRmCf3q93qXdYupMA6Ge9xq4oPWA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=kH8rknGiNhbEO1jd4Mp4Jz+TWPEsseDqMSy2U0F6DW08uZCVGL9ypeFCuHFksvO+O
         CfmiigFF9PD5Ljvw1FrC1VQj/5bWqjTRmecPbgxx+KVrICdrQiX3VKkLlq1jRPndtO
         DgOovIGS95S3ww+rEAyypckboXU0k7NKHG4eL41JLeaaBvYfPG9kc0Em96GlDvYN8Q
         68mtEdYXRpTCWPVBeIFonQiS4g6qx87aB1j+KHL0SQ7AHoWFd9AbnSzQShLwNYKU5B
         cre6Zk3LlOw6g7ecPwZsMdgdYoo0ioCUja7yaQ0hLso9NuZa9ZliyrTN7r1QMppu6D
         y6LCyHW4XchSw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 496D7A0085;
        Wed, 22 Jan 2020 09:55:55 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 22 Jan 2020 01:55:55 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 22 Jan 2020 01:55:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMX/WG8YZJJ6ZXb6ahhliri99/gDzDEc82Fdjwlr1MWURw4u/6tWPw32fmvN7J7bg0v0uUXgiM+IHQA7NCn2hL5ir3spV0ZuF7eIFflPefyMIqSwjNdMfupa6z2AU32cDa6P7rhUCv6iLdSlC4TEuk+tJYgnlN9jKTMD31ir79YcTuf1ZHRPO/7i09apOa+e7C/6vu6TTH3Ag7t0MlZcXXDD98B+RiF6GYpNdVwK4btEgu4kEkbs1qlXrgTsXbtHABJEyxvehQcXPWmHu12jr3T0U92v5XnenqR/VrLpqbpW6/5BBeB6LBT5I7IQaFHE2Lh/whqGkAWXZ8j4MJm0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLrHdFY/H//p/H0YRmCf3q93qXdYupMA6Ge9xq4oPWA=;
 b=cBbgdHaVr83Wwk359qxerP0bSc32/eWUFag014FJ3FVJcjPxPUKa39x/l40qIYqryz96qcEdpwHrQro40J1Z+szxpEeJ5bQVxeKQi4y6RBzOacvLPsPx8pPngZoX6QYGruwsrMJt49d3qktRY5k5apg4b1xlGwyezeL7IsGL3Z8fiGAplqbvgUBt77xhmLb3ksyibyX8JBSU89VUU4JAeK9tIyS3yOs8z5gLCLS2h/VtLP2DkXtg16qhk7iMS4Sdh/5RZZe/7a3RE9/+kGTAg06EZhcgIt9fMAtRwH503hAbDp+h0pIPzZpt9jthoYHsd5ezTm3C9yS527zRrKxiiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLrHdFY/H//p/H0YRmCf3q93qXdYupMA6Ge9xq4oPWA=;
 b=C3banMiM068OeE6p89arW5t27hUFlo8UazkmQ0lF3L0cFgx/dWRbKVY6ANwZVXd7LfFXdaLU6Ve0u89zngnr0RgZxKbYZyIrcDbObJaUerpHOpVs8J7920Mf4CiKhGDUqO/LAg0tFUHSo1GNYPe2GprwUMLMNNlFY1mBFSEwHHs=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3026.namprd12.prod.outlook.com (20.178.210.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Wed, 22 Jan 2020 09:55:52 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 09:55:52 +0000
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
Subject: RE: [PATCH net v3 1/5] net: stmmac: Fix incorrect location to set
 real_num_rx|tx_queues
Thread-Topic: [PATCH net v3 1/5] net: stmmac: Fix incorrect location to set
 real_num_rx|tx_queues
Thread-Index: AQHV0QPdI0TP73liMkC6zs86z0tb/af2cgbQ
Date:   Wed, 22 Jan 2020 09:55:52 +0000
Message-ID: <BN8PR12MB3266F0534CE20CE906AA3C06D30C0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200122090936.28555-1-boon.leong.ong@intel.com>
 <20200122090936.28555-2-boon.leong.ong@intel.com>
In-Reply-To: <20200122090936.28555-2-boon.leong.ong@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdeb2744-ce37-42ac-6b42-08d79f214453
x-ms-traffictypediagnostic: BN8PR12MB3026:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB30264F067D7F3DE9C17F7B39D30C0@BN8PR12MB3026.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(189003)(199004)(54906003)(4326008)(110136005)(9686003)(7696005)(55016002)(4744005)(7416002)(8936002)(81166006)(81156014)(64756008)(66556008)(66946007)(66476007)(33656002)(186003)(5660300002)(66446008)(76116006)(2906002)(86362001)(26005)(52536014)(498600001)(71200400001)(6506007)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3026;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rekbeK7wh8zJzdbHCDhqmAsEtqjSZx1NvW+2lK9E6fUVkRvNAUSCXos+n9LXx+QI8qr85suO0Dl4aD0Bp2WbyEJnokqFBEn4rALrHSDmu6WqtoBWpDNPXQUUBcXdgzSCzb79jIyNp2CJ6Aon2e/R6sBt4s5jCz63/ib9MdZamH+HdpD/P1ocYKB9KuSgO9zFonjrORkaOhiFOOzLicDyuYKCtQ5ksfiqHo5LLgRJWyON0OGCtACT7LxsDizfM9rPlk/JfMGVYO0asPzXFyJbS5idJOHQcZP0lAhOwM28av77GaY1J6/X2YRIP2tyCzdQJFGs0MvbdbqfDZthB91GoxL1wgTK9TYL3qY5RVEK/mHVug+brq76uvQvtCQkdY9qU0Lhgu/xlDsKnCEgtt+A6tpnDkHlf8szPjt10UV7OXMW7kqg88J0PKvsJsyUVNj3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cdeb2744-ce37-42ac-6b42-08d79f214453
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 09:55:52.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uP2DFy6lcOmK8s46VlHTczPM98d+nld6s/eU/KRs/8olEhk24ZKd1xODXR/CD2ia1vcErMQYPFO507PVF9hY5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3026
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>
Date: Jan/22/2020, 09:09:32 (UTC+00:00)

> For driver open(), rtnl_lock is acquired by network stack but not in the
> resume(). Therefore, we introduce lock_acquired boolean to control when
> to use rtnl_lock|unlock() within stmmac_hw_setup().

Why not use rtnl_is_locked() instead of the boolean ?

---
Thanks,
Jose Miguel Abreu
