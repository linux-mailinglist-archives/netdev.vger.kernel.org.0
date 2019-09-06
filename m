Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974F3AB16E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 05:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392213AbfIFDxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 23:53:25 -0400
Received: from mx.socionext.com ([202.248.49.38]:28932 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732004AbfIFDxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 23:53:25 -0400
Received: from unknown (HELO kinkan-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 06 Sep 2019 12:53:23 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by kinkan-ex.css.socionext.com (Postfix) with ESMTP id 4B7CD180B7D;
        Fri,  6 Sep 2019 12:53:23 +0900 (JST)
Received: from 10.213.24.1 (10.213.24.1) by m-FILTER with ESMTP; Fri, 6 Sep 2019 12:53:23 +0900
Received: from SOC-EX01V.e01.socionext.com (10.213.24.21) by
 SOC-EX02V.e01.socionext.com (10.213.24.22) with Microsoft SMTP Server (TLS)
 id 15.0.995.29; Fri, 6 Sep 2019 12:53:22 +0900
Received: from SOC-EX01V.e01.socionext.com ([10.213.24.21]) by
 SOC-EX01V.e01.socionext.com ([10.213.24.21]) with mapi id 15.00.0995.028;
 Fri, 6 Sep 2019 12:53:22 +0900
From:   <yamada.masahiro@socionext.com>
To:     <andriin@fb.com>, <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        <sfr@canb.auug.org.au>
Subject: RE: [PATCH bpf-next] kbuild: replace BASH-specific ${@:2} with shift
 and ${@}
Thread-Topic: [PATCH bpf-next] kbuild: replace BASH-specific ${@:2} with shift
 and ${@}
Thread-Index: AQHVZBO7/L6pfNSQwUKKg4pTyRjpVacd+BEQ
Date:   Fri, 6 Sep 2019 03:53:21 +0000
Message-ID: <0b39dab4fdbe4c678902657c71364abd@SOC-EX01V.e01.socionext.com>
References: <20190905175938.599455-1-andriin@fb.com>
In-Reply-To: <20190905175938.599455-1-andriin@fb.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.5.2
x-shieldmailcheckerpolicyversion: POLICY190801
x-originating-ip: [10.213.24.1]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmlpIE5ha3J5aWtv
IDxhbmRyaWluQGZiLmNvbT4NCj4gU2VudDogRnJpZGF5LCBTZXB0ZW1iZXIgMDYsIDIwMTkgMzow
MCBBTQ0KPiBUbzogYnBmQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
YXN0QGZiLmNvbTsNCj4gZGFuaWVsQGlvZ2VhcmJveC5uZXQNCj4gQ2M6IGFuZHJpaS5uYWtyeWlr
b0BnbWFpbC5jb207IGtlcm5lbC10ZWFtQGZiLmNvbTsgQW5kcmlpIE5ha3J5aWtvDQo+IDxhbmRy
aWluQGZiLmNvbT47IFN0ZXBoZW4gUm90aHdlbGwgPHNmckBjYW5iLmF1dWcub3JnLmF1PjsgWWFt
YWRhLA0KPiBNYXNhaGlyby8bJEI7M0VEGyhCIBskQj8/OTAbKEIgPHlhbWFkYS5tYXNhaGlyb0Bz
b2Npb25leHQuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggYnBmLW5leHRdIGtidWlsZDogcmVwbGFj
ZSBCQVNILXNwZWNpZmljICR7QDoyfSB3aXRoIHNoaWZ0DQo+IGFuZCAke0B9DQo+IA0KPiAke0A6
Mn0gaXMgQkFTSC1zcGVjaWZpYyBleHRlbnNpb24sIHdoaWNoIG1ha2VzIGxpbmstdm1saW51eC5z
aCByZWx5IG9uDQo+IEJBU0guIFVzZSBzaGlmdCBhbmQgJHtAfSBpbnN0ZWFkIHRvIGZpeCB0aGlz
IGlzc3VlLg0KPiANCj4gUmVwb3J0ZWQtYnk6IFN0ZXBoZW4gUm90aHdlbGwgPHNmckBjYW5iLmF1
dWcub3JnLmF1Pg0KPiBGaXhlczogMzQxZGZjZjhkNzhlICgiYnRmOiBleHBvc2UgQlRGIGluZm8g
dGhyb3VnaCBzeXNmcyIpDQo+IENjOiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVnLm9y
Zy5hdT4NCj4gQ2M6IE1hc2FoaXJvIFlhbWFkYSA8eWFtYWRhLm1hc2FoaXJvQHNvY2lvbmV4dC5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQoN
ClJldmlld2VkLWJ5OiBNYXNhaGlybyBZYW1hZGEgPHlhbWFkYS5tYXNhaGlyb0Bzb2Npb25leHQu
Y29tPg0KDQo=
