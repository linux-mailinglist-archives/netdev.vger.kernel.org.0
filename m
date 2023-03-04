Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F6E6AA7AC
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 03:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCDCpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 21:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjCDCps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 21:45:48 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F194205;
        Fri,  3 Mar 2023 18:45:46 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PT8Jk6JWYzSkMg;
        Sat,  4 Mar 2023 10:42:46 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 4 Mar 2023 10:45:44 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2507.021;
 Sat, 4 Mar 2023 10:45:44 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [Qestion] abort backport commit ("net/ulp: prevent ULP without
 clone op from entering the LISTEN status") in stable-4.19.x
Thread-Topic: [Qestion] abort backport commit ("net/ulp: prevent ULP without
 clone op from entering the LISTEN status") in stable-4.19.x
Thread-Index: AQHZTjZujnKkJ9z9STWxQrC2kjT+n67p6JLQ
Date:   Sat, 4 Mar 2023 02:45:44 +0000
Message-ID: <55378c79847a4fe092cc924e4df24f4d@huawei.com>
References: <D899D5DA-C73C-46C4-A123-A10F0D389D0D@amazon.co.jp>
In-Reply-To: <D899D5DA-C73C-46C4-A123-A10F0D389D0D@amazon.co.jp>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSXdhc2hpbWEsIEt1bml5
dWtpIFttYWlsdG86a3VuaXl1QGFtYXpvbi5jby5qcF0NCj4gU2VudDogU2F0dXJkYXksIE1hcmNo
IDQsIDIwMjMgOToxMyBBTQ0KPiBUbzogbGl1amlhbiAoQ0UpIDxsaXVqaWFuNTZAaHVhd2VpLmNv
bT4NCj4gQ2M6IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IEdyZWcgS0gNCj4gPGdy
ZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgTmV0d29y
aw0KPiBEZXZlbG9wbWVudCA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IEl3YXNoaW1hLCBLdW5p
eXVraQ0KPiA8a3VuaXl1QGFtYXpvbi5jby5qcD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5l
bC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUWVzdGlvbl0gYWJvcnQgYmFja3BvcnQgY29tbWl0ICgi
bmV0L3VscDogcHJldmVudCBVTFAgd2l0aG91dA0KPiBjbG9uZSBvcCBmcm9tIGVudGVyaW5nIHRo
ZSBMSVNURU4gc3RhdHVzIikgaW4gc3RhYmxlLTQuMTkueA0KPiANCj4gRnJvbTogSmFrdWIgS2lj
aW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gRGF0ZTogRnJpLCAzIE1hciAyMDIzIDE3OjA2OjA4
IC0wODAwDQo+ID4gT24gRnJpLCAzIE1hciAyMDIzIDEwOjUyOjE1ICswMDAwIGxpdWppYW4gKENF
KSB3cm90ZToNCj4gPiA+IFdoZW4gSSB3YXMgd29ya2luZyBvbiBDVkUtMjAyMy0wNDYxLCBJIGZv
dW5kIHRoZSBiZWxvdyBiYWNrcG9ydA0KPiBjb21taXQgaW4gc3RhYmxlLTQuMTkueCBtYXliZSBz
b21ldGhpbmcgd3Jvbmc/DQo+ID4gPg0KPiA+ID4gNzU1MTkzZjI1MjNjICgibmV0L3VscDogcHJl
dmVudCBVTFAgd2l0aG91dCBjbG9uZSBvcCBmcm9tIGVudGVyaW5nDQo+ID4gPiB0aGUgTElTVEVO
IHN0YXR1cyIpDQo+ID4gPg0KPiA+ID4gMS4gIGVyciA9IC1FQUREUklOVVNFIGluIGluZXRfY3Nr
X2xpc3Rlbl9zdGFydCgpIHdhcyByZW1vdmVkLiBCdXQgaXQNCj4gPiA+ICAgICBpcyB0aGUgZXJy
b3IgY29kZSB3aGVuIGdldF9wb3J0KCkgZmFpbHMuDQo+ID4NCj4gPiBJIHRoaW5rIHlvdSdyZSBy
aWdodCwgd2Ugc2hvdWxkIGFkZCBzZXR0aW5nIHRoZSBlcnIgYmFjay4NCj4gDQo+IFllcywgdGhl
IHNhbWUgaXNzdWUgaGFwcGVuZWQgb24gNS4xNS44OCwgYnV0IEkgZm9yZ290IHRvIGNoZWNrIG90
aGVyIHN0YWJsZQ0KPiBicmFuY2hlcy4NCj4gSSdsbCBjaGVjayB0aGVtIGFuZCBwb3N0IGZpeGVz
IGxhdGVyLg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9zdGFibGUvMjAyMzAyMjAxMzM1NTUu
MTQwODY1Njg1QGxpbnV4Zm91bmRhdGlvbi4NCj4gb3JnLw0KPiANClRoYW5rcyBJd2FzaGltYS4N
Cj4gDQo+ID4NCj4gPiA+ICAyLiBUaGUgY2hhbmdlIGluIF9fdGNwX3NldF91bHAoKSBzaG91bGQg
bm90IGJlIGRpc2NhcmRlZD8NCj4gPg0KPiA+IFRoYXQgcGFydCBzaG91bGQgYmUgZmluZSwgYWxs
IFVMUHMgaW4gNC4xOSAoaS5lLiBUTFMpIHNob3VsZCBmYWlsIHRoZQ0KPiA+IC0+aW5pdCgpIGNh
bGwgaWYgc2tfc3RhdGUgIT0gRVNUQUJMSVNIRUQuDQpHb3QgaXQuIFRoYW5rcyBKYWt1Yi4NCg0K
