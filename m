Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719DC57E3A2
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 17:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiGVPVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 11:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiGVPVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 11:21:52 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4D8A95B34;
        Fri, 22 Jul 2022 08:21:46 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 26MFLbDD2013549, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 26MFLbDD2013549
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 22 Jul 2022 23:21:37 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 22 Jul 2022 23:21:42 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 22 Jul 2022 23:21:42 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600]) by
 RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600%5]) with mapi id
 15.01.2308.027; Fri, 22 Jul 2022 23:21:42 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH net-next] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
Thread-Index: AQHYnRCVRrASn8LKuEagRDBDIpqm962Iwo2AgAG5lVA=
Date:   Fri, 22 Jul 2022 15:21:42 +0000
Message-ID: <ab3f4c46d0a7489597150dc47a5211cb@realtek.com>
References: <20220721144550.4405-1-hau@realtek.com>
 <356f4285-1e83-ab14-c890-4131acd8e61d@gmail.com>
In-Reply-To: <356f4285-1e83-ab14-c890-4131acd8e61d@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzcvMjIg5LiL5Y2IIDEyOjQ0OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAyMS4wNy4yMDIyIDE2OjQ1LCBDaHVuaGFvIExpbiB3cm90ZToNCj4gPiBydGw4MTY4aChy
ZXZpZCAweDJhKSArIHJ0bDgyMTFmcyBpcyBmb3IgZmliZXIgcmVsYXRlZCBhcHBsaWNhdGlvbi4N
Cj4gPiBydGw4MTY4aCB3aWxsIGNvbnRyb2wgcnRsODIxMWZzIHZpYSBpdHMgZWVwcm9tIG9yIGdw
byBwaW5zLg0KPiANCj4gUlRMODE2OGggaGFzIGFuIGludGVncmF0ZWQgUEhZLCBob3cgaXMgaXQg
d2l0aCByZXYgMHgyYT8gQ2FuIHRoaXMgdmVyc2lvbiBiZQ0KPiB1c2VkIHdpdGggYW4gZXh0ZXJu
YWwgUEhZIG9ubHk/DQo+IEFuZCBob3cgYWJvdXQgdGhlIGNhc2UgdGhhdCBzb21lYm9keSBjb21i
aW5lcyB0aGlzIGNoaXAgdmVyc2lvbiB3aXRoDQo+IGFub3RoZXIgUEhZIHRoYXQgc3VwcG9ydHMg
ZmliZXI/IEl0IHNlZW1zIHRoZSBjb2RlIG1ha2VzIHRoZSBhc3N1bXB0aW9uDQo+IHRoYXQgcmV2
MmEgaXMgYWx3YXlzIGNvdXBsZWQgd2l0aCBhbiBleHRlcm5hbCBSVEw4MjExRlMuDQo+IA0KPiBB
cmUgdGhlcmUgYW55IHJlYWx3b3JsZCBkZXZpY2VzIHRoYXQgdXNlIFJUTDgxNjhIIHdpdGggZmli
ZXI/DQo+IA0KUlRMODE2OGggd2l0aCByZXZpZCAweDJhIGlzIGFsd2F5cyBjb3VwbGVkIHdpdGgg
YW4gZXh0ZXJuYWwgIFJUTDgyMTFGUy4gUmlnaHQgbm93IHRoZXJlIGlzIG5vIHBsYW4gZm9yIGl0
IHRvIGNvbm5lY3QgdG8gYW5vdGhlciBleHRlcm5hbCBQSFkuDQpSVEw4MTY4SCB3aXRoIHJldmlk
IDB4MTUgYW5kIGl0IHdpdGggcmV2aWQgMHgyYSBhcmUgdGhlIHNhbWUgY2hpcC4gQnV0IHJldmlk
IDB4MmEgaXMgdXNlZCBmb3IgaWRlbnRpZnkgdGhpcyBhcHBsaWNhdGlvbi4gDQpGb2xsb3dpbmcg
aXMgdGhlIGRpYWdyYW0gZm9yIHRoaXMgYXBwbGljYXRpb24uDQoNCistLS0tLS0tLS0tLS0tKyAg
RXRoZXJuZXQgQ2FibGUgICstLS0tLS0tLS0tLS0tKw0KfCAgICAgICAgICAgICAgICAgICAgICAr
LS0tLS0tLS0tLS0tLS0tLS0tLS0gKyAgICAgICAgICAgICAgICAgICAgICB8DQp8ICAgICAgICAg
ICAgICAgICAgICAgIHwgIE1ESU8oRUVETikgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICB8
ZmliZXINCnwgIHJ0bDgxNjhoICAgKy0tLS0tLS0tLS0tLS0tLS0tIC0tLSsgIHJ0bDgyMTFmcyAg
ICstLS0tLS0rDQp8ICAgICAgICAgICAgICAgICAgICAgIHwgIE1EQyhFRUNTKSAgICAgICAgIHwg
ICAgICAgICAgICAgICAgICAgICAgIHwNCnwgICAgICAgICAgICAgICAgICAgICAgKy0tLS0tLS0t
LS0tLS0tLS0tLS0tKyAgICAgICAgICAgICAgICAgICAgICAgfA0KKy0tLS0tLS0tLS0tLS0rICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKy0tLS0tLS0tLS0tLS0tKw0KDQotLS0tLS1Q
bGVhc2UgY29uc2lkZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFp
bC4NCg==
