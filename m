Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CDC517C2A
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 05:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiECDMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 23:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiECDMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 23:12:35 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419053917C;
        Mon,  2 May 2022 20:09:02 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24338k3kA007504, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24338k3kA007504
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 3 May 2022 11:08:46 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 3 May 2022 11:08:46 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 3 May 2022 11:08:45 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Tue, 3 May 2022 11:08:45 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Forest Crossman <cyrozap@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: Realtek RTL8156 devices defaulting to CDC-NCM instead of vendor mode, resulting in reduced performance
Thread-Topic: Realtek RTL8156 devices defaulting to CDC-NCM instead of vendor
 mode, resulting in reduced performance
Thread-Index: AQHYXe/ogs9OqQEtRUWyhpGpwalf560MbNjg
Date:   Tue, 3 May 2022 03:08:45 +0000
Message-ID: <39404cc4bf87474e83ef142fb4cdeb3b@realtek.com>
References: <CAO3ALPzKEStzf5-mgSLJ_jsCSbRq_2JzZ6de2rXuETV5RC-V8w@mail.gmail.com>
In-Reply-To: <CAO3ALPzKEStzf5-mgSLJ_jsCSbRq_2JzZ6de2rXuETV5RC-V8w@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMiDkuIvljYggMTA6MTc6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rm9yZXN0IENyb3NzbWFuIDxjeXJvemFwQGdtYWlsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBNYXkg
MiwgMjAyMiAyOjQzIFBNDQo+IFRvOiBIYXllcyBXYW5nIDxoYXllc3dhbmdAcmVhbHRlay5jb20+
OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBrdWJhQGtlcm5lbC5vcmcNCj4gQ2M6IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXVzYkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmVh
bHRlayBSVEw4MTU2IGRldmljZXMgZGVmYXVsdGluZyB0byBDREMtTkNNIGluc3RlYWQgb2YgdmVu
ZG9yDQo+IG1vZGUsIHJlc3VsdGluZyBpbiByZWR1Y2VkIHBlcmZvcm1hbmNlDQo+IA0KPiBIaSwg
YWxsLA0KPiANCj4gSSByZWNlbnRseSBwdXJjaGFzZWQgYSBwYWlyIG9mIFVTQiB0byAyLjVHIEV0
aGVybmV0IGRvbmdsZXMgYmFzZWQgb24NCj4gdGhlIFJUTDgxNTYsIGFuZCBoYXZlIHNvIGZhciBi
ZWVuIHZlcnkgaGFwcHkgd2l0aCB0aGVtLCBidXQgb25seSBhZnRlcg0KPiBhZGRpbmcgc29tZSB1
ZGV2IHJ1bGVzWzBdIHRvIHRvIHRha2UgYWR2YW50YWdlIG9mIHRoZSByODE1MiBkcml2ZXIgYnkN
Cj4gc3dpdGNoaW5nIHRoZSBkZXZpY2VzIGZyb20gdGhlaXIgZGVmYXVsdCBDREMtTkNNIG1vZGUg
dG8gdGhlIHZlbmRvcg0KPiBtb2RlLiBJIHdhcyBwcm9tcHRlZCB0byB1c2UgdGhvc2UgcnVsZXMg
dG8gc3dpdGNoIHRoZSBkcml2ZXIgYmVjYXVzZQ0KPiBvbmUgb2YgdGhlIGFkYXB0ZXJzIChiYXNl
ZCBvbiB0aGUgUlRMODE1NkEpIHdvdWxkIGdldCB2ZXJ5IGhvdCwgdXAgdG8NCj4gMTIwIEYgKDQ5
IEMpIGV2ZW4gd2hpbGUgaWRsZSwgYW5kIHRoZSByb3VuZC10cmlwIGxhdGVuY3kgZGlyZWN0bHkN
Cj4gYmV0d2VlbiB0aGUgcGFpciBvZiBhZGFwdGVycyB3YXMgYWJvdXQgMyBtcywgYW5kIEkgY291
bGRuJ3QgaGVscCBidXQNCj4gd29uZGVyIGlmIG1heWJlIHRoZSB2ZW5kb3IgbW9kZSBtaWdodCBi
ZSBtb3JlIGVmZmljaWVudC4NCj4gDQo+IEFmdGVyIHBlcmZvcm1pbmcgc29tZSB0ZXN0cyBvZiBs
YXRlbmN5IGFuZCBwb3dlciBjb25zdW1wdGlvbiwgdGVzdGluZw0KPiBmaXJzdCB3aXRoIGJvdGgg
YWRhcHRlcnMgaW4gTkNNIG1vZGUgYW5kIHRoZW4gYWdhaW4gd2l0aCBib3RoIGluDQo+IHZlbmRv
ciBtb2RlLCBJIHByb3ZlZCBteSBodW5jaCBjb3JyZWN0LiBJIGRpc2NvdmVyZWQgdGhhdCwgaW4g
YQ0KPiBkaXNjb25uZWN0ZWQgc3RhdGUsIHRoZSBSVEw4MTU2QSBhZGFwdGVyIHVzZWQgYWJvdXQg
aGFsZiBhcyBtdWNoIHBvd2VyDQo+ICgwLjY0IFcgLT4gMC4zMCBXKSB3aGlsZSB0aGUgUlRMODE1
NkIgYWRhcHRlciBzYXcgYSAyMSUgcmVkdWN0aW9uIGluDQo+IHBvd2VyICgwLjM0IFcgLT4gMC4y
NyBXKS4gU2ltaWxhcmx5LCBpbiBhIGNvbm5lY3RlZC1idXQtaWRsZSBzdGF0ZSB0aGUNCj4gUlRM
ODE1NkEgYWdhaW4gc2F3IGFib3V0IGEgNTUlIHNhdmluZ3MgaW4gcG93ZXIgY29uc3VtcHRpb24g
KDIuMTcgVyAtPg0KPiAwLjk3IFcpIGFuZCBhIDQwJSBzYXZpbmdzIGluIHRoZSBSVEw4MTU2QiBh
ZGFwdGVyICgwLjk0IFcgLT4gMC41NiBXKS4NCj4gSXQgd2FzIG9ubHkgdW5kZXIgZnVsbCBsb2Fk
IHRoYXQgdGhlIGZld2VzdCBwb3dlciBzYXZpbmdzIHdlcmUgc2VlbiwNCj4gd2l0aCBhIHJlZHVj
dGlvbiBvZiBvbmx5IDE1JSBpbiB0aGUgUlRMODE1NkEgKDIuMjMgVyAtPiAxLjkwIFcpIGFuZCBu
bw0KPiBzYXZpbmdzIGZvciB0aGUgUlRMODE1NkIgKDAuOTYgVykuIFNpbWlsYXJseSwgcm91bmQt
dHJpcCBsYXRlbmN5IHdoaWxlDQo+IGlkbGUgd2VudCBmcm9tIDMgbXMgdG8gMC42IG1zLiBJIGFs
c28gdGVzdGVkIHVuZGVyIGxvYWQgYW5kIHNhdyBtdWNoDQo+IGxhcmdlciBsYXRlbmN5IHNhdmlu
Z3MgYW5kIHJlZHVjZWQgcGFja2V0IGxvc3MsIGJ1dCBmb3Jnb3QgdG8gd3JpdGUNCj4gZG93biB0
aGUgbnVtYmVycyAoSSBjYW4gcnVuIHRoZSB0ZXN0cyBhZ2FpbiBpZiBzb21lb25lIHJlYWxseSB3
YW50cyBtZQ0KPiB0b28pLiBBbHNvLCBqdW1ibyBmcmFtZXMgZHJhc3RpY2FsbHkgcmVkdWNlZCBw
ZXJmb3JtYW5jZSB1bmRlciBOQ00NCj4gbW9kZSwgd2hpbGUgdmVuZG9yIG1vZGUgaGFuZGxlZCBp
dCBsaWtlIGEgY2hhbXAgKGFnYWluLCBJIGZvcmdvdCB0bw0KPiB3cml0ZSBkb3duIHRoZSBudW1i
ZXJzIGJ1dCBjYW4gdGVzdCBhZ2FpbiBpZiBhc2tlZCkuDQo+IA0KPiBTbywgd2l0aCBhbGwgdGhl
IGJlbmVmaXRzIEkndmUgc2VlbiBmcm9tIHVzaW5nIHRoZXNlIGFkYXB0ZXJzIGluIHRoZWlyDQo+
IHZlbmRvciBtb2RlLCBpcyB0aGVyZSBzdGlsbCBhIHJlYXNvbiB0byBsZXQgdGhlIGtlcm5lbCBw
cmVmZXIgdGhlaXINCj4gTkNNIG1vZGU/IEl0J2QgYmUgbmljZSB0byBiZSBhYmxlIHRvIGdldCB0
aGUgbWF4aW11bSBwZXJmb3JtYW5jZSBmcm9tDQo+IHRoZXNlIGFkYXB0ZXJzIG9uIGFueSBMaW51
eCBzeXN0ZW0gSSBwbHVnIHRoZW0gaW50bywgd2l0aG91dCBoYXZpbmcgdG8NCj4gaW5zdGFsbCBh
IHVkZXYgcnVsZSBvbiBldmVyeSBvbmUgb2YgdGhvc2Ugc3lzdGVtcy4NCj4gDQo+IElmIGFueW9u
ZSB3b3VsZCBsaWtlIHRvIHRyeSByZXBsaWNhdGluZyB0aGUgcmVzdWx0cyBJIGxpc3RlZCBoZXJl
LCBvcg0KPiB0byBwZXJmb3JtIG5ldyB0ZXN0cywgdGhlIHNwZWNpZmljIFJUTDgxNTZBIGFkYXB0
ZXIgSSB1c2VkIGlzIHRoZQ0KPiBVZ3JlZW4gQ00yNzVbMV0gYW5kIHRoZSBSVEw4MTU2QiBhZGFw
dGVyIGlzIHRoZSBJbmF0ZWNrIEVUMTAwMVsyXS4NCj4gDQo+IA0KPiBDdXJpb3VzIHRvIGhlYXIg
eW91ciB0aG91Z2h0cyBvbiB0aGlzLA0KDQpUaGUgZGVmYXVsdCBjb25maWd1cmF0aW9uIG9mIFVT
QiBkZXZpY2UgaXMgZGV0ZXJtaW5lZCBieSBVU0ItY29yZSBvZiBMaW51eA0Ka2VybmVsLiBJdCBp
cyBub3Qgc2VsZWN0ZWQgYnkgdGhlIEV0aGVybmV0IGRyaXZlciBvciBkZXZpY2UuIEkgdHJpZWQg
dG8NCnN1Ym1pdCBhIHBhdGNoIHRoYXQgY291bGQgc3dpdGNoIHRoZSBjb25maWd1cmF0aW9uIGF1
dG9tYXRpY2FsbHkgdGhyb3VnaA0KdGhlIGRyaXZlci4gVGhlbiwgdGhlIHVzZXJzIGNvdWxkIHNl
bGVjdCB0aGVpciBmYXZvcml0ZSBtb2RlIHdoZW4NCmNvbmZpZ3VyaW5nIHRoZSBrZXJuZWwuIEhv
d2V2ZXIsIHRoZSBwYXRjaCB3YXMgcmVqZWN0ZWQuIFNvbWVvbmUgc2FpZA0KdGhhdCB0aGUga2Vy
bmVsIHN1cHBvcnQgbXVsdGktY29uZmlndXJhdGlvbnMgZm9yIFVTQiBhbmQgdGhleSBoYXZlIHRv
IGJlDQpzd2l0Y2hlZCBieSB0aGUgdXNlcnMuIFRoZSBmaW5hbCBjb25jbHVzaW9uIHdhcyB0byBj
aGFuZ2UgaXQgYXQgcnVuLXRpbWUsDQpvciB1c2UgdWRldiBydWxlLg0KDQpCZXN0IFJlZ2FyZHMs
DQpIYXllcw0KDQo=
