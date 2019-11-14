Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D330DFC2BF
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfKNJiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:38:06 -0500
Received: from mail-eopbgr40068.outbound.protection.outlook.com ([40.107.4.68]:24146
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726185AbfKNJiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 04:38:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pg1SBH1RgKqBpSlY7u6ewP9pXYJikTfAD9iX1tregtgo90KKhbJpxnOIugdxKB3omY8lih9zfkey7s2iWDdjiyi0WWp4vl1AfqmRqEhRwk6rl7aEQdK1Ca3udYKrWCwu+fbWzAeHwxwfuX4hPp8iCC/uVZXrkmFrredfeNtOOjLTwq0uBq0Gzzw863QZx1mQJbvkNppX3V23qi4LmAF3RVwu71EZNSRZYOtTt1V4mwzrzQDghTlooEobJiJlgTn2hsZWymyHNw/egY9buqK/6rkImFh9LmX57SnFyWoaIriw7nq1kqRZNz7yipzCuL3b82Kbo5abRxALKQAHBE2DYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA/WtiFR9MA9R4NSp3QiIzKw2M998xCXiqxg0FugMMU=;
 b=PvyYBsDzNJhpZcMFotEkwYF5iE8dQFA6HP6XarWJkRt6JQB248RUZyd2gta91QZRbh73r/OsMf75DoWmdPM+2QgUuVLnOeXTGl7OLCQkMefYNXZ/bGFkWQsKOtXrdbP7Uh8/ZD++FbBVA2fx8ti/IXTlujcjyGqhHMjwGp4D/D67T8toxIjiL+U4YGcfrG1jhAfOYTQv/PrqUCy07m7W1hMDetZPpI8RSEQkCIbbeXfp9nKioAszs7JUsQvIx4nZ72EpJmk+5EGF+jUG4F0c4e/30XnyNo8+mj0Eouym1naQ08g34pSgKwjWjCVfo3umm3nY3LHMbJmfXSTLhZXA5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA/WtiFR9MA9R4NSp3QiIzKw2M998xCXiqxg0FugMMU=;
 b=ONFoHloZ2HoPY1lGu5n/ucaBXEaMOD6kyMkZH24PrSL0XAYs6HgXTQ3VdawsIVAZIXn26yt9S7PB3+/MwmtLsXi8aMgjaxOUo2XolqGi65g2C9S6qtBQspWld0hY2EUPzz7rkhgb7dBQ5D1XHiwpZqyWDaANXwTISAKr8sUq44w=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB5717.eurprd05.prod.outlook.com (20.178.92.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Thu, 14 Nov 2019 09:38:02 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e%7]) with mapi id 15.20.2430.028; Thu, 14 Nov 2019
 09:38:02 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH iproute2 1/5] tc_util: introduce a function to print
 JSON/non-JSON masked numbers
Thread-Topic: [PATCH iproute2 1/5] tc_util: introduce a function to print
 JSON/non-JSON masked numbers
Thread-Index: AQHVmgsbT5eSD/f+hU6my+fa44wqGaeJWReAgAEROYA=
Date:   Thu, 14 Nov 2019 09:38:02 +0000
Message-ID: <129e2006-c3ef-fa3e-847d-a6e2e74eaa96@mellanox.com>
References: <20191113101245.182025-1-roid@mellanox.com>
 <20191113101245.182025-2-roid@mellanox.com>
 <20191113092005.23695425@shemminger-XPS-13-9360>
