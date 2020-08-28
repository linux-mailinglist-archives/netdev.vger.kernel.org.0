Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B831255C56
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 16:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgH1OYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 10:24:36 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:4927 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbgH1OYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 10:24:32 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f49139d0000>; Fri, 28 Aug 2020 22:24:29 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Fri, 28 Aug 2020 07:24:29 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Fri, 28 Aug 2020 07:24:29 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 28 Aug
 2020 14:24:29 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 28 Aug 2020 14:24:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdgLVh1MDMq0YS6vZ25xi1EjGU19N/3/5Mw6Kh6Ru1ZpB9+SkNpGxuFRu7DpuRnd5f2hI8z99RGFd8r368YkC5pCTXI5VcQhROu26b4kiK763Sq6yMV1Spx9DeyRVwENSPhFdzV+ZOHsAh5pc26u7Mwy0traAmL2PF3PTCb/38xp/qxzIAppo/cQcp+6zvQwbWkfUdQynytCjn0jspdv1pCLq8WtLJiz2UG/4lWeVK4JV3a38fET2lJ634NJpumEKvZCQ2Ig6WFEpADsslLdSgeWVFlqhhFHgxKgu6NWsFDXDM7HI7ODSWpr5zpc+1wfKqBYGIofoHb4uYhJmuL+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OfZzXEWSFAwyI780f4FP2p509ToTtmAbgYLBFFNy6k=;
 b=dSWNA9SCDVaHMML/3IjCe2bYS/4SNAaVrU2YK17qlrIUb0Al3LjDmYAcRC47vY+wlVi0mK1EqvXsKN5BZns4A9F7Lr7hkW031HPs4AcVUR+Vs0ZkitVrK0tAKbCjw4vVNa74Be/ZRVp90Qz4Pv0Z7U9pW3CyQx0UALiK9isHEzLmqx1U7hv5zH5lLb7eN4JjhBeVLXKuFJdJNlMrZ4q039I9kCnUlMwGBBMRB5R3VkRkr+7yGJ5I5/xlpI6fBdtH2QCaiLpAUVZ/rH9VAsD69qfT1D1YukLjnfkc7qqU+xsrd7SOKZ1LpMgG4+wgYSgm/UuikT0oBLVRwTobIZxn1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB3685.namprd12.prod.outlook.com (2603:10b6:610:2d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.22; Fri, 28 Aug
 2020 14:24:28 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::150:9678:b51a:640a]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::150:9678:b51a:640a%4]) with mapi id 15.20.3305.032; Fri, 28 Aug 2020
 14:24:28 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        David Thompson <dthompson@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Asmaa Mnebhi <Asmaa@mellanox.com>
Subject: RE: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Topic: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Index: AQHWZ2nVHXVRhRunfEuitWH9aE9Z16lNvlMg
Date:   Fri, 28 Aug 2020 14:24:28 +0000
Message-ID: <CH2PR12MB389568AB4EBE620FD22894A8D7520@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731183851.GG1748118@lunn.ch>
In-Reply-To: <20200731183851.GG1748118@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [65.96.160.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08fcfac7-18b9-4a14-adc2-08d84b5e128d
x-ms-traffictypediagnostic: CH2PR12MB3685:
x-microsoft-antispam-prvs: <CH2PR12MB368577EEE2C1EDD113269452D7520@CH2PR12MB3685.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fp12OfNWML2ppG1RjUJUEZXPQdtKy1pqLwzDsfMYyPPa1H5WOhw8qUzovnKp7JASgIbmdqxZifilYVy1AeVSmGaAR6KHQVawRp+xb1hOjTbru1JMyWA3RGV/coxSU4RyJ7t6WRTfTLr0H/gSWbhmnj6XR9ltj8x9S9vcuZ3n1p8zslpuuJpRlaNVaZHfD4gYuLV2KXBFV7N3jJc4jEVRyss13oW1ewDQ4elwQAW6kL+WucMX4q/W0Yk5QUN+nM6KaASRDOe7pplVGn0xy0bwcS4i/oXbxWFXSda/boT842FfcFuLcAZ6SrERbOIdaadO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(2906002)(6506007)(26005)(66946007)(186003)(76116006)(33656002)(110136005)(52536014)(71200400001)(64756008)(478600001)(54906003)(66446008)(66556008)(86362001)(66476007)(7696005)(4326008)(4744005)(107886003)(9686003)(55016002)(8676002)(8936002)(5660300002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TMmhxcg5DLoK/L+Yx6RSEdhs3P4KL9zy8j/VWbem4ofJLwz4I83V+Rgy4PldCy+TFdPqbU75ML5Z+CmKDOII8faF+84eU3k5j1B17+v/SVH00mdcsLni4QAaem4lbE6h6LNp7gUEJq1b8qBO6sBrbs6WcrAExvkQEUITPBdHmxDS10speVWJo/tXeyg50acYAt35+N5USIcsqbM4hudoyXHne9p5qp/+qpa5GuiFACLnFS5tEIZJPlBrLUalkNaFMvuHXgCTvvnXE1CQYhPcBpWlj2BAz0zOPGVaNPbbd5ysEbkEcdrmCLYJ/ZFj41+FpJc/3VceQulXnuaAMMmzDGLYsH1TfneiUh+L8L/3QOKqaWRyGKaCNMTGorTvgvX+8vKm4lLIQSbf27bA+yI6srBKqs6LLxZpcYehcmUhv3/0x2LiFhuWZy6ANvZzty8jdh9d7p9LvdhINjtuAlHMjK5iV0j1bx0WITEn7NmXs8gkqCPUnNv6l5RCiqaOTrmFXnGe3nCYKcveK0vQgbfpy0kmpaofomDxanvnXUoqxbTO/9oJc5ZXB9G4xmNgCsXmoz7HrVhwi8+APss3tvXAwowvOXwqpbyp4OClKjeUnu8xYo2nzSzlvuOkSwr7DOzBP+w2QgN6aHjhBtblFtby6A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08fcfac7-18b9-4a14-adc2-08d84b5e128d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2020 14:24:28.1710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uQwUPAkLBkM4cGcpW1rVybs/j2vmFyEjusE/4bzKs5mUTNppKDnIA2Ef2bnZ4vO20F80dI+fhfC5Q5Wb8is+Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3685
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598624669; bh=0OfZzXEWSFAwyI780f4FP2p509ToTtmAbgYLBFFNy6k=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-exchange-transport-forked:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Pr4p9S1neG53GxqZvpdlr4327OHUjrzaxWM7R35j0oSqhLIDPsof3b6QVCuuR7kc1
         DMmYBJk6/FBEgckOt9oaY9iRSKw7LX129PvNRKXTJ/VEIQSVvAGGn/sRszLr6gCAXH
         cTf9V7t0GaREU6+ldG3en79I0+ZwQ+RuK0yaWL0V3WmFf2JKnR8TMFv64RF8F2tupK
         Irxt13ciqBB2554IPtKs9sRHVDBf+zfcF16zBDwoJvmHaTymqZCUyZpib4O2SG7hol
         pZomSo2Jv/9wjs5iM8WrVjwDmEKrMSXy08ffmgNegai8hwlwN/txyWGBHFLVKS/cAH
         s53/HsFduUp4Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	  The second generation BlueField SoC from Mellanox Technologies
> > +	  supports an out-of-band Gigabit Ethernet management port to the
> > +	  Arm subsystem.
>=20
> You might want to additionally select the PHY driver you are using.
>=20
It is preferable to not set a specific PHY driver here because it is suscep=
tible to change. And even customers might use a different PHY device.
