Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35237583B70
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbiG1Jl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbiG1Jl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:41:28 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2795365D54;
        Thu, 28 Jul 2022 02:41:27 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 26S9fA9j9023028, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 26S9fA9j9023028
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 28 Jul 2022 17:41:10 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 28 Jul 2022 17:41:17 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 28 Jul 2022 17:41:17 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600]) by
 RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600%5]) with mapi id
 15.01.2308.027; Thu, 28 Jul 2022 17:41:17 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Oliver Neukum <oneukum@suse.com>
CC:     USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: handling MAC set by user space in reset_resume() of r8152
Thread-Topic: handling MAC set by user space in reset_resume() of r8152
Thread-Index: AQHYoa2Y9Pz4/O8XDEKFeUHGHHdeq62SBZCAgAFrpBD//4SgAIAAjZXw
Date:   Thu, 28 Jul 2022 09:41:16 +0000
Message-ID: <6ed729b080c04fc8b93b43b09cf42be0@realtek.com>
References: <2397d98d-e373-1740-eb5f-8fe795a0352a@suse.com>
 <YuGFOU7oKlAGZjTa@lunn.ch> <353a10d11f2345c8acff717be4ade74a@realtek.com>
 <4dfebefb-b4a4-ccdb-d0f7-015273710076@suse.com>
In-Reply-To: <4dfebefb-b4a4-ccdb-d0f7-015273710076@suse.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzcvMjgg5LiK5Y2IIDA2OjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
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

T2xpdmVyIE5ldWt1bSA8b25ldWt1bUBzdXNlLmNvbT4NClsuLi5dDQo+IE9LLCB0aGFuayB5b3Uu
IERvIHlvdSBhZ3JlZSB0aGF0IGEgbWFudWFsbHkgc2V0IE1BQyBuZWVkcyB0byBiZSBrZXB0DQo+
IGV2ZW4gdGhyb3VnaCBhIHByZS9wb3N0X3Jlc2V0KCkgYW5kIHJlc2V0X3Jlc3VtZSgpLCB3aGls
ZSBhIE1BQyBwYXNzZWQNCj4gdGhyb3VnaCBuZWVkcyB0byBiZSByZWV2YWx1YXRlZCBhdCBwcmUv
cG9zdF9yZXNldCgpIGJ1dCBub3QgYXQNCj4gcmVzZXRfcmVzdW1lKCkNCg0KWWVzLiBJIHRoaW5r
IGEgdXNlciB3aXNoZXMgdG8ga2VlcCBpdC4NCg0KPiA+IEJlc2lkZXMsIEkgZG9uJ3QgdW5kZXJz
dGFuZCB3aHkgeW91IHNldCB0cC0+ZXh0ZXJuYWxfbWFjID0gZmFsc2UNCj4gPiBpbiBydGw4MTUy
X2Rvd24oKS4NCj4gDQo+IEZyYW5rbHkgSSBuZWVkIHRvIHVuZG8gdGhlIGVmZmVjdCBvZiBuZG9f
c2V0X21hY19hZGRyZXNzKCkNCj4gYXQgc29tZSB0aW1lLCBidXQgaXQgaXMgdW5jbGVhciB0byBt
ZSBob3cgdG8gcmV0dXJuIGEgbmV0d29yaw0KPiBpbnRlcmZhY2UgdG8gaXRzICJuYXRpdmUiIE1B
Qy4NCj4gQW55IGlkZWFzPw0KDQpJIGFtIG5vdCBzdXJlLiBJcyBpdCBuZWNlc3Nhcnk/DQpJZiBJ
IGNoYW5nZSB0aGUgTUFDIGFkZHJlc3MsIEkgZG9uJ3QgaG9wZSBpdCBpcyByZWNvdmVyZWQgdW5l
eHBlY3RlZGx5DQp1bmxlc3MgdGhlIHN5c3RlbSBpcyByZWJvb3RlZCBvciBzaHV0ZG93bi4NCg0K
QmVzdCBSZWdhcmRzLA0KSGF5ZXMNCg0KDQo=
