Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1811856F9
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgCOBbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:31:09 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:48357
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727304AbgCOBbJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:31:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jm5Tvw+FrWPmf3c83ya8olEr4BllxJmgQO7bjDi/5+OfQJVE6zV78xTqeeuf46NGYgalGF+N4GM51+SBXL1fSw4VKO8m/qA9yEy6KATG6V67SIWPfMizcvwlbu21F1U4MaYpTsdZraP48zVimbsTC4EaS1BqzcCRDOPTzLq6rrnMwcYsaSshAfRfEs5CFyrGeyMtvzZZiJGTG3p2Ah83hvcCWP3hBs91h/FX11dG+joS+6Jy1S3Q13xtLGkPackvMZDeFIP0ImTEfQ7F7mIZv8FC8ZxXWdAak0JsuhqwT3jsvO7on2rSJ4WREAi8RmBZuHNfsab5G1k8KTHvAqggNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEVWY+rypyvXETbtnyTbAWd+EumM6LiU9VVkj+/vLN8=;
 b=DiH7ZG8pJk9+NDjXNkoLBkUmOZh1ZtV2QRkDMEK+wKe7MjJSQy0/RFBrLPuYOc9j2WYrkqHE+r01/GG6ihtr6Nwo9A2QJAdFdoUCRUaEz4vYdWa87njWc0f0wZ+t1u2MIDqKOMdErpM4mR2LPS1/OSf84VQBBB89AP0mxsbbrQDqIpFmyjmgPI3QH7YV0gsJQekiNmHD2iw3oWQZzbweSRemMYiy/1SVsGhb5NKYWqkz3Ms4I0kyONLk/pMjL3Fg1M3w41jVUhzaa2tcjtEN6qVZB7m5wyqIFuC0tAbFqzzYv7pokRgJnvGazsOpLNUcqbY20pmoIgAl382+DidWGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEVWY+rypyvXETbtnyTbAWd+EumM6LiU9VVkj+/vLN8=;
 b=hm+ws5RBiz00RhgMIVH11tqoziPeX5mIloFa/EX0P1mWoebK8J2CeKhFwdNvRv/FmbHrUzZlmnW95GiqIp2TMjZ+AWCxETaRJgSKAu4OWAFN+yWItV4i5iZlgr4oNSeLKePOWMIZcX+Z6UN2WJCPCNVfSl6ImsqZVrF3sTADQC4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5376.eurprd05.prod.outlook.com (20.178.9.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Sat, 14 Mar 2020 06:23:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 06:23:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: [net-next 13/14] net/mlx5: DR, Add support for flow table id
 destination action
Thread-Topic: [net-next 13/14] net/mlx5: DR, Add support for flow table id
 destination action
Thread-Index: AQHV+Z5KMJTJPnFqWk6XkYKUy9hOVKhHX4+AgAA/TAA=
Date:   Sat, 14 Mar 2020 06:23:19 +0000
Message-ID: <0d44ec618bb10d9d0b03ff8c20b284c4117f2092.camel@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
         <20200314011622.64939-14-saeedm@mellanox.com>
         <20200313193643.5186b300@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200313193643.5186b300@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 72f8d731-b225-435a-39a8-08d7c7e03098
x-ms-traffictypediagnostic: VI1PR05MB5376:|VI1PR05MB5376:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB537633C072728BDBCFD7B118BEFB0@VI1PR05MB5376.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(199004)(64756008)(66446008)(71200400001)(66476007)(91956017)(76116006)(66946007)(5660300002)(54906003)(2906002)(66556008)(4744005)(6506007)(8936002)(81166006)(316002)(8676002)(81156014)(6512007)(6486002)(4326008)(186003)(2616005)(26005)(6916009)(107886003)(966005)(36756003)(478600001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5376;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ed4UQxl5JmOcUNrdK+zhRYC8OKQH98BcTIO3h7eg6gVPfFPfMxuJvs02MJsd6BKHWam7DNVPVShDyxr6n6IUZV5puIKX8gJuyrgwEb1ojzC+IBmEHu5EnuZGMoXPQcpXneAhOSGSxkBYNDtq1ObVeLa+W+cYS35XRBFD7TJrrh/OMUgASF1n2EVD1QUVd712ZPGztpO3fEaPu4kabR3ZYxclWUWRIQ2b9FZF6fHtHCnNvPaOMaYMB5XzyJRdNtpXBs/PSboReutINk1BVROa0dLToGVEfVlP2Dz0ipv8ZaOCUp8j51GXSWxmM9CxY8eg8+hdlZYZJGBr8rHCyjPNJL0oTGCyfFL+go35XjLXUIdds9XrSrlrmPNPiJQntrFMZ2fT8fSoRwIJEIS57CJT54SJoSm2NdVkmhNvGjjbCpOiXB0l/pQf1HO34kIUbeiXn+ivG6j8/dQZqTwJFL1QElNDHGqLcYkKURtVZj9C6r4UlM2c+6sD4t/bYCcrQcVfcFgKlrOOJigcYQwB+yt97A==
x-ms-exchange-antispam-messagedata: dNV2zQtOTrjChpJ7kvi8/Qv6yrwy2X4nFriq5hdqDc5ADICx/YeDjnpDO1XRdy/N8Z2DFPX3H9Jy83OkZ5ChUwyIYzuW1xgcSU4NItCTeLBtbogOK+PLBLczxqx4RKVmiPP+l6WRLGHTDRPveNh6IQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <8094C5C48EF22E4185FE78667417C97C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f8d731-b225-435a-39a8-08d7c7e03098
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2020 06:23:19.6499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ybLCzJEgTpNg8IWgjsL668br+ZfC9sTCbhRl9QPvSIJ5+iVS4b3aLcyPoas5ctuRwlq+l2WybdcXdXdJqCTAyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAzLTEzIGF0IDE5OjM2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAxMyBNYXIgMjAyMCAxODoxNjoyMSAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBBbGV4IFZlc2tlciA8dmFsZXhAbWVsbGFub3guY29tPg0KPiA+IA0KPiA+
IFRoaXMgYWN0aW9uIGFsbG93cyB0byBnbyB0byBhIGZsb3cgdGFibGUgYmFzZWQgb24gdGhlIHRh
YmxlIGlkLg0KPiA+IEdvdG8gZmxvdyB0YWJsZSBpZCBpcyByZXF1aXJlZCBmb3Igc3VwcG9ydGlu
ZyB1c2VyIHNwYWNlIFNXLg0KPiANCj4gV2hhdCdzIHVzZXIgc3BhY2UgU1c/DQoNCmluIHNob3J0
IDopIDoNClJETUEgREVWWCBbMV0gYmFzZWQgYXBwbGljYXRpb24uDQoNClsxXSBodHRwczovL3Bh
dGNod29yay5vemxhYnMub3JnL2NvdmVyLzkzMDQ0OS8NCg0KUkRNQSBhcHBsaWNhdGlvbnMgdXNp
bmcgREVWWCBBUEkgY2FuIGFjY2VzcyBhIG1seDUgc3BlY2lhbGx5IGNyZWF0ZWQNCnN0ZWVyaW5n
IGFyZW5hL2RvbWFpbiBmb3IgREVWWCBhcHBzLCBzdWNoIGFwcHMgY2FuIHByb2dyYW0gdGhpcyBk
b21haW4NCnRoZSB3YXkgdGhleSBkZXNpcmUgd2hpbGUgYnlwYXNzaW5nIEZXLCBhbmQgdGhleSB3
aWxsIGdldCBsaWdodG5pbmcNCnNwZWVkIHN0ZWVyaW5nIHJ1bGUgaW5zZXJ0aW9uIHJhdGUuDQoN
Cg==
