Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A3E3BF4EB
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 07:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhGHFHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 01:07:10 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:54156 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229644AbhGHFHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 01:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1625720667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SxkRh4EAVd5sVyp905pmapmXZ1UmlJGM/wvb+WEeA4Q=;
        b=gaW4k7T+aKo4QAcJtBty3ZIxQM1VgDfGWQV5bijh7gP/QXZ8u3QEWkMAat1f2Y5QBC+6bx
        vgbx2y8LgGZOv7vk0Jx4B4jIzNMyeKFN5V2QkA9BvzwaB+dI95LKbYHakQJRVwg7eO0f6m
        2ZZL54Uo312cLEmWjfb+gljrCC6/2/U=
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138--TaiwSFAP6-cijz2_JFM7w-1; Thu, 08 Jul 2021 01:04:25 -0400
X-MC-Unique: -TaiwSFAP6-cijz2_JFM7w-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.33; Thu, 8 Jul
 2021 05:04:21 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 05:04:20 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH v5 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v5 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXblLidA9sMBr3UkmswKjsJw5n+as2HEqAgAACygCAAM1fgIAAvqKAgADlr4A=
Date:   Thu, 8 Jul 2021 05:04:20 +0000
Message-ID: <b9df4e0a-0a70-7691-fd35-ab9e1e5dcdbb@maxlinear.com>
References: <20210701082658.21875-1-lxu@maxlinear.com>
 <20210701082658.21875-2-lxu@maxlinear.com>
 <7e2b16b4-839c-0e1d-4d36-3b3fbf5be9eb@maxlinear.com>
 <20210706154454.GR22278@shell.armlinux.org.uk>
 <c4772ca8-42e3-9c9d-2388-e19acb19e073@maxlinear.com>
 <YOXGp39i6foOHv02@lunn.ch>
