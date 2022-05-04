Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B11151B14D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378866AbiEDVsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357779AbiEDVsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:48:02 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97786532C8
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:44:24 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2C3602C05A0;
        Wed,  4 May 2022 21:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1651700662;
        bh=d2feeeykm7wjSFoB/XtcG0diIztRkQUy2w9jfQd12Hw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ZZzP4KX9rx3H82ojdDKf8O1e4si6GHHcYqo+Ue72knQD0J038yaKPFeqAkrzLaQlK
         L/4gJ7ZltNHfHxGw2zg5ErBVD3NQlr8eqejMmUN7Tq3N4/Q8mRnJAon38gj3zPw3Rs
         1+80atcROqYlAt8f2ghQVbB2JmE2SnlKHl49aSJ9QzahNhEnC9lc6TKVr/8qdEp8Sk
         Runxa4rwBSz30Bd7SFVxcYX8tQAov1384wRxWViNFjAKaFmdm0iffO9dtYb6M3xSL3
         2mPjuzz7YaFhss+5lgVMG8Irw1TaHEH9s66SvZwD5pjwg3+HEVI6rQa1ILlkllz3RQ
         QviGmg83w7iyQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6272f3b60001>; Thu, 05 May 2022 09:44:22 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 5 May 2022 09:44:21 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.033; Thu, 5 May 2022 09:44:21 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "thomas.petazzoni@free-electrons.com" 
        <thomas.petazzoni@free-electrons.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: orion-mdio: Convert to JSON schema
Thread-Topic: [PATCH] dt-bindings: net: orion-mdio: Convert to JSON schema
Thread-Index: AQHYX3B5f0UE73T8kUSqO9RiVeRuz60OddiAgAACVQA=
Date:   Wed, 4 May 2022 21:44:20 +0000
Message-ID: <5916c6ec-a73f-8a93-bcdc-e9b443a8d49d@alliedtelesis.co.nz>
References: <20220504043603.949134-1-chris.packham@alliedtelesis.co.nz>
 <YnLxv8PbDyBE1ODa@lunn.ch>
In-Reply-To: <YnLxv8PbDyBE1ODa@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9898F0912EDD2A499F692B796E80C7A6@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7GXNjH+ c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=Xnau0cJti1tb1vfjEOIA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA1LzA1LzIyIDA5OjM1LCBBbmRyZXcgTHVubiB3cm90ZToNCj4gT24gV2VkLCBNYXkgMDQs
IDIwMjIgYXQgMDQ6MzY6MDJQTSArMTIwMCwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4+IENvbnZl
cnQgdGhlIG1hcnZlbGwsb3Jpb24tbWRpbyBiaW5kaW5nIHRvIEpTT04gc2NoZW1hLg0KPj4NCj4+
IFNpZ25lZC1vZmYtYnk6IENocmlzIFBhY2toYW0gPGNocmlzLnBhY2toYW1AYWxsaWVkdGVsZXNp
cy5jby5uej4NCj4+IC0tLQ0KPj4NCj4+IE5vdGVzOg0KPj4gICAgICBUaG9tYXMsIEFudGlvbmUg
JiBGbG9yaWFuIEkgaG9wZSB5b3UgZG9uJ3QgbWluZCBtZSBwdXR0aW5nIHlvdSBhcw0KPj4gICAg
ICBtYWludGFpbmVycyBvZiB0aGUgYmluZGluZy4gQmV0d2VlbiB5b3UgeW91J3ZlIHdyaXR0ZW4g
dGhlIG1ham9yaXR5IG9mDQo+PiAgICAgIHRoZSBtdm1kaW8uYyBkcml2ZXIuDQo+IEkgYWN0dWFs
bHkgdGhpbmsgaXQgd2lsbCBiZSBtZSBkb2luZyBhbnkgbWFpbnRlbmFuY2Ugd29yayBvbiB0aGF0
DQo+IGRyaXZlci4NCkkgZGlkbid0IHdhbnQgdG8gYXNzdW1lLiBCdXQgdGhhbmtzIGZvciB2b2x1
bnRlZXJpbmcuIEknbGwgc2VlIGlmIA0KdGhlcmUncyBhbnkgb3RoZXIgY29tbWVudHMgYW5kIHNl
bmQgYSB2MiB3aXRoIHlvdSBhcyBtYWludGFpbmVyIGZvciB0aGUgDQpiaW5kaW5nIHRvbW9ycm93
Lg0KPj4gICAgICBUaGlzIGRvZXMgdGhyb3cgdXAgdGhlIGZvbGxvd2luZyBkdGJzX2NoZWNrIHdh
cm5pbmdzIGZvciB0dXJyaXMtbW94Og0KPj4gICAgICANCj4+ICAgICAgYXJjaC9hcm02NC9ib290
L2R0cy9tYXJ2ZWxsL2FybWFkYS0zNzIwLXR1cnJpcy1tb3guZHRiOiBtZGlvQDMyMDA0OiBzd2l0
Y2gwQDEwOnJlZzogW1sxNl0sIFswXV0gaXMgdG9vIGxvbmcNCj4+ICAgICAgICAgICAgICBGcm9t
IHNjaGVtYTogRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYXJ2ZWxsLG9y
aW9uLW1kaW8ueWFtbA0KPiBJIGFzc3VtZSB0aGlzIGlzIGNvbWluZyBmcm9tDQo+DQo+IAkJcmVn
ID0gPDB4MTAgMD47DQo+DQo+IFRoaXMgaXMgb2RkLiBMZXRzIHNlZSB3aGF0IE1hcmVrIEJlaMO6
biBoYXMgdG8gc2F5Lg0KPg0KPiAgICAgICBBbmRyZXc=
