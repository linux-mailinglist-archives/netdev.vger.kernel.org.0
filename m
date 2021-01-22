Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A493001C6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 12:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbhAVLkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 06:40:31 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:44919 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbhAVLjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 06:39:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611315595; x=1642851595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0Op5641yfIBm3yGv8Ic1BshgxbPbsSuxsuxX632fBTU=;
  b=QWTlgKRicq++rcqk3JUXELfphA4RAnWwdo4zQ07JxGazVNEE0Zp+MsTY
   b3MNLqqIwkPc0007EFFqLp5C3k8N4COrW39H2rEVwqEC8XMQjr4HAzaxn
   drd/wxJ493u3ET2D/riqOXFZUEUySUNvbxsb7KvbV50WWnMJEfQQ81jA3
   gpYhGoz+DkyyfPPrM/t66+jceeV0ArRX/tu3QNu7u2QwzSvKBM5a0BUdn
   5mufdAhw53dAPY8zOiJbdBLpGo/PFVSoSNKZXWD4ys9qmNL58/5Q3mmrA
   s7AhGD3uyKvxWZYoa+NLSh0VfjmzwLOSwHr4BOA30Qbu13Pw1vkzCFQXo
   A==;
IronPort-SDR: 3rkJ+L8lsYDsTEefM5bUChunJ1OF1iawUECtKv8kcmDeiZpLc06FC/9cTjxyIwaq/KkcM0OHfW
 3uWxnkBBEJ8KTrg4QGFsAbwstiswtldSOTGUWvJf0X+8ljsuYLpnE+PEcMWZaTcQ2U+de9RFOx
 5t5Wjs+CwUdH2J3BCb06NZrwcdiZUlAYC3PsfO1Ef5T0d8QmhuIbQlgen7DAYvATN8i4EjaMt2
 9F+S8vHZBlISN5l7hRvO9pJTlGeFk4J47+7weACPOJWEpNzND6Bi39pe3+EeyAxPWnMOsQFYpT
 bGo=
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="106388789"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jan 2021 04:38:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 22 Jan 2021 04:38:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 22 Jan 2021 04:38:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFCUAMTNCFoDNr7yoxWpzl16N1BrUkMB73iNm0N5bV2i2nrZsgR6J4G7r30OzM175ogPT6hMzp6wQEOVyDHPX7R6MvFl1Tswhoq1UEkNbISFytfDd5H24cAJYmO3uN+az0U3TiedOGYpm3Mofn+j2OPz/3q9aq9c90A4Jb/AxG3hg6FhCAjHjGETfZAK477sAjldCngsw9x6TNal7hd70zyBI9EuC5CH1TeIPxH5W4LrT33pn+UmF8dAE2O7FpKfhMGr7H44ghPaxDVUq4bTWgv1koHP4kYpj07XVJMyLFISUgBLygNENTUdMdhqQYuH6jNEk1KPsduVZ2dHJ+R7RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Op5641yfIBm3yGv8Ic1BshgxbPbsSuxsuxX632fBTU=;
 b=XCURTCMWdVDLCf80fx/WjxizvqHZYSsMorQD7kNQdvbW9phkb0rA3RowdU/Cvrk7yoetaCAj/lA6sDi1ImResAnr8D1wx1bfjpvXXM4w43koWmv511G/PzPOwQlELlhMq68XT+UEIdqRwniPU8FYBNl+KQg4qfUUgLzCZawz+Hka1sw2yyzVzAmoL9bpA5mcP/iKtaR7heRGJKCkOODLHuoFhuvKuJU0q021XdAYF5Tl8UYpFETqX+NOiMdxuvn5MMPhI7fz9jpku33QUQSf/wIjmNswrcLIG4vHBwO1NF6BAYXZlAbagEljT+ecgbmZgk60chbIfYnPO//bEanNNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Op5641yfIBm3yGv8Ic1BshgxbPbsSuxsuxX632fBTU=;
 b=tzZn19nIFYcDgzmdZCQsZTNQtt9fH/KjdnyGM2njWhlPpG+YaVi05ZVM44M3s19PMflGSWo8Ln8w0KFhj4fAUX5XCcKJX0dqTrN6K2xgfthLZEZ+t9OgJ7uc/hsf3Q/b5qSYTV3a+E4b37JPf2gGbd1nGns4HcwzVHPTsWEZjpc=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM5PR1101MB2185.namprd11.prod.outlook.com (2603:10b6:4:4f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.11; Fri, 22 Jan 2021 11:38:30 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4%5]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 11:38:30 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <michael@walle.cc>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>
