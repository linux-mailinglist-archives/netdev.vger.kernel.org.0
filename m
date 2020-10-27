Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BBF29A2AD
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 03:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409072AbgJ0CXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 22:23:09 -0400
Received: from ZXSHCAS2.zhaoxin.com ([203.148.12.82]:10970 "EHLO
        ZXSHCAS2.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408685AbgJ0CXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 22:23:09 -0400
Received: from zxbjmbx2.zhaoxin.com (10.29.252.164) by ZXSHCAS2.zhaoxin.com
 (10.28.252.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 27 Oct
 2020 10:23:05 +0800
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by zxbjmbx2.zhaoxin.com
 (10.29.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 27 Oct
 2020 10:23:05 +0800
Received: from zxbjmbx1.zhaoxin.com ([fe80::290a:f538:51e7:1416]) by
 zxbjmbx1.zhaoxin.com ([fe80::290a:f538:51e7:1416%16]) with mapi id
 15.01.1979.003; Tue, 27 Oct 2020 10:23:05 +0800
From:   WeitaoWang-oc <WeitaoWang-oc@zhaoxin.com>
To:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "Cobe Chen(BJ-RD)" <CobeChen@zhaoxin.com>,
        "Tony W. Wang(XA-RD)" <TonyWWang@zhaoxin.com>,
        "Weitao Wang(BJ-RD)" <WeitaoWang@zhaoxin.com>,
        "Tim Guo(BJ-RD)" <TimGuo@zhaoxin.com>,
        "wwt8723@163.com" <wwt8723@163.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBOZXQvVXNiOkZpeCByZWFsdGVrIHdpcmVsZXNzIE5J?=
 =?gb2312?Q?C_non-canonical_address_access_issues?=
Thread-Topic: [PATCH] Net/Usb:Fix realtek wireless NIC non-canonical address
 access issues
Thread-Index: AQHWptWcI93k67JN3065ovtm7Wgr1qmqMs2AgACKYXk=
Date:   Tue, 27 Oct 2020 02:23:05 +0000
Message-ID: <c3eb90876bd54831bd845f2952f691d5@zhaoxin.com>
References: <1603193939-3458-1-git-send-email-WeitaoWang-oc@zhaoxin.com>,<1603763274.2765.5.camel@realtek.com>
In-Reply-To: <1603763274.2765.5.camel@realtek.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.29.8.32]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAgVHVlLCAyMDIwLTEwLTI3IGF0IDA5OjM5ICswODAwLCBQa3NoaWggV3JvdGU6DQo+T24g
VHVlLCAyMDIwLTEwLTIwIGF0IDE5OjM4ICswODAwLCBXZWl0YW9XYW5nb2Mgd3JvdGU6DQoNCj5G
b3IgcnRsd2lmaSBkcml2ZXIsIHBsZWFzZSB1c2UgJ3J0bHdpZmk6ICcgYXMgcHJlZml4IG9mIG1h
aWwgc3ViamVjdCwgbGlrZQ0KPiJydGx3aWZpOiBGaXggbm9uLWNhbm9uaWNhbCBhZGRyZXNzIGFj
Y2VzcyBpc3N1ZXMiDQoNCj4+IER1cmluZyByZWFsdGVrIFVTQiB3aXJlbGVzcyBOSUMgaW5pdGlh
bGl6YXRpb24sIGl0J3MgdW5leHBlY3RlZA0KPj4gZGlzY29ubmVjdGlvbiB3aWxsIGNhdXNlIHVy
YiBzdW1ibWl0IGZhaWwuT24gdGhlIG9uZSBoYW5kLA0KDQo+bml0OiBhZGQgc3BhY2UgcmlnaHQg
YWZ0ZXIgcGVyaW9kLCBsaWtlICIuLi4gZmFpbC4gT24gdGhlIG9uZSBoYW5kIC4uLiINCg0KVGhh
bmtzIGZvciBZb3VyIHN1Z2dlc3Rpb24sIEkgd2lsbCByZXNlbmQgdGhpcyBtYWlsLiANCg0KV2Vp
dGFvd2FuZw0KVGhhbmtzDQoNCg==
