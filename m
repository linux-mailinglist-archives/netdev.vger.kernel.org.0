Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D462F8826
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 23:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbhAOWFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 17:05:17 -0500
Received: from m1534.mail.126.com ([220.181.15.34]:23954 "EHLO
        m1534.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbhAOWFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 17:05:16 -0500
X-Greylist: delayed 13798 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2021 17:05:14 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=QWl1k
        wxmlrAvmPs2BfGhX9V7ZRzLA6vNlVk4+GazSRo=; b=elI7USCuMpzGIdWktS/o+
        M0Q8ypI8BUdMkkRF90pqvhDNbhs54hyho6NKTbfJLgRVSplJlQg1yPjd6lgpcfFU
        wgjJGJdTHE4to1sijDQalxCEDzDp8JIEOZp90aEmWcAQ+xaFj21OEMdsZytFWNKC
        5w/XknoqyWjcjH2YpDbzsY=
Received: from wangyingjie55$126.com ( [116.162.2.41] ) by
 ajax-webmail-wmsvr34 (Coremail) ; Fri, 15 Jan 2021 21:27:58 +0800 (CST)
X-Originating-IP: [116.162.2.41]
Date:   Fri, 15 Jan 2021 21:27:58 +0800 (CST)
From:   "Yingjie Wang" <wangyingjie55@126.com>
To:     "Geethasowjanya Akula" <gakula@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Vidhya Vidhyaraman" <vraman@marvell.com>,
        "Stanislaw Kardach [C]" <skardach@marvell.com>,
        "Sunil Kovvuri Goutham" <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        "Jerin Jacob Kollanukkaran" <jerinj@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re:Re: [EXT] [PATCH v3] octeontx2-af: Fix missing check bugs in
 rvu_cgx.c
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn 126com
In-Reply-To: <DM6PR18MB26023B6D29E67754CDF8FB2FCDA71@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <1610602240-23404-1-git-send-email-wangyingjie55@126.com>
 <DM6PR18MB26023B6D29E67754CDF8FB2FCDA71@DM6PR18MB2602.namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=us-ascii
MIME-Version: 1.0
Message-ID: <7378cece.54f3.177063b30b6.Coremail.wangyingjie55@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: IsqowEDpd0NemAFgx4IgAQ--.7761W
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbiVxUbp1pECd2i0AABsH
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHJlcGx5LiBJIGhhdmUgcmVzZW5kZWQgdGhlIGVtYWlsIHdpdGggdGhl
IFJldmlld2VkLWJ5IHRhZy4KQXQgMjAyMS0wMS0xNSAxODo1ODo0OSwgIkdlZXRoYXNvd2phbnlh
IEFrdWxhIiA8Z2FrdWxhQG1hcnZlbGwuY29tPiB3cm90ZToKPlRoZSBjaGFuZ2VzIGxvb2sgZ29v
ZCB0byBtZS4NCj4NCj5Zb3UgY2FuIGFkZDoNCj5SZXZpZXdlZC1ieTogR2VldGhhIHNvd2phbnlh
PGdha3VsYUBtYXJ2ZWxsLmNvbT4NCj4NCj5fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fDQo+RnJvbTogd2FuZ3lpbmdqaWU1NUAxMjYuY29tIDx3YW5neWluZ2ppZTU1QDEy
Ni5jb20+DQo+U2VudDogVGh1cnNkYXksIEphbnVhcnkgMTQsIDIwMjEgMTE6MDAgQU0NCj5Ubzog
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBWaWRoeWEgVmlkaHlhcmFtYW47
IFN0YW5pc2xhdyBLYXJkYWNoIFtDXQ0KPkNjOiBTdW5pbCBLb3Z2dXJpIEdvdXRoYW07IExpbnUg
Q2hlcmlhbjsgR2VldGhhc293amFueWEgQWt1bGE7IEplcmluIEphY29iIEtvbGxhbnVra2FyYW47
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IFlp
bmdqaWUgV2FuZw0KPlN1YmplY3Q6IFtFWFRdIFtQQVRDSCB2M10gb2N0ZW9udHgyLWFmOiBGaXgg
bWlzc2luZyBjaGVjayBidWdzIGluIHJ2dV9jZ3guYw0KPg0KPkV4dGVybmFsIEVtYWlsDQo+DQo+
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KPkZyb206IFlpbmdqaWUgV2FuZyA8d2FuZ3lpbmdqaWU1NUAxMjYuY29t
Pg0KPg0KPkluIHJ2dV9tYm94X2hhbmRsZXJfY2d4X21hY19hZGRyX2dldCgpDQo+YW5kIHJ2dV9t
Ym94X2hhbmRsZXJfY2d4X21hY19hZGRyX3NldCgpLA0KPnRoZSBtc2cgaXMgZXhwZWN0ZWQgb25s
eSBmcm9tIFBGcyB0aGF0IGFyZSBtYXBwZWQgdG8gQ0dYIExNQUNzLg0KPkl0IHNob3VsZCBiZSBj
aGVja2VkIGJlZm9yZSBtYXBwaW5nLA0KPnNvIHdlIGFkZCB0aGUgaXNfY2d4X2NvbmZpZ19wZXJt
aXR0ZWQoKSBpbiB0aGUgZnVuY3Rpb25zLg0KPg0KPkZpeGVzOiA5NmJlMmUwZGE4NWUgKCJvY3Rl
b250eDItYWY6IFN1cHBvcnQgZm9yIE1BQyBhZGRyZXNzIGZpbHRlcnMgaW4gQ0dYIikNCj5TaWdu
ZWQtb2ZmLWJ5OiBZaW5namllIFdhbmcgPHdhbmd5aW5namllNTVAMTI2LmNvbT4NCj4tLS0NCj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYvcnZ1X2NneC5jIHwgNiAr
KysrKysNCj4gMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPg0KPmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfY2d4LmMgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfY2d4LmMNCj5pbmRl
eCBkMjk4YjkzNTcxNzcuLjZjNmI0MTFlNzhmZCAxMDA2NDQNCj4tLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfY2d4LmMNCj4rKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfY2d4LmMNCj5AQCAtNDY5LDYgKzQ2
OSw5IEBAIGludCBydnVfbWJveF9oYW5kbGVyX2NneF9tYWNfYWRkcl9zZXQoc3RydWN0IHJ2dSAq
cnZ1LA0KPiAgICAgICAgaW50IHBmID0gcnZ1X2dldF9wZihyZXEtPmhkci5wY2lmdW5jKTsNCj4g
ICAgICAgIHU4IGNneF9pZCwgbG1hY19pZDsNCj4NCj4rICAgICAgIGlmICghaXNfY2d4X2NvbmZp
Z19wZXJtaXR0ZWQocnZ1LCByZXEtPmhkci5wY2lmdW5jKSkNCj4rICAgICAgICAgICAgICAgcmV0
dXJuIC1FUEVSTTsNCj4rDQo+ICAgICAgICBydnVfZ2V0X2NneF9sbWFjX2lkKHJ2dS0+cGYyY2d4
bG1hY19tYXBbcGZdLCAmY2d4X2lkLCAmbG1hY19pZCk7DQo+DQo+ICAgICAgICBjZ3hfbG1hY19h
ZGRyX3NldChjZ3hfaWQsIGxtYWNfaWQsIHJlcS0+bWFjX2FkZHIpOw0KPkBAIC00ODUsNiArNDg4
LDkgQEAgaW50IHJ2dV9tYm94X2hhbmRsZXJfY2d4X21hY19hZGRyX2dldChzdHJ1Y3QgcnZ1ICpy
dnUsDQo+ICAgICAgICBpbnQgcmMgPSAwLCBpOw0KPiAgICAgICAgdTY0IGNmZzsNCj4NCj4rICAg
ICAgIGlmICghaXNfY2d4X2NvbmZpZ19wZXJtaXR0ZWQocnZ1LCByZXEtPmhkci5wY2lmdW5jKSkN
Cj4rICAgICAgICAgICAgICAgcmV0dXJuIC1FUEVSTTsNCj4rDQo+ICAgICAgICBydnVfZ2V0X2Nn
eF9sbWFjX2lkKHJ2dS0+cGYyY2d4bG1hY19tYXBbcGZdLCAmY2d4X2lkLCAmbG1hY19pZCk7DQo+
DQo+ICAgICAgICByc3AtPmhkci5yYyA9IHJjOw0KPi0tDQo+Mi43LjQNCg==