Subject: Re: [PATCH] net: macb: ignore tx_clk if MII is used
Thread-Topic: [PATCH] net: macb: ignore tx_clk if MII is used
Thread-Index: AQHW79Z6nzNG5V5dqke5o+L2S+jLWw==
Date:   Fri, 22 Jan 2021 11:38:29 +0000
Message-ID: <9a6a93a0-7911-5910-333d-4aa9c0cd184d@microchip.com>
References: <20210120194303.28268-1-michael@walle.cc>
 <38734f00-e672-e694-1344-35f4dd68c90c@microchip.com>
 <bd029c647db42e05bf1a54d43d601861@walle.cc>
 <1bde9969-8769-726b-02cb-a1fcded0cd74@microchip.com>
 <9737f7e5e53790ca5acbea8f07ddf1a4@walle.cc>
In-Reply-To: <9737f7e5e53790ca5acbea8f07ddf1a4@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.76.227.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3df74c07-4337-4f5b-3087-08d8beca3db2
x-ms-traffictypediagnostic: DM5PR1101MB2185:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB2185CE58FAD06689C041371687A00@DM5PR1101MB2185.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eT3drmTJNIKbc/2S9GdhxQ5zyyFvP9gq4aQSaUJ2tgTky7CakYRlooLnZ0J43Y8TvB9lm6REWW+Cu4ppxlG4hIzLn5m7OaVuhRfQWDgquwTNSHqo9MCqbxg+PyQEkL15Nyux3A1TC6ga4gL8aK3HU6G4Pxc1AXo1ybhQRD7ngjrxJ6IsXI/wUD8jLUAfLuvT1nwxjPRkuBuD3uVECuhtC/TKQF2b6brFzdtHDiRdxaQIEQf/KjLqCqztfX7KR6n0GozN+Dy6tU6z5OUpXhqzloEpAnEqZvTguuBMaSATiYiIzXzZSHNBFY2NrMA9mEX5IAg5tr4mKYd8RdIf3BpuiahumyIXkQlP3mk63J32nzS7WBHrW02UWs0PWY6jBiSnL7OlKGih5L9KF1o9tB7f2EHOGoEb97IYhkFAZWg8IVse6kmpq5lYmHsXwjmHVywtAgI4q4TbMdb6DRYJDIwuYSFb2A7CraeRujZfSnNG4VM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(39860400002)(376002)(91956017)(53546011)(31686004)(6916009)(478600001)(66556008)(6506007)(66476007)(66946007)(5660300002)(8936002)(316002)(76116006)(64756008)(26005)(83380400001)(186003)(71200400001)(4326008)(2906002)(31696002)(54906003)(8676002)(2616005)(36756003)(86362001)(6486002)(66446008)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MVhBckxPUDVvUStmR3dScjgzYmNXTWVUYXVwazdPVHFobzdVU1dsa01sMHht?=
 =?utf-8?B?cS9XTmhvZmFnMDdNcElZN1ZhQkVkaWFUNmxsMnc4LzMrWEJhQm5ZUTA4azNv?=
 =?utf-8?B?UlpOVHFMY3B2UmZ4a2pwOUlzY0lnVkY4elA1MTh6bzhVbjg5Y0lQeVlMK0pE?=
 =?utf-8?B?VzcwdS9RT3B2MTUwVmpvMEU5VlF2QTV2N1ZCajZNLzZ4K1UwaDRhbmlaeXNl?=
 =?utf-8?B?ZzJxUlIvY3VydWFaY1BteDdPbDJPS1dyV0F4bWVxUmU5ZnpyTW0vRlUwUWhV?=
 =?utf-8?B?eXZsbjVxMGg4WURYM1RWbXozd0x5UFVmK3NoRmNSYVpqNkZsbm5IVmNnclpU?=
 =?utf-8?B?QmpoTGRjWGYwbFhNMzlPYnlJSHRpWHl4bVFJK1hhNkZ1UFExRVRhZkFodlVR?=
 =?utf-8?B?WGZaaCtRbXA5Unl4MU9ueDczUkgzNWQvN0NWcmd3ZU1JMzJDNXA5V0lVRTBR?=
 =?utf-8?B?NjFlWVBrL3dXYVBwYjY1YUJ5SllYZ2RpaVJnYkQ4MWt1dzJxMjhsMk5YYW5K?=
 =?utf-8?B?WHpuWUwzZEhrejkvSllQSmJ4N0VEVGtVMTdQSXNNMlB6am5BeXF1bEJFT25Q?=
 =?utf-8?B?TFlWSlFtR1dUTDVhKzlrLzg2aHlVVS9lOU5DK3liQ0dXRUVadlZDMjB5TlVk?=
 =?utf-8?B?T0FBajBwR1VGelFBc3lhWXBsNUc3bksrUkxEYXBnSW0xemNaY1F1S0dkZG9h?=
 =?utf-8?B?bE5FTEp6QlZjeVppcDYvelZySXhlK1BHbzZJNE9EbFVDbjNaQlllQ1VqME1j?=
 =?utf-8?B?a0tJSzh5RUtmRmQ3T01tbDV1ZlVWYXB4QkpicWVYVmJvYm8zQW8xd3lkdFQ3?=
 =?utf-8?B?cWx0dUtUb1h2QjkzM3RxWTRQeHpUVDFrcHF6WW1BbGI2aFdveS9YN1BwSHlx?=
 =?utf-8?B?dlNVNE9Rbk5LOGN6cXpmVTROQnRKY2FQOGxVY3FLbWFDa1dzMXh2bDMxcEl2?=
 =?utf-8?B?NE00WHYwbzk4MlRHK0gvQ2J1c1JQWERMSGloZk4rSUZXR1BZakRVQ2ZIZXdr?=
 =?utf-8?B?YllJaXRMcDVHZWtxNG1oVXVlZTZQandZRUxXRUJDV1ROZ2RJc3k0TzFMTjVT?=
 =?utf-8?B?TENCOTZHc01DSS9XN0JkK2ZjVFNVcmVueW9xLzRyY3VNSHNFWDFBdy9OdFow?=
 =?utf-8?B?NWw2eCtSN3lSNHdRSTNIeFRrMUMxUkt3NmpVV0lJQmtVNlUrcG0zNkExZkE5?=
 =?utf-8?B?TUNxTHhKcmNKdWVVN2pPQmMvcUNBMUJkZHlkWWlWZjFxUkhxb0NCRjZWRDNB?=
 =?utf-8?B?cmExNG9lK1o2SVYvRWRRY2srVjhMcUI3Q09tcG12a3FtVkFTTHlTNmVLQ0cz?=
 =?utf-8?B?bWhUS1lreWVibjNYbWZoU1ZOVXA4Qlp3TENzK3hjTUtPMldjMzFxdEhxM2dI?=
 =?utf-8?B?MG91TGhNSXUvSFl2OFhTTzZPcEhTdW1GWnNCMGJKY0lkZ0NTcE1nd2g4bk9m?=
 =?utf-8?B?MUdoV1lQRlRJOUhCMGlKNmQwMkdJenZMTVpPVXJRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F52BE015A50C648B94DFDADACAD0F32@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df74c07-4337-4f5b-3087-08d8beca3db2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 11:38:29.9495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qBo0wstmTJ9xSWllCZ27wu9Z24C9VEnogn4pKMALtcnLzGKpJZQABY9qISdmpoIUzAMk5hJs0gpOezI/msakXn6ChBCVUGSLZj4KFgoEjrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2185
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIyLjAxLjIwMjEgMTM6MjAsIE1pY2hhZWwgV2FsbGUgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlDQo+IGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gQW0gMjAyMS0wMS0yMiAxMDoxMCwg
c2NocmllYiBDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tOg0KPj4gT24gMjEuMDEuMjAyMSAx
MTo0MSwgTWljaGFlbCBXYWxsZSB3cm90ZToNCj4+PiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNs
aWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93DQo+Pj4gdGhlDQo+
Pj4gY29udGVudCBpcyBzYWZlDQo+Pj4NCj4+PiBIaSBDbGF1ZGl1LA0KPj4+DQo+Pj4gQW0gMjAy
MS0wMS0yMSAxMDoxOSwgc2NocmllYiBDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tOg0KPj4+
PiBPbiAyMC4wMS4yMDIxIDIxOjQzLCBNaWNoYWVsIFdhbGxlIHdyb3RlOg0KPj4+Pj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3UNCj4+Pj4+IGtub3cNCj4+Pj4+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4+Pj4+DQo+Pj4+PiBJ
ZiB0aGUgTUlJIGludGVyZmFjZSBpcyB1c2VkLCB0aGUgUEhZIGlzIHRoZSBjbG9jayBtYXN0ZXIs
IHRodXMNCj4+Pj4+IGRvbid0DQo+Pj4+PiBzZXQgdGhlIGNsb2NrIHJhdGUuIE9uIFp5bnEtNzAw
MCwgdGhpcyB3aWxsIHByZXZlbnQgdGhlIGZvbGxvd2luZw0KPj4+Pj4gd2FybmluZzoNCj4+Pj4+
IMKgIG1hY2IgZTAwMGIwMDAuZXRoZXJuZXQgZXRoMDogdW5hYmxlIHRvIGdlbmVyYXRlIHRhcmdl
dCBmcmVxdWVuY3k6DQo+Pj4+PiAyNTAwMDAwMCBIeg0KPj4+Pj4NCj4+Pj4NCj4+Pj4gU2luY2Ug
aW4gdGhpcyBjYXNlIHRoZSBQSFkgcHJvdmlkZXMgdGhlIFRYIGNsb2NrIGFuZCBpdCBwcm92aWRl
cyB0aGUNCj4+Pj4gcHJvcGVyDQo+Pj4+IHJhdGUgYmFzZWQgb24gbGluayBzcGVlZCwgdGhlIE1B
Q0IgZHJpdmVyIHNob3VsZCBub3QgaGFuZGxlIHRoZQ0KPj4+PiBicC0+dHhfY2xrDQo+Pj4+IGF0
IGFsbCAoTUFDQiBkcml2ZXIgdXNlcyB0aGlzIGNsb2NrIG9ubHkgZm9yIHNldHRpbmcgdGhlIHBy
b3BlciByYXRlDQo+Pj4+IG9uDQo+Pj4+IGl0DQo+Pj4+IGJhc2VkIG9uIGxpbmsgc3BlZWQpLiBT
bywgSSBiZWxpZXZlIHRoZSBwcm9wZXIgZml4IHdvdWxkIGJlIHRvIG5vdA0KPj4+PiBwYXNzDQo+
Pj4+IHRoZQ0KPj4+PiB0eF9jbGsgYXQgYWxsIGluIGRldmljZSB0cmVlLiBUaGlzIGNsb2NrIGlz
IG9wdGlvbmFsIGZvciBNQUNCIGRyaXZlci4NCj4+Pg0KPj4+IFRoYW5rcyBmb3IgbG9va2luZyBp
bnRvIHRoaXMuDQo+Pj4NCj4+PiBJIGhhZCB0aGUgc2FtZSB0aG91Z2h0LiBCdXQgc2hvdWxkbid0
IHRoZSBkcml2ZXIgaGFuZGxlIHRoaXMgY2FzZQ0KPj4+IGdyYWNlZnVsbHk/DQo+Pj4gSSBtZWFu
IGl0IGRvZXMga25vdyB0aGF0IHRoZSBjbG9jayBpc24ndCBuZWVkZWQgYXQgYWxsLg0KPj4NCj4+
IEN1cnJlbnRseSBpdCBtYXkga25vd3MgdGhhdCBieSBjaGVja2luZyB0aGUgYnAtPnR4X2Nsay4g
TW9yZW92ZXIgdGhlDQo+PiBjbG9jaw0KPj4gY291bGQgYmUgcHJvdmlkZWQgYnkgUEhZIG5vdCBv
bmx5IGZvciBNSUkgaW50ZXJmYWNlLg0KPiANCj4gVGhhdCBkb2Vzbid0IG1ha2UgdGhpcyBwYXRj
aCB3cm9uZywgZG9lcyBpdD8gSXQganVzdCBkb2Vzbid0IGNvdmVyDQo+IGFsbCB1c2UgY2FzZXMg
KHdoaWNoIGFsc28gd2Fzbid0IGNvdmVyZWQgYmVmb3JlKS4NCg0KSSB3b3VsZCBzYXkgdGhhdCBp
dCBicmVha3Mgc2V0dXBzIHVzaW5nIE1JSSBpbnRlcmZhY2UgYW5kIHdpdGggY2xvY2sNCnByb3Zp
ZGVkIHZpYSBEVCB0aGF0IG5lZWQgdG8gYmUgaGFuZGxlZCBieSBtYWNiX3NldF90eF9jbGsoKS4N
Cg0KPiANCj4+IE1vcmVvdmVyIHRoZSBJUCBoYXMgdGhlIGJpdCAicmVmY2xrIiBvZiByZWdpc3Rl
ciBhdCBvZmZzZXQgMHhjICh1c2VyaW8pDQo+PiB0aGF0IHRlbGxzIGl0IHRvIHVzZSB0aGUgY2xv
Y2sgcHJvdmlkZWQgYnkgUEhZIG9yIHRvIHVzZSBvbmUgaW50ZXJuYWwNCj4+IHRvDQo+PiB0aGUg
U29DLiBJZiBhIFNvQyBnZW5lcmF0ZWQgY2xvY2sgd291bGQgYmUgdXNlZCB0aGUgSVAgbG9naWMg
bWF5IGhhdmUNCj4+IHRoZQ0KPj4gb3B0aW9uIHRvIGRvIHRoZSBwcm9wZXIgZGl2aXNpb24gYmFz
ZWQgb24gbGluayBzcGVlZCAoaWYgSVAgaGFzIHRoaXMNCj4+IG9wdGlvbg0KPj4gZW5hYmxlZCB0
aGVuIHRoaXMgc2hvdWxkIGJlIHNlbGVjdGVkIGluIGRyaXZlciB3aXRoIGNhcGFiaWxpdHkNCj4+
IE1BQ0JfQ0FQU19DTEtfSFdfQ0hHKS4NCj4+DQo+PiBJZiB0aGUgY2xvY2sgcHJvdmlkZWQgYnkg
dGhlIFBIWSBpcyB0aGUgb25lIHRvIGJlIHVzZWQgdGhlbiB0aGlzIGlzDQo+PiBzZWxlY3RlZCB3
aXRoIGNhcGFiaWxpdHkgTUFDQl9DQVBTX1VTUklPX0hBU19DTEtFTi4gU28sIGlmIHRoZSBjaGFu
Z2UNCj4+IHlvdQ0KPj4gcHJvcG9zZWQgaW4gdGhpcyBwYXRjaCBpcyBzdGlsbCBpbXBlcmF0aXZl
IHRoZW4gY2hlY2tpbmcgZm9yIHRoaXMNCj4+IGNhcGFiaWxpdHkgd291bGQgYmUgdGhlIGJlc3Qg
YXMgdGhlIGNsb2NrIGNvdWxkIGJlIHByb3ZpZGVkIGJ5IFBIWSBub3QNCj4+IG9ubHkNCj4+IGZv
ciBNSUkgaW50ZXJmYWNlLg0KPiANCj4gRmFpciBlbm91Z2gsIGJ1dCB0aGlzIHJlZ2lzdGVyIGRv
ZXNuJ3Qgc2VlbSB0byBiZSBpbXBsZW1lbnRlZCBvbg0KPiBaeW5xLTcwMDAuIEFsYmVpdCBNQUNC
X0NBUFNfVVNSSU9fRElTQUJMRUQgaXNuJ3QgZGVmaW5lZCBmb3IgdGhlDQo+IFp5bnEgTUFDQi4g
SXQgaXNuJ3QgZGVmaW5lZCBpbiB0aGUgWnlucS03MDAwIHJlZmVyZW5jZSBtYW51YWwgYW5kDQo+
IHlvdSBjYW5ub3Qgc2V0IGFueSBiaXRzOg0KPiANCj4gPT4gbXcgMHhFMDAwQjAwQyAweEZGRkZG
RkZGDQo+ID0+IG1kIDB4RTAwMEIwMEMgMQ0KPiBlMDAwYjAwYzogMDAwMDAwMDANCg0KSSB3YXNu
J3QgYXdhcmUgb2YgdGhpcy4gSW4gdGhpcyBjYXNlLCBtYXliZSBhZGRpbmcgdGhlDQpNQUNCX0NB
UFNfVVNSSU9fRElTQUJMRUQgdG8gdGhlIFp5bmMtNzAwMCBjYXBhYmlsaXR5IGxpc3QgYW5kIGNo
ZWNraW5nIHRoaXMNCm9uZSBwbHVzIE1BQ0JfQ0FQU19VU1JJT19IQVNfQ0xLRU4gd291bGQgYmUg
YmV0dGVyIGluc3RlYWQgb2YgY2hlY2tpbmcgdGhlDQpNQUMtUEhZIGludGVyZmFjZT8NCg0KPiAN
Cj4gQWxzbyBwbGVhc2Ugbm90ZSwgdGhhdCB0eF9jbGsgbWF5IGJlIGFuIGFyYml0cmFyeSBjbG9j
ayB3aGljaCBkb2Vzbid0DQo+IG5lY2Vzc2FyaWx5IG5lZWQgdG8gYmUgdGhlIGNsb2NrIHdoaWNo
IGlzIGNvbnRyb2xsZWQgYnkgQ0xLX0VOLiBPcg0KPiBhbSBJIG1pc3Npbmcgc29tZXRoaW5nIGhl
cmU/DQoNCkkgc3VwcG9zZSB0aGF0IHdob2V2ZXIgY3JlYXRlcyB0aGUgZGV2aWNlIHRyZWUga25v
d3Mgd2hhdCBpcyBkb2luZyBhbmQgaXQNCnBhc3NlcyB0aGUgcHJvcGVyIGNsb2NrIHRvIG1hY2Ig
ZHJpdmVyLg0KDQpUaGFuayB5b3UsDQpDbGF1ZGl1IEJlem5lYQ0KDQo+IA0KPiAtbWljaGFlbA0K
PiANCj4+PiBVc3VzdWFsbHkgdGhhdA0KPj4+IGNsb2NrDQo+Pj4gaXMgZGVmaW5lZCBpbiBhIGRl
dmljZSB0cmVlIGluY2x1ZGUuIFNvIHlvdSdkIGhhdmUgdG8gcmVkZWZpbmUgdGhhdA0KPj4+IG5v
ZGUNCj4+PiBpbg0KPj4+IGFuIGFjdHVhbCBib2FyZCBmaWxlIHdoaWNoIG1lYW5zIGR1cGxpY2F0
aW5nIHRoZSBvdGhlciBjbG9ja3MuDQo+Pj4NCj4+PiAtbWljaGFlbA==
