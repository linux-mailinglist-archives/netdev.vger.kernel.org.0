Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353E21867F1
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgCPJcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:32:32 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:39984 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730025AbgCPJcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:32:32 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9E435891AD;
        Mon, 16 Mar 2020 22:32:27 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1584351147;
        bh=V0O3aq6hbiIFibPdk6wV1NdKjC0vrqYnL+s1/TpL2AY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=xcFDkYZdMgaWXcdgkzR9rwLeNts9xQIfTG1F1eVfKO8WRzMg6AAQOPBYsaG+SpUb5
         UI5jCtbtC/4NIWeF0GshJ1Q+PqBYJJ+8He67DwSf3Bmqtj0B7kOweFkpGIMA8ra/pR
         vl0WE6b72v4bazdkXx4AYBwH84uk8jNz26IdBBg13tDUN+bzkY/rHmAMf/ZJNufmhT
         nApN5FNY5T49I1xF7rCZ4AwDkKzDf9ope6ihouui84RQTDVJ5r3JEAKitl0zRSAcyE
         G2eWDwSIW/qFOkaOkp1wZGwX15aHKdVK0S/HPqIMq0o9tg3xAfF1EsMUqwg1gy4D2D
         B3o/ld3G9Fkog==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e6f47ac0000>; Mon, 16 Mar 2020 22:32:28 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Mar 2020 22:32:26 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 16 Mar 2020 22:32:26 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josua@solid-run.com" <josua@solid-run.com>
Subject: Re: [PATCH v2] net: mvmdio: avoid error message for optional IRQ
Thread-Topic: [PATCH v2] net: mvmdio: avoid error message for optional IRQ
Thread-Index: AQHV9+B2ZGst8pFaOk2XUMzXhPXGHqhJ/4cAgAATMACAAA80gA==
Date:   Mon, 16 Mar 2020 09:32:25 +0000
Message-ID: <49cd4dbc073c3b8b1a5d9b2714d95a45b0d21a97.camel@alliedtelesis.co.nz>
References: <20200311200546.9936-1-chris.packham@alliedtelesis.co.nz>
         <63905ad2134b4d19cb274c9e082a9326a07991ac.camel@alliedtelesis.co.nz>
         <20200316083800.GB8524@lunn.ch>
In-Reply-To: <20200316083800.GB8524@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.14.96]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5399738A5E26844DABE8E4273C1A4593@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAzLTE2IGF0IDA5OjM4ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiBBY3R1YWxseSBvbiBjbG9zZXIgaW5zcGVjdGlvbiBJIHRoaW5rIHRoaXMgaXMgd3JvbmcuDQo+
ID4gcGxhdGZvcm1fZ2V0X2lycV9vcHRpb25hbCgpIHdpbGwgcmV0dXJuIC1FTlhJTyBpZiB0aGUg
aXJxIGlzIG5vdA0KPiA+IHNwZWNpZmllZC4NCj4gDQo+IFRoZSBfb3B0aW9uYWwgaXMgdGhlbiBw
b2ludGxlc3MuIEFuZCBkaWZmZXJlbnQgdG8gYWxsIHRoZSBvdGhlcg0KPiBfb3B0aW9uYWwgZnVu
Y3Rpb25zIHdoaWNoIGRvbid0IHJldHVybiBhbiBlcnJvciBpZiB0aGUgcHJvcGVydHkgaXMNCj4g
bm90DQo+IGRlZmluZWQuDQo+IA0KPiBBcmUgeW91IHJlYWxseSBzdXJlIGFib3V0IHRoaXM/IEkg
ZG9uJ3QgaGF2ZSB0aGUgdGltZSByaWdodCBub3cgdG8NCj4gY2hlY2suDQo+IA0KDQpSZWdyZXRh
YmJseSB5ZXNbMV0uIEl0IGNhdWdodCBtZSBieSBzdXJwcmlzZSB0b28uIEkgb25seSBub3RpY2Vk
IHdoZW4gSQ0Kd2VudCB0byB1c2UgYSBkaWZmZXJlbnQgYm9hcmQgdGhhdCB1c2VkIHRoYXQgZHJp
dmVyLiBJIHRoaW5rIHRoZQ0KcHJvYmxlbSBpcyB0aGF0IG9uIHNvbWUgcGxhdGZvcm1zIDAgaXMg
YSB2YWxpZCBpcnEgc28gaXQgY2FuJ3QganVzdCBiZQ0KdXNlZCB0byBpbmRpY2F0ZSBhIG1pc3Np
bmcgaW50ZXJydXB0Lg0KDQpbMV0gLSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvdHJlZS9kcml2ZXJzL2Jhc2UvcGxhdGZv
cm0uYyNuMTM4DQoNCg0K
