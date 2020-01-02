Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CA812E1A0
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 03:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgABCQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 21:16:50 -0500
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:42886
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727511AbgABCQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jan 2020 21:16:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPlhPZcK8DkH8GbT/iFP1Vx1jfVEo4aP6HJLzs5DDWYZ2viwWJaoFTRIJ+90zkONKLiLYhLkqlkz6k8N5rb5odQaBz8an0gu5DA1nWYzXmOrs8/QB46K65KpBSf6ZgFAXVzk7q8xCJHAPhbKmVMzEQXZGI/xycMKfFCHe7wBPVNRL4342LTjudZP5S+dmCEx3AalROylPU7V+mqcWT5v13GGpRTD/adx/EovDnjNNKilH5mnB0djbpEUpMiUXdrU/V+8XMN9snjCwMRZFBmHmlnFodX7XjKKERI6Vum5hlux3myIIqCPlDLcqvCEooN8FCHYj7Y4F4crCArXS6MD5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9LJ1ONiRUjizdKb4XSzL7fqWm10GzotmXyVmJIhHGo=;
 b=oQLDJ4p/gMRwwECHcgjdRL5kABEgWMSZBt+9Nz607I52g9OXkN/9MYa16o9OaHXpnwz4vNoCVn6bsFIl98iaCEnHv5txuyuK0TRDn0qjFs5qFT34TqZVqhwIIKQZ+pww5uNxV0W4EGbQJLW3fHbSLMOfqDKbNlnnkUNjv3qVQcBaWPvpMlIif2s4Q5V98njThgCvESasj2kJDzNygLMZkQCKt9BuoYwwqrON6CBGhBmsB/qeUq1nMZMqr/KKaP2KsU8XYEzWBKptQULU4X5iFQ9ZODf6lK7CsG/YK7WAkvuGq/AuPbHKTBgG20RpzEPPcao3dAEVKJkO/aeGeJgOdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9LJ1ONiRUjizdKb4XSzL7fqWm10GzotmXyVmJIhHGo=;
 b=OdMZxjqe8h7xzMN+MpzHRMJLst2LbSJyTZKgaxmFGZkZDTrSQWMfjlSfLHqGW0aFrhinM/usuokcbkn7fNx6V5J/Mr4CEM37EpTi3UP0g4zOOiOrdnRQtoO5clvxJUGG8nola4zPa5uChONZrcFBLcgY00YiPgUp5LdDVQ3oKgs=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6590.eurprd04.prod.outlook.com (20.179.234.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Thu, 2 Jan 2020 02:16:43 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc%3]) with mapi id 15.20.2581.013; Thu, 2 Jan 2020
 02:16:42 +0000
From:   Po Liu <po.liu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>
Subject: RE: [EXT] Re: [v2,net-next] enetc: add support time specific
 departure base on the qos etf
Thread-Topic: [EXT] Re: [v2,net-next] enetc: add support time specific
 departure base on the qos etf
Thread-Index: AQHVvGNyrgSmwD+0RU+o/s0aZaT5DqfTrEYAgAMAKwA=
Date:   Thu, 2 Jan 2020 02:16:42 +0000
Message-ID: <VE1PR04MB6496E2419F471AF65339E7C892200@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191223032618.18205-1-Po.Liu@nxp.com>
        <20191227025547.4452-1-Po.Liu@nxp.com>
 <20191230.202652.128958107020164612.davem@davemloft.net>
