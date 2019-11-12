Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2FD9F993B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKLS7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:59:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47848 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfKLS7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:59:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39EEF154CC65C;
        Tue, 12 Nov 2019 10:59:39 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:59:38 -0800 (PST)
Message-Id: <20191112.105938.992505074954061727.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     po.liu@nxp.com, claudiu.manoil@nxp.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com
Subject: Re: [net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112.105859.2271759135957958056.davem@davemloft.net>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
        <20191112094128.mbfil74gfdnkxigh@netronome.com>
        <20191112.105859.2271759135957958056.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 10:59:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVHVlLCAxMiBO
b3YgMjAxOSAxMDo1ODo1OSAtMDgwMCAoUFNUKQ0KDQo+IA0KPiBPb3BzLCBJIGRpZG4ndCBzZWUg
dGhpcyBmZWVkYmFjayBiZWNhdXNlIHYyIGhhZCBiZWVuIHBvc3RlZC4NCj4gDQo+IEknbGwgcmV2
ZXJ0IHRoYXQgbm93Lg0KPiANCj4gUGxlYXNlIGFkZHJlc3MgU2ltb24ncyBmZWVkYmFjayBvbiB0
aGVzZSB0d28gcGF0Y2hlcywgYW5kIHRoZW4gcG9zdCBhIHYzLA0KPiB0aGFuayB5b3UuDQoNCkFs
c28sIHYyIGRvZXNuJ3QgZXZlbiBjb21waWxlIDotKA0KDQpJbiBmaWxlIGluY2x1ZGVkIGZyb20g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjLmg6MTQsDQogICAgICAg
ICAgICAgICAgIGZyb20gZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRj
X3Fvcy5jOjQ6DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcW9z
LmM6IEluIGZ1bmN0aW9uIKFlbmV0Y19zZXR1cF90Y190YXByaW+iOg0KZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX2h3Lmg6MzA4OjMyOiB3YXJuaW5nOiChdGVtcKIg
bWF5IGJlIHVzZWQgdW5pbml0aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uIFstV21heWJlLXVuaW5p
dGlhbGl6ZWRdDQogI2RlZmluZSBlbmV0Y193cl9yZWcocmVnLCB2YWwpIGlvd3JpdGUzMigodmFs
KSwgKHJlZykpDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+fg0KZHJp
dmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3Fvcy5jOjU5OjY6IG5vdGU6
IKF0ZW1woiB3YXMgZGVjbGFyZWQgaGVyZQ0KICB1MzIgdGVtcDsNCiAgICAgIF5+fn4NCkVSUk9S
OiAiZW5ldGNfc2NoZWRfc3BlZWRfc2V0IiBbZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxl
L2VuZXRjL2ZzbC1lbmV0Yy12Zi5rb10gdW5kZWZpbmVkIQ0KRVJST1I6ICJlbmV0Y19zZXR1cF90
Y190YXByaW8iIFtkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZnNsLWVuZXRj
LXZmLmtvXSB1bmRlZmluZWQhDQptYWtlWzFdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUubW9kcG9z
dDo5NDogX19tb2Rwb3N0XSBFcnJvciAxDQptYWtlOiAqKiogW01ha2VmaWxlOjEyODI6IG1vZHVs
ZXNdIEVycm9yIDINCg==
