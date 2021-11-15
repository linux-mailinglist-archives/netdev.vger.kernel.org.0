Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBDD4506E4
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhKOObv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:31:51 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14746 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbhKOObQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 09:31:16 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HtBLt1zy2zZd4r
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 22:25:58 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 15 Nov 2021 22:28:19 +0800
Received: from dggpemm500020.china.huawei.com (7.185.36.49) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 15 Nov 2021 22:28:18 +0800
Received: from dggpemm500020.china.huawei.com ([7.185.36.49]) by
 dggpemm500020.china.huawei.com ([7.185.36.49]) with mapi id 15.01.2308.020;
 Mon, 15 Nov 2021 22:28:18 +0800
From:   "jiangheng (H)" <jiangheng12@huawei.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Chenxiang (EulerOS)" <rose.chen@huawei.com>,
        "jiangheng (H)" <jiangheng12@huawei.com>,
        Denis Kirjanov <dkirjanov@suse.de>
Subject: Re: [PATCH iproute2 v2] lnstat:fix buffer overflow in lnstat lnstat
 segfaults when called the following command: $ lnstat -w 1
Thread-Topic: [PATCH iproute2 v2] lnstat:fix buffer overflow in lnstat lnstat
 segfaults when called the following command: $ lnstat -w 1
Thread-Index: AdfaLFC1YeYWaDsKQT62e1Cgm8WnrQ==
Date:   Mon, 15 Nov 2021 14:28:18 +0000
Message-ID: <5f525820edf449dcbbc84e45f71c8f4b@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.117.195]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpGcm9tIGQ3OTdjMjY4MDAzOTE5ZjZlODNjMWJiZGNjZWJmNjI4MDVkYzI1ODEgTW9uIFNlcCAx
NyAwMDowMDowMCAyMDAxDQpGcm9tOiBqaWFuZ2hlbmcgPGppYW5naGVuZzEyQGh1YXdlaS5jb20+
DQpEYXRlOiBUaHUsIDExIE5vdiAyMDIxIDE4OjIwOjI2ICswODAwDQpTdWJqZWN0OiBbUEFUQ0gg
aXByb3V0ZTJdIGxuc3RhdDpmaXggYnVmZmVyIG92ZXJmbG93IGluIGxuc3RhdCBjb21tYW5kDQoN
CnNlZ2ZhdWx0cyB3aGVuIGNhbGxlZCB0aGUgZm9sbG93aW5nIGNvbW1hbmQ6IGxuc3RhdCAtdyAx
DQpbcm9vdEBsb2NhbGhvc3Qgfl0jIGxuc3RhdCAtdyAxDQpTZWdtZW50YXRpb24gZmF1bHQgKGNv
cmUgZHVtcGVkKQ0KDQpUaGUgbWF4aW11bSB2YWx1ZSBvZiB0aC5udW1fbGluZXMgaXMgSERSX0xJ
TkVTKDEwKSwgaCBzaG91bGQgbm90IGJlDQplcXVhbCB0byB0aC5udW1fbGluZXMsIGFycmF5IHRo
LmhkciBtYXkgYmUgb3V0IG9mIGJvdW5kcy4NCg0KU2lnbmVkLW9mZi1ieSBqaWFuZ2hlbmcgPGpp
YW5naGVuZzEyQGh1YXdlaS5jb20+DQotLS0NCm1pc2MvbG5zdGF0LmMgfCAyICstDQoxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL21p
c2MvbG5zdGF0LmMgYi9taXNjL2xuc3RhdC5jIGluZGV4IDg5Y2IwZTdlLi4yNmJlODUyZCAxMDA2
NDQNCi0tLSBhL21pc2MvbG5zdGF0LmMNCisrKyBiL21pc2MvbG5zdGF0LmMNCkBAIC0yMTEsNyAr
MjExLDcgQEAgc3RhdGljIHN0cnVjdCB0YWJsZV9oZHIgKmJ1aWxkX2hkcl9zdHJpbmcoc3RydWN0
IGxuc3RhdF9maWxlICpsbnN0YXRfZmlsZXMsDQogCQlvZnMgKz0gd2lkdGgrMTsNCiAJfQ0KIAkv
KiBmaWxsIGluIHNwYWNlcyAqLw0KLQlmb3IgKGggPSAxOyBoIDw9IHRoLm51bV9saW5lczsgaCsr
KSB7DQorCWZvciAoaCA9IDE7IGggPCB0aC5udW1fbGluZXM7IGgrKykgew0KIAkJZm9yIChpID0g
MDsgaSA8IG9mczsgaSsrKSB7DQogCQkJaWYgKHRoLmhkcltoXVtpXSA9PSAnXDAnKQ0KIAkJCQl0
aC5oZHJbaF1baV0gPSAnICc7DQotLQ0KMi4yNy4wDQo=