In-Reply-To: <YOXGp39i6foOHv02@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb6abe8a-0628-4b7d-5084-08d941cdd8b3
x-ms-traffictypediagnostic: MWHPR19MB0077:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB0077653E45253238ACE42C92BD199@MWHPR19MB0077.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3qCJSYhZdNsaHzlccHnUNs+5Eb6bKljSaBvQcH7OSGgRUIfE7dxuLkq3kguVcBNjIwDNyOQJydl93qyQwo3Jka2zUUiEYIuq2970qOuA/67liENlBFPuKkitdWDZRKokk/+td0S6n0hRI/hIK8irStdXRdyPBdHnSvh7rdXjlbs7lQWIj9oCgLDS0TBVaKMQYOIG7yAeCTRoP1HXxF+bxqlRWwAgSr0Debqfdii19SHdH0KUVYBqkkkHkBIHKYWl76w4J8Dgc6/RNA+FV2Al7Wvx0qam/4Z/U8FpMnwWIf7WsBrawGsli9OZFX5q/YeTYErEcn/5xd/AQ3aVC2RJYAgTxcNLkvVFlDaZPgO0wivlCWK36+Elh3lGDHt/2pE6QlxApM1YGOfU9pXjkhxOfrcydNG50hGhuInRKUzdCdiKHTFmY6vUcmsKJWqucAN/P2msK6JYzGMpd/fV8qkbCtPN3CLgntf9c4lRi3nWcfNO9OmbPWaWgYrikHmJdJ4PphWtY4hg/YTnFE/WKvfElRZfhT23V3a73SC8BgGUCAWq/ObofEYhnjmSjuZDdFX+VCSTmh2G9S9W+PA28ux0GZSSVYh8EOuubZ1PJTsXUMv/eZ7OPXHIyUanXBeO3w7r84BKyPEaaDlobJPj6ZfkiPB9QyYUmHeT4yGeol529ywdnbQn05xqcUWHcL6dIXeW+1tKyS76MWHGRxx2Dh+kdweZRP15O0TUTsyqEHJ0xZQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(376002)(346002)(136003)(396003)(64756008)(8676002)(26005)(122000001)(4326008)(76116006)(66446008)(36756003)(4744005)(91956017)(186003)(54906003)(6916009)(83380400001)(6486002)(66946007)(66556008)(316002)(38100700002)(31686004)(8936002)(5660300002)(6512007)(66476007)(6506007)(53546011)(2906002)(86362001)(31696002)(478600001)(2616005)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0V0N0Uya0dsQkx6VGFGRjNYNUxNWlRibDZIOGd4OHdEbGIxWUZNMmNJYzNv?=
 =?utf-8?B?MVlZUWJkK2VVVlBZZE53ektObFVKNm9idHhBV2tZUFdDNjN5UVRLN1I4Y1hl?=
 =?utf-8?B?VDNQSTlXRXBta2FoWU1GRW9NS294T2lqWE5TTEM3L0gzVUN3YXdJdTVsb1JH?=
 =?utf-8?B?LytlMW03dVRXUlVkbmhvWWZsZ0luQ21PV0dwWHFKSzJDZFQ1dEo3dk9IbGRj?=
 =?utf-8?B?R2NqOW5EbDJSbGJGVmUzVEkwU2FtUEZGTGRNMWYwTGxLK2l4YzVWNnlCb1ht?=
 =?utf-8?B?NVl2T3BSZFF2ZlNsbmY5ZDZHN0wxR1BHV21vdmxZZ2p5eVlRVkt0bVZ3eGIx?=
 =?utf-8?B?elRkT0FYaXVheFpBNmYvZDMzSThTOEgwclJmOGYxNVhLOE53OVhPQ0xWN3Vn?=
 =?utf-8?B?aDlvT2t3ZFg2QlhQNzB4ak1KTEM4SnR6bjZ0QVZFK2I0YjF0cStWWk9BclNC?=
 =?utf-8?B?Y29JR3Z4WW1QeTh0ajFBbzdTdU1RendjTmtpSytHUDlpeGpHand2dFY2WGxw?=
 =?utf-8?B?cWM1S3o2M3hDVmwvQUNrTTBac1dxaHM1dHR1WlJxeWk5TFZzbUhJMi93aDk1?=
 =?utf-8?B?RmJnVTc0OVJHbVZ6Y1pGZzJYMkIraGwrbDUwOGU3bVRtN1MydTl6c0xEVXhL?=
 =?utf-8?B?a1poVmdxS3FxbEtwSmZwRHJwYjcxaXlqV1BIQ2NxT1JCS0NaTFpHTnpGYzVJ?=
 =?utf-8?B?M25DRDViYTJzZy9hRUkzSFFWbjlUQVh3Kys4eDhFZHJTejNNb1ZmRkhxUzVI?=
 =?utf-8?B?NGJGdnl6dGJWSnJIZWxZbVlkMmFwVUFFU1cwY0UxeWtnamJsM3lWRWdwVGps?=
 =?utf-8?B?eVV3c2VzTnpGYjluMlBFMmszc05mNU9rMnJ0RDNodmk2Z1VSS2N6NVpNdnpQ?=
 =?utf-8?B?cDk1REdXY3lVODJUOHhUZUZKc2ZicmNCSjV6UzdlU1lZQXJvRFZuUFFQTmVC?=
 =?utf-8?B?VGx0QmlmRjFhd05sd1RsaEN3cms3WVdkdHdoRlEycjVIanQyZ0ZPMVA4T0JY?=
 =?utf-8?B?c1Q3eHlPdkhoM29ITWFzZlZIbDZZbFZiSG1wblphUmtjMjhZTk9MMGxBZEc4?=
 =?utf-8?B?aThtQ0VFeVlGV2tpdXJDQVFPWUhOS2pZRzJYOFJUNDJITWRuNlV5c1lGbWNB?=
 =?utf-8?B?SUkxYlo5eXowRTI0Q2ZKalRvc2Ivc2dNSlFrQXNWY2IxNXA0OWJObmdDbytV?=
 =?utf-8?B?bDE0NTFYWWJqQnY0ZEJiQ21qLzNORnVSN0EyRnBtWUVMSXVXbVpCVFR5MDNo?=
 =?utf-8?B?cW1jUWg4R2FkZUtNZjg3MTZzT0xnUGU4RnY2Z3ZGVEhzR25EeWI1eFlZYUZF?=
 =?utf-8?B?SFFycGc5aUxnZm1vOHNQU0ZVMndUWFQwU25laHd4b0dRdXRtcHVxelZrbVdN?=
 =?utf-8?B?MnV0Sis1UkdWWjRFWXBKL0RLNzJmWnlESmpHd1VNU2FCTTVCREUyMS9abkli?=
 =?utf-8?B?M1Fra3hJRDY2SHh4bFJsbnNZdVduekd0aGZTQXYrZjVYK2NTY2xuRjkwZEhy?=
 =?utf-8?B?M3lDNUQxSE5ITUR2ZUFsMHUwK3lyb2JVMzhpNmNyVlJ1dWhoZlNMZmtRd2ov?=
 =?utf-8?B?dmV5azdlbzl2SWp3NU16NXprNU5wVzNYRVJlbnQ5Rzc2ODBub21Qd3c3a3BX?=
 =?utf-8?B?Unk3dE5KTU5UYUlxNHk1eUp6cWtROTYyazJqMGFwdDJ0ZWVNR29wbFhDQklx?=
 =?utf-8?B?L1Vqb2tEWGxuMUxxRFFEbEZpVUhRTXBVWmlIS3doYm56TEFUWS9LMHJHSW9p?=
 =?utf-8?Q?is/gB3SdB+nUre2q80=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6abe8a-0628-4b7d-5084-08d941cdd8b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 05:04:20.7858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LmfAk5WjktLPHOKGE03zEo/Ew/IaE/KZSt59ddlLuuMIGvVW52K3EdhEHDmhIT93sIOCfHtIPumElWh6y4z6Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB0077
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <1723D11350F56D48BD45FD95100C8071@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy83LzIwMjEgMTE6MjIgcG0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBUaGlzIGVtYWlsIHdh
cyBzZW50IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+DQo+DQo+PiBJcyB0aGUgbWVyZ2lu
ZyBmYWlsdXJlIGR1ZSB0byB0aGUgdHJlZSBkZWNsYXJhdGlvbj8gT3Igc29tZXRoaW5nIGVsc2Ug
SSBhbHNvDQo+PiBuZWVkIHRha2UgY2FyZS4NCj4gSXQgaXMgcHJvYmFibHkgZHVlIHRvIHRoZSB0
cmVlIGRlY2xhcmF0aW9uLCBhc3N1bWluZyB5b3UgYXJlIGFjdHVhbGx5DQo+IHVzaW5nIHRoZSBj
b3JyZWN0IHRyZWUuDQo+DQo+PiBXaGVuIGRpZCB0aGUgbmV0LW5leHQgd2FzIGNsb3NlZD8gSSBz
YXcgc29tZSBvdGhlciBwYXRjaGVzIGFmdGVyIDEgSnVsIHdlcmUNCj4+IGFjY2VwdGVkLCBob3cg
bWFueSBkYXlzIGJlZm9yZSB0aGUgY2xvc2Ugc2hvdWxkIEkgc3VibWl0Pw0KPiBJdCB2YXJpZXMg
Ynkgc3Vic3lzdGVtLiBBUk0gU29DIHRlbmRzIHRvIGNsb3NlIGFyb3VuZCBhIHdlZWsgYmVmb3Jl
DQo+IHRoZSBtZXJnZSB3aW5kb3cgb3BlbnMuIG5ldGRldiBzZWVzIHNvbWUgcGF0Y2hlcyBhY2Nl
cHRlZCBvbmUgb3IgdHdvDQo+IGRheXMgYWZ0ZXIgdGhlIG1lcmdlIHdpbmRvdyBvcGVucywgYnV0
IHlvdSBzaG91bGQgbm90IGFzc3VtZSBwYXRjaGVzDQo+IHdpbGwgYmUgYWNjZXB0ZWQgdGhhdCBs
YXRlLiBBbHNvLCB5b3Ugc2hvdWxkIHN1Ym1pdCBwYXRjaGVzIGVhcmxpZXIsDQo+IHJhdGhlciB0
aGFuIGxhdGVyLiBUaGV5IGdldCBtb3JlIHRlc3RpbmcgdGhhdCB3YXksIHlvdSBoYXZlIHRpbWUg
dG8NCj4gZml4IGlzc3VlcyBldGMuDQo+DQo+PiBEbyBJIG5lZWQgcmUtc3VibWl0IHRoZSBwYXRj
aCB3aGVuIG5ldF9uZXh0IGlzIG9wZW4gYWdhaW4sIG9yIHRoZSBjdXJyZW50IHBhdGNoDQo+PiB3
aWxsIGJlIHB1bGxlZCBpbiBuZXh0IG9wZW4gd2luZG93Pw0KPiBZb3UgbmVlZCB0byByZXN1Ym1p
dC4NCj4NCj4gICAgICBBbmRyZXcNCj4NClRoYW5rIHlvdSB2ZXJ5IG11Y2guDQoNCg==

