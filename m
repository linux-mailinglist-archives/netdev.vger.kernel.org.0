Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD91AAF85B
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfIKI7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:59:50 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:47566 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726657AbfIKI7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:59:50 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 793FEC0D94;
        Wed, 11 Sep 2019 08:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568192389; bh=VxYuo+i6l1ehrhAN7UrgAsRW68teXNF6qJ/SFoPI7og=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DIE9NYzLhG4dbO3hPUsginL6HbkN7R3qP+U2rDqTasFWz46NbkOfGMz/wOCzPu2Ji
         P+p99eP+856aj3N6KO1ewF4PYST6ZiFy2OOYt9XNQ2TN6WtCXjmjiuT+1Z5SEsuNor
         kRpa6mRx50xWvEOj1gVXLRuJKCXQQnV4+hmLgqElq3s09npliX5bE/MboKOVyvu2aT
         Ip8x+AYU3+GqqH9X7eyTt4OkigZsrh4MKySjaR4mO7amNRA+9rlQgL0AO4Cfda4eIU
         OewVcKb0Rp1fvNh6qzUG4NywbTVNTPmhb7neDdW+GH7j2e+CjIvUausy86DKO7e/p1
         NeIS+iVlk9ZRw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 257C3A005A;
        Wed, 11 Sep 2019 08:59:47 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 11 Sep 2019 01:59:47 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 11 Sep 2019 01:59:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFoHYcP2D6CSb3yPk5NRjDm0MHxioLdiJAE7h4aAoizDzBHU2Wi7qrKstTzwNmizbtI2hG+vkoDeO+oziWMG9/gQVKewBUbx2gPcXliZk1hL0E1xRJCWyrUMTaMJ/la6yV+wUVdPv9YNqzRAnWH03cZIm5zD9KTxa/KRCKNkglMgzoUh24dDpTL4BtFnDPpJJAQvCK+98I9uwMXvoekoXmUPBM4N6IllwoabpqnRA9G0eynStOS5bmW51M1tNiyNrKvVTFi7jLPe0YuG/Wr/YP+aFnaTbQwYN/YY70qU7Ps+jeW3zKqQ1XRPnrMsQ3qdSDaafuvOLDsKyODjT1/SUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/S5c1i+dfxXALaBei7CJnk3VD6sbdXfs9w6cAqD8uo=;
 b=MArOkFEt5IW3tYhkkeAX6iehh0D2YNVIHZDuVdij2iD9KhfLp9h6+vYoYnD5Bm2PY3PDY89nmKdnfW5JabRKqxYTHHqq/nt0jHh1JWz88nCanVvr1+kdYZIK4ueLBG9J/ldtqMCOQJ/EWKj/9/s7b3cdajtWIhD0ka89BnBZjYgJpuzwvVzSv3FAFN7FMN2J9hAuD1x6fjj8eE3J64DjPrrRJhJVgzVGWXB8rXTs+Khbbw7UAiOtLoy+cOMV3GHbd+1CW/wq1LXNs5KdC2+fwCcFk2JLfsxz8oA+0oSstWzr8YNmZDMs/Unr3cdS2bPXdJ/s/dEPIhiA+totWbMBeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/S5c1i+dfxXALaBei7CJnk3VD6sbdXfs9w6cAqD8uo=;
 b=KMrngl0r4JWTmAwqBwTJmyhoCF10YQEh8+gBuoYe/y/WcJBrd9hvYI3F1ProTmtX1etHNdmz8TqDaihoatbPYpg94VECnj3GOIR3HQPEzeezDYrzpTknYqqlHq3LM0kREy03Gg7PVh/nhutvlYlEQ4hG3GktqZb/xJ9pF+CJ2gk=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3539.namprd12.prod.outlook.com (20.179.65.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 08:59:46 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.015; Wed, 11 Sep 2019
 08:59:46 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Miller <davem@davemloft.net>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 0/6] net: stmmac: Improvements for -next
