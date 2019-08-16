Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 046228FDC1
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfHPI0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:26:20 -0400
Received: from de-out1.bosch-org.com ([139.15.230.186]:38268 "EHLO
        de-out1.bosch-org.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPI0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 04:26:20 -0400
Received: from si0vm1947.rbesz01.com (unknown [139.15.230.188])
        by si0vms0217.rbdmz01.com (Postfix) with ESMTPS id 468xHD4PLnz4f3kZr;
        Fri, 16 Aug 2019 10:26:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=escrypt.com;
        s=key1-intmail; t=1565943976;
        bh=51lHsOudyERfxi06LdmLTl0wH2tAJofmNNzjgVcYkQk=; l=10;
        h=From:Subject:From:Reply-To:Sender;
        b=eKmEMwuZXGOsZ8mgXfzigiOEyHZf+By8nt9KDsoawFhz12ggcA1JlhY3glYwYxUyp
         0PnlGtbmuS5w/P2Muap52fJ37iG1+1rkSmdxijvQIpoyTAfpyuiLLCQyeYMqUSYEyM
         atn8MD2/cxfOOkAiC3fGG17LZ43DUomtkZuFa6RE=
Received: from fe0vm7918.rbesz01.com (unknown [10.58.172.176])
        by si0vm1947.rbesz01.com (Postfix) with ESMTPS id 468xHD42ktz6CjQfT;
        Fri, 16 Aug 2019 10:26:16 +0200 (CEST)
X-AuditID: 0a3aad10-12dff700000020cf-9e-5d5668a833e4
Received: from si0vm1949.rbesz01.com ( [10.58.173.29])
        (using TLS with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by fe0vm7918.rbesz01.com (SMG Outbound) with SMTP id 71.8D.08399.8A8665D5; Fri, 16 Aug 2019 10:26:16 +0200 (CEST)
Received: from FE-MBX2038.de.bosch.com (fe-mbx2038.de.bosch.com [10.3.231.48])
        by si0vm1949.rbesz01.com (Postfix) with ESMTPS id 468xHD2TcNz6Cjw36;
        Fri, 16 Aug 2019 10:26:16 +0200 (CEST)
Received: from FE-MBX2038.de.bosch.com (10.3.231.48) by
 FE-MBX2038.de.bosch.com (10.3.231.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 16 Aug 2019 10:26:16 +0200
Received: from FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2]) by
 FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2%2]) with mapi id
 15.01.1713.008; Fri, 16 Aug 2019 10:26:16 +0200
From:   "FIXED-TERM Buecheler Konstantin (ETAS-SEC/ECT-Mu)" 
        <fixed-term.Konstantin.Buecheler@escrypt.com>
To:     Patrick Menschel <menschel.p@posteo.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dan Murphy <dmurphy@ti.com>
Subject: AW: can: tcan4x5x: spi bits_per_word issue on Raspberry PI
Thread-Topic: can: tcan4x5x: spi bits_per_word issue on Raspberry PI
Thread-Index: AdVShK+Dlg6CyEY5S5W9jARFpSiyrAAKzACwACDpRIAABDvpgAAxaNpg
Date:   Fri, 16 Aug 2019 08:26:16 +0000
Message-ID: <47108d803086402c83d1073f3e3a62bb@escrypt.com>
References: <3f71bdff8f4f4fe19ad9a09be89bc73d@escrypt.com>
 <f78bb414-4165-3f56-151a-47ab4a8a645d@pengutronix.de>
 <e6577cc2-89fc-9428-b73e-47f41eff2949@posteo.de>
