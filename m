Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87E41A7937
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390849AbgDNLPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:15:09 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:50966 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728734AbgDNLPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:15:04 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DCAF2C00A6;
        Tue, 14 Apr 2020 11:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1586862902; bh=mNrejdGQ9VY2kUIVe00JlOU/9wt3geagh3oVFyRJvMk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DUoPdui5auFaXoOyiivKhFSu4G0BsfhRE5w4eLYOJ6IiqjQEtrAs3ob7SBSJIoesP
         0Lq3x4dtE1cUzWoRcV07YC70/CJaT5SpAwiCE0Z459Fi7Wg7e1hqZOiu0NmIIj1i0n
         wY9kFG79WeQarXPL3vm+c99Qi2YEIFiPoN+m2HKkRfqSjlf/M6SohF5r7f74kEixsQ
         Wxg8zLwPTSDUjgwq3HK5PgYhLXqR58qfq0MlIrF7rN5WAY+CYh4OxpdKJDA3dzkY8u
         PWxtc5GGpueF/L/AnDiGypWMoFwyV6ujhwmKKx2J+TV9aLyBp4Drrw5tX/e/4u/yoa
         9bmJh17wR4fTA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 09669A0083;
        Tue, 14 Apr 2020 11:15:00 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 14 Apr 2020 04:14:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 14 Apr 2020 04:14:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvU0e9WqD3+Q+UfXbuLaow8K+Nsdy21MTVIKyG0hgR2BxBM7QFWlea36H6YoPQVUsncSKFiU9M6V4XMzvNYWPK6HzUGdbc0QAIfmKopv8vr5C8HZbhcxNZ/1sNU601UtzFVNFKwfxjubYzY4bFL+gFdmydWHjcGReSEcRV6DQ+ohlQuhv6HqmDRQ6+9y+wJs/BMq8MKIJyoDLRe/FVgLcd+tlT6cPMiPuLqCN103fvIdZHvDZQeNvkV2lUR8zRoPrzGIrm6rmYRp8PSYaB75aFMn1FN0jkp/r96KYb1WpIDboIDFOnR7bYHqFOqnhpyeb+BgX2bF/7h89vX7XcWDcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNrejdGQ9VY2kUIVe00JlOU/9wt3geagh3oVFyRJvMk=;
 b=EhrYGALAvjB+Ko9Z0Ojpl5UpDKQ+6pljJZmek0W3y8wm6sLcECgWBjmi6tSFFvoOP+p1VKB3HwwnUpappwuBze9hCDt41gYPLpoFHHp8adT5AQ8rRHD21jcLBtA9rvu786uPvvv4pdJb//tFweJzO/9DNbzhmFHz6ppe6OZK92s3JJOlyhOadDmvXh+BjYZUvhC5475srM1iSoU0YVGLcHmjSLVusJarAw5eCgQYPI+pT10FI+uDP6PIWf9DP6H3hNJS3uemp820alOPlQ8gCKnmCWcd5DVIfzd0/gxx9zxV6iry3ZswCqMUhH+j3G0KEeWnrxTf0plDXvXv4s9GDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNrejdGQ9VY2kUIVe00JlOU/9wt3geagh3oVFyRJvMk=;
 b=l6zFnrz73RgfqlDolQwJqfv8Hpc1lm1MsZhBCGz3YgbtismYZ2ALvlbDnsRCe8ytHws+e1D9EWDE3BMQBVpAllUK+vqbhCIgQ/Q2mmhqfT9FTY2plxSd9B9T4M1/kORr9ErMivnVJigBtdHnz+/ZJCQ8aXYKISmX8EFNsYJJimE=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB2849.namprd12.prod.outlook.com (2603:10b6:408:6e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Tue, 14 Apr
 2020 11:14:05 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 11:14:05 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Julien Beraud <julien.beraud@orolia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/2] net: stmmac: Fix sub-second increment