Thread-Topic: [PATCH net-next 0/6] net: stmmac: Improvements for -next
Thread-Index: AQHVZ+Xjv6EH/CtyAkiGIiwkAINrlqcmJCWAgAAG+zA=
Date:   Wed, 11 Sep 2019 08:59:45 +0000
Message-ID: <BN8PR12MB326676C474619C79EC0F2AC6D3B10@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1568126224.git.joabreu@synopsys.com>
 <20190911.102155.148817974369878410.davem@davemloft.net>
In-Reply-To: <20190911.102155.148817974369878410.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [148.69.85.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 308a46c2-9552-4f9a-2fb9-08d7369664d3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3539;
x-ms-traffictypediagnostic: BN8PR12MB3539:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3539F44096ED20A9F5BE7ED8D3B10@BN8PR12MB3539.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(39850400004)(346002)(366004)(189003)(199004)(81156014)(4326008)(25786009)(186003)(6246003)(229853002)(5660300002)(6636002)(446003)(7736002)(52536014)(476003)(11346002)(486006)(2906002)(33656002)(71190400001)(71200400001)(66946007)(66476007)(64756008)(66446008)(8936002)(66556008)(99286004)(86362001)(305945005)(81166006)(316002)(66066001)(14454004)(6506007)(2501003)(110136005)(76116006)(26005)(7696005)(76176011)(74316002)(14444005)(478600001)(55016002)(9686003)(102836004)(256004)(53936002)(6436002)(3846002)(8676002)(6116002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3539;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oaVdBcINhgX5EINw863Th1V6uDSrUe46i+UksidzUngmS7paaqMQPQjepySaPRVuYYB4fULLpUZgG9IiUwbHx2fWHU1U0Ncz05fuSkv/ZVzuD6g+Zjdto8oku+RE4Hg5iRNSK0GIa4CsWsUi6pNDXTvgZVbeqXRHu8uERXPgHKETFa0N91mhUmkQpItecei669/XDhjxp+ciyX0lpnUnxNC5NiAytN+KTris5fQSslwKHu25a+R82sQSjKDmiAwaW9AoxXvlfDReAxqABtrNFnHrUXGwYHESMxcZNHIwzAy9iWLJ+DoOAn5o06yOQCiqYNxPj4rmMxjdPruWjXur3uUnPJ+U9JzyB7QN8G5+q+pLM2uNbRZPCaw6vJkuxjJTWR57A9ZmK+50dCDMxkWh1n6iBDmZ3eZR+7EBgAg7aIQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 308a46c2-9552-4f9a-2fb9-08d7369664d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 08:59:45.9771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jphXZPWpDJLGxiZ4+Z5PH4UVghnQL3MDvZZyzKT3cPiFd/LPQi5SIuLS9ZQrC18xAIju3sHodxglhl3GFP6TpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3539
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sep/11/2019, 09:21:55 (UTC+00:00)

> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Date: Tue, 10 Sep 2019 16:41:21 +0200
>=20
> > Misc patches for -next. It includes:
> >  - Two fixes for features in -next only
> >  - New features support for GMAC cores (which includes GMAC4 and GMAC5)
>=20
> Series applied, but what exactly does "ARP offload" even do?

ARP Offload allows the IP to reply to ARP_REQUEST packets automatically=20
without passing by the application.

As net doesn't support this offloading I'm currently using this feature=20
to test endianness issues in the IP and check if MAC Address is=20
correctly configured, the logic is as follows:
 - MAC is set in loopback mode and ARP offload is activated
 - selftests create a dummy ARP_REQUEST packet and send it out
 - IP will detect the ARP_REQUEST packet and generate an ARP_REPLY=20
packet
 - As MAC is in loopback mode then selftests will receive the ARP_REPLY=20
packet
 - selftests logic will check if ARP_REPLY packet is correct (i.e. MAC=20
address and packet type)

This way if this test fails it probably indicates that MAC address of IP=20
is not correctly configured or that endianness of the IP was changed=20
from default setting (which is LE).

By default the feature is off because user may not want to reply to=20
ARP_REQUEST and I'm more using it as a diagnose facility. Let me know if=20
you agree with this approach.

---
Thanks,
Jose Miguel Abreu
