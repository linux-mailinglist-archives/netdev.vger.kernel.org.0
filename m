Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C265C21EFC0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 13:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgGNLv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 07:51:59 -0400
Received: from mx20.baidu.com ([111.202.115.85]:51016 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbgGNLv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 07:51:58 -0400
X-Greylist: delayed 1860 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2020 07:51:58 EDT
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 55973F373BA686E0E41A;
        Tue, 14 Jul 2020 19:05:38 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Tue, 14 Jul 2020 19:05:38 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Tue, 14 Jul 2020 19:05:38 +0800
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
Thread-Index: AdZQR0EbXNQd8xyJRvWOWMhzMsvatQC0jCIAABEVlZABnAtukA==
Date:   Tue, 14 Jul 2020 11:05:37 +0000
Message-ID: <7aac955840df438e99e6681b0ae5b5b8@baidu.com>
References: <2863b548da1d4c369bbd9d6ceb337a24@baidu.com>
 <CAJ8uoz08pyWR43K_zhp6PsDLi0KE=y_4QTs-a7kBA-jkRQksaw@mail.gmail.com> 
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.197.251]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2020-07-14 19:05:38:307
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IExpLFJvbmdxaW5nDQo+
IOWPkemAgeaXtumXtDogMjAyMOW5tDfmnIg25pelIDE0OjM4DQo+IOaUtuS7tuS6ujogJ01hZ251
cyBLYXJsc3NvbicgPG1hZ251cy5rYXJsc3NvbkBnbWFpbC5jb20+DQo+IOaKhOmAgTogaW50ZWwt
d2lyZWQtbGFuIDxpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZz47IEJqw7ZybiBUw7Zw
ZWwNCj4gPGJqb3JuLnRvcGVsQGludGVsLmNvbT47IEthcmxzc29uLCBNYWdudXMgPG1hZ251cy5r
YXJsc3NvbkBpbnRlbC5jb20+Ow0KPiBOZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+DQo+
IOS4u+mimDog562U5aSNOiBbSW50ZWwtd2lyZWQtbGFuXSBbYnVnID9dIGk0MGVfcnhfYnVmZmVy
X2ZsaXAgc2hvdWxkIG5vdCBiZSBjYWxsZWQNCj4gZm9yIHJlZGlyZWN0ZWQgeHNrIGNvcHkgbW9k
ZQ0KPiANCj4gDQo+IA0KPiA+IC0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCj4gPiDlj5Hku7bkuro6
IE1hZ251cyBLYXJsc3NvbiBbbWFpbHRvOm1hZ251cy5rYXJsc3NvbkBnbWFpbC5jb21dDQo+ID4g
5Y+R6YCB5pe26Ze0OiAyMDIw5bm0N+aciDbml6UgMTQ6MTMNCj4gPiDmlLbku7bkuro6IExpLFJv
bmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiDmioTpgIE6IGludGVsLXdpcmVkLWxh
biA8aW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc+OyBCasO2cm4gVMO2cGVsDQo+ID4g
PGJqb3JuLnRvcGVsQGludGVsLmNvbT47IEthcmxzc29uLCBNYWdudXMgPG1hZ251cy5rYXJsc3Nv
bkBpbnRlbC5jb20+Ow0KPiA+IE5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4NCj4gPiDk
uLvpopg6IFJlOiBbSW50ZWwtd2lyZWQtbGFuXSBbYnVnID9dIGk0MGVfcnhfYnVmZmVyX2ZsaXAg
c2hvdWxkIG5vdCBiZQ0KPiA+IGNhbGxlZCBmb3IgcmVkaXJlY3RlZCB4c2sgY29weSBtb2RlDQo+
ID4NCj4gPiBUaGFuayB5b3UgUm9uZ1FpbmcgZm9yIHJlcG9ydGluZyB0aGlzLiBJIHdpbGwgdGFr
ZSBhIGxvb2sgYXQgaXQgYW5kDQo+ID4gcHJvZHVjZSBhIHBhdGNoLg0KPiA+DQo+ID4gL01hZ251
cw0KPiANCg0KUGluZw0KDQoNCi1MaQ0K
