Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFA7221BFC
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 07:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgGPFdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 01:33:42 -0400
Received: from mx24.baidu.com ([111.206.215.185]:53732 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725935AbgGPFdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 01:33:41 -0400
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id 0ED66205AF967BF4EE28;
        Thu, 16 Jul 2020 13:33:38 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Thu, 16 Jul 2020 13:33:38 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Thu, 16 Jul 2020 13:33:31 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbSW50ZWwtd2lyZWQtbGFuXSBbYnVnID9dIGk0MGVfcnhfYnVm?=
 =?utf-8?B?ZmVyX2ZsaXAgc2hvdWxkIG5vdCBiZSBjYWxsZWQgZm9yIHJlZGlyZWN0ZWQg?=
 =?utf-8?Q?xsk_copy_mode?=
Thread-Topic: [Intel-wired-lan] [bug ?] i40e_rx_buffer_flip should not be
 called for redirected xsk copy mode
Thread-Index: AdZQR0EbXNQd8xyJRvWOWMhzMsvatQC0jCIAABEVlZABnAtukABGg5QAABJ4q9A=
Date:   Thu, 16 Jul 2020 05:33:31 +0000
Message-ID: <8c3ad8e1f3484d79a09b77170abb5d3f@baidu.com>
References: <2863b548da1d4c369bbd9d6ceb337a24@baidu.com>
 <CAJ8uoz08pyWR43K_zhp6PsDLi0KE=y_4QTs-a7kBA-jkRQksaw@mail.gmail.com>
 <7aac955840df438e99e6681b0ae5b5b8@baidu.com>
 <CAJ8uoz3Qrh7gTtsOPiz=Z_vHEk+ZoC35cEZ1audDNu5G5pogZg@mail.gmail.com>
In-Reply-To: <CAJ8uoz3Qrh7gTtsOPiz=Z_vHEk+ZoC35cEZ1audDNu5G5pogZg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.197.251]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex13_2020-07-16 13:33:38:176
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+ID4gPg0KPiA+ID4gPiBUaGFuayB5b3UgUm9uZ1FpbmcgZm9yIHJlcG9ydGluZyB0aGlzLiBJ
IHdpbGwgdGFrZSBhIGxvb2sgYXQgaXQNCj4gPiA+ID4gYW5kIHByb2R1Y2UgYSBwYXRjaC4NCj4g
PiA+ID4NCj4gPiA+ID4gL01hZ251cw0KPiA+ID4NCj4gPg0KPiA+IFBpbmcNCj4gDQo+IE15IGFw
b2xvZ2llcyBSb25nUWluZywgYnV0IGl0IGlzIHRha2luZyBsb25nZXIgdGhhbiBleHBlY3RlZCBk
dWUgdG8ga2V5IHBlb3BsZQ0KPiBiZWluZyBvbiB2YWNhdGlvbiBkdXJpbmcgdGhpcyBzdW1tZXIg
cGVyaW9kLiBXZSBhcmUgZGViYXRpbmcgd2VhdGhlciB0aGUNCj4gc2ltcGxlIGZpeCB5b3UgcHJv
dmlkZWQgY292ZXJzIGFsbCBjYXNlcy4NCj4gSG9wZWZ1bGx5IGl0IGRvZXMsIGJ1dCB3ZSBqdXN0
IHdhbnQgdG8gbWFrZSBzdXJlLiBUaGUgZml4IGlzIG5lZWRlZCBpbiBmb3VyDQo+IGRyaXZlcnM6
IHRoZSBvbmVzIHlvdSBtZW50aW9uIHBsdXMgaWNlLg0KPiANCj4gL01hZ251cw0KDQpJZiBteSBS
RkMgcGF0Y2ggaXMgc3VpdGFibGUgZm9yIHRoaXMgYnVnLCBJIHdpbGwgcmVzZW5kIGl0Lg0KDQpz
aG91bGQgSSBzZW5kIGZvdXIgcGF0Y2hlcyBmb3IgZm91ciBkcml2ZXJzLCBvciBzaG91bGQgSSBz
ZW5kIG9uZSBwYXRjaCBmb3IgdGhlbT8NCg0KDQpUaGFua3MNCg0KLUxpDQoNCg0K
