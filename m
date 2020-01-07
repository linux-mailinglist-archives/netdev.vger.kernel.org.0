Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A120513225D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgAGJaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:30:10 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:59636 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727832AbgAGJaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:30:09 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 992D54064D;
        Tue,  7 Jan 2020 09:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578389408; bh=KpzZTU1qRng39gDYv9LbKr9ZYqpjWFrru/Yv251II9M=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=A1bHRj1qHdXTScpG6f5FVyS2jcQmroIhQc0lvubJ57ClqQpYL22RdvJzeicnSSyoH
         iPLZ4WuAYIrXPVL1qcyFGS/reDkJK94MHAv9xpTcBEPw/HCwGIrUc927ChM8j8F64v
         EowSrkT2IbFbRziNKloyr71FR60PAIUkdG0Bzcy2w/zbc5EyFIenmapE1qwSvym+tm
         vzq5I+8DPOYHLwEcZujs9liMYei1FrD5e5nxTsabGWRpCOAATU9Hui0fDqjLS7rjcp
         0bcKulcpa7WmAIsRgbKfiqoSTmjDR3dEkRr7rmGmv0n95Ey4pvAUNoqh/xOD4m0zF8
         6jwoTQba+4PSA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8895AA0083;
        Tue,  7 Jan 2020 09:30:08 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 7 Jan 2020 01:29:52 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 7 Jan 2020 01:29:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldn+2s52FC90h51LfutqWMrEHuCTreR7xiZg+bjjKlPQi0QiKYLhjp/1adquYUoEBf5kuBUSD1Y5zc96HsZj2FPvEu8NFZGLrdS1P9f/up8cYfqebMnxFTcU5n4keM7tUbQfvub/OxcX0tHbZOa0gNJhfpn1Fttc6teXtIbf0M1qxIYmIpPhovCuYo/yIMZaxNW8p/yXNjOGIEbs7p3WoH4HTO31RdLCBw92XBPT5CZQQuT4OPXnb+0bZTmvsnvt8TzkvaolJFIk5Dd4KIiLNC3kZQLHV6nqK9YPGP9ZJg0qUVjUMyx17h1SY/+a9xCz4KtMKpWMKufLVHiNNPO/mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpzZTU1qRng39gDYv9LbKr9ZYqpjWFrru/Yv251II9M=;
 b=jvTBg4R+JRdf9V27dTD8KIRQ66vCe1t6Q0+6w9irGPHgXJIdQzGGD0c/47BHzy9XG3epCaz4piQDwqImRu22zVPZyk1qDtrnjWjL0EBrGFKkjHdQpPY7AC/UrvTvlckDrE4Rqnngt/Kx1I52Fs+yoWKT+bG+FvXCUuve+RM+os4gA5vBnKRNxj44Cwhf/dR49O9jrobEXTYd0bAv8q9Uu30qKFhLky6hXjzEm2levZC7viiEIdIWXUGbC94t4OvLu7ARI4EDtBcYwGO2aYlFeoxfL1ww07O2UtcU33yHQdFMnf0tZYJ8SDOsAL6dNA2UzpAUq6f6nmxiwsGJzz9Szg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpzZTU1qRng39gDYv9LbKr9ZYqpjWFrru/Yv251II9M=;
 b=kkXX5f/wd2/H9WPCMxLEQLXbtNpXnhBLvOWowdHNnQystQlgS+okLQVZfBsm8gHfE0lkIeucJQhMfYUFpAuJ9o3wrjQxYKPMZBuagSb5d6aZcChhGjk90Sle3x90DKcgi2zv5OArISg1pfS4FKQKFHouVz+psxoIaGeN9Pbdclc=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3348.namprd12.prod.outlook.com (20.178.211.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 09:29:51 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 09:29:51 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andre Guedes <andre.guedes@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        David Ahern <dsahern@gmail.com>
Subject: RE: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Topic: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Index: AQHVtOPaDcyycxk/7Eqs7zmpoaCgzqfAhW2AgAAAN3CAHfDGgIAAmUHA
Date:   Tue, 7 Jan 2020 09:29:51 +0000
Message-ID: <BN8PR12MB3266015708808170D71B17C6D33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
 <874kxxck0m.fsf@linux.intel.com>
 <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
 <157835635771.12437.5922951778370014410@aguedesl-mac01.jf.intel.com>
In-Reply-To: <157835635771.12437.5922951778370014410@aguedesl-mac01.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec72b0b4-66c4-4802-d75a-08d793542599
x-ms-traffictypediagnostic: BN8PR12MB3348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB33484B119BF3570D3C2268F1D33F0@BN8PR12MB3348.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(39860400002)(346002)(366004)(136003)(189003)(199004)(81156014)(8676002)(81166006)(478600001)(110136005)(66556008)(71200400001)(76116006)(54906003)(316002)(8936002)(2906002)(4326008)(66476007)(55016002)(64756008)(66446008)(9686003)(33656002)(186003)(6506007)(52536014)(5660300002)(4744005)(86362001)(7696005)(26005)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3348;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k8rw47sFe0uqKVtH42LjdAK2CF1qKUCPw9+iMbtQEOu6WCzoUCajW6UQ13XaswSGGQ0suSi0WVsrDxlFgMbCHEfWinpMDzOQNBFEhk7yVCbk7ummNsUbx9Yw6XPi5v2OLIwFoJA4G79sH09/8pj3PdaZ7cfwbWnE262VkOptgKcNw2amWhFfOA/LPT53Y1CK06ZbXVmlWWgGsO11B1h4cSX3NzkFAael7+UPoJ8Mw5BvGfxcJYcJ3pjIX8PwWbRUH+sQbOQsy2gGPH9GD/hdC31eWJOVKnFNxRzAqFNDJpMIHPNdE7aqL7Wh8EVPcn9nD2ojvNazDjgne/RtHw8f4OqCNHRaGwMH4BjH5g3GU7EZuNBwChK/qKskhVVfM2PXETutayh7W4AFukCvGs/TLVCUVlRdueHt1GvFmG6/qLDKx1PHa5rCoCqsN4qIJPbB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ec72b0b4-66c4-4802-d75a-08d793542599
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 09:29:51.2979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kT2c6LuIbqjG7Xc7q+wC4nzXmQ9LiFYwnwPDSrrKVHG4BLSHd6c4hlEmBo/kDw8mmpSMdsOw8PbT3fr/BbTz0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3348
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5kcmUgR3VlZGVzIDxhbmRyZS5ndWVkZXNAbGludXguaW50ZWwuY29tPg0KRGF0ZTog
SmFuLzA3LzIwMjAsIDAwOjE5OjE3IChVVEMrMDA6MDApDQoNCj4gPiBPbiBvdXIgSVBzIFF1ZXVl
IDAgaXMgYnkgcHJlZW1wdGlibGUgYW5kIGFsbCByZW1haW5pbmcgb25lcyBhcmUgZXhwcmVzcyAN
Cj4gPiBieSBkZWZhdWx0Lg0KPiANCj4gSXMgdGhpcyBjb25maWd1cmF0aW9uIGZpeGVkIGluIHlv
dXIgSVAgb3IgdGhlIHVzZXIgY2FuIGNvbnRyb2wgaWYgYSBzcGVjaWZpYw0KPiBxdWV1ZSBpcyBw
cmVlbXB0aWJsZSBvciBleHByZXNzPw0KDQpJdCdzIGNvbmZpZ3VyYWJsZSBmb3IgYWxsIFF1ZXVl
cyBleGNlcHQgMCB3aGljaCBpcyBmaXhlZCBhcyBwcmVlbXB0aWJsZS4NCg0KPiBJJ20gdHJ5aW5n
IHRvIGZpZ3VyZSBvdXQgaG93IHRoaXMgZGlzY3Vzc2lvbiByZWxhdGVzIHRvIHRoZSBRYnUgZGlz
Y3Vzc2lvbg0KPiB3ZSdyZSBoYXZpbmcgaW4gIlt2MSxuZXQtbmV4dCwgMS8yXSBldGh0b29sOiBh
ZGQgc2V0dGluZyBmcmFtZSBwcmVlbXB0aW9uIG9mDQo+IHRyYWZmaWMgY2xhc3NlcyIuDQoNCkht
bW0uDQoNCkkgdGhpbmsgdGMgdXRpbGl0eSBpcyB0aGUgcmlnaHQgd2F5IHRvIGRvIHRoaXMsIGFu
ZCBub3QgZXRodG9vbCBiZWNhdXNlIA0KRVNUIGFuZCBGUCBhcmUgaGlnaGx5IHRpZWQgLi4uIERv
IHlvdSBhZ3JlZSA/DQoNCi0tLQ0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
