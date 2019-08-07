Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C697D8502F
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 17:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388730AbfHGPq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 11:46:26 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:37766 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387827AbfHGPqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 11:46:25 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0B91AC016E
        for <netdev@vger.kernel.org>; Wed,  7 Aug 2019 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565192785; bh=WFo3fq6GgoUTcA01mW+/oWaNxEpceO2ueU/N/MAkYM4=;
        h=From:To:Subject:Date:From;
        b=dUsjdkQ3ArnxQBISHfmW1xVht0QKfYq0O5ifwfI+xp98CNR9UTf1STFEp3PKuvaxc
         ei8O4gp5aJluEjl9tKiz55GMdSy2NBltwgHBvBzoggBJ3aNwVzY/BbV1tI2DWRm65c
         o1g5nSZ+SYVGQVCU0b86enSVgUixw6lJ6vWTu7h7oD7FaKyn50rtuL9PYk4OLlR2OY
         y75c/xGtPaUvnvUMMxmmFfpCI/CA7JhRLWEl1KfieU+jIUqikycqS0E4VY9l+UG43T
         M/DzpOIengNTWXYQSfsvlWbAKSejiiy9Di5F5zGZ98H7lHcB6CkICPtlEidJPNPlMn
         QqjHTX7W8GwlA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id EAB7BA008A
        for <netdev@vger.kernel.org>; Wed,  7 Aug 2019 15:46:24 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 7 Aug 2019 08:46:24 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 7 Aug 2019 08:46:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaSvzfr90DoGWjTPWEbBmOu6DjkPLADwWzANi4Cd6w47N7qVc14LQIaLPv+uR4WMB0gBTX2dTU1+gV+jKOq+iox45+s2ULSeGS6hrCeXzjbwKBEAd2hA5CCM9JncUfzxHjTzzWVPEcCbBJiKM7St4fv9dkDhRmrGYk/gMugQp8+JAwsL0PhXxbeHPAqN5JSA1R+b+Sr1MyTbx0lo5lCdGyEEIpb7tb6tGauLDGErCD02F0zbJBTD8Vu6cUcVmlCzCapO0UuNQKJKnLUEXz/lIy1uLB794FKcHvciFu/PB76o9hdNEeo6vwSwtpxDGWnYAQNxDN3urO+h+Eh3V6k7Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Suh+EYnKfl3RBu2y21qygf7zoOHMlTJjv+tJh3mdaxI=;
 b=k93qOu2CMwOjnTDaeVbo06Vj0yKRAz6MeTdlJNh+n/ivD2SBIs2z1//KHTydtsrI7/tw5we81mL65QwiN2xqyiO7ou5nyxUpUyQaglXQtJaaH9TW86gJTT1jb8Q50vT53cSMHPvNzO+jEhy+AbTfuMM1mxF8/435KDUE6IAzDwqCTmAALniuOkS+PR+RhOTTElZOELQvswrTtc/oZvcs/Jv+OA0Baf71XDaYPgRwyN2gI0g7RAhDz9YFIzrMkog5fJ/bm8UHYgi2Si00+DqBsvF6Wyu8yTfRSEmWr5oaZLrlPhncHaCjGTw4AswIH10jk+7mya11ypSfsz+rsBm4pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Suh+EYnKfl3RBu2y21qygf7zoOHMlTJjv+tJh3mdaxI=;
 b=KtFWt1mCpmILGlxJ2T7OQwFDY5KrVyVUmVjk6eDfEUtUz5SGEbhfH2etdU0UOqYwz4iUXL//fXBxgPNEJmIwaVX5/HS6ij0TIbMUGyAM4OmUnV1vGM0XRHKDP/Ea4k5foX/q+PEO7BT1x1A83fypgLwFjQcJvnjshqho9wiRSXc=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3284.namprd12.prod.outlook.com (20.179.67.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Wed, 7 Aug 2019 15:46:23 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c%5]) with mapi id 15.20.2157.015; Wed, 7 Aug 2019
 15:46:23 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Clause 73 and USXGMII
