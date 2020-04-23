Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CE01B64BF
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgDWTt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:49:29 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:37237
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbgDWTt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 15:49:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UH5ZCLaPYRN2BW93Iw+tHdZRVAo9dx/YCG8H5eaTXxwnPjaR/1H9het+RalDqCO1ossnfnpmEFE+kEBlebMuRmoU/Xg0obfXMWlV8wfwkNwBUv3ytW0GaL3+dpmA+2G62mOHradZws2bJtTRUV4cYKYukPHDT39XcOMxcDH0Xl51zlDDuvS7nI2lnkJTVl1ATofeI1SJDYBysFXWUbAEUSErzBbRVSgZS7MMhN2tZTNgwOhwMWXSdlgViOR3idPSCnPj31M89zHxHOS4wmTiRUpuUaJ7u18hhWxYFwbezoGytqCA19mDPimHcxQmUZigv+9CcoGP6qWo80x1GVCp/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYZAurytj/H5bC59mMrP2pwkiW5T77SExqV1fqMJ/mE=;
 b=jsXGLwWl/KmMLrSKAUjELr/HGg1fHfHVFVLnC30VqhnLBTnyVcVauCtAR/BgvJx4ai6iPw2bK0p3c6/YHgVmrp4Cik3RXZ/e5FMAbC/C0n14lSEywcHu+IqBbE/rIGZa2iHPnxRNmEYohfoc3o3Qo+6Uhwmxl10KF6rURXn/bnhJdd3fzijiFYEgE4Gjp2JlE37oSexn5er2nnwLEChZySWTORsKSJNgiGqYLFEWe3g/96vDe2JNUbZaSXD60gi+u0tBeuK5ipSr1Ki6+DZNFBOdxjKDXD0XgoMbrglp6HSHGsN6SKcuVLW9i24fpL6avkwjPca6FCGxhBPIrEztYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYZAurytj/H5bC59mMrP2pwkiW5T77SExqV1fqMJ/mE=;
 b=lzX5Jlqvo2qAuaGT2VRFLqBcwK9DiVoMP95YR7fMzn1rgo4oBJZois1Rhpu90KkmXO4jwdGN6yYpXXiNLWnYsjR4P4gkEP4s78SF+i8qDHh6RbLmwETGcyoEN+GhmAVm0gUfGBq7CtkoIuNGreY/vdDidpnte4F7lGaVz6OBvdk=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (2603:10a6:10:113::21)
 by DB8PR04MB6458.eurprd04.prod.outlook.com (2603:10a6:10:10a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Thu, 23 Apr
 2020 19:49:24 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d%8]) with mapi id 15.20.2921.035; Thu, 23 Apr 2020
 19:49:24 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Nipun Gupta <nipun.gupta@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: RE: [PATCH net-next 2/2] dpaa2-eth: fix return codes used in
 ndo_setup_tc
Thread-Topic: [PATCH net-next 2/2] dpaa2-eth: fix return codes used in
 ndo_setup_tc
Thread-Index: AQHWGX+WSAFwNq/g40q6dGNCYAgDBKiHHVNg
Date:   Thu, 23 Apr 2020 19:49:24 +0000
Message-ID: <DB8PR04MB6828F8C888DD8D532C34302FE0D30@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
 <158765387082.1613879.14971732890635443222.stgit@firesoul>