In-Reply-To: <e6577cc2-89fc-9428-b73e-47f41eff2949@posteo.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.23.200.63]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA22Tb0xTVxjGOb0XubBePVza8g6odF1kUSLCplnVbTFxM3yYc3OBELYGi1xo
        M1pIb3FCsoXYuRBqoCaUlTJAwTrnolX+yMaUhgICZbJpmEEDW3RzQ6bOjVBEEXfbW2g/7MvJ
        Oc9zfs/7nvfmUgTTQSVQOoOJNRo0xcpVMWTMtjPyjae02er08+5ElWW0M1J1et5GqP6xjpEq
        V2sdqbp8TLYjMrP2aXrm435p5tBEtyhztn3tu2RuzGsFbLHuAGvc9Ma+GO3C8Hxk6QV88PMj
        40QlqsTVKJoCvBm+9/4ZVY1iKAbbRXDr2Xjw0IvgjtkbKRzuIxiYqiRWnLN/LZJ+fhXWwdEO
        q8hvSPAgArN9KspvEDgZJloeIv8+Du+Ee2fv8ADFX3oTjjSm+mUJ3gU1422BHBKvA3O9L3Cd
        xtvg+BdtIqGYE8Gw3RUwovHr0GFdCOQjLIdz534khFrx0P7HfKTwIAwnLgo6YCnc/W0pqCvg
        QX9PoAcCrwdXzyYBfQHqLLeihLqxMNLwO2lF8Y6wVEeIcIQRjjDiGCJPI2khm35A/+rWDFWa
        MZ/lKtIz0vaX6NuR8Anxt+g7b6EHiSjkQVsokVJKf2x7X82szi8pKNdqOG2esayY5ZQJdJdc
        pWbiVmSuLF+v4zhdicGDgCKUEtp6da+aoQs05RWssUTAPCiRIpXxdBG150MGF2lM7EcsW8oa
        l93tFKUEerYwW83EGtki9mChrti0bCvlNIqIiGBk4U54WREV7UGvUGK+doM/guZKNXpOVxTE
        nxdwZlkNoV6URVnvNrUSVN9gM786B9v4daDJ2UowpKHEwCbE02Vb+ETsZ7VlhpWeEpLol5z8
        M6VhRih3Bk0gCinj6I4CHhbzf0uoG6C7/QOMDYoh6OUTPIO9z0HzISPYH9oQLNlPknDINUfC
        XNczftfeGQWu+hEKqnofUTD9w7AYqlrnxDDhPENDy+XDq6Hz8PE1MDEztAYaa69iaK43M1D3
        6AoDt61OCczeOy+Fqs4RGTyYORkP7r6hJPil7kYSzF75Wg43emuT4afJm8nQZXcoYPFXnwKu
        +VqUMDx98UWwuGvXw2cW34YZftIiftJbx7L8kzZpTP8z6aAaelxCJYIxrwbJOnIfL41m7/wy
        p2Cv27S73/UzkyZpesuyveGbZFuO6v7mGq4rZXHtV6n6jO7r124+GamRKFJk7803fipKHOnb
        uDCZt9ujcA0+saVMpppl+v3TuadSFezb4gFC/U7F7bxPfJeu28vd0n17Llj/nc764Ojojr97
        ctZdmnraW60kOa0mYwNh5DT/AbbNXJzGBAAA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+PiBOb3cgSSBoYXZlIGFub3RoZXIgcmVhbGx5IGNvbmZ1c2luZyBwcm9ibGVtLiBBbnl0aGlu
