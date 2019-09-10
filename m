Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EE8AEFF0
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436934AbfIJQul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:50:41 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:41864 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436758AbfIJQul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:50:41 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A046DC0EB9;
        Tue, 10 Sep 2019 16:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568134240; bh=1l2N/1ITeD+vI3yMCijQCzfXn6NxAl88T7WdyuPMavc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=GDYvI7y/CuZtO/3MfGy0cPxmE68GvQQv03nQxVa0sgM/MhD19KobvRUb8x7lIxQd5
         RTXFCNVDnPdgfMmKogstZN09SRp6l8rtXwVVVbzzGv49352xOrNSmAjdEpjDN/5ku4
         i99sAKZ6DLvfrf2XQ0At/dh5Z63HVzOFkCJ96jNx4TinnonmHj9Sxi8QyD3AF77mbI
         eFUZndvUfQ3onGLWa3XUvPaEgQEwlcIavDEeidx8iM/GmJtvVxU6LLShN4F4Wol+Iw
         NalklicLsp5w6C0faeQa6PLVWYy8/l5gQ6rUYrcSWayJpPHly+M527cSf8EAK639uE
         5Sx42V41NOu6A==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id DA6F7A005A;
        Tue, 10 Sep 2019 16:50:36 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 10 Sep 2019 09:50:36 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 10 Sep 2019 09:50:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SU7VQGDXq6CaoOBmgAFkUtHy61gv1ZU6Qd1iAt4Db1MxVHkbggj7WuDlPpV+41LlFpI9Uuq37+sn/pctS0badoGK9cwlbbtFBWs7jYoG5JrTjSjKDz7o2VT7V4gnll36w1DEq/hf6T8P5Nc6YNMCMj0x1V381Yi1vFYEqt9XJyO6G7xnXDrnGrx3LXBPlbUjpCfPu2nyOBv1y6RM6a4cAcurp46bi7xRnFGpGLM6MxbGM80DeIiWARLUt+8WixRzAfWIVHXYyXLa1xmjNU8SII4qO8O7Ve4kxl4Lyqi+2TSmUnhAUrkDeNFVii+g4k7d1w40762ZDeBT4/2/DYaXqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pK1jXmQmS5bBm+tartDs95dhp2zoy76QGHzByDkwdhk=;
 b=P0Dj5f632eVU2PL/Bc9OPiVbK0ih3MU+MvZ/AkSNz6h5CFbl8Wh+4UQzPHHKb61DOrG0r1H/DjWpXHXtmOIaFYqtyykW7oyJX8HpI60GGxnj6BXDwxCOYSWW0T6XjMCMCNEqEaFXb8P1Q/I2vxNoe/gyvHpLt7nLVnlSx7iu0nuWgiaMJw+Bkb+NkhR1DH5xZICiri0fnPfLYVu8DkFY+QP7CZvMoU5swaOgPw60T89gerj9S79jFsnNFJXk3fT6NVUfGZM92WvVYztFjIrDyZzX0cFwYH+8BXX3+dLSR8XWzw30mZgU9iY2rXY/JoWHyGZ8BOOO3k06qYZ01kPswg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pK1jXmQmS5bBm+tartDs95dhp2zoy76QGHzByDkwdhk=;
 b=Wl+DxopzM3VC9f7hCXIVpUpX0bcWrrXdLlBgbKkbNXPQfREqs7dBBzdDWlqC5VgebekTKRSgu2I/X+kEQi6NSFmbP8/2kjU+624sd44EZCea7cT1bwVdr5XD9nezWgxDl1EJfGZ1zKBivVkRVY6rkVteeio62PmaPWeQJwtKK3E=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3458.namprd12.prod.outlook.com (20.178.211.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Tue, 10 Sep 2019 16:50:35 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.005; Tue, 10 Sep 2019
 16:50:35 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 0/6] net: stmmac: Improvements for -next