In-Reply-To: <20191113092005.23695425@shemminger-XPS-13-9360>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
x-clientproxiedby: AM4PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:200:42::27) To AM6PR05MB4198.eurprd05.prod.outlook.com
 (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0a443550-c29a-4f45-7ba2-08d768e6580f
x-ms-traffictypediagnostic: AM6PR05MB5717:|AM6PR05MB5717:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5717E4FFECD55209395E5969B5710@AM6PR05MB5717.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:121;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(189003)(199004)(186003)(5660300002)(52116002)(4744005)(76176011)(6916009)(102836004)(26005)(53546011)(6506007)(8676002)(6246003)(99286004)(386003)(65806001)(65956001)(66066001)(107886003)(8936002)(6436002)(6486002)(31696002)(6512007)(86362001)(316002)(229853002)(58126008)(54906003)(486006)(4326008)(2616005)(476003)(81166006)(81156014)(446003)(11346002)(36756003)(31686004)(3846002)(478600001)(6116002)(7736002)(71190400001)(71200400001)(66946007)(25786009)(66446008)(64756008)(66556008)(66476007)(256004)(2906002)(4001150100001)(305945005)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5717;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OQov+7CQnkdtJgaMsBTQfv3bqf9SYsbrDeBwxpfV09lHaEg7WX88KxRgHTQ7k2fGl1fRzzgEBHwLx2gfR11G4w8LHlgaN7fEQkl4pG8Gy9zrtoVZ8Cueik0fXqH0wTd5VZpuSUWcC6AGyCnbbQcnDixD3eoeWowqpo2p7fqijra+mjXPcVy3HNrSD5O4CDjw1xAHh/PIEsSNNSY1AO7C+IUeO+ODXBsdNFXMcM+bniNge9YSwJzn21aHBSTyQ0DexYNv7m7BDZ+Ti7h0A1Lm1xqdXQUxmhcNp2k14S5CEiRjMXA5Sddp/e+nAFSNZe6J6jTAjYr4oxMJVho6ZPQqMsKx2g2Pg7Ff0YAlAv1RpG07n88WfySIqPsbjYCz/gDYRG/MZDGyxSUZgf2LEHS2OGJDO1RQDOIC3hpTQFhJGZHsfH0nVmEmwVPp6YHamdFU
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1B3C46F8D2AE24E9A56355F81A55A62@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a443550-c29a-4f45-7ba2-08d768e6580f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 09:38:02.7110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1S82ytHBzwYufcvaLFZzD+OMpgXx8j5K0UKd5seu9DisYobul7s7u5G7xUpUe0ta812pNWvm5D3GpJWl32vAlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5717
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMTktMTEtMTMgNzoyMCBQTSwgU3RlcGhlbiBIZW1taW5nZXIgd3JvdGU6DQo+IE9u
IFdlZCwgMTMgTm92IDIwMTkgMTI6MTI6NDEgKzAyMDANCj4gUm9pIERheWFuIDxyb2lkQG1lbGxh
bm94LmNvbT4gd3JvdGU6DQo+IA0KPj4gKw0KPj4gKwkJaWYgKGlzX2pzb25fY29udGV4dCgpKSB7
DQo+PiArCQkJc3ByaW50ZihuYW1lZnJtLCAiXG4gICVzICUldSIsIG5hbWUpOw0KPj4gKwkJCXBy
aW50X2h1KFBSSU5UX0FOWSwgbmFtZSwgbmFtZWZybSwNCj4+ICsJCQkJIHJ0YV9nZXRhdHRyX3R5
cGUoYXR0cikpOw0KPj4gKwkJCWlmIChtYXNrICE9IHR5cGVfbWF4KSB7DQo+PiArCQkJCWNoYXIg
bWFza19uYW1lW1NQUklOVF9CU0laRS02XTsNCj4+ICsNCj4+ICsJCQkJc3ByaW50ZihtYXNrX25h
bWUsICIlc19tYXNrIiwgbmFtZSk7DQo+PiArCQkJCXNwcmludGYobmFtZWZybSwgIlxuICAlcyAl
JXUiLCBtYXNrX25hbWUpOw0KPj4gKwkJCQlwcmludF9odShQUklOVF9BTlksIG1hc2tfbmFtZSwg
bmFtZWZybSwgbWFzayk7DQo+IA0KPiBTaG91bGQgdXNlIF9TTF8gdG8gaGFuZGxlIHNpbmdsZSBs
aW5lIG91dHB1dCBmb3JtYXQgY2FzZSAoaW5zdGVhZCBvZiBcbikNCj4gDQoNCm5vdyBpIHNlZSB0
aGVyZSBhcmUgbW9yZSBwbGFjZXMgdXNpbmcgXG4gaW5zdGVhZCBvZiBfU0xfIHdoaWNoIGJyZWFr
cw0Kb25lbGluZSBvdXRwdXQuIG5vdCByZWxhdGVkIHRvIHRoaXMgY2hhbmdlIHNvIGknbGwgcHJl
cGFyZSBmaXhlcyBmb3INCnRob3NlIGxhdGVyLg0KdGhhbmtzLg0K