ZyBJIHdyaXRlIHRvIFNQSSBpcyB3cml0dGVuIGxpdHRsZSBlbmRpYW4uIFRoZSB0Y2FuIGNoaXAg
ZXhwZWN0cyBiaWcgZW5kaWFuLg0KPiA+PiBBbnl0aGluZyBJIHJlYWQgZnJvbSBTUEkgaXMgdHJl
YXRlZCBhcyBsaXR0bGUgZW5kaWFuIGJ1dCBpcyBiaWcgZW5kaWFuLiBEb2VzIGFueW9uZSBrbm93
IHdoeSB0aGlzIGhhcHBlbnM/DQo+ID4+IElzIHRoZXJlIGEgZmxhZyBvciBzb21ldGhpbmcgSSBj
YW4gc2V0IGZvciB0aGUgU1BJIGRldmljZS93aXJlIHRvIGZpeCB0aGlzPw0KPiA+DQo+ID4gSGF2
ZSB5b3UgY2hhbmdlZCB0aGUgYml0c19wZXJfd29yZCB0byA4PyBUaGVuIHlvdSByZWFkIGp1c3Qg
YSBzdHJlYW0NCj4gPiBvZiBieXRlcy4gSWYgeW91IHRyZWFkIHRoZW0gYXMgYW4gdTMyIHRoZXkg
YXJlIGluIGhvc3Qgb3JkZXIuDQo+ID4NCg0KQE1hcmMNClllcywgSSBjaGFuZ2VkIGJpdHNfcGVy
X3dvcmQgdG8gOC4gU2luY2UgdGhlIFBJIGRvZXMgbm90IHN1cHBvcnQgYW55IHZhbHVlcyBhcGFy
dCBmcm9tIA0KOCBhbmQgOSB0aGlzIHNlZW1zIHRvIGJlIHRoZSBvbmx5IHdheS4NCg0KPiA+IE1h
cmMNCj4gPg0KPiANCj4gDQo+IEhpLA0KPiANCj4gZnJvbSBteSBleHBlcmllbmNlIHdpdGggU1BJ
REVWIG9uIFJQSSwgdGhlIGRyaXZlciB1c2VzIGEgY2hhciBhcnJheSBmb3IgSS9PLg0KPiBBcyB0
aGUgUlBJIGNvZGUgaXMgYnVpbGQgbGl0dGxlIGVuZGlhbiwgbG9naWNhbGx5IGxpdHRsZSBlbmRp
YW4gY29tZXMgb3V0IG9mIFNQSS4gWW91DQo+IGJhc2ljYWxseSBoYXZlIHRvIGludmVydCB0aGUg
Yml0IGFuZCBieXRlIG9yZGVyIGJ5IGhhbmQgZm9yIGEgYmlnIGVuZGlhbiBzbGF2ZS4NCj4gDQoN
CkBQYXRyaWNrLCBNYXJjDQpZb3UgYm90aCBhcmUgcmlnaHQuIFRoaXMgc2VlbXMgdG8gYmUgdGhl
IHByb2JsZW0uIFRoZSBTUEkgZHJpdmVyIHVzZXMgY2hhciBhcnJheXMNCmFuZCB0aGUgdGNhbiBk
cml2ZXIgdHJlYXRzIHRoZW0gYXMgdTMyLiANCg0KSSB3aWxsIHRyeSB0byBjaGFuZ2UgdGhlIGJ5
dGUgb3JkZXIgYnkgaGFuZCB0byBnZXQgaXQgcnVubmluZyBmb3IgbXkgcHJvamVjdC4gQnV0IGlu
IHRoZSBsb25nIA0KcnVuLCB0aGlzIGRvZXMgbm90IHNlZW0gdG8gYmUgYSBwcm9wZXIgc29sdXRp
b24uLi4gDQoNClJlZ2FyZHMsIA0KS29uc3RhbnRpbiANCg0KDQo+IENsb2NrIFBoYXNlIGFuZCBD
bG9jayBQb2xhcml0eSBhcmUgYWxzbyBhbiBpc3N1ZSBvbiB0aGUgUlBJIGFzIGF0IGxlYXN0IFNQ
SURFVg0KPiBraW5kbHkgb3Zlcmxvb2tzIGFueSBvcHRpb25zIHNldCBwcmV2aW91c2x5Lg0KPiBJ
IGhhZCBteSBzaGFyZSBvZiB0aGlzIHdoaWxlIHdyaXRpbmcgYSB0ZXN0IGFwcCBmb3IgYSBNQVgz
MTg1NSBJQyBhbmQgZW5kZWQgdXANCj4gY2FzdGluZyBhIGxpdHRsZSBlbmRpYW4gYXJyYXkgdG8g
YSBiaWcgZW5kaWFuIHN0cnVjdHVyZS4NCj4gDQo+IFJlZ2FyZHMsDQo+IFBhdHJpY2sNCg0K