Thread-Topic: [PATCH net-next 0/6] net: stmmac: Improvements for -next
Thread-Index: AQHVZ+Xjv6EH/CtyAkiGIiwkAINrlqclH45Q
Date:   Tue, 10 Sep 2019 16:50:34 +0000
Message-ID: <BN8PR12MB3266C0DED372AEE787FA00DAD3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1568126224.git.joabreu@synopsys.com>
In-Reply-To: <cover.1568126224.git.joabreu@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [148.69.85.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d25fcdc0-e733-4dc1-e47f-08d7360f001c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3458;
x-ms-traffictypediagnostic: BN8PR12MB3458:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3458932C71B2EE3A1CBABBFAD3B60@BN8PR12MB3458.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(136003)(376002)(346002)(189003)(199004)(76176011)(74316002)(486006)(66446008)(11346002)(99286004)(6506007)(53936002)(6116002)(3846002)(4326008)(71190400001)(71200400001)(478600001)(25786009)(6246003)(66066001)(33656002)(7736002)(8676002)(26005)(52536014)(102836004)(5660300002)(81166006)(81156014)(186003)(86362001)(476003)(14454004)(66946007)(76116006)(6436002)(8936002)(2501003)(66476007)(66556008)(64756008)(305945005)(2906002)(446003)(256004)(9686003)(229853002)(54906003)(316002)(110136005)(7696005)(5024004)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3458;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jI4J8bP9YBjKLPhqYt2/qdVBKroL53ehztPo5xhA3E79Ir7u5l0o5imZewypoleZVCr5lnIHY7iaTPnWxxzPD+2eD2+rVS/dneG48oxA3OTQLn41XnTelGQmM439/iJhZsbnWeJSVlz/fg3NJQXwvpMrJrZMbGJwDvMvuX58CPoArBwgkHnGb69ILloY2TnDjIEW+t17Vqx/4xKVo5KmBMIdKlWJbm7rmz+IKIsVUHjNj9GIHycoZWvHApOiIshF/cTbQJ889RZXM6P78l+TH/IF6YuPoZ6b99bCKfYL+jXYxmcZb20cPFPyfZC1IjWdP5Y0MsdEZAAn6uMlmYdO2dQHAtCdAXktHQsZjxdsSmG2++Sar+V461q3Ie7OjPWBGpTEgcqIN+CKr/fuF7JRRJ4acPYPLVPxg3y46wCYxXw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d25fcdc0-e733-4dc1-e47f-08d7360f001c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 16:50:34.8948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w7JKThsDzv0tcnkHCQxLib/NRgc4h4LP8F5FXHSPdmv1QgCP4eNQDtf9ngY1OGrRsoIM7ItjyATbGq2LIQoGog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3458
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <joabreu@synopsys.com>
Date: Sep/10/2019, 15:41:21 (UTC+00:00)

> Misc patches for -next. It includes:
>  - Two fixes for features in -next only
>  - New features support for GMAC cores (which includes GMAC4 and GMAC5)

BTW, just for reference (and because I forgot to attach it earlier),=20
this is the selftests output for GMAC5.10 after this patchset:

# ethtool -t ens4
The test result is PASS
The test extra info:
 1. MAC Loopback         	 0
 2. PHY Loopback         	 0
 3. MMC Counters         	 0
 4. EEE                  	 -95
 5. Hash Filter MC       	 0
 6. Perfect Filter UC    	 0
 7. MC Filter            	 0
 8. UC Filter            	 0
 9. Flow Control         	 0
10. RSS                  	 -95
11. VLAN Filtering       	 0
12. Double VLAN Filtering	 0
13. Flexible RX Parser   	 0
14. SA Insertion (desc)  	 0
15. SA Replacement (desc)	 0
16. SA Insertion (reg)  	 0
17. SA Replacement (reg)	 0
18. VLAN TX Insertion   	 0
19. SVLAN TX Insertion  	 0
20. L3 DA Filtering     	 -95
21. L3 SA Filtering     	 -95
22. L4 DA TCP Filtering 	 -95
23. L4 SA TCP Filtering 	 -95
24. L4 DA UDP Filtering 	 -95
25. L4 SA UDP Filtering 	 -95
26. ARP Offload         	 0
27. Jumbo Frame         	 0
28. Multichannel Jumbo  	 0
29. Split Header        	 -95

---
Thanks,
Jose Miguel Abreu
