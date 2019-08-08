Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0CF85CA1
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 10:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbfHHIRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 04:17:39 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:42362 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731642AbfHHIRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 04:17:39 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DB057C01D3;
        Thu,  8 Aug 2019 08:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565252258; bh=Z3RSQRSNwamoSj/YmyHbqaph8isIWTY4mZSMT5l+LTw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=P8goSq+PxibvrjYDsOVR7b/p/dBnIHZMHqgsz7soHqr7qKIPys3pOOPgRTIAlNPn2
         nsPGs4X0YgI6+tAJF+FeyKAMjfA3WsSNjP/QGzDzU0XRr1BfjBIYdMG9apBWgGWihM
         V9xEnFjYknJiDBNVR2tRj4JaDDqMM42GEl6Fy++TZlS3g0AmooAv9kDqIkZ8JpJ55x
         P4Tyb7lh/8bZeawCF77IQL4R3sS7SlYNDpo7EibH9FuCF+3t+EIOwyEb3RU/jo9jBS
         2WWI6w0cep0rb3/WZGss9QuF6XEU1ZWpGB28dv7MDx2HorhDf/l+MrwxMcsJffJpkX
         S13ufBQ5M2a5g==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 937B3A0075;
        Thu,  8 Aug 2019 08:17:32 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 8 Aug 2019 01:17:31 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 8 Aug 2019 01:17:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/rw3U6gcVH6QjMHhkCjdbG0OXlLzqrc5R8q00E3jMF1Kra6gcEaVUkYnScbvYtzSDNODxxZIO/lTJA154vLzPDzyc3h1xnSV8ssceGb4GdevYGzze9g8nXqGCrAtekM7lnAXQzBWPDp2CsFcXmYzMSjudYgPXLCJ4V7tHM2mXSfROny2FMJ0YYEu7hjyoyoyR//GCIYkD7tiGvI8i+01RhlbPKZ5jttDWXb4Ce370A73NfE3s+HB5Fii4ir7IxRt1blu7e9zAri6lRj80MNS6qkMkj4FKJjYt1Wm3XilTmOcARxn/IWWtln4AnNANnu5apg7W6l88WD45ug9OYnLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OzvjAEkKhyQ2xsAAGvUTkRtKCfsI7tKkW6FH4+TBw8=;
 b=gEn+e61YIQModFZlyhWpnHzk+rbe81EU9L1EcFHUqZrHGD5hStsKskT58BSD7KMtONwaKBpWsNWHlLWtIeSiIqCdwtT1ddlW6KRhPTKdhXC5NgOtcFH41vebzON1FhKsNnn+4JVrNFyPszlsOovvB6sYy95wHM0iz70wHwqBKE7108Kk1uW9ZfYepAF43D/XoUJyUho3TnRjl9wA3RiDRZbIKW+pJVwxCuoqXZ4wHcVMTs8Q6IbgBvRDDN7Oi5UgvsIh5rDvOm/JFv+FaliHlKKbKG0zJQMy8yCH/mJ3ziRjezdI0uTYt81aW9bmIw0xHNFmk3vKLLHxePlL8ZjqZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OzvjAEkKhyQ2xsAAGvUTkRtKCfsI7tKkW6FH4+TBw8=;
 b=luBc6aolZstIMyMIWWnEyDLGw60602pM6Wx3xSQ7fxRrWPozPPiksFHn+Qdqqq82rSPQG+GwqfvmsVVVM29KAajubD05q+p97JT61sLyf7B1HwUON+Jap1G6zRVUhVj56d7C/p96YrKaq/hM0jjNUu9yczQZM90tIGZ6/4GjGro=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3121.namprd12.prod.outlook.com (20.178.210.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Thu, 8 Aug 2019 08:17:29 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c%5]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 08:17:29 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: Clause 73 and USXGMII