Thread-Topic: Clause 73 and USXGMII
Thread-Index: AdVNNhg1/QU8BXytSDGOHsr0Lj0BgQ==
Date:   Wed, 7 Aug 2019 15:46:22 +0000
Message-ID: <BN8PR12MB32662070AAC1C34BA47C0763D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10264b68-1da2-4f93-27b1-08d71b4e6653
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3284;
x-ms-traffictypediagnostic: BN8PR12MB3284:
x-microsoft-antispam-prvs: <BN8PR12MB3284F74DCE14AD99B8CB8126D3D40@BN8PR12MB3284.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(376002)(39860400002)(346002)(199004)(189003)(7696005)(33656002)(6436002)(6916009)(9686003)(102836004)(53936002)(99286004)(5640700003)(68736007)(55016002)(2351001)(476003)(305945005)(7736002)(6506007)(316002)(7116003)(486006)(74316002)(81156014)(1730700003)(8676002)(8936002)(186003)(26005)(256004)(3846002)(66066001)(14444005)(52536014)(14454004)(76116006)(6116002)(66476007)(86362001)(478600001)(66946007)(2906002)(5660300002)(71200400001)(66556008)(64756008)(71190400001)(81166006)(66446008)(25786009)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3284;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F6ieqgo0mFoJUDSkuLev+e8UBsvvPI8RS2YWnhTc9nOqExxeqmXr++AHSEMBLv5P3xQesZxRudm4Hry/5rBfWhOk0hFAbDWwIIea9Js77jp0J4EgMrxU4sb8PBP3jxNfXgQ+HwgBOu15I9KTlKqQXRUTvui3pAu8lBgPnfyz0VInr0jLvF/+Nr38fxVCRGv3qdM6QU9AbZD4AmzcCWN+Qy7aAVHYeMFrCq7wDWXp5PTEXR9jxog9TCDp7mJH6SkeVv/74dVeID31JEiDW+7wVLZ3b18cZcQlyEFZvPm/3dhiVV+GhebRv7ZFlQgHM47va0bONX3LIrirVMgzAiHkkVYBzvQhqJSQGwrmu/Vtu9GBRmJ3u+bOVlBozg0wXCJO/u/1hcY47w24NyiDYG85CmYxwdrpCqccbmCJ6lRH84s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 10264b68-1da2-4f93-27b1-08d71b4e6653
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 15:46:23.0861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eauFbKypqltQzkiWFvK/KxzIw+fAuZjBwWHX/Chy14ijXxvYBUA8DJqZM2FJxpaR6hwo8iyR913MX6tbCLm7Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3284
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I've some sample code for Clause 73 support using Synopsys based XPCS=20
but I would like to clarify some things that I noticed.

I'm using USXGMII as interface and a single SERDES that operates at 10G=20
rate but MAC side is working at 2.5G. Maximum available bandwidth is=20
therefore 2.5Gbps.

So, I configure USXGMII for 2.5G mode and it works but if I try to limit=20
the autoneg abilities to 2.5G max then it never finishes:
# ethtool enp4s0
Settings for enp4s0:
	Supported ports: [ ]
	Supported link modes:   1000baseKX/Full=20
	                        2500baseX/Full=20
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  1000baseKX/Full=20
	                        2500baseX/Full=20
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Speed: Unknown!
	Duplex: Unknown! (255)
	Port: MII
	PHYAD: 0
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: ug
	Wake-on: d
	Current message level: 0x0000003f (63)
			       drv probe link timer ifdown ifup
	Link detected: no

When I do not limit autoneg and I say that maximum limit is 10G then I=20
get Link Up and autoneg finishes with this outcome:
# ethtool enp4s0
Settings for enp4s0:
	Supported ports: [ ]
	Supported link modes:   1000baseKX/Full=20
	                        2500baseX/Full=20
	                        10000baseKX4/Full=20
	                        10000baseKR/Full=20
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  1000baseKX/Full=20
	                        2500baseX/Full=20
	                        10000baseKX4/Full=20
	                        10000baseKR/Full=20
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  1000baseKX/Full=20
	                                     2500baseX/Full=20
	                                     10000baseKX4/Full=20
	                                     10000baseKR/Full=20
	Link partner advertised pause frame use: Symmetric Receive-only
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 2500Mb/s
	Duplex: Full
	Port: MII <- Never mind this, it's a SW issue
	PHYAD: 0
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: ug
	Wake-on: d
	Current message level: 0x0000003f (63)
			       drv probe link timer ifdown ifup
	Link detected: yes

I was expecting that, as MAC side is limited to 2.5G, I should set in=20
phylink the correct capabilities and then outcome of autoneg would only=20
have up to 2.5G modes. Am I wrong ?

---
Thanks,
Jose Miguel Abreu
