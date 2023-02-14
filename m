Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23391695581
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 01:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBNApR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 19:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBNApQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 19:45:16 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0610D527;
        Mon, 13 Feb 2023 16:45:12 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31E0iaInB002345, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31E0iaInB002345
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Tue, 14 Feb 2023 08:44:36 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Tue, 14 Feb 2023 08:44:38 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 14 Feb 2023 08:44:38 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Tue, 14 Feb 2023 08:44:38 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [Issue Report] Realtek 8852AE Bluetooth audio issues while using WiFi
Thread-Topic: [Issue Report] Realtek 8852AE Bluetooth audio issues while using
 WiFi
Thread-Index: AQHZP++iRX35EKlpEk+ewenwK0sPRa7Nla3g
Date:   Tue, 14 Feb 2023 00:44:38 +0000
Message-ID: <0ab9319d40cc4ee7885441cbc7f39b74@realtek.com>
References: <2dcc7926-4d80-0d70-edf3-d05ea3dc542e@collabora.com>
In-Reply-To: <2dcc7926-4d80-0d70-edf3-d05ea3dc542e@collabora.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzIvMTMg5LiL5Y2IIDA2OjU5OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTXVoYW1tYWQgVXNhbWEg
QW5qdW0gPHVzYW1hLmFuanVtQGNvbGxhYm9yYS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEZlYnJ1
YXJ5IDE0LCAyMDIzIDQ6MzggQU0NCj4gVG86IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsu
Y29tPjsgS2FsbGUgVmFsbyA8a3ZhbG9Aa2VybmVsLm9yZz47IERhdmlkIFMuIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47
IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJl
ZGhhdC5jb20+DQo+IENjOiBNdWhhbW1hZCBVc2FtYSBBbmp1bSA8dXNhbWEuYW5qdW1AY29sbGFi
b3JhLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbSXNz
dWUgUmVwb3J0XSBSZWFsdGVrIDg4NTJBRSBCbHVldG9vdGggYXVkaW8gaXNzdWVzIHdoaWxlIHVz
aW5nIFdpRmkNCj4gDQo+IEhpLA0KPiANCj4gSSdtIHJ1bm5pbmcgNi4xLjAtMyBrZXJuZWwgYW5k
IGdldHRpbmcgQmx1ZXRvb3RoIGF1ZGlvIGdsaXRjaGVzIGNvbnN0YW50bHkNCj4gb24gYSBwYWly
IG9mIGJ1ZHMgYW5kIGFsbCB0aGUgdGltZSB3aGVuIFdpRmkgaXMgY29ubmVjdGluZyBhbmQgd29y
a2luZyBvbg0KPiBSVEwgODg1MkFFIGNhcmQuIFNvbWUgQmx1ZXRvb3RoIGF1ZGlvIGRldmljZXMg
d29yayBmaW5lIHdpdGhvdXQgaXNzdWUuIEJ1dA0KPiBzb21lIGRldmljZXMgZ2V0IGdsaXRjaHkg
YXVkaW8gYWxsIHRoZSB0aW1lIHdoZW4gV2lmaSBpcyBiZWluZyB1c2VkLiBUaGUNCj4gYXVkaW8g
YmVjb21lcyBtb3JlIGFuZCBtb3JlIGdsaXRjaHkgYXMgdGhlIFdpRmkgdXNlIGluY3JlYXNlcy4g
WzFdIG1lbnRpb25zDQo+IHRoYXQgdGhlIHByb2JsZW0gZm9yIFJlYWx0ZWsgODcyM0JFIGdldHMg
c29sdmVkIGJ5IHN3aXRjaGluZyB0byA1R0h6IHdpZmkNCj4gb3IgdXBncmFkaW5nIGRyaXZlcy4g
SXMgdGhpcyBpc3N1ZSBwcmVzZW50IG9uIG90aGVyIG9wZXJhdGluZyBzeXN0ZW1zIGZvcg0KPiB0
aGlzIGNoaXAgYXMgd2VsbD8gQ2FuIGl0IGJlIHNvbHZlZCBmb3IgTGludXggaWYgV2lmaSBpcyB1
c2VkIGF0IDIuNCBHSHo/DQoNCkJsdWV0b290aCBkZXZpY2VzIHdvcmsgb24gMi40IEdIeiwgc28g
dGhlIGNvZXhpc3RlbmNlIG1lY2hhbmlzbSBvbiB0aGlzIGJhbmQNCmlzIG1vcmUgZGlmZmljdWx0
IHRoYW4gNSBHSHouIFRoYXQgaXMgd2h5IFsxXSBzdWdnZXN0IHRvIHN3aXRjaCB0byA1R0h6Lg0K
DQpUbyBkZWJ1ZyB0aGlzIHByb2JsZW0sIHBsZWFzZSBmb2xsb3cgYmVsb3cgc3RlcHMgdG8gY2Fw
dHVyZSBsb2cgYW5kIHNlbmQgdGhlbQ0KdG8gbWUgcHJpdmF0ZWx5LiBJIHdpbGwgZm9yd2FyZCB0
aGVtIHRvIHRoZSBwZXJzb24gd2hvIGlzIGZhbWlsaWFyIHdpdGggDQpXaUZpIGFuZCBCVCBjb2V4
aXN0ZW5jZS4NCg0KVGhlIGRpcmVjdG9yeSBvZiBkZWJ1ZyBlbnRyeSBpcyBsaWtlIC9zeXMva2Vy
bmVsL2RlYnVnL2llZWU4MDIxMS9waHkwL3J0dzg5DQpVc2UgYmVsb3cgc2hlbGwgY29tbWFuZCB0
byBjYXB0dXJlIGxvZyBwZXJpb2RpY2FsbHkgZHVyaW5nIEJUIGdldHMgZ2xpdGNoLA0KJCB3aGls
ZSBbIDEgXTsgZG8gZGF0ZSAtUjsgY2F0IC9zeXMva2VybmVsL2RlYnVnL2llZWU4MDIxMS9waHkw
L3J0dzg5L2J0Y19pbmZvOyBzbGVlcCAyOyBkb25lIHwgdGVlIHh4eC5sb2cgDQoNClBsZWFzZSBw
cm92aWRlIHNlcGFyYXRlIGxvZ3MgZm9yIGVhY2ggQmx1ZXRvb3RoIGRldmljZSB3aXRoL3dpdGhv
dXQgZ2xpdGNoLA0KYW5kIGdpdmUgdXMgc2ltcGxlIGRlc2NyaXB0aW9ucyBhYm91dCB0aW1lc3Rh
bXAgYW5kIHN5bXB0b20sIGxpa2UNCiJhdCB0aW1lIDA5OjEwIEJsdWV0b290aCBkZXZpY2UgZ2V0
cyBnbGl0Y2ggd2hlbiBXaUZpIGlzIGRvd25sb2FkaW5nIGZpbGUiDQpUaGF0IGNhbiBoZWxwIHVz
IHRvIGFkZHJlc3MgcHJvYmxlbSBxdWlja2x5LiBQbGVhc2Ugb25seSBwYWlyIG9ubHkgb25lDQpC
bHVldG9vdGggZGV2aWNlIHdoZW4gY2FwdHVyaW5nIGxvZy4NCg0KUGluZy1LZQ0KDQo=
