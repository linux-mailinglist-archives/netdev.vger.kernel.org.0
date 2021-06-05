Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9A939C581
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 05:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhFEDee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 23:34:34 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:26615 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhFEDed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 23:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622863965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoOHH6S0guFm7Qy9e8csQYcynY0BSqfjHAQUS4zhOrQ=;
        b=KgzcPhqD3VaXKUNkFGS+HnU5ztrWn9SaZqDQNM01yU/4zK3qRJAdB2uknkQ6zgxh9dLD58
        ppnsUalyTgt/rIiAr13LB9VmVBKL123yEy3G4Sfqr0am8mFnPmh1ED83Yq/qvgfUJVsLx1
        8yoDmLwX3KvIWXfZbFUGK2wk6raJKW0=
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-RczodIH5ODyH6MkgXxVUWQ-1; Fri, 04 Jun 2021 23:32:43 -0400
X-MC-Unique: RczodIH5ODyH6MkgXxVUWQ-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (10.164.204.32) by
 MWHPR19MB1039.namprd19.prod.outlook.com (10.173.124.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.20; Sat, 5 Jun 2021 03:32:40 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.024; Sat, 5 Jun 2021
 03:32:39 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWVyDhUpan91jNkyIQ1KYwvXYZKsEQVYAgACCzgA=
Date:   Sat, 5 Jun 2021 03:32:39 +0000
Message-ID: <b01a8ac2-b77e-32aa-7c9b-57de4f2d3a95@maxlinear.com>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <20210604194428.2276092-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20210604194428.2276092-1-martin.blumenstingl@googlemail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [27.104.184.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a81c785-06d9-41c7-bd7f-08d927d2923d
x-ms-traffictypediagnostic: MWHPR19MB1039:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB10397BB478A9CC7A64309425BD3A9@MWHPR19MB1039.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: CdOSTiMFxC+fwJTH0z1wxdvHlpgKFy+AB5S3ItZBbrYEa8B0iAZi6CNGx5hozCdyqeAQBk6Wl0qkEV7lI4mS0E6DVdMxLnLFVCik56OI/3Bmz77xkohuYbESm5iEIuOgOfg2Eogd4hkZxsYAy0z5Wmdz/YGXQm4J+ql7WNeHZgJkfXvXFzKJuERpkQwEAlDSeplUWi73HSoSOJuDKFxd7FV6pqgPArmJAkTGKaSyIa50DJCXJcaXyhjbm4zfLPLCi5nFc7BRP9qwaI+X+HYMKoqeV1c9RQf7K6anU4jwM1Y1/zkY7sC4vsYsj/Mi/qtEuqatx6potXxg/ofa7NV5sE6cyrNULjNXdY5Yegwxmoj2p/u1WJpH78MOEpUrDoW+FzUctdCqc8QkJl85ID6jBrDHtUXmv0Veh1FEDCcw+U5tEwNxaGBQY3Ib8UwaOuOWNQ+5Iodor5r+f8DDfMDyF6hmjNimTYqGEJ5vBiGqVHycWpAIz/TD4hK0lWe0Y9lt1f3ZB0t8+8jVvAW+9ar83csdNa6CYPKEbAF00D/vBIQxX3gxackb0b7KTkYt0xX2W20S5Nsj3UlXRdFPOfhHAhfdAxsV5/gEyBqVmWMO7qCfP2P9CTPbfsnFIQaIutiN/4KBDIOrJM2iFZXcza/wmHYDk56/FE2Xc2c6RHF8WiCtMrTRh/Cn0Z1vcCoZlfs8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39840400004)(366004)(31696002)(6506007)(86362001)(53546011)(54906003)(2906002)(38100700002)(8936002)(122000001)(4326008)(8676002)(316002)(36756003)(71200400001)(6916009)(76116006)(66556008)(6512007)(66446008)(186003)(26005)(64756008)(31686004)(6486002)(66476007)(91956017)(478600001)(5660300002)(2616005)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?TkE2ekxJbkZpdEZxUUMvNTBlTDRWUGcwVzFFK1g2NXhVYldtNE1BbVdqMFpl?=
 =?utf-8?B?UVZHY2lyL29KSU5YSDRUMi96NGNQampYK0x1RXJmTU9aS25ra0hyQXp1Y1Vh?=
 =?utf-8?B?UngwNVRPQUJRcUFIbUc1WVhnWUFTeXVCUnBlTWliOC9iNzZKUXJDbkJaeGRQ?=
 =?utf-8?B?cXBvQU51MzNHc2RCWXRQK3Nqb0kvd2ppY09OQWFkZ0ZBR3VSYTJoVzB6b0FS?=
 =?utf-8?B?UXF5ajB1dVByZmJTTG5RQmg0NklMa0hPUEpqenNLQk01cmlQbVRjbUZaWXha?=
 =?utf-8?B?U2cvcWFNK2tsV25mYmJyRldXRmEwOVFhQjdOUjRuSFd4TEVoMk02dllqb0Nx?=
 =?utf-8?B?RTdQWTZxTjI1aW5ENkdYR0hJWmZ5WDdBN1NFOStYN1BSVVlyTkZKWFdOSERy?=
 =?utf-8?B?SC9ZM3RPV0lMSXJRVVBnNWRXY1ZIWlBRWFZCSTI4TDF4eXJYTFBINFFEZkEv?=
 =?utf-8?B?aEZtbk80azQ4UUttTDM5V2E2ZitpV3RMNzM2MkpPTk1sRjdTMkIzRGF1UEpt?=
 =?utf-8?B?aC9aMUl1UmtVZXNRZnhNNS9WVmltWjZkcXd0TW9sRHhRMW5xUS9la0VCNlJo?=
 =?utf-8?B?bnJ1a3RQV3NQU2tHZ0toMEljRm1YN0VYOGdXSG0rK1F4RnZLQm1ydzhERkxF?=
 =?utf-8?B?MmRZN0JVYlN4MVZwRElNN0RKMFA3eE1ab0x4UnhBUlRhb29SMzlTNUlpYmdS?=
 =?utf-8?B?bGFaOTBmWnJyekx0SGFUQTZzUFR5ZE5sd244eUw0MUtnZHEzN3NoWm9PUHNL?=
 =?utf-8?B?dDVkTEZpa2xvakU2ZmFhTjliTURKeHRIMHhEbldqOEhKaG1MWWtPcnRhQXFZ?=
 =?utf-8?B?MXk3U2MrdHcxOUpXNVJ0ajg4Syt3S0JjVmFHcEpodEkydU5SMjNtalkvZ3hY?=
 =?utf-8?B?eC9pSDcvQXkwNGYyNGppVGtDOUNJQXl5dTA3cVRmV0N4TWdaMWpjZ1llRitr?=
 =?utf-8?B?b3NXeDRjRXBGOGx1ZDdrbld3S0JaQnJjS2txcGVlQlpEeEpKZ09nek5Ga3l2?=
 =?utf-8?B?bkpISm90UjRXbDk0N2JUNTZlREo3NmF1TjduYkdYbjdOdHV2RGN2OEJoVVVJ?=
 =?utf-8?B?UTRDK0JmbmZpemNpVWJrazgzcTI0RXlZWXlGbGJkbi9RUzZTT3orM0x3VGVN?=
 =?utf-8?B?SDJQQzNxemJhU0ZReWxpbGswSUZ6QWJoUHUrOFpPcXI0cWpoSlFFdlcrM1lW?=
 =?utf-8?B?a3RaWmEvYXJkcytDbVVHQ2ttR2pDa2wwSGRNUXoxSkt2RVROSit2KzB0Y2t2?=
 =?utf-8?B?YjZVOC9RV2VWVnV0Y2YvV09yZUdQSHlzVkJEV2hvNHQ3VlUyMmFSdU9jSlNW?=
 =?utf-8?B?YVdOVnpBb0pkZ1kyaW9rbjQyZ2kwU0ZkVHMxOVovTmJQd0RMYmoyS2dkZklP?=
 =?utf-8?B?T3Z0dlF1VlA2eno4QWJTL05ucjhOay9VcDZEZWNybkd6ZDNNUVhYRGtKbzNx?=
 =?utf-8?B?b2hTUWc3K0ZvMk1uem9YejJmZjhjL3FjNlF2UExBYmFQV0xidW4rMW1BTUxz?=
 =?utf-8?B?ZlhEZHV6YURqRlA1OEFvSVRaZ3FaVXZ4ZVdTUjVnYVF4am02clZkTjhTd2ta?=
 =?utf-8?B?NFpEeWhSTHFhNERvYnFYVjdmaTRXWVcvUEJEdlhoK0pMQ3VCeWNVcTczVTNx?=
 =?utf-8?B?MTAyUGdvZlo4YlN5S25IQlRmUGhKWm1GZXAyRHdqRG1OUXZQdWRvQ1JURVFk?=
 =?utf-8?B?b0hyMENUSDdDVHhkSUg5bjRZRkZBOGdFaGJERStFZFdVMVJPSmZURDBQRWds?=
 =?utf-8?Q?H6f0OzzzEkTBSGhCeQ=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a81c785-06d9-41c7-bd7f-08d927d2923d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2021 03:32:39.9311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mOEx2RPVmXcfriFVhU+TTFp/+T1T1FLkdKCH7unwbm72I9GrqWk/5AOUli1VPGOXhs/W9F+qC/1VnDTkflcRAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB1039
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <56E8D5A42D12A84D8C6544BA2F54FA67@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS82LzIwMjEgMzo0NCBhbSwgTWFydGluIEJsdW1lbnN0aW5nbCB3cm90ZToNCj4gVGhpcyBl
bWFpbCB3YXMgc2VudCBmcm9tIG91dHNpZGUgb2YgTWF4TGluZWFyLg0KPg0KPg0KPiBIZWxsbywN
Cj4NCj4+IEFkZCBkcml2ZXIgdG8gc3VwcG9ydCB0aGUgTWF4bGluZWFyIEdQWTExNSwgR1BZMjEx
LCBHUFkyMTIsIEdQWTIxNSwNCj4+IEdQWTI0MSwgR1BZMjQ1IFBIWXMuDQo+IHRvIG1lIHRoaXMg
c2VlbXMgbGlrZSBhbiBldm9sdXRpb24gb2YgdGhlIExhbnRpcSBYV0FZIFBIWXMgZm9yIHdoaWNo
DQo+IHdlIGFscmVhZHkgaGF2ZSBhIGRyaXZlcjogaW50ZWwteHdheS5jLg0KPiBJbnRlbCB0b29r
IG92ZXIgTGFudGlxIHNvbWUgeWVhcnMgYWdvIGFuZCBsYXN0IHllYXIgTWF4TGluZWFyIHRoZW4N
Cj4gdG9vayBvdmVyIHdoYXQgd2FzIGZvcm1lcmx5IExhbnRpcSBmcm9tIEludGVsLg0KPg0KPiAg
RnJvbSB3aGF0IEkgY2FuIHRlbGwgcmlnaHQgYXdheTogdGhlIGludGVycnVwdCBoYW5kbGluZyBz
dGlsbCBzZWVtcw0KPiB0byBiZSB0aGUgc2FtZS4gQWxzbyB0aGUgR1BIWSBmaXJtd2FyZSB2ZXJz
aW9uIHJlZ2lzdGVyIGFsc28gd2FzIHRoZXJlDQo+IG9uIG9sZGVyIFNvQ3MgKHdpdGggdHdvIG9y
IG1vcmUgR1BIWXMgZW1iZWRkZWQgaW50byB0aGUgU29DKS4gU0dNSUkNCj4gc3VwcG9ydCBpcyBu
ZXcuIEFuZCBJIGFtIG5vdCBzdXJlIGFib3V0IFdha2Utb24tTEFOLg0KPg0KPiBIYXZlIHlvdSBj
b25zaWRlcmVkIGFkZGluZyBzdXBwb3J0IGZvciB0aGVzZSBuZXcgUEhZcyB0byBpbnRlbC14d2F5
LmM/DQo+DQo+DQo+DQo+IEJlc3QgcmVnYXJkcywNCj4gTWFydGluDQo+DQpJJ20gdGhpbmtpbmcg
dG8gc2VwYXJhdGUgdGhlbS4NCg0KVGhleSBhcmUgYmFzZWQgb24gZGlmZmVyZW50IElQIGFuZCBo
YXZlIG1hbnkgZGlmZmVyZW5jZXMuDQoNClRoZSBYV0FZIFBIWXMgYXJlIGdvaW5nIHRvIEVvTCAo
b3IgbWF5YmUgYWxyZWFkeSBFb0wpLg0KDQpJdCBjcmVhdGVzIGRpZmZpY3VsdHkgZm9yIHRoZSB0
ZXN0IGNvdmVyYWdlIHRvIHB1dCB0b2dldGhlci4NCg0K