In-Reply-To: <158765387082.1613879.14971732890635443222.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.25.102.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 82f13b89-43a6-42a8-6d3c-08d7e7bf6cf4
x-ms-traffictypediagnostic: DB8PR04MB6458:|DB8PR04MB6458:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6458317FBE165AF672D15661E0D30@DB8PR04MB6458.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(186003)(5660300002)(26005)(52536014)(54906003)(316002)(4326008)(71200400001)(6506007)(2906002)(33656002)(478600001)(8936002)(8676002)(81156014)(76116006)(9686003)(44832011)(55016002)(66946007)(86362001)(7696005)(6916009)(66446008)(64756008)(66556008)(66476007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +XqH1rlVpmgvRGep7JdgUb4I9xH4+R6AApWbSZhz2Qtx3ozzVE8hL8GBJjBtQzcZZ8WhTQpJ7NSZbb4cknSDrX41jqQ0Z5LJCeObR0jXAgXo2GL3ImndfjEV2dSy7VtPMr3iYPGHZBTjgq2rhdFoHI02y+I6BZzecShcXIC/5+RlIQXFPjQ2X/73yAAaI7hsFTm7vI5mhlQnqNO41R4zEZ/IE6QaQWgCR3K9+2h7r6AAUVIJuWs6qh7D5vzzmozV/1xHbzgw8B1uLT9ko6pISnGp6rVnEfrDqKhyiiaAKdMcuit1B2XhNkDRzr3rHcPxJ4Ha8WMEXLOyz/JffyJxGRkPdgFk6vS+oIlLyh4T5cHeUAka5FmHLifrJgJL5iSkH/M2yGzewfccxhm5e1lAcdS4Tf6NJOfV3qbNaLaqbll/U4bVKK9E+67dLk/Jyayc
x-ms-exchange-antispam-messagedata: HjEFyuNYNJh994kXfUIS6LuxNzIvNWwId2ucUHFLGH0Yos8iNbtpoOdDJVEzZzqC9ok+tp854jHsgC8IyyEsZ6nMpvxtWBAE32h/eJhrJk5XJtgUASgnrw+KPhFBKyiFa9Va9aTRonlHPU+DvN8PZw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f13b89-43a6-42a8-6d3c-08d7e7bf6cf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 19:49:24.7538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: atxRQaUzhayk3av24Mhq5xnhR3xjcLtAeFGl5KNvCFqS1gDMN9II4m15YsHQwyStu/Hhlkop3KIWrqCSqNB+SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6458
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgMi8yXSBkcGFhMi1ldGg6IGZpeCByZXR1cm4gY29k
ZXMgdXNlZCBpbiBuZG9fc2V0dXBfdGMNCj4gDQo+IERyaXZlcnMgbmRvX3NldHVwX3RjIGNhbGwg
c2hvdWxkIHJldHVybiAtRU9QTk9UU1VQUCwgd2hlbiBpdCBjYW5ub3Qgc3VwcG9ydA0KPiB0aGUg
cWRpc2MgdHlwZS4gT3RoZXIgcmV0dXJuIHZhbHVlcyB3aWxsIHJlc3VsdCBpbiBmYWlsaW5nIHRo
ZSBxZGlzYyBzZXR1cC4gIFRoaXMgbGVhZA0KPiB0byBxZGlzYyBub29wIGdldHRpbmcgYXNzaWdu
ZWQsIHdoaWNoIHdpbGwgZHJvcCBhbGwgVFggcGFja2V0cyBvbiB0aGUgaW50ZXJmYWNlLg0KPiAN
Cj4gRml4ZXM6IGFiMWU2ZGUyYmQ0OSAoImRwYWEyLWV0aDogQWRkIG1xcHJpbyBzdXBwb3J0IikN
Cj4gU2lnbmVkLW9mZi1ieTogSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJlZGhhdC5j
b20+DQo+IC0tLQ0KDQpUZXN0ZWQtYnk6IElvYW5hIENpb3JuZWkgPGlvYW5hLmNpb3JuZWlAbnhw
LmNvbT4NCg0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLWV0
aC5jIHwgICAgNCArKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9kcGFhMi9kcGFhMi1ldGguYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9kcGFhMi9kcGFhMi1ldGguYw0KPiBpbmRleCA4NzNiNjZlZDNhZWUuLmE3MmY1YTBkOWU3YyAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEy
LWV0aC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhMi9kcGFh
Mi1ldGguYw0KPiBAQCAtMjA1NSw3ICsyMDU1LDcgQEAgc3RhdGljIGludCBkcGFhMl9ldGhfc2V0
dXBfdGMoc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5ldF9kZXYsDQo+ICAJaW50IGk7DQo+IA0KPiAg
CWlmICh0eXBlICE9IFRDX1NFVFVQX1FESVNDX01RUFJJTykNCj4gLQkJcmV0dXJuIC1FSU5WQUw7
DQo+ICsJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gDQo+ICAJbXFwcmlvLT5odyA9IFRDX01RUFJJ
T19IV19PRkZMT0FEX1RDUzsNCj4gIAludW1fcXVldWVzID0gZHBhYTJfZXRoX3F1ZXVlX2NvdW50
KHByaXYpOyBAQCAtMjA2Nyw3ICsyMDY3LDcNCj4gQEAgc3RhdGljIGludCBkcGFhMl9ldGhfc2V0
dXBfdGMoc3RydWN0IG5ldF9kZXZpY2UgKm5ldF9kZXYsDQo+ICAJaWYgKG51bV90YyAgPiBkcGFh
Ml9ldGhfdGNfY291bnQocHJpdikpIHsNCj4gIAkJbmV0ZGV2X2VycihuZXRfZGV2LCAiTWF4ICVk
IHRyYWZmaWMgY2xhc3NlcyBzdXBwb3J0ZWRcbiIsDQo+ICAJCQkgICBkcGFhMl9ldGhfdGNfY291
bnQocHJpdikpOw0KPiAtCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwkJcmV0dXJuIC1FT1BOT1RTVVBQ
Ow0KPiAgCX0NCj4gDQo+ICAJaWYgKCFudW1fdGMpIHsNCj4gDQoNCg==
