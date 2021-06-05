Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6501F39C584
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 05:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFEDhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 23:37:02 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:49384 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhFEDhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 23:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622864113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CsLdjd4wbv/ZMmkV98NaoCNLBgk912dfPrNIGc8YoNU=;
        b=i3WvYOyfPrn7sw/+IV5AnlGO4ylYCAAt3SztuFlDbeK2EgKdfJQ99YfvMVreJc3hmrhtoQ
        iSLzx9w+xhQr+Kjq8yHG/cQJx0MFKbCWebwtDBCMPfajFXQQhANq4ictS1Az7MLGtefL5W
        0YcL5uBnsrOd9HNuHAgpzfr8q/AXgLQ=
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-NaTMFnMlOsmY75ygHuWXmg-1; Fri, 04 Jun 2021 23:35:10 -0400
X-MC-Unique: NaTMFnMlOsmY75ygHuWXmg-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (10.164.204.32) by
 MWHPR19MB1039.namprd19.prod.outlook.com (10.173.124.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.20; Sat, 5 Jun 2021 03:35:07 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.024; Sat, 5 Jun 2021
 03:35:07 +0000
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
Thread-Index: AQHXWVyDhUpan91jNkyIQ1KYwvXYZKsECXGAgAAhoACAAB2SAIAAfDEA
Date:   Sat, 5 Jun 2021 03:35:07 +0000
Message-ID: <2b9945f9-16a4-bda5-40df-d79089be3c12@maxlinear.com>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
 <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
 <YLqIvGIzBIULI2Gm@lunn.ch>
In-Reply-To: <YLqIvGIzBIULI2Gm@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [27.104.184.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a9662bc-d110-45a0-3e62-08d927d2e9f5
x-ms-traffictypediagnostic: MWHPR19MB1039:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB103929846B822132D2A8AE56BD3A9@MWHPR19MB1039.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: IJBvQWaOHuEFfllH5NOnWa22WqKiSNsHmbXLK0VfXAhSGGLNQYWdwQwcctA6TqASWgbOFUMGEH+3ayL7mfOQP87d4V8zXZOk+YjcYSGuZj96hI0P28Hxec+6fh8VZ41TjLo+ApK4EcTClvv9ZmkuYny5aygL/TXQMCAs7a9C/tP8f3dZAbocoUEqHNP3Ui255RJBnjO83ufbGI/+enDeGDu0VIHjIo7r4nSbg6Mz2todLNF2L35+jxmDo2WZRLEAWVms1MFafyk8rmwR33EBnGQrx5GdnSHvCzuAZCYlV7TYmLqbFjQYxadmqp1pm6gt86ICLet/yqtg9WYBcsC+3gvk9l5H9zYuYS54zZEJTiIrkPYxasBFKjb9i+5b/sDES8WBvARiyUafEfEJPxOvz4o+2B0oDMbx17R5F3CTT3b8NFmXUaskVHLYEYFIMhzZzDulnbM9Sfs5U637qmL5nGYprXPl6WlGGPe+YpYw7CM4MZqMH4DzByrOTHY1addThNw4gRy6Ud1cMIhKRWmJdjt2vdt9x2BwTkuV4TKAXxQH0Cj6cdECR5jldQRlMKH3ZB/a5J5Xm0q/aR8MMBqYK/VxNPRGGlCc8dAIc3s14c5qog9f7dICxK3xx8vOJULPyPW++oOa6wmLQF0ImgFpZcv0J15XidJolZw1ytypmw/eCTUumweik0Ym6EWp+QC9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39840400004)(396003)(136003)(376002)(76116006)(71200400001)(6916009)(66556008)(83380400001)(478600001)(36756003)(5660300002)(2616005)(66946007)(26005)(64756008)(6512007)(66446008)(186003)(31686004)(6486002)(66476007)(91956017)(8936002)(6506007)(54906003)(86362001)(53546011)(107886003)(31696002)(8676002)(316002)(2906002)(122000001)(4326008)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?bzh6NmUwczliRjl4dWpkL3ZtWEM1Z2t4UUtpMjZvc0dVbnJjTWdTbEFGeWpx?=
 =?utf-8?B?aXlIUUtyaFJDbG5LbTlIMk5QZy8xenF0V05BamFuQ3gyb01wSzRNTkJXdG5M?=
 =?utf-8?B?YkpRUS9EdW00QnFUaVFZU2hpNWRDOGY1dS9MeVZzRXdVLy91QXRwR1lYR3dG?=
 =?utf-8?B?RllOTGJ2WFpWaytCT0dCdHAyWk9KU3pRT2pQeG45QUFpa0k1RFd6a2U2K2sr?=
 =?utf-8?B?Nnd4WktqK3dzbFAzUEtvYldMNUpjRFZGc0VsdG9pcXNCY1BYbnMvV1lCb1dY?=
 =?utf-8?B?SkJ3QVdzV0lubHZDdEVtOEl1eFI0aTZ4MHJ2RTBadUtHNjE1ZGd3UG9FR1lq?=
 =?utf-8?B?NlExYkYyRTJkNXhxbGNNRjN1MFB1UzJscUtkalFTOWhWZ29YOXRjTlhDWkZk?=
 =?utf-8?B?WFVwcFc2d2crcFpWaVFsQjMzMEljR0dsK3RJc2tXWmZWQytjUkhWeVVPRTRt?=
 =?utf-8?B?TlFDZ05HL2EzZk9jU2ltZUhSUENnQ2xWdDRqQTJlYXB2WFVTV1UxdnU2d0Ju?=
 =?utf-8?B?b29KSjJwaXBHWTIybjdFZU5UdWNYM2cvNHpIR1R2NitBVncvczNvUUdzMU40?=
 =?utf-8?B?VWg0M2N3MHAybGdoNGpHQkp0dmF1MVpma3dtcjlSdDhyZWRlUTV2N2Zzek5F?=
 =?utf-8?B?azBYRVJDMEZBNmd6WTU0dC9leXFiR1dYUllyK0ZsN3RHWlAzUzBWOTIvUlJ1?=
 =?utf-8?B?SUhjc3dwRG5Ud0N1VkdIT1hyWnF2dk1YSlo1aVJPak9GTXhmTWRISVFmRE9J?=
 =?utf-8?B?enExQjkwQ0krZ05xOWczSzhtMk5vanZDV2xlZ2pRVHJDWmtGQUZHOExLYUN0?=
 =?utf-8?B?d0ZsTTNodDhLZ1M2My9CaWhiRW9icDhid2wyM21qalZYWG5jZG1SaXZubmdE?=
 =?utf-8?B?UFdGQWJYYjU1QVg2WldwS3h1VDFCbTNrWitwZ205bW9yQ0hCalRTQmVXM05v?=
 =?utf-8?B?QnZyYzZqWG5HSVFIeWt3bWlxVDMwaW9sNlIyMDdqREtIOGRRNTN2TW9YSHZP?=
 =?utf-8?B?OWI4YjlNY3JjNVlwMk5MdDllSlFZNTBFREE4L3FvY3hWajZDb3J5SHR5R3hK?=
 =?utf-8?B?QUxmVG5ZR0RWSWIwNkJ6SklVMFpXNzlBM2U5VFFtR2cxYWw4ckh6UVVING1u?=
 =?utf-8?B?UEZOWkU0T1BjNmtGZ3BBSFJCQVcxa3pUR3NpWkhsbDhBeVlMb3RxSy94VXkr?=
 =?utf-8?B?QUY5OWwzNGp2M0VGaXZ0eEZMTmVtRnBENktPcVlmcG9lcnQ5czBkMGVoNy9x?=
 =?utf-8?B?dXNyOHJXUThJRkJNRm1PeEhUbXBGUW04YVVOVTVrRm4vc1JPT1FRZjA2NkpO?=
 =?utf-8?B?OWJaU3kzVTRhT1lkbjdVTHNTY2NqOWZoZlNlQ1lPa25xemtraFZHNHFDY3VZ?=
 =?utf-8?B?eUZ2NmpJeExQaEtZUy9pRzFCTkFiUDFwMWlhT2J1aDhaT2tRSlJ3V2wzb3pN?=
 =?utf-8?B?VjFEcFl3SkZoam1WeWZtVU5VelRkNWkwbjZoS1o0ck1uRUlkSS9ueXJNa2lP?=
 =?utf-8?B?STNhNWFlZ2llZ2haNm42T25KWmd6c1pVR2Yzei9LcW5GMFRWWWdpQWJXazRm?=
 =?utf-8?B?S1hPM0FpZGhKSE5jUWNYZmZqQThIVzVLMXhDb3JwcmQ1Y21LT0dkZVRtcWZs?=
 =?utf-8?B?ZkRIOEJPUW1Qc3pkZTlLTlBmOENUMVZld3V5c0g0cGhjQTNZMXlHTXphMm5y?=
 =?utf-8?B?TWY5ZkNabFdVVXdjQURMTlhCa1JOTlpvdUlXYlhUYlhxS2NMSEFVd1YxMnNq?=
 =?utf-8?Q?1FzQZLavqhm4aTXOYQ=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9662bc-d110-45a0-3e62-08d927d2e9f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2021 03:35:07.0675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /NSyGOLjT0YeagMVXEvNDVlGXgbH+sQOWR4alSMrVfrxQJgZBdqijgu+2XysbBR7/sw9uE1zoP7hkaLij/1AJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB1039
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <7D61193535285F419F2C2083DEFCC0CF@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS82LzIwMjEgNDoxMCBhbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IFRoaXMgZW1haWwgd2Fz
IHNlbnQgZnJvbSBvdXRzaWRlIG9mIE1heExpbmVhci4NCj4NCj4NCj4+Pj4gK3N0YXRpYyBpbnQg
Z3B5X3JlYWRfYWJpbGl0aWVzKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+Pj4+ICt7DQo+
Pj4+ICsgaW50IHJldDsNCj4+Pj4gKw0KPj4+PiArIHJldCA9IGdlbnBoeV9yZWFkX2FiaWxpdGll
cyhwaHlkZXYpOw0KPj4+PiArIGlmIChyZXQgPCAwKQ0KPj4+PiArIHJldHVybiByZXQ7DQo+Pj4+
ICsNCj4+Pj4gKyAvKiBEZXRlY3QgMi41Ry81RyBzdXBwb3J0LiAqLw0KPj4+PiArIHJldCA9IHBo
eV9yZWFkX21tZChwaHlkZXYsIE1ESU9fTU1EX1BNQVBNRCwgTURJT19TVEFUMik7DQo+Pj4+ICsg
aWYgKHJldCA8IDApDQo+Pj4+ICsgcmV0dXJuIHJldDsNCj4+Pj4gKyBpZiAoIShyZXQgJiBNRElP
X1BNQV9TVEFUMl9FWFRBQkxFKSkNCj4+Pj4gKyByZXR1cm4gMDsNCj4+Pj4gKw0KPj4+PiArIHJl
dCA9IHBoeV9yZWFkX21tZChwaHlkZXYsIE1ESU9fTU1EX1BNQVBNRCwgTURJT19QTUFfRVhUQUJM
RSk7DQo+Pj4+ICsgaWYgKHJldCA8IDApDQo+Pj4+ICsgcmV0dXJuIHJldDsNCj4+Pj4gKyBpZiAo
IShyZXQgJiBNRElPX1BNQV9FWFRBQkxFX05CVCkpDQo+Pj4+ICsgcmV0dXJuIDA7DQo+Pj4+ICsN
Cj4+Pj4gKyByZXQgPSBwaHlfcmVhZF9tbWQocGh5ZGV2LCBNRElPX01NRF9QTUFQTUQsIE1ESU9f
UE1BX05HX0VYVEFCTEUpOw0KPj4+PiArIGlmIChyZXQgPCAwKQ0KPj4+PiArIHJldHVybiByZXQ7
DQo+Pj4+ICsNCj4+Pj4gKyBsaW5rbW9kZV9tb2RfYml0KEVUSFRPT0xfTElOS19NT0RFXzI1MDBi
YXNlVF9GdWxsX0JJVCwNCj4+Pj4gKyBwaHlkZXYtPnN1cHBvcnRlZCwNCj4+Pj4gKyByZXQgJiBN
RElPX1BNQV9OR19FWFRBQkxFXzJfNUdCVCk7DQo+Pj4+ICsNCj4+Pj4gKyBsaW5rbW9kZV9tb2Rf
Yml0KEVUSFRPT0xfTElOS19NT0RFXzUwMDBiYXNlVF9GdWxsX0JJVCwNCj4+Pj4gKyBwaHlkZXYt
PnN1cHBvcnRlZCwNCj4+Pj4gKyByZXQgJiBNRElPX1BNQV9OR19FWFRBQkxFXzVHQlQpOw0KPj4+
IFRoaXMgZG9lcyBub3QgYWNjZXNzIHZlbmRvciBzcGVjaWZpYyByZWdpc3RlcnMsIHNob3VsZCBu
b3QgdGhpcyBiZSBwYXJ0DQo+Pj4gb2YgdGhlIHN0YW5kYXJkIGdlbnBoeV9yZWFkX2FiaWxpdGll
cygpIG9yIG1vdmVkIHRvIGEgaGVscGVyPw0KPj4+DQo+PiBnZW5waHlfcmVhZF9hYmlsaXRpZXMg
ZG9lcyBub3QgY292ZXIgMi41Ry4NCj4+DQo+PiBnZW5waHlfYzQ1X3BtYV9yZWFkX2FiaWxpdGll
cyBjaGVja3MgQzQ1IGlkcyBhbmQgdGhpcyBjaGVjayBmYWlsIGlmDQo+PiBpc19jNDUgaXMgbm90
IHNldC4NCj4gWW91IGFwcGVhciB0byBvZiBpZ25vcmVkIG15IGNvbW1lbnQgYWJvdXQgdGhpcy4g
UGxlYXNlIGFkZCB0aGUgaGVscGVyDQo+IHRvIHRoZSBjb3JlIGFzIGkgc3VnZ2VzdGVkLCBhbmQg
dGhlbiB1c2UNCj4gZ2VucGh5X2M0NV9wbWFfcmVhZF9hYmlsaXRpZXMoKS4NCj4NCj4gICAgICAg
ICAgQW5kcmV3DQo+DQpJJ20gbmV3IHRvIHVwc3RyZWFtIGFuZCBkbyBub3Qga25vdyB0aGUgcHJv
Y2VzcyB0byBjaGFuZ2UgY29kZSBpbiBjb3JlLg0KDQpTaG91bGQgSSBhZGQgdGhlIHN1cHBvcnQg
ZnVuY3Rpb24gaW4gc2FtZSBwYXRjaD8NCg0K

