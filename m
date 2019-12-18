Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BCB124876
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLRNez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:34:55 -0500
Received: from mail-eopbgr680076.outbound.protection.outlook.com ([40.107.68.76]:23364
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbfLRNez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 08:34:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZS5k9QUFGUYnNuxA498he9d+DWpP5QGfkQkeS626lguheHMpDsaDEqrlp3ezuj1t4/3sWVnuA9wOlOmEr5b3r5mySI02rRUph63amMPAA88PPVDBUDPeqG7ZaSufE1V6iSCVCokMd97KzNTkLTwOVzpiqC/2HYa1/2tZIXthB8mgM72pBZJn4RoFgUynaR5pZIgaYh/6pTOyLVRhDZ1UTa9GusqigGUco4OUHYBxjwJB6IhnwZ6I5QxbZsSRvv31r6copK3V7UteAI3rmItUJ4Xv1Laj/6l13Zvabn1PGrFxMh8B1dgTNs/oF9vtocTZgWfQc0ZoSBoXlZPnWQA8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRCkxkSeAlEZ+IpDcwbYjkqEqMjcZs4FSpuv3vinLGo=;
 b=CsM8C7OPcFmUeSs+I9IEHvWwqeo0zAOuhGtCZh2WstUr4f8Gj8kUGDH2FDb+gN7OSYwQSBzXl+4YWF2csmkboxVudviTZhbsmLmaYmju+QoiH9BTsNw2o7vLEvZrJB4hIKnHrZ2p0YJV1fpIV1Rc5QbXopgFCF4Oovydzo2p82LRkfyLdc/lr+9rcqNRMUFGoYs1UCnIs8jh25eqXUwz3GekB8D8jCGbesoXgi3conH5QWrWit/X/86qXr8tupYiQSkevBGDhmmfGptqQdD931qIDdiFPTyIEiMaXr9GKBSJWq2PD9gYRyamY3mWcT9bPJyf+HClab8+2wI+qa2L+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRCkxkSeAlEZ+IpDcwbYjkqEqMjcZs4FSpuv3vinLGo=;
 b=jgCkmWKsueg0QZAg0o2NnjglaG2WZH1EvxEAT+n453TorK7QwHhlcyzSS3WrEj6YqF4XIlwUftmm4a5V0HNlZwVqJ0I0aq8asKzSDh2Ay7FpFwuPe9qxEhVpYdxuy7GDuGyoybva8TX40vJ6QkAu/oFoFZRbzXeYl7D5UjLrQCI=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6421.namprd02.prod.outlook.com (52.132.231.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 13:34:51 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 13:34:51 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     David Miller <davem@davemloft.net>
CC:     Michal Simek <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>
Subject: RE: [PATCH net-next 1/3] net: emaclite: Fix coding style
Thread-Topic: [PATCH net-next 1/3] net: emaclite: Fix coding style
Thread-Index: AQHVtAmigeW+a78/0E2rrUrIsSbtOqe+4eCAgAEC3CA=
Date:   Wed, 18 Dec 2019 13:34:50 +0000
Message-ID: <CH2PR02MB700048BB28C0D3625B1B7AC3C7530@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <1576498090-1277-1-git-send-email-radhey.shyam.pandey@xilinx.com>
        <1576498090-1277-2-git-send-email-radhey.shyam.pandey@xilinx.com>
 <20191217.135729.173497629676380262.davem@davemloft.net>
In-Reply-To: <20191217.135729.173497629676380262.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5ee4ea42-c942-418d-7b2e-08d783bf0f11
x-ms-traffictypediagnostic: CH2PR02MB6421:|CH2PR02MB6421:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6421ACB0AD05743D835575F9C7530@CH2PR02MB6421.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:499;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(13464003)(51914003)(199004)(189003)(9686003)(86362001)(26005)(64756008)(66446008)(52536014)(7696005)(5660300002)(478600001)(55016002)(4326008)(33656002)(107886003)(316002)(71200400001)(186003)(66946007)(66556008)(66476007)(76116006)(6506007)(53546011)(4744005)(81156014)(54906003)(81166006)(8936002)(8676002)(6916009)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6421;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G+9CqJBmxIkJSG+FXytzM7ZGM0ix62KuGib+yt+5O7dqIQDG6+fqVolg+fm2JJm8cC+HJvrxKAIdPt3p9EfO9dZe4ZTKub2tMUfN9b/nyPdZhokbKb/fCk2PcHnFPXhBVTXDXQHV5xrdxxKyn5kNSoHlFYwX1gR3c06yAM5dHZA9+ZlHXgV9MYdgW5zNDAnnkBVZvs9+g7jl92yatTGZ0dDlSkFQwe6bfiBEMTtQ9HjCUVKELjvL+Sqo0mu2fQEVnMMZ4hq3vfIpv6EuEyIuL2QwUy/0kZSITqa3WCScotz0Ac+tte7XSP9zRrkXpnZ7t5998G146OIj+T8uZOvY5nRkxs5wxNvRzr6qXVBYPKyC62im9Da04iPeGK8XQglu7munNMUWlbUVHPb1kzpOsvNJNX1Kcu2qvEF/LBDW/4JFQICFECs3SuLQbfsXPxiKEAQJKWm3KwBYVd0hv2EEWinmxeAylTCTFWFwxPn8JJ/zjylqezSZs78nf0313TggsVF0RmoW7oYHM92CGuKleQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee4ea42-c942-418d-7b2e-08d783bf0f11
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 13:34:50.9995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y+GUkKY3XIDiQhuQf2+bOwLy5eercbmZ/M2Z1qfDdhxbirgNuzzWdPMzz4cNyJaFfAH7UHbfYL1VDCQzE61Gig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6421
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, December 18, 2019 3:27 AM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: Michal Simek <michals@xilinx.com>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; git
> <git@xilinx.com>
> Subject: Re: [PATCH net-next 1/3] net: emaclite: Fix coding style
>=20
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Date: Mon, 16 Dec 2019 17:38:08 +0530
>=20
> > -	spinlock_t reset_lock;
> > +	spinlock_t reset_lock; /* lock used for synchronization */
>=20
> If you're just going to put the comment there to shut up the warnings,
> I'm not applying your patches.
>=20
> You have to write a thoughtful comment which explains what this lock
> actually protects.
Thanks for the review. Sure, will fix reset_lock comment
and also its kernel-doc description in v2.

