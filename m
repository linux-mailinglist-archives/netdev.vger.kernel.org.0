Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D214188969
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgCQPtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:49:08 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:56030 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbgCQPtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:49:08 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8ED43C04F5;
        Tue, 17 Mar 2020 15:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584460147; bh=LO3LsaNP4SOFsCWvyXXpyw/MarGKmg0EdWyr0jJgjFI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=YNmv3pGLg01bnk2aA/vo6dmk2IE8IHGXeZLOzUE78uUW3yflJp8Zo9k8Z8Nd4e5e1
         rIUMF5T0JIsDww+TTVcnFloREHPBIn2wmtbmyxp3vbeS9aXwH7x5uZtXNrDkUB5EJe
         glvP9ylyTo2r6QGipc0+PNz1spR4vSixFI3eWqsKPCbyIwLS5BiLFlCiJv3uV8KBjC
         jnuyLThwqRc39iY6jJqkElADmA8gj67GSqG64QJOcVHPkqEfO3hRl6MOWCeEIpnMnM
         szBlN+UPAHX6qpeWhj2r9iQ1M+OvbOm1Ti+WCoKL7NO0LkVluXoxPLlDd4dyAuSXNz
         uSiir0rmt5ZRw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id CFC68A0085;
        Tue, 17 Mar 2020 15:49:04 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 17 Mar 2020 08:48:54 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 17 Mar 2020 08:48:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJXbDedC5QMNwuweicISyVi7sGuw69zU/n+bptYNkWWc2LX+wiPqqUScdOVcM054yEUDcQdA/2WBYooUjsoxv3qQqCt03cBPRi0Q+yjN4JAEs4DyDwu9bOz6HGx7trVALdSuI5VyqMr0rKXoM81G/UM3anF3t8ZMbpSwy4jmmta7mWvTNJVLEsBHSivKxmnwou4m9aaK6lZVB/OJfo2UOJv6bbvLDirCLF2ZBSLhDJYAiUFShzI3fvTERjOEx94Mq/XrXQ56Gwi3SbBORRVJrylRfGfxgxFU1vU50UACJIiB8ACj8DU4uhCzJF9Nu6nApk9RTNFTucp0Hwh3oenX0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LO3LsaNP4SOFsCWvyXXpyw/MarGKmg0EdWyr0jJgjFI=;
 b=JBfIMHjlKzQhlLa8IZ8K9P1BbYGUsj7CNMkkFumPotko8TavE+Ba6OjvITcyyFuCYpiO6+7KyijW2gBiztHGa/K0hJMgbZ5JBJJoxewJFIqdU3v2cBztmsG9xWjYaCnaIlFyWCb6rz4mFfJtUXxH5BuMg4/VBG59FjPT9uyEpBnXdBJVvZRMxnssEuf2934Az4Plg8Ni8WkCLIjFa/WONBs6S/i9kWFn0QqKSQHEP0CsK1v8ZCLG84miToQeyivQLy5DebAJ25Gu2fgXY0cEOYaouzeoBjdDHCJfgmsdVz5RdHJQJnJYzS+7dkSc7No4pE4ZkNLYjBRhn4Xezi10MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LO3LsaNP4SOFsCWvyXXpyw/MarGKmg0EdWyr0jJgjFI=;
 b=GJgFKRv5M5x7E00zi7Hd/ILmxmolaSMgu+q9e2HRiowMU3M5Kasy59KZ1hPXs21S4YtcMbs7BlLzx4KZgRv+YijtF5OVpyDgJgkRDeuaZM7AUo2x+lpOprV1xNdRl7TbnnEUN2XHA6iEfMDltTKRyODGSbgYYKOuUK76pkpuEDw=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3427.namprd12.prod.outlook.com (2603:10b6:408:62::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21; Tue, 17 Mar
 2020 15:48:50 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 15:48:50 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Thread-Topic: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Thread-Index: AQHV/HG4xNUA04fN3kCshkX6WTztf6hM7Dow
Date:   Tue, 17 Mar 2020 15:48:50 +0000
Message-ID: <BN8PR12MB3266FC193AF677B87DFC98C2D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bcacea1-7160-4619-f56f-08d7ca8ab003
x-ms-traffictypediagnostic: BN8PR12MB3427:
x-microsoft-antispam-prvs: <BN8PR12MB3427272E8DA5728DB608EA90D3F60@BN8PR12MB3427.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(376002)(366004)(346002)(199004)(186003)(316002)(26005)(8676002)(81166006)(81156014)(54906003)(110136005)(8936002)(4744005)(5660300002)(71200400001)(76116006)(2906002)(66476007)(7696005)(66556008)(6506007)(64756008)(66446008)(478600001)(66946007)(52536014)(55016002)(86362001)(33656002)(4326008)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3427;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NSu/q8Xnwc/BKS+XmWocHOCj69VbBi9O5jdlOo53YBF+TjZOaogFDGiY8g3SNku8HkE0VOBWQtwt/Oq3i6+LWCkbMHwE+ZyGhTCfYj7vwzW1Hr9sKTP6liFqZOiaugKwboP3sEO0LaukbivzQmFYA50Dc2Dfu2EsyqH1Fd4WfAPSQWvNyWbxbEZCE6Ne+9aqNSVvpc9XNc7jPmYzW2IT2vrHHzfGmzv6HBvrGeGUlFAQb7tC5yXynZYvRQcblrB1nYCIrHsaeJROkISQvixgImRFM7yZsFRqZQlEo7WrolqT770cwSf7JrbL504PXpDHX6jzq+zEcJvwnOQKki5O96VQKiHae3bPACInd4913DEPKeyqnfs+c1nwkG3oHbPv4tWEdHWJbs+FuWGJzQOBTdBFlMXlLgmhP8NUpB/wSHRTILjcTOX0otVCW59C7k39
x-ms-exchange-antispam-messagedata: VQzFjzPZQ4G8coD76lKjOlqj1yCde1dqLf7Qfx90QH7hAHE9C+uYd7mEx7wEESHc0AgYG2rJ0El1wMvXLImpZjlvaZrfAugWKRoh2/xz9IHtzdjbL/SG1UzMZUuZ2HfJs8g9YpBHWMB6WX5pMDcmUg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bcacea1-7160-4619-f56f-08d7ca8ab003
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 15:48:50.2742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 14JSV/7zLKQBOJ2dQvh+9U7fHjdcjCNhwwOMb2N0HAKFYGeu/xHF8HpZW6WmNXuS4MXBNPNlAlADRW1Yj/Z2hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3427
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUnVzc2VsbCBLaW5nIDxybWsra2VybmVsQGFybWxpbnV4Lm9yZy51az4NCkRhdGU6IE1h
ci8xNy8yMDIwLCAxNDo1Mjo1MSAoVVRDKzAwOjAwKQ0KDQo+IC1zdGF0aWMgdm9pZCBwaHlsaW5r
X21hY19hbl9yZXN0YXJ0KHN0cnVjdCBwaHlsaW5rICpwbCkNCj4gK3N0YXRpYyB2b2lkIHBoeWxp
bmtfbWFjX3Bjc19hbl9yZXN0YXJ0KHN0cnVjdCBwaHlsaW5rICpwbCkNCj4gIHsNCj4gIAlpZiAo
cGwtPmxpbmtfY29uZmlnLmFuX2VuYWJsZWQgJiYNCj4gLQkgICAgcGh5X2ludGVyZmFjZV9tb2Rl
X2lzXzgwMjN6KHBsLT5saW5rX2NvbmZpZy5pbnRlcmZhY2UpKQ0KPiAtCQlwbC0+bWFjX29wcy0+
bWFjX2FuX3Jlc3RhcnQocGwtPmNvbmZpZyk7DQo+ICsJICAgIHBoeV9pbnRlcmZhY2VfbW9kZV9p
c184MDIzeihwbC0+bGlua19jb25maWcuaW50ZXJmYWNlKSkgew0KDQpQbGVhc2UgY29uc2lkZXIg
cmVtb3ZpbmcgdGhpcyBjb25kaXRpb24gYW5kIGp1c3QgcmVseSBvbiBhbl9lbmFibGVkIGZpZWxk
LiANCkkgaGF2ZSBVU1hHTUlJIHN1cHBvcnQgZm9yIENsYXVzZSA3MyBBdXRvbmVnIHNvIHRoaXMg
d29uJ3Qgd29yayB3aXRoIA0KdGhhdC4NCg0KT3ZlcmFsbCwgbG9va3MgbmljZSBidXQgSSBkb24n
dCBzZWUgYSBtZWNoYW5pc20gdG8gcmVzdGFydCBBdXRvTmVnIGluIGNhc2UgDQpvZiBmYWlsdXJl
LiBpLmUuIGZvbGxvd2luZyBQSFlMSUIgaW1wbGVtZW50YXRpb24geW91IHNob3VsZCBhZGQgYSBj
YWxsIHRvIA0KcmVzdGFydF9hbmVnIGluIHRoZSBzdGF0ZSBtYWNoaW5lLiBUaGlzIHdhcyBqdXN0
IGEgcXVpY2sgbG9vayBzbyBJIG1heSANCmhhdmUgbWlzc2VkIHRoaXMuDQoNCi0tLQ0KVGhhbmtz
LA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
