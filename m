Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4067E6B8733
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjCNAsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCNAsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:48:24 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FB9305E0;
        Mon, 13 Mar 2023 17:48:22 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32E0lwaoF019084, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32E0lwaoF019084
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Tue, 14 Mar 2023 08:47:58 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Tue, 14 Mar 2023 08:48:10 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 14 Mar 2023 08:48:09 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Tue, 14 Mar 2023 08:48:09 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH v2 RFC 3/9] wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
Thread-Topic: [PATCH v2 RFC 3/9] wifi: rtw88: mac: Support SDIO specific bits
 in the power on sequence
Thread-Index: AQHZU48SQkItyU0DS0St9KPoQOCyqq74bdTQgAA1AICAAM37IA==
Date:   Tue, 14 Mar 2023 00:48:09 +0000
Message-ID: <8404a75a4c194fa79f8e24a9731c3ce3@realtek.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-4-martin.blumenstingl@googlemail.com>
 <7330960d32664bf0bce8446aa93d10c8@realtek.com>
 <CAFBinCA-OHPbwdxdDe50og787LMSnbPhYbsRL6UzQUhxWgxWbQ@mail.gmail.com>
In-Reply-To: <CAFBinCA-OHPbwdxdDe50og787LMSnbPhYbsRL6UzQUhxWgxWbQ@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFydGluIEJsdW1lbnN0
aW5nbCA8bWFydGluLmJsdW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCj4gU2VudDogVHVlc2Rh
eSwgTWFyY2ggMTQsIDIwMjMgNDoxMiBBTQ0KPiBUbzogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVh
bHRlay5jb20+DQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IFlhbi1Ic3Vh
biBDaHVhbmcgPHRvbnkwNjIwZW1tYUBnbWFpbC5jb20+OyBLYWxsZSBWYWxvDQo+IDxrdmFsb0Br
ZXJuZWwub3JnPjsgVWxmIEhhbnNzb24gPHVsZi5oYW5zc29uQGxpbmFyby5vcmc+OyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1t
bWNAdmdlci5rZXJuZWwub3JnOyBDaHJpcyBNb3JnYW4gPG1hY3JvYWxwaGE4MkBnbWFpbC5jb20+
OyBOaXRpbiBHdXB0YQ0KPiA8bml0aW4uZ3VwdGE5ODFAZ21haWwuY29tPjsgTmVvIEpvdSA8bmVv
am91QGdtYWlsLmNvbT47IEplcm5laiBTa3JhYmVjIDxqZXJuZWouc2tyYWJlY0BnbWFpbC5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgUkZDIDMvOV0gd2lmaTogcnR3ODg6IG1hYzogU3Vw
cG9ydCBTRElPIHNwZWNpZmljIGJpdHMgaW4gdGhlIHBvd2VyIG9uIHNlcXVlbmNlDQo+IA0KPiBI
ZWxsbyBQaW5nLUtlLA0KPiANCj4gT24gTW9uLCBNYXIgMTMsIDIwMjMgYXQgMTA6MDXigK9BTSBQ
aW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6DQo+IFsuLi5dDQo+ID4gPiAg
ICAgICAgIHB3cl9zZXEgPSBwd3Jfb24gPyBjaGlwLT5wd3Jfb25fc2VxIDogY2hpcC0+cHdyX29m
Zl9zZXE7DQo+ID4gPiAgICAgICAgIHJldCA9IHJ0d19wd3Jfc2VxX3BhcnNlcihydHdkZXYsIHB3
cl9zZXEpOw0KPiA+ID4gLSAgICAgICBpZiAocmV0KQ0KPiA+ID4gLSAgICAgICAgICAgICAgIHJl
dHVybiByZXQ7DQo+ID4gPiArDQo+ID4gPiArICAgICAgIGlmIChydHdfaGNpX3R5cGUocnR3ZGV2
KSA9PSBSVFdfSENJX1RZUEVfU0RJTykNCj4gPiA+ICsgICAgICAgICAgICAgICBydHdfd3JpdGUz
MihydHdkZXYsIFJFR19TRElPX0hJTVIsIGltcik7DQo+ID4gPg0KPiA+ID4gICAgICAgICBpZiAo
cHdyX29uKQ0KPiA+ID4gICAgICAgICAgICAgICAgIHNldF9iaXQoUlRXX0ZMQUdfUE9XRVJPTiwg
cnR3ZGV2LT5mbGFncyk7DQo+ID4NCj4gPiBJZiBmYWlsZWQgdG8gcG93ZXIgb24sIGl0IHN0aWxs
IHNldCBSVFdfRkxBR19QT1dFUk9OLiBJcyBpdCByZWFzb25hYmxlPw0KPiBUaGF0IHNvdW5kcyB2
ZXJ5IHJlYXNvbmFibGUgdG8gbWUhDQoNCkxldCBtZSBjbGVhciBoZXJlIG1vcmUuDQoNCkNvbnNp
ZGVyIGEgdXNlIGNhc2U6DQoxLiBJbml0aWFsbHksIGl0IGVudGVycyB0aGlzIGZ1bmN0aW9uIHdp
dGggcHdyX29uID0gdHJ1ZSwgYW5kIFJUV19GTEFHX1BPV0VST04gaXMgdW5zZXQuDQoyLiBydHdf
cHdyX3NlcV9wYXJzZXIoKSByZXR1cm4gZXJyb3IsIHNvIHBvd2VyIHN0YXRlIGlzIHVuY2VydGFp
bi4NCjMuIFVuY29uZGl0aW9uYWxseSwgc2V0IFJUV19GTEFHX1BPV0VST04uDQoNCnJ0d19tYWNf
cG93ZXJfb24oKSB3aWxsIHRyeSB0byBwb3dlciBvZmYvb24gb25jZSBhZ2FpbiBpZiBpdCBmYWls
cywgc28NCmluIHN0ZXAgMyBzZXR0aW5nIFJUV19GTEFHX1BPV0VST04gb25seSBpZiBydHdfcHdy
X3NlcV9wYXJzZXIoKSByZXR1cm5zIDANCmNhbiBoYXZlIHRoZSBzYW1lIHZhbHVlcyBhcyBzdGVw
IDEsIHdoZW4gaXQgcmV0cmllcyB0byBwb3dlciBvbi4NCg0KSG9uZXN0bHksIHdlIGRvbid0IGhh
dmUgcGVyZmVjdCBlcnJvciBoYW5kbGUgZm9yIGVycm9yIG9mIHJ0d19wd3Jfc2VxX3BhcnNlcigp
LA0KYnV0IHN0aWxsIHdhbnQgdG8gbWFrZSB0aGluZ3MgZWFzaWVyIHVuZGVyc3RhbmQuDQoNCj4g
DQo+ID4gRGlkIHlvdSBtZWV0IHJlYWwgcHJvYmxlbSBoZXJlPw0KPiA+DQo+ID4gTWF5YmUsIGhl
cmUgY2FuIGJlDQo+ID4NCj4gPiAgICAgICAgICBpZiAocHdyX29uICYmICFyZXQpDQo+ID4gICAg
ICAgICAgICAgICAgICBzZXRfYml0KFJUV19GTEFHX1BPV0VST04sIHJ0d2Rldi0+ZmxhZ3MpOw0K
PiBJIGNhbid0IHJlbWVtYmVyIGFueSBpc3N1ZSB0aGF0IEkndmUgc2Vlbi4gSSdsbCB2ZXJpZnkg
dGhpcyBhdCB0aGUgZW5kDQo+IG9mIHRoZSB3ZWVrICh1bnRpbCB0aGVuIEkgYW0gcHJldHR5IGJ1
c3kgd2l0aCBteSBkYXl0aW1lIGpvYikgYW5kIHRoZW4NCj4gZ28gd2l0aCB5b3VyIHN1Z2dlc3Rp
b24uDQoNClRoYW5rcy4gV2FpdCBmb3IgeW91Lg0KDQo+IFRoYW5rcyBhZ2FpbiBhcyBhbHdheXMg
LSB5b3VyIGZlZWRiYWNrIGlzIHJlYWxseSBhcHByZWNpYXRlZCENCj4gDQo+IEFsc28gdGhhbmsg
eW91IGZvciBjb21tZW50aW5nIG9uIHRoZSBvdGhlciBwYXRjaGVzLiBJJ2xsIHRha2UgYSBjbG9z
ZXINCj4gbG9vayBhdCB5b3VyIGZlZWRiYWNrIGF0IHRoZSBlbmQgb2YgdGhlIHdlZWsgYW5kIHNl
bmQgYW5vdGhlciB2ZXJzaW9uDQo+IG9mIHRoaXMgc2VyaWVzLg0KPiANCg0KSSBhbHNvIHRoYW5r
IHlvdSBmb3IgY29va2luZyB0aGVzZSBwYXRjaGVzIHZvbHVudGFyaWx5IGZvciBwZW9wbGUgd2hv
DQpjYW4gdXNlIHRoZWlyIG93biB3aWZpIGhhcHBpbHkuIDotKQ0KDQpQaW5nLUtlDQoNCg==
