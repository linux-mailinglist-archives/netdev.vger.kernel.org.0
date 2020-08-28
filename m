Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B30255C6C
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 16:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgH1O3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 10:29:21 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:45408 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgH1O3R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 10:29:17 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4914ba0000>; Fri, 28 Aug 2020 22:29:14 +0800
Received: from HKMAIL104.nvidia.com ([10.18.16.13])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Fri, 28 Aug 2020 07:29:14 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Fri, 28 Aug 2020 07:29:14 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 28 Aug
 2020 14:29:14 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 28 Aug 2020 14:29:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ey9zyxjb/ES7aBEcfIKvY2iEqWesu4RrCaaYJUqnXfoixq1nJTzT2UqCs/XPgfVu3zPkKYrQJpj8RaAFLA27by6qg3NZR6NAKPaySN/pSkrN02add+s1T2eWyPQEmM/LWImAs9sxLsPSlgBmJWqamUdTOs4UQMMpNSX5/0DqI+36GqrXqjrpQgfSH+yLicAa7nOIcJS7IP9c16KxNUpLzExPWTafNdp1cmytfteKmntKWCgyUuSy5UpKWmTKb/ZtezJ4FMtUW6WxtTqLxwm8mftPcytnTg9nT0GPh0yytvixyZEpNJyB1VBSY4jmOR/TtYkljVcqnOpk0N9KS6H/HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bsMnIncT2ZEn9ofX9LC+43x95j+zplJhOW8+HnFjOs=;
 b=ZYDMZKrgJJsyUUJysjsobfxDRk+9wzDHj8ypb1VEBvyeIwBXh82EU5PGFY2411YlC7dUMQG+JYWIcShaHs8UXh6agzvEe4zTEzwuq/oZ0c4mqGD6PLGrpRRBRjG0+fTASkkL72ZQoW7bpP+n34Z/KI1uvlfxB1s+Z7kO0DyroZJQYfimUy0rEjSZxgiAjbsh3DevM1AASq/iKE3MonC1BWVCBjADNYnfoSIrzdEpV1IBY/eHTU3NEWqIfR5LR4HFpXF52L18O/0Ld2EwLI5fm+Dexaajrd5/Gl70rWX1Y3GvgqmnxkpjhJqMxJvrIOM9uggvX0/mmhqx9JIC72K7fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4165.namprd12.prod.outlook.com (2603:10b6:610:a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Fri, 28 Aug
 2020 14:29:11 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::150:9678:b51a:640a]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::150:9678:b51a:640a%4]) with mapi id 15.20.3305.032; Fri, 28 Aug 2020
 14:29:10 +0000
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
Thread-Index: AQHWZ2m1HXVRhRunfEuitWH9aE9Z16lNv3/A
Date:   Fri, 28 Aug 2020 14:29:10 +0000
Message-ID: <CH2PR12MB3895E1621A2B120C1CB3BB6CD7520@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731183756.GF1748118@lunn.ch>
In-Reply-To: <20200731183756.GF1748118@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [65.96.160.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49ce11b9-e967-40fd-f8e2-08d84b5ebb09
x-ms-traffictypediagnostic: CH2PR12MB4165:
x-microsoft-antispam-prvs: <CH2PR12MB41653C022A2553216D12F6A4D7520@CH2PR12MB4165.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZoHkFgf8195BE4TBR75xc0nmHATcXGRSxPfhmuCSmrBHijYqRFRAL3cpJNppteH6dTCWEnn4ZI3Nnb3iUz5HgPWwZPfuqZooONdNbJ1NxJn4+aDXPR5lI4Y88BzEabWb+pyn03E9VcR517URgau8Ljkt2G6TT/LVq1y/a8uhtqarIPutzxCs1hPlFCGp6bvfD53EYwN/pgO8MSR/Mau3Vi5lEQRgqBbAZmwPGnjgrMD+W9lNvESpuTMqannQS6PLB+3o12RU4gF9OpREupZQ9fbjcagTV3hI0qctSaAxJtyQ+/XQehS8Ob1AxtUE15r/Wz9VbiArrblTEPqnA5aSrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(8676002)(33656002)(8936002)(498600001)(110136005)(54906003)(55016002)(186003)(9686003)(26005)(86362001)(66446008)(76116006)(5660300002)(64756008)(66476007)(4326008)(107886003)(6506007)(7696005)(71200400001)(4744005)(52536014)(66556008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QT3TeY+XaMV8qVkvPjsj34PIDlVmIHVTtEoASSGyCtFs4YbX5K1LqGdbchiKtZG8eQSixymg4TGkHyLWD2OaZ9A7nrhu+pmL1SQXm4+ArCHjzm7I1Rvb46pA5jA0Q8jbV5haCWcNNcUUwhkFSWsBGG9k9/W5NSNF0evQh85bgq4Yw3yS9LSycsw4DicO0UsyAWqFg0EMDRnBWV/pRVQJ1UKUhCtDmKM5autMsBoiVLrJVajxKfzPLzt8QvYaUWvCXThSGry/WKlQfw3OfVPLRz4wILwvkk1gni9YQ6+hFFDQ9Q4c6fQAO8cHiSmwcP2DUon7hWZjsDIumpBOOeYge2Z2ZT/mn/3K4xF6UjdR9kXz48yzRWfxdrxI2ibqaPjQjOwOM9zdszFt2WJRE1cYyiccJOy/8N5zssuzeygAFk8uzmny6iOITp2feFD/JM1SrAWTyDP7nj4xjqCfk6X0ZmT7n+XiNagERgYFaY0l8dTOMFnrdxo1ZAsVvle8b/CWYBk0pyoBw0C6Zl8NYemeCTsbXf22VXVyi0ZEQDoT81zjvMqYXT2HRT/IFNnZSxgXXGS2suP7EMltwqMyQGuhodKH1mwaf9hrEmhARQ9i8M1/xHIlNPOMuubJ4CIafi+MCCrCrjrysvrTz1cmGvKFAQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ce11b9-e967-40fd-f8e2-08d84b5ebb09
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2020 14:29:10.9037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IPKBY656QgpT8Gokxv9nOs62vWxoQ10+DA23i2UstJ2HdpISsyfPj8/80Sv8XJuonGsPyfixOohFC5wDYNe5aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4165
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598624954; bh=4bsMnIncT2ZEn9ofX9LC+43x95j+zplJhOW8+HnFjOs=;
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
        b=RA4ZZEcV/r6+SXV1JaPVuzK5zQO4Wnn/JS5Iz6VAJsWShq6LKClNpk7hWy5/W6H7v
         dJz5J3UCs2j+xAEbwFv1aUUVbJ5Q5nfUAEGXZBR7+8y1xjG8NuMNabDc0d/wepI0dy
         9dGO5IWKlsJ06Na7AS9aK5eIPEEMuIDMkZB58JGh5F4rjKVgDkMBKurHnLFVSAjeWs
         BGe2JNDX6C4aD/8FwMw3nc1d8dA2KaWquPjJzYZ0CmSiS94OixZqqNfsBYKRdydkOp
         ePejk2AkxsmaeMeBuam3tAvYY+y2S/KwirIuP8m3NZq/6qk+1rK8FlzNcRfJHZVNqu
         RMPCX6fIx+EVw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int mlxbf_gige_get_link_ksettings(struct net_device *netdev,
> > +					 struct ethtool_link_ksettings
> *link_ksettings) {
> > +	struct phy_device *phydev =3D netdev->phydev;
> > +	u32 supported, advertising;=20
> phy_ethtool_ksettings_get() and maybe phy_ethtool_ksettings_set().

Sounds good for phy_ethtool_ksettings_get. However, there is no use for phy=
_ethtool_ksettings_set because our HW only supports 1G full duplex speed. (=
and consequently aneg is always supported).

Thanks.
Asmaa
