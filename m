Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7795A3DCEF2
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 05:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhHBDgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 23:36:12 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:1842 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231361AbhHBDgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 23:36:10 -0400
X-UUID: 646c5d5928024c22a2ad7045ea5aa7fb-20210802
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ZK3e9Sg7ghuyh77VEHKTRyGoBtj/73rumt2QQW4OnHM=;
        b=I1sTjCKmkm3Pr3FQlnuF3fvH+3ffvbvnfU5jGUKMMyBKeEdvjbffWFmT0UgOc54aN3XB7mcpmbzdf9zdyu+YuZEAVI6qqmyHdgzzoMPKPRmvbbSD5UkRGPBsZDEaGvxPLXYQDRA3yioZUN31DLcaQpYvdULWrdjJh7q5kQuNep0=;
X-UUID: 646c5d5928024c22a2ad7045ea5aa7fb-20210802
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1405854002; Mon, 02 Aug 2021 11:35:56 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS32N1.mediatek.inc (172.27.4.71) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 2 Aug 2021 11:35:49 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 2 Aug 2021 11:35:48 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <rocco.yue@gmail.com>,
        <chao.song@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH net-next v2] ipv6: add IFLA_INET6_RA_MTU to expose mtu value in the RA message
Date:   Mon, 2 Aug 2021 11:19:24 +0800
Message-ID: <20210802031924.3256-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <5be90cf4-f603-c2f2-fd7e-3886854457ba@gmail.com>
References: <5be90cf4-f603-c2f2-fd7e-3886854457ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 717DC6BBB0EEBCBF51C02B29FAF02E489CDAC93F80059C78A30F86F824E5FC2D2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTA3LTMxIGF0IDExOjE3IC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCk9u
IDcvMzAvMjEgNzo1MiBQTSwgUm9jY28gWXVlIHdyb3RlOg0KPj4gSW4gdGhpcyB3YXksIGlmIHRo
ZSBNVFUgdmFsdWVzIHRoYXQgdGhlIGRldmljZSByZWNlaXZlcyBmcm9tDQo+PiB0aGUgbmV0d29y
ayBpbiB0aGUgUENPIElQdjQgYW5kIHRoZSBSQSBJUHY2IHByb2NlZHVyZXMgYXJlDQo+PiBkaWZm
ZXJlbnQsIHRoZSB1c2VyIHNwYWNlIHByb2Nlc3MgY2FuIHJlYWQgcmFfbXR1IHRvIGdldA0KPj4g
dGhlIG10dSB2YWx1ZSBjYXJyaWVkIGluIHRoZSBSQSBtZXNzYWdlIHdpdGhvdXQgd29ycnlpbmcN
Cj4+IGFib3V0IHRoZSBpc3N1ZSBvZiBpcHY0IGJlaW5nIHN0dWNrIGR1ZSB0byB0aGUgbGF0ZSBh
cnJpdmFsDQo+PiBvZiBSQSBtZXNzYWdlLiBBZnRlciBjb21wYXJpbmcgdGhlIHZhbHVlIG9mIHJh
X210dSBhbmQgaXB2NA0KPj4gbXR1LCB0aGVuIHRoZSBkZXZpY2UgY2FuIHVzZSB0aGUgbG93ZXIg
TVRVIHZhbHVlIGZvciBib3RoDQo+PiBJUHY0IGFuZCBJUHY2Lg0KPiANCj4geW91IGFyZSBzdG9y
aW5nIHRoZSB2YWx1ZSBhbmQgc2VuZGluZyB0byB1c2Vyc3BhY2UgYnV0IG5ldmVyIHVzaW5nIGl0
DQo+IHdoZW4gc2VuZGluZyBhIG1lc3NhZ2UuIFdoYXQncyB0aGUgcG9pbnRpbmcgb2YgcHJvY2Vz
c2luZyB0aGUgTVRVIGluIHRoZQ0KPiBSQSBpZiB5b3UgYXJlIG5vdCBnb2luZyB0byB1c2UgaXQg
dG8gY29udHJvbCBtZXNzYWdlIHNpemU/DQoNCkhpIERhdmlkLA0KDQpJbiB0aGUgcmVxdWlyZW1l
bnQgb2YgbW9iaWxlIG9wZXJhdG9yIGF0JnQgaW4gMjAyMToNCkFUJlQgPENEUi1DRFMtMTE2PiBQ
cmlvcml0aXplIExvd2VyIE1UVSB2YWx1ZToNCklmIHRoZSBNVFUgdmFsdWVzIHRoYXQgdGhlIGRl
dmljZSByZWNlaXZlcyBmcm9tIHRoZSBuZXR3b3JrIGluIHRoZSBQQ08NCklQdjQgPENEUi1DRFMt
MTEwPiBhbmQgdGhlIFJBIElQdjYgPENEUi1DRFMtMTEyPiBwcm9jZWR1cmVzIGFyZSBkaWZmZXJl
bnQsDQp0aGVuIHRoZSBkZXZpY2Ugc2hhbGwgdXNlIHRoZSBsb3dlciBNVFUgdmFsdWUgZm9yIGJv
dGggSVB2NCBhbmQgSVB2Ni4NCg0KQW5kIGluIHRoZSAzR1BQIDIzLjA2MDoNClRoZSBQRFAgUERV
cyBzaGFsbCBiZSByb3V0ZWQgYW5kIHRyYW5zZmVycmVkIGJldHdlZW4gdGhlIE1TIGFuZCB0aGUg
R0dTTg0Kb3IgUC1HVyBhcyBOLVBEVXMuIEluIG9yZGVyIHRvIGF2b2lkIElQIGxheWVyIGZyYWdt
ZW50YXRpb24gYmV0d2VlbiB0aGUNCk1TIGFuZCB0aGUgR0dTTiBvciBQLUdXLCB0aGUgbGluayBN
VFUgc2l6ZSBpbiB0aGUgTVMgc2hvdWxkIGJlIHNldCB0byB0aGUNCnZhbHVlIHByb3ZpZGVkIGJ5
IHRoZSBuZXR3b3JrIGFzIGEgcGFydCBvZiB0aGUgSVAgY29uZmlndXJhdGlvbi4gVGhpcw0KYXBw
bGllcyB0byBib3RoIElQdjYgYW5kIElQdjQuDQoNClRoYXQgbWVhbnMgdXNlciBuZWVkcyB0byBi
ZSBhYmxlIHRvIGNvcnJlY3RseSByZWFkIHRoZSBtdHUgdmFsdWUgY2FycmllZA0KaW4gdGhlIFJB
IG1lc3NhZ2Ugc28gdGhhdCB1c2VyIGNhbiBjb3JyZWN0bHkgY29tcGFyZSBQQ08gaXB2NCBtdHUg
YW5kDQpSQSBpcHY2IG10dS4NCg0KPj4gQEAgLTU3NjEsNiArNTc2NSw3IEBAIHN0YXRpYyBpbnQg
aW5ldDZfc2V0X2lmdG9rZW4oc3RydWN0IGluZXQ2X2RldiAqaWRldiwgc3RydWN0IGluNl9hZGRy
ICp0b2tlbiwNCj4+ICBzdGF0aWMgY29uc3Qgc3RydWN0IG5sYV9wb2xpY3kgaW5ldDZfYWZfcG9s
aWN5W0lGTEFfSU5FVDZfTUFYICsgMV0gPSB7DQo+PiAgCVtJRkxBX0lORVQ2X0FERFJfR0VOX01P
REVdCT0geyAudHlwZSA9IE5MQV9VOCB9LA0KPj4gIAlbSUZMQV9JTkVUNl9UT0tFTl0JCT0geyAu
bGVuID0gc2l6ZW9mKHN0cnVjdCBpbjZfYWRkcikgfSwNCj4+ICsJW0lGTEFfSU5FVDZfUkFfTVRV
XQkJPSB7IC50eXBlID0gTkxBX1UzMiB9LA0KPj4gIH07DQo+PiAgDQo+PiAgc3RhdGljIGludCBj
aGVja19hZGRyX2dlbl9tb2RlKGludCBtb2RlKQ0KPiANCj4gSXRzIHZhbHVlIGlzIGRlcml2ZWQg
ZnJvbSBhbiBSQSBub3Qgc2V0IGJ5IHVzZXJzcGFjZSwgc28gc2V0IHRoZSB0eXBlIHRvDQo+IE5M
QV9SRUpFQ1Qgc28gdGhhdCBpbmV0Nl92YWxpZGF0ZV9saW5rX2FmIHdpbGwgcmVqZWN0IG1lc3Nh
Z2VzIHRoYXQgaGF2ZQ0KPiBJRkxBX0lORVQ2X1JBX01UVSBzZXQuIFlvdSBjYW4gc2V0ICJyZWpl
Y3RfbWVzc2FnZSIgaW4gdGhlIHBvbGljeSB0bw0KPiByZXR1cm4gYSBtZXNzYWdlIHRoYXQgIklG
TEFfSU5FVDZfUkFfTVRVIGNhbiBub3QgYmUgc2V0Ii4NCg0Kd2lsbCBkby4NCg0KVGhhbmtzDQpS
b2Njbw==

