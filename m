Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C2B132655
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 13:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgAGMgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 07:36:42 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:37404 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727834AbgAGMgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 07:36:42 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D0DE3405EC;
        Tue,  7 Jan 2020 12:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578400601; bh=HZEWeToSluP2P7XemVLVhSS2ICpKePUp1ZMffsTD9vA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=kfLVBGmMFSRtWGWJn6lODq9cORpGEfjMsIhcvbS/nQ4lv4dqfTYtFVeC4v/3FcXk4
         rb/onrxgNZ4m/tlr1fZoxq4aK1Qc9SD3iNMYqNzqkCpO6+7sI21Tl3WbcthjZfIOFz
         F3sH6z56QoloShYACS0DKoduRwGtjg2DaY7NHOuyyiwNW0sLoLu9MOE3Izj5uzRzit
         765wlTyScYepTuZdZW5Io5iaPPD0t9OL1lITPUgz64NX45Mh7Sj/xvrb6g5zjoAQUb
         OknHQutAYJS04zZeGQDNalT/N5Ff/XDTz7icmGDyUh1kP9Wvccqvy4HAPXXDOubHcI
         SfRvycV5phpWw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 80ED0A007A;
        Tue,  7 Jan 2020 12:36:39 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 7 Jan 2020 04:36:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 7 Jan 2020 04:36:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dyfaja/ZaRloGLABwSprA1hhAuy5gnO56R3r2SJ0VxjZa8LdgT9PByPD3HhJKPBNN9Or5DTsS7TOt19IFDVkh/g3mgKs9A6ljgwXKGaIIutozdIj6IHZWR5lnd15GBB1FTN7E7fc++uJalUC3LRY9vZQw8tbPwPovncsVy47l15Lra75q5HFkFonEt20kAWBjQSVUYCm80ZzB7jILI2Zp9TRdD6VWakIC+xHM6QmilEZq2ohmtKhIjvs88aMJd36/dnPgAEVlx5wywgnSx7BFPAKxmmlV5kzGLhAWI0jF2Lj+2AB238JimB0tg6TDMmN/hhdXbJO1DMbFRQmolMIIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZEWeToSluP2P7XemVLVhSS2ICpKePUp1ZMffsTD9vA=;
 b=ixqql9ZOvWChegMCloPpGYU1eJNL3VAs/eVuP7BCQTupYclD+/Z70rm1vKjzPN9zBVWNt42i/jYauqLjKLK65TLbs19XzyaITpNt6llQOXDswCcdsPKJnOQYDD1S13XgkepFbbW5hFBGCS37tfhVNy0Gf4MOwFDoP0rx9Jo7o1YSIuCMBBQNjhTA7iAlP1lxthHmnC4cWqTcXyOgdzasaqMY6DBbKm9x3ETYtL4w2qBwvvETQHzd3F6AYwUtwKNpbdlwRM8pvTg5gHtlHR8DM8ZYvPCA68mUuNbMZfFi8i5Gy22onGg6LNL/41F8ahy+bMWIR8zPSaeDxvFHnpb41g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZEWeToSluP2P7XemVLVhSS2ICpKePUp1ZMffsTD9vA=;
 b=H+MMPLoUFbVu0J1ptR8dpMa6AZI7+EvfmfrJbUgroNhlXAeakgW3Ms+7rXfUr8/vOzz6u/4HPOGHqWWQRFg/WOnehlGh/L46/yfXdlmtuHVvcQxPx+bjmtEkW0JpCyEcS0jm1V+TtrOuhoCQjeb55O/kROhd+q1IN4wtrlatuNQ=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3009.namprd12.prod.outlook.com (20.178.210.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 12:36:32 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 12:36:32 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Sriram Dash <sriram.dash@samsung.com>,
        'Robin Murphy' <robin.murphy@arm.com>,
        'Florian Fainelli' <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        'Heiko Stuebner' <heiko@sntech.de>
CC:     'Jayati Sahu' <jayati.sahu@samsung.com>,
        'Alexandre Torgue' <alexandre.torgue@st.com>,
        "tomeu.vizoso@collabora.com" <tomeu.vizoso@collabora.com>,
        "rcsekar@samsung.com" <rcsekar@samsung.com>,
        "khilman@baylibre.com" <khilman@baylibre.com>,
        "mgalka@collabora.com" <mgalka@collabora.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        'Padmanabhan Rajanbabu' <p.rajanbabu@samsung.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        'Maxime Coquelin' <mcoquelin.stm32@gmail.com>,
        "guillaume.tucker@collabora.com" <guillaume.tucker@collabora.com>,
        "enric.balletbo@collabora.com" <enric.balletbo@collabora.com>,
        "'Giuseppe Cavallaro'" <peppe.cavallaro@st.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "heiko@sntech.de" <heiko@sntech.de>
Subject: RE: [PATCH net] Revert "net: stmmac: platform: Fix MDIO init for
 platforms without PHY"
Thread-Topic: [PATCH net] Revert "net: stmmac: platform: Fix MDIO init for
 platforms without PHY"
Thread-Index: AQHVxRimtok0wFzL+UGNRMlNrZMzLafesXQAgABWhwCAABXNgIAABhTw
Date:   Tue, 7 Jan 2020 12:36:32 +0000
Message-ID: <BN8PR12MB3266EC51599357258E6E2292D33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <CGME20200107050854epcas1p3c1a66e67f14802322063f6c9747f1986@epcas1p3.samsung.com>
        <20200107050846.16838-1-f.fainelli@gmail.com>
        <011a01d5c51d$d7482290$85d867b0$@samsung.com>
        <59cb4087-6a71-9684-c4cf-d203600b45a9@arm.com>
 <014001d5c553$ff7f06d0$fe7d1470$@samsung.com>
In-Reply-To: <014001d5c553$ff7f06d0$fe7d1470$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7be4ce4-4321-4e75-1d96-08d7936e3a21
x-ms-traffictypediagnostic: BN8PR12MB3009:
x-microsoft-antispam-prvs: <BN8PR12MB30092DF05339C75A6EC5D0A0D33F0@BN8PR12MB3009.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(136003)(376002)(366004)(39860400002)(199004)(189003)(55016002)(478600001)(54906003)(110136005)(966005)(4326008)(6506007)(26005)(316002)(186003)(9686003)(71200400001)(81166006)(2906002)(5660300002)(7416002)(8936002)(81156014)(86362001)(33656002)(76116006)(66556008)(66476007)(66446008)(7696005)(66946007)(558084003)(64756008)(52536014)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3009;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y8NsU4IZ7AB1nwFzf//h6MepTFJeUU81AW1r8PzSWnIoShfBRqtamYk2nIlN7lFUR6V1xnj895/x4p1Ksi53a8dOVmokrjENm3A6hhvspye0FEtMUDcNquOVR4wlxBgpMj6wbF9MW35CB+aCQKDuyWWfNafeF+obFebcpgqs8UQd+F1YRIiMK9BLLFfFKwyyuWiRbcRYaGKb5fMH0XIoW2dfPQsJ9DEVjVv7OS7ajrjyZEFW+/IP9pTgqsQiAKRY2WLx3HSJt8YnekuBL+vlBzkMuQYxHa5nYJyS4nXIBfPWOYoNKgNBx2iUsubqagCslGDhBhSMu4lhPS9QMJ+dHHbpBXeEQxjFqnYq5NREdwvF1tOFtzNARb8/PTy8Cd4YcuSVPc+GLL6CVuN0DKdCwp2GYiQAPzYxRKk0iFH6cZc1mS7pIs+1dwAJeMG67OECNVBR2rTNS6xZuVkB/c4zgzcQYALCWWh2CfSTlJSlINI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b7be4ce4-4321-4e75-1d96-08d7936e3a21
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 12:36:32.5120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4RoLGqUQSwR8N5j5cws/UuSJEIqG15q2OTZkA4DE1THboL5zj101BHRpX9vukOYE/gYGt5lC34o+qmkpMmgrCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3009
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU3JpcmFtIERhc2ggPHNyaXJhbS5kYXNoQHNhbXN1bmcuY29tPg0KRGF0ZTogSmFuLzA3
LzIwMjAsIDEyOjE0OjE5IChVVEMrMDA6MDApDQoNCj4gQ2FuIHlvdSBndXlzIHBsZWFzZSB0ZXN0
IHRoaXMgb24geW91ciBwbGF0Zm9ybXM/DQo+IFdlIGNhbiBwb3N0IGEgbW9yZSBjbGVhbmVyIHZl
cnNpb24gb2YgdGhlIHBhdGNoIGlmIGFsbCBhZ3JlZSB0byBpdC4NCg0KQ2FuIHlvdSBhbHNvIHRl
c3QgdGhpcyBvbmUgWzFdID8NCg0KWzFdIGh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcGF0
Y2gvMTIxODc2Mi8NCg0KLS0tDQpUaGFua3MsDQpKb3NlIE1pZ3VlbCANCkFicmV1DQo=