Thread-Topic: Clause 73 and USXGMII
Thread-Index: AdVNNhg1/QU8BXytSDGOHsr0Lj0BgQAi2zcg
Date:   Thu, 8 Aug 2019 08:17:29 +0000
Message-ID: <BN8PR12MB3266A710111427071814D371D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <BN8PR12MB32662070AAC1C34BA47C0763D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB32662070AAC1C34BA47C0763D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3275a300-340f-49d4-fd16-08d71bd8db20
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB3121;
x-ms-traffictypediagnostic: BN8PR12MB3121:
x-microsoft-antispam-prvs: <BN8PR12MB3121C6A1B837EC1AAAAD3F01D3D70@BN8PR12MB3121.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(55016002)(76176011)(52536014)(81166006)(25786009)(8676002)(478600001)(66066001)(81156014)(3846002)(5660300002)(6116002)(5640700003)(486006)(54906003)(256004)(9686003)(316002)(14444005)(2906002)(8936002)(6436002)(1730700003)(2351001)(186003)(86362001)(6506007)(66476007)(11346002)(66556008)(102836004)(7696005)(6916009)(476003)(229853002)(53936002)(6246003)(7736002)(64756008)(4326008)(26005)(66446008)(7116003)(74316002)(446003)(66946007)(2501003)(33656002)(71200400001)(14454004)(71190400001)(305945005)(76116006)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3121;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Rj48dcWzF+pudqf8TppxJNM8rwx6AErNrNpWh5NT8y1gR01T/T2nrrWByBcLgGgFs0G0gUN/W+tOqw2PzOCK4Vs/VkkAlx2Ejx2BXN7/43NNtaJZ8tbkGKyIbAKEX03MmubM2Xa7qHqUZdVOXst1Z/dd5KUJI6gD5ijFPXhigwTE52E+MXrHGWRm6sjJp/ecSdkaqtkuQXtvtQDhzQodHmx5+SHZtSQbPdjRo2qBvwhbGv0XRUjnLWh3JZxPOZGHqdbrIDExAmps9GMoUs3czDzZvIBxjT1Pk5Ke1GAwYMopbsmo9/7rIsE2NP2ATV10MZps+adNQfqffwSA58sOda10X413B/J/i9TV4jA4cJHMPFQzhLP2py3WVgfw/6w8C1MrBQ/7cZvScDMjXnfUlqIs48vcQojy9M2NlXIiZms=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3275a300-340f-49d4-fd16-08d71bd8db20
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 08:17:29.8103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sutuqPL7R2YbQ7GqA7XI63DvSphLAOGs6L9GoZlS2tnxqAbflHLGy0LP3R0fIuqIw/UhGbl9VJ87sof29XRnpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3121
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

++ PHY Experts

From: Jose Abreu <joabreu@synopsys.com>
Date: Aug/07/2019, 16:46:23 (UTC+00:00)

> Hello,
>=20
> I've some sample code for Clause 73 support using Synopsys based XPCS=20
> but I would like to clarify some things that I noticed.
>=20
> I'm using USXGMII as interface and a single SERDES that operates at 10G=20
> rate but MAC side is working at 2.5G. Maximum available bandwidth is=20
> therefore 2.5Gbps.
>=20
> So, I configure USXGMII for 2.5G mode and it works but if I try to limit=
=20
> the autoneg abilities to 2.5G max then it never finishes:
> # ethtool enp4s0
> Settings for enp4s0:
> 	Supported ports: [ ]
> 	Supported link modes:   1000baseKX/Full=20
> 	                        2500baseX/Full=20
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: Yes
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  1000baseKX/Full=20
> 	                        2500baseX/Full=20
> 	Advertised pause frame use: Symmetric Receive-only
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Speed: Unknown!
> 	Duplex: Unknown! (255)
> 	Port: MII
> 	PHYAD: 0
> 	Transceiver: internal
> 	Auto-negotiation: on
> 	Supports Wake-on: ug
> 	Wake-on: d
> 	Current message level: 0x0000003f (63)
> 			       drv probe link timer ifdown ifup
> 	Link detected: no
>=20
> When I do not limit autoneg and I say that maximum limit is 10G then I=20
> get Link Up and autoneg finishes with this outcome:
> # ethtool enp4s0
> Settings for enp4s0:
> 	Supported ports: [ ]
> 	Supported link modes:   1000baseKX/Full=20
> 	                        2500baseX/Full=20
> 	                        10000baseKX4/Full=20
> 	                        10000baseKR/Full=20
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: Yes
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  1000baseKX/Full=20
> 	                        2500baseX/Full=20
> 	                        10000baseKX4/Full=20
> 	                        10000baseKR/Full=20
> 	Advertised pause frame use: Symmetric Receive-only
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Link partner advertised link modes:  1000baseKX/Full=20
> 	                                     2500baseX/Full=20
> 	                                     10000baseKX4/Full=20
> 	                                     10000baseKR/Full=20
> 	Link partner advertised pause frame use: Symmetric Receive-only
> 	Link partner advertised auto-negotiation: Yes
> 	Link partner advertised FEC modes: Not reported
> 	Speed: 2500Mb/s
> 	Duplex: Full
> 	Port: MII <- Never mind this, it's a SW issue
> 	PHYAD: 0
> 	Transceiver: internal
> 	Auto-negotiation: on
> 	Supports Wake-on: ug
> 	Wake-on: d
> 	Current message level: 0x0000003f (63)
> 			       drv probe link timer ifdown ifup
> 	Link detected: yes
>=20
> I was expecting that, as MAC side is limited to 2.5G, I should set in=20
> phylink the correct capabilities and then outcome of autoneg would only=20
> have up to 2.5G modes. Am I wrong ?
>=20
> ---
> Thanks,
> Jose Miguel Abreu


---
Thanks,
Jose Miguel Abreu
