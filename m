Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F1B39D3C3
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 06:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhFGEIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 00:08:40 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:45180 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230178AbhFGEIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 00:08:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1623038807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ilgAovHx7Z4KRiwp8HrMTyzavnR6BZV4uAWCylgkY28=;
        b=FtZfKBk7CgrWhjLCRKG1P0sJEAUiM5RCx/Osm3Z8oi1Rxrlaajqkjq3S66Lw57iJrn0HVV
        11Kb/U5io0yJG74ERduJpuh2kQ1zdGAag8yq5np4spP3qXZsOiB8OSYedjO6YvKKWTwPOY
        /CtsOFAQBKYhUjaaLD0IkAC0tsoCHeg=
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-3e0DOZvuOiCNqbi1qXF9DA-1; Mon, 07 Jun 2021 00:06:45 -0400
X-MC-Unique: 3e0DOZvuOiCNqbi1qXF9DA-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by CO6PR19MB4802.namprd19.prod.outlook.com (2603:10b6:5:343::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 04:06:43 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.029; Mon, 7 Jun 2021
 04:06:43 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWVyDhUpan91jNkyIQ1KYwvXYZKsECXGAgAAhoACAAB2SAIAAfDEAgAC87YCAAnCRAA==
Date:   Mon, 7 Jun 2021 04:06:42 +0000
Message-ID: <9a838afe-83e7-b575-db49-f210022966d5@maxlinear.com>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
 <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
 <YLqIvGIzBIULI2Gm@lunn.ch>
 <2b9945f9-16a4-bda5-40df-d79089be3c12@maxlinear.com>
 <YLuPZTXFrJ9KjNpl@lunn.ch>
In-Reply-To: <YLuPZTXFrJ9KjNpl@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [138.75.37.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4899cebc-83e2-4b8e-0367-08d92969a8e2
x-ms-traffictypediagnostic: CO6PR19MB4802:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR19MB4802F6A0CA340B0FE6A8813EBD389@CO6PR19MB4802.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: c0CvkE9e1wlpHQRj7OfL2SDpFNjL/ZfTOoTIAcSQdSGtQSVbf61V+0cBG4UMpcBLt2FKFat05LQBmGIwgbkhFG5BFdbAQdU190jhp8TevQvE/E3NMdlgcDquKlkHoBYGczLGRztLRhcz/uf8RoYwd6ztX224XjjF3LI5x1SHwXWqXH8jYr3DuJJZBTM/BaEBR8179nmMozx7eKfTi4BysErDSkSeAT7ri7UgGpizyeBMqz92Gr9iLs0ZRRFJRIWRyLbif9xyfIWx5g8SPXs48RTFhEk+NkQPZIELS3hH5scB2f9NZmqHBytK+LBX3Gjzm7Sz/j0/syzhVrrmJTB1qy2h0RW2VlKaNrGXoyHYTReYdZDuoW/9bPw7fH/KOxIFZ9dXmXk0l9iElil7ewG5/NpEt3EOnNpHU32wyo8NFJU94MumDZ/x7aMk7NYMVdsBJlspnTdtKK52gf7VS/zTkOai2+HQS7e8nV2brwToyOTZD5ambSqTzhUEthVFMIioBg9sNnvbfOL6HOG6Fz+qiPtNYq3NDe7zxHK9bkk0HaXa7/mKKXxBPmQGeXWxMJmBMH3FjufN6tjVxd1067yDnB+KHCuPWyh2/oEL98Md55FnmLfDmHEFMgBpAcDpDjpaDSSRIwA/ISa6zR2IvzEC6YJURNEsesnb6NSKLI9w/h543q76vAtfTiRJcbHDzHX5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(396003)(376002)(136003)(346002)(122000001)(4326008)(66946007)(31696002)(6916009)(8936002)(2616005)(316002)(38100700002)(64756008)(91956017)(76116006)(66476007)(66556008)(66446008)(478600001)(107886003)(26005)(186003)(2906002)(71200400001)(5660300002)(36756003)(8676002)(54906003)(6486002)(86362001)(53546011)(6506007)(83380400001)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?MDBqcVJ1N2FOdmdrcTRwd3dqUEpuZmRFVE9iaEJKWnJlc09ta0lnZjJjaTRz?=
 =?utf-8?B?azhKOHh5S3hNKzZLNWRyZnpSZk5GaDVrSEVmNXJMWW5BcERlVHRzckdIRjVP?=
 =?utf-8?B?SGdEL0RsUm5nKyt4RHgxZzdvREF2UXdyZ0prYmlsSFpPNWpBSU8vbWl0MTZU?=
 =?utf-8?B?aDZKdHZxZ3VteWtueG1QUkhPVFlIU0trMUs1amNRaUswNTAyOEo4U3FicjFE?=
 =?utf-8?B?V0pTeVY0SThCUkUxL1RuOEMrUUYzZlNsYWh4V1VXdCtYSEsxMHE1bTdRbWs4?=
 =?utf-8?B?N3NmT0hjZTlSY1ZvTXIxcmZ2MDB4QnZ2YkI1c3BETjRVam9QY0o5NTRwM1lx?=
 =?utf-8?B?cEZkUlpsM2R6eE5tWDJFeFdJODE2UlZCV0JtOXpBMXhqdkljVmNNUTBmTGZp?=
 =?utf-8?B?anQvcW5DbE1sTitVYUF6V1hyNkJiV1RtaWlKcXZud2ZYeWlyYmw5WU81VEt6?=
 =?utf-8?B?WUs2REhuQ3NSbzFLQkZQS3FBL2Q5Z3pPN0FHTEk0amJOOVo3R2NRSVdrTHc5?=
 =?utf-8?B?RXZZckpoWUtWc3cvUVlPWUwzVHNTblFSblhHUlR0NlpJOVRGWmJWWHZHTkRT?=
 =?utf-8?B?OWVHRXFsd2N1NnUyRkZUNVJXcVZGNXVkT3R3WVZBY0tQSzZZb1dvUm9VcVpi?=
 =?utf-8?B?UGNOQWlINlkvZ0hSOFlvam55MGZ0UXRGNTd2eHNZbmtaeXJJSEZOdmxrVEQ4?=
 =?utf-8?B?VmpzZHAyc0EzemFIODkxL2JtazV3bDBYeW50dFZZV3grS1RKZ2FtU2kwUk9J?=
 =?utf-8?B?S1RsKzRINlpjNUxpWDhoK1Fnc1RqcFc2QWVEOEhpMFBEbmRTdXU2dm81S0hF?=
 =?utf-8?B?VXNWWUdaZkdnN0cyR2N3L1RNNkUwcEg0emRKMXdlTDUvOEZVRWZaTUR5ZVRM?=
 =?utf-8?B?SGdNWW9SdTVXZ2kxZXMzRTh0dzhMY0JGejZQb2pQdFEraE1tZEk1WEhzd20y?=
 =?utf-8?B?b004aFRzeEQ5ay9ESmpmeSsxOVpiU2Zub1pWcGgya1U0ZlFCMFd2clpnZmIv?=
 =?utf-8?B?cHE5VWRBNDAvUmV1Smp1WVQwWWJMUUtycFZ2ZkxJVXJpQkNUWXhJTEV1aU9n?=
 =?utf-8?B?dDFDcTB1UktISTh4eE9tTjNpY2pjOVgxZXR5S2ZEREhTK0U2bFgzTjlTUFlX?=
 =?utf-8?B?UXppTXZ3UlFJc3R3Qjl6Uy9kZmlpblk2emJZcVFTRldGV08xN0dQNk5CdGFh?=
 =?utf-8?B?YlE0WDRVZDVWbjBZU2xUWUxhSVJGTUw1ZkVqVm9qZzZCbEFiQWVDcHNQY1Fv?=
 =?utf-8?B?Nk1lTU11K3A0USsvTm5YRGlaRGpRMGJmNVg4eTBFMlYrdlR6M05kNnlkSTlK?=
 =?utf-8?B?MDFhODVOZUV4aUxGWDMwcDNwSDgyemR3WGFuMXVzZHdMVmRsRUpZVUtyVXE5?=
 =?utf-8?B?c3Y5TkJQdTgvSDhWUTR5MVpLTUFQaHpoeVp4SjVKdjVsdU56UnQ2bGh3RWl2?=
 =?utf-8?B?RGtPZlJtOUN2NHU0bGFmQXhnUHBmR08yd2x6N1RsY1dTR3VpSk00WmZCMmJB?=
 =?utf-8?B?UFNBYTJCVklQMW81c1gxay84TTNaMWpEMDU4NTkvTDN2SWtvRU14MzVVdHAx?=
 =?utf-8?B?M0ZsaVo4Ty9TZWdyREIwZU1BSVZ6R2ZGc21yMDZhbHM3YUtJcDRsemNwdFVw?=
 =?utf-8?B?SUJoWmNHejFLODRTN0M0TzVPdHF0WTZUQmFmdmtQK2w0Lzd6dHBKOGFBajFo?=
 =?utf-8?B?N3JNbFVneTAweU5RL0xDSkxLSDYwRHAyN2VJTGZ1Zk9BZEwwZVRTTVZpRlV1?=
 =?utf-8?Q?ga28Wu65Q0iArUpMTM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4899cebc-83e2-4b8e-0367-08d92969a8e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 04:06:42.8956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8DaGm1o1+t9Nx39+4K7OneI4Px3hcyhFOjercH0iY1Bc6h3tYVn2DcuW7Vx2y82MOGLEzarpQtgCHWhnBqkt6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB4802
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <84869CBC894E31488198290A904CF195@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS82LzIwMjEgMTA6NTEgcG0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBUaGlzIGVtYWlsIHdh
cyBzZW50IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+DQo+DQo+Pj4+PiBUaGlzIGRvZXMg
bm90IGFjY2VzcyB2ZW5kb3Igc3BlY2lmaWMgcmVnaXN0ZXJzLCBzaG91bGQgbm90IHRoaXMgYmUg
cGFydA0KPj4+Pj4gb2YgdGhlIHN0YW5kYXJkIGdlbnBoeV9yZWFkX2FiaWxpdGllcygpIG9yIG1v
dmVkIHRvIGEgaGVscGVyPw0KPj4+Pj4NCj4+Pj4gZ2VucGh5X3JlYWRfYWJpbGl0aWVzIGRvZXMg
bm90IGNvdmVyIDIuNUcuDQo+Pj4+DQo+Pj4+IGdlbnBoeV9jNDVfcG1hX3JlYWRfYWJpbGl0aWVz
IGNoZWNrcyBDNDUgaWRzIGFuZCB0aGlzIGNoZWNrIGZhaWwgaWYNCj4+Pj4gaXNfYzQ1IGlzIG5v
dCBzZXQuDQo+Pj4gWW91IGFwcGVhciB0byBvZiBpZ25vcmVkIG15IGNvbW1lbnQgYWJvdXQgdGhp
cy4gUGxlYXNlIGFkZCB0aGUgaGVscGVyDQo+Pj4gdG8gdGhlIGNvcmUgYXMgaSBzdWdnZXN0ZWQs
IGFuZCB0aGVuIHVzZQ0KPj4+IGdlbnBoeV9jNDVfcG1hX3JlYWRfYWJpbGl0aWVzKCkuDQo+Pj4N
Cj4+PiAgICAgICAgICAgQW5kcmV3DQo+Pj4NCj4+IEknbSBuZXcgdG8gdXBzdHJlYW0gYW5kIGRv
IG5vdCBrbm93IHRoZSBwcm9jZXNzIHRvIGNoYW5nZSBjb2RlIGluIGNvcmUuDQo+IFByZXR0eSBt
dWNoIHRoZSBzYW1lIHdheSB5b3UgY2hhbmdlIGNvZGUgaW4gYSBkcml2ZXIuIFN1Ym1pdCBhIHBh
dGghDQo+DQo+IFBsZWFzZSBwdXQgaXQgaW50byBhIHNlcGFyYXRlIHBhdGNoLCBzbyBtYWtpbmcg
YSBwYXRjaCBzZXJpZXMuIFBsZWFzZQ0KPiBhZGQgc29tZSBrZXJuZWwgZG9jIHN0eWxlIGRvY3Vt
ZW50YXRpb24sIGRlc2NyaWJpbmcgd2hhdCB0aGUgZnVuY3Rpb24NCj4gZG9lcy4gTG9vayBhdCBv
dGhlciBmdW5jdGlvbnMgaW4gcGh5X2RldmljZS5jIGZvciBleGFtcGxlcy4NCj4NCj4gQW55Ym9k
eSBjYW4gY2hhbmdlIGNvcmUgY29kZS4gSXQganVzdCBnZXRzIGxvb2tlZCBhdCBjbG9zZXIsIGFu
ZCBuZWVkDQo+IHRvIGJlIGdlbmVyaWMuDQo+DQo+ICAgICBBbmRyZXcNCj4NClRoYW5rIHlvdS4g
SSB3aWxsIGNyZWF0ZSAyIHBhdGNoZXMgZm9yIHRoZSBjb3JlIG1vZGlmaWNhdGlvbiBhbmQgZHJp
dmVyIA0Kc2VwYXJhdGVseQ0KDQppbiBuZXh0IHVwZGF0ZS4NCg0K