In-Reply-To: <20191230.202652.128958107020164612.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95855fbc-5e69-48ba-d162-08d78f29cf3d
x-ms-traffictypediagnostic: VE1PR04MB6590:|VE1PR04MB6590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6590DFCF532F896E3A0A0A1592200@VE1PR04MB6590.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(136003)(39850400004)(396003)(346002)(13464003)(199004)(189003)(66556008)(66476007)(66446008)(44832011)(66946007)(53546011)(4744005)(52536014)(316002)(7696005)(2906002)(76116006)(71200400001)(64756008)(33656002)(54906003)(4326008)(9686003)(81156014)(6506007)(186003)(55016002)(5660300002)(26005)(8936002)(8676002)(6916009)(478600001)(86362001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6590;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EETZOtWcuBFEt5OpQw3qDdp3vOP/TkIrziL0U7tb6Gepl7RfCUXAvR7nr//7dUD4qm227NdRpfxX+LS2MCdg8MUsqerVAC1dmWI7MxOauQq011ZYAR03LpdgJTLpkMzTZGz7EsvL2kZNh3y1f3AxfpRot5by/O7TmRzFfGakXwdmonPCFybkvjTcNusSZP1HPLs+UEeGj0g9Yn3/bB35m319EGt+25bGmhQUML9BjLx6BF4th8bYLxIIv44SA+fbPHUk+0gnGS++yE25m5N4fa0h6HOBMGTcCw+Qo+LgUsdFWTkqU9XX1D80io3e3qSqBxPI6Q65uv3LX8asOt4tiIdsGhE6uhtnJa2P5OwcYswYxmLXVVNNd49o+MKzpnUeZQGwT4Cg+rlZ5eGVR5SKlHq9P1YIr+H45oDCm1qVW1wKDCEiPqLh8rAHQoKCxcHRr5Hc9xGXPG/nDdnIBAtzAQ9zhR9+bo2ebThmMBtAWbs7KBkP2iGOAwPy4s90/XPs
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95855fbc-5e69-48ba-d162-08d78f29cf3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2020 02:16:42.8031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qF3NqKmCrHOF4SnGusa4Ugrhexrqic0OA5l+sE6CGAlTvIHx4uYWx5gu3Z2MUgKr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IERhdmlkIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gU2VudDogMjAxOcTqMTLUwjMxyNUgMTI6MjcNCj4gVG86IFBv
IExpdSA8cG8ubGl1QG54cC5jb20+DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiB2aW5pY2l1cy5nb21lc0BpbnRlbC5jb207IENs
YXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsNCj4gVmxhZGltaXIgT2x0ZWFu
IDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47IEFsZXhhbmRydSBNYXJnaW5lYW4NCj4gPGFsZXhh
bmRydS5tYXJnaW5lYW5AbnhwLmNvbT47IFhpYW9saWFuZyBZYW5nDQo+IDx4aWFvbGlhbmcueWFu
Z18xQG54cC5jb20+OyBSb3kgWmFuZyA8cm95LnphbmdAbnhwLmNvbT47IE1pbmdrYWkgSHUNCj4g
PG1pbmdrYWkuaHVAbnhwLmNvbT47IEplcnJ5IEh1YW5nIDxqZXJyeS5odWFuZ0BueHAuY29tPjsg
TGVvIExpDQo+IDxsZW95YW5nLmxpQG54cC5jb20+OyBpdmFuLmtob3JvbnpodWtAbGluYXJvLm9y
Zw0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW3YyLG5ldC1uZXh0XSBlbmV0YzogYWRkIHN1cHBvcnQg
dGltZSBzcGVjaWZpYyBkZXBhcnR1cmUgYmFzZQ0KPiBvbiB0aGUgcW9zIGV0Zg0KPiANCj4gQ2F1
dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBGcm9tOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBE
YXRlOiBGcmksIDI3IERlYyAyMDE5IDAzOjEyOjE4ICswMDAwDQo+IA0KPiA+IHYyOg0KPiA+IC0g
Zml4IHRoZSBjc3VtIGFuZCB0aW1lIHNwZWNpZmljIGRlYXBydHVyZSByZXR1cm4gZGlyZWN0bHkg
aWYgYm90aA0KPiA+IG9mZmxvYWRpbmcgZW5hYmxlZA0KPiANCj4gVGhlIHRlc3QgaXMgaW4gdGhl
IHdyb25nIGxvY2F0aW9uLg0KPiANCj4gWW91IGFyZSB0ZXN0aW5nIGF0IHJ1biB0aW1lIHdoZW4g
cGFja2V0cyBhcmUgYmVpbmcgdHJhbnNtaXR0ZWQuDQo+IA0KPiBJbnN0ZWFkLCB5b3Ugc2hvdWxk
IHRlc3Qgd2hlbiB0aGUgY29uZmlndXJhdGlvbiBjaGFuZ2UgaXMgbWFkZSB3aGljaCBjcmVhdGVz
DQo+IHRoZSBjb25mbGljdCwgYW5kIGRpc2FsbG93IHRoZSBjb25maWd1cmF0aW9uIGNoYW5nZSBp
biBzdWNoIGEgY29uZmxpY3RpbmcgY2FzZS4NCg0KT2ssIHRoYW5rcyENCg0KQnIsDQpQbyBMaXUN
Cg==
