Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8FD3DBDFC
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhG3R4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:56:25 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:55857 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229773AbhG3R4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:56:24 -0400
X-UUID: 7ff3e3043d2d45d6bd1a577cb1eea578-20210731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8l+AZ2PYieDguCAzfGAi17aTcglVGuO3Plp5Mxjbqi4=;
        b=AN269eGzAFtxqQ7boOsUh7E3gPII0QXzdqC1sxcXSbwSIHh4wFFBG5KEs/rTpec7uUe+HMJStwK3FuUEbj9/67QQL7qWgBzmF7OEd0AMz9gyaNrHHdRtVUseS9qh4yU8LC8/Z2cjMwJsm3GatmEmy3sq/zR/+xR2Tqeal/iYYwA=;
X-UUID: 7ff3e3043d2d45d6bd1a577cb1eea578-20210731
Received: from mtkcas36.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 932028897; Sat, 31 Jul 2021 01:56:14 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS32N1.mediatek.inc (172.27.4.71) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 31 Jul 2021 01:56:06 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 31 Jul 2021 01:56:05 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <rocco.yue@gmail.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH net-next] net: ipv6: add IFLA_RA_MTU to expose mtu value in the RA message
Date:   Sat, 31 Jul 2021 01:39:46 +0800
Message-ID: <20210730173946.31205-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <57652c0b-ded8-8386-c9a7-40deb1525db2@gmail.com>
References: <57652c0b-ded8-8386-c9a7-40deb1525db2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: ED024F4D181FE5C06A2E15C032934C38617A85931FDD670D971FE0B3D0CB59DB2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA3LTI5IGF0IDExOjI4IC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCk9u
IDcvMjkvMjEgOTo0MiBBTSwgUm9jY28gWXVlIHdyb3RlOg0KPj4gQmVjYXVzZSB0aGUgcHVycG9z
ZSBvZiB0aGlzIHBhdGNoIGlzIGZvciB1c2Vyc3BhY2UgdG8gY29ycmVjdGx5IHJlYWQgdGhlDQo+
PiByYV9tdHUgdmFsdWUgb2YgZGlmZmVyZW50IG5ldHdvcmsgZGV2aWNlLCBpZiB0aGUgREVWQ09O
RiBpcyBjb21wbGV0ZWx5IGRyb3BwZWQsDQo+PiBkb2VzIHRoYXQgbWVhbiBJIGNhbiBhZGQgdGhl
ICJyYV9tdHUiIG1lbWJlciBpbiB0aGUgInN0cnVjdCBuZXRfZGV2aWNlIiAuDQo+IA0KPiBnb29k
IHBvaW50LiBJRkxBIGlzIHRoZSB3cm9uZyBhdHRyaWJ1dGUuIEl0IHNob3VsZCBiZSBJRkxBX0lO
RVQ2X1JBX01UVSwNCj4gc3RvcmVkIGluIGluZXQ2X2RldiBhbmQgYWRkZWQgdG8gdGhlIGxpbmsg
bWVzc2FnZSBpbg0KPiBpbmV0Nl9maWxsX2lmbGE2X2F0dHJzLg0KDQp3aWxsIGRvLCB0aGFua3Mg
Zm9yIHlvdXIgc3VnZ2VzdGlvbi4NCg==