Thread-Topic: [PATCH 2/2] net: stmmac: Fix sub-second increment
Thread-Index: AQHWEjzJl2bGDtzrd0q53ni2NN1AB6h4VYEggAAJQYCAABbfQA==
Date:   Tue, 14 Apr 2020 11:14:04 +0000
Message-ID: <BN8PR12MB32661DCB43EFE9F9235431A4D3DA0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200414091003.7629-1-julien.beraud@orolia.com>
 <20200414091003.7629-2-julien.beraud@orolia.com>
 <BN8PR12MB3266F9F1656962A9D1675AE9D3DA0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <310f0a67-7744-3544-126f-dff1fcb75ef4@orolia.com>
In-Reply-To: <310f0a67-7744-3544-126f-dff1fcb75ef4@orolia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [82.155.99.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2885ff1f-41e7-406b-789d-08d7e064f19a
x-ms-traffictypediagnostic: BN8PR12MB2849:
x-microsoft-antispam-prvs: <BN8PR12MB2849D2CD082B70346F9E79C9D3DA0@BN8PR12MB2849.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(366004)(346002)(136003)(396003)(39860400002)(33656002)(4326008)(26005)(8936002)(8676002)(2906002)(9686003)(81156014)(55016002)(110136005)(316002)(66946007)(66476007)(66446008)(64756008)(66556008)(186003)(6506007)(7696005)(86362001)(5660300002)(71200400001)(52536014)(478600001)(76116006);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TThtq8/T9K3apS+wpVoH+dxKYpDERMHVvPFwHRpV3R5KROLf3gHVBfe/6VT2q/YG7XoO1OeLi1B+gDaCQFt2I2gCUxF67ESDXbOWBrpb4qpvIoyC+v36k+QvbVOA/4OaMx61TR8MqkCWKUiNle5/5b6reW1WoaukcaBAsE7a1+xh9zYDnQoFI2SX4FUuDA8F3qCkyS68VyfWZBL65Nztug2xceJxY0ZcnNm5N4v3aAu3ef6IqGdlpxtJ6GQ74QfqePr2lvadyBS3K+1HtSqFd6bUq10zAjM4DPJAyYS7xZpWD/xR1vdkY8Vu/MWTXo1emktGuD5prLkJXqbe6E//yz+ZPad9MHjabsUs2aIuXEo3rLz9YIr1Iw/HrV4YhVGsGzUwU0oImi0bQGhppF9zNyhce3fkk8TuIntGIIBIid9XIn2UQZwH70FFFKzXgzIW
x-ms-exchange-antispam-messagedata: kKxfgpxLplYDvzGlIapT5EYE84l2k7LDYp3LJr7rnDidwjyjC6HpFj/ydsOCxnnQkux2d121lZMenzALS6ivwqqk56WQ979++lJGqkNGS/tXHrK7dE/FXyqI/5xg0n8yx/ZLTk1rJKTdY/LTAwOc9w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2885ff1f-41e7-406b-789d-08d7e064f19a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 11:14:05.0208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hn57JsL3vDTL+yMuxgkUmmhLlaSWi+JfQOhAzZiMI8SWJJG1AS4yv98nRZz7Op2oWJr590XgvSFvfc+u6gGujA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2849
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSnVsaWVuIEJlcmF1ZCA8anVsaWVuLmJlcmF1ZEBvcm9saWEuY29tPg0KRGF0ZTogQXBy
LzE0LzIwMjAsIDEwOjQ2OjQ5IChVVEMrMDA6MDApDQoNCj4gVGhlIG51bWJlcnMgSSBoYXZlIGlu
IHRoZSBkb2N1bWVudGF0aW9uIHNheSB0aGF0IHRoZSBtaW5pbXVtIGNsb2NrIA0KPiBmcmVxdWVu
Y3kgZm9yIFBUUCBpcyBkZXRlcm1pbmVkIGJ5ICIzICogUFRQIGNsb2NrIHBlcmlvZCArIDQgKiBH
TUlJL01JSSANCj4gY2xvY2sgcGVyaW9kIDw9IE1pbmltdW0gZ2FwIGJldHdlZW4gdHdvIFNGRHMi
LiBUaGUgZXhhbXBsZSB2YWx1ZXMgc2F5IA0KPiA1TUh6IGZvciAxMDAwLU1icHMgRnVsbCBEdXBs
ZXguIElzIHRoaXMgZG9jdW1lbnRhdGlvbiBpbmNvcnJlY3QgPw0KDQpJIG1lYW50IGZvciBmaW5l
IHVwZGF0ZSBtZXRob2QgKHdoaWNoIGlzIHRoZSBvbmUgY3VycmVudGx5IHVzZWQpLCB0aGUgDQpj
bG9jayBmcmVxdWVuY3kgbXVzdCBiZSBoaWdoZXIgdGhhbiB0aGUgZGVzaXJlZCBhY2N1cmFjeSAo
d2hpY2ggaXMgDQo1ME1IeikuDQoNCj4gQXBhcnQgZnJvbSB0aGF0LCB0aGUgZXhpc3RpbmcgbG9n
aWMgZG9lc24ndCB3b3JrLiBUaGUgY2FsY3VsYXRpb24gaXMgb2ZmIA0KPiBieSBhIGZhY3RvciAy
LCBtYWtpbmcgdGhlIHB0cCBjbG9jayBpbmNyZW1lbnQgdHdpY2Ugc2xvd2VyIGFzIGl0IHNob3Vs
ZCwgDQo+IGF0IGxlYXN0IG9uIHNvY2ZwZ2EgcGxhdGZvcm0gYnV0IEkgZXhwZWN0IHRoYXQgaXQg
aXMgdGhlIHNhbWUgb24gb3RoZXIgDQo+IHBsYXRmb3Jtcy4gUGxlYXNlIGNoZWNrIGNvbW1pdCAx
OWQ4NTdjLCB3aGljaCBoYXMga2luZCBvZiBiZWVuIHJldmVydGVkIA0KPiBzaW5jZSBmb3IgbW9y
ZSBleHBsYW5hdGlvbiBvbiB0aGUgc3ViLXNlY29uZHMgKyBhZGRlbmQgY2FsY3VsYXRpb24uDQo+
IEFsc28sIGl0IGFydGlmaWNpYWxseSBzZXRzIHRoZSBpbmNyZW1lbnQgdG8gYSB2YWx1ZSB3aGls
ZSB3ZSBzaG91bGQgDQo+IGFsbG93IGl0IHRvIGJlIGFzIHNtYWxsIGFzIHBvc2libGUgZm9yIGhp
Z2hlciBmcmVxdWVuY2llcywgaW4gb3JkZXIgdG8gDQo+IGdhaW4gYWNjdXJhY3kgaW4gdGltZXN0
YW1waW5nLg0KDQpJJ20gc29ycnkgYnV0IEkgZG9uJ3Qgc2VlIGFueSAib2ZmIGJ5IGZhY3RvciBv
ZiAyIi4gSSBhbHNvIGRvbid0IA0KdW5kZXJzdGFuZCB0aGlzOg0KICJ0aGUgYWNjdW11bGF0b3Ig
Y2FuIG9ubHkgb3ZlcmZsb3cgb25jZSBldmVyeSAyIGFkZGl0aW9ucyINCg0KQ2FuIHlvdSBwbGVh
c2UgcHJvdmlkZSBtb3JlIGRldGFpbHMgPw0KDQpCVFcsIEkgYXBwbGllZCB5b3VyIHBhdGNoIGFu
ZCBJIHNhdyBubyBkaWZmZXJlbmNlIGF0IGFsbCBpbiBteSBzZXR1cCANCmV4Y2VwdCBmb3IgcGF0
aCBkZWxheSBpbmNyZWFzaW5nIGEgbGl0dGxlIGJpdC4NCg0KLS0tDQpUaGFua3MsDQpKb3NlIE1p
Z3VlbCBBYnJldQ0K
