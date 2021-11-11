Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB5D44D7DA
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhKKOLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:11:22 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:35320 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233633AbhKKOLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:11:21 -0500
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 11 Nov 2021 22:08:24
 +0800 (GMT+08:00)
X-Originating-IP: [10.214.160.77]
Date:   Thu, 11 Nov 2021 22:08:24 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v0] hamradio: delete unnecessary free_netdev()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <20211111060439.7d34f189@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211111140007.7244-1-linma@zju.edu.cn>
 <20211111060439.7d34f189@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <21668706.188d88.17d0f5404b7.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgC3vuLYI41hI2zlBA--.57229W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwUCElNG3ElR6gAdsw
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIKCj4gT24gVGh1LCAxMSBOb3YgMjAyMSAyMjowMDowNyArMDgwMCBMaW4gTWEgd3Jv
dGU6Cj4gPiBUaGUgZm9ybWVyIHBhdGNoICJkZWZlciA2cGFjayBrZnJlZSBhZnRlciB1bnJlZ2lz
dGVyX25ldGRldiIgYWRkcwo+ID4gZnJlZV9uZXRkZXYoKSBmdW5jdGlvbiBpbiBzaXhwYWNrX2Ns
b3NlKCksIHdoaWNoIGlzIGEgYmFkIGNvcHkgZnJvbSB0aGUKPiA+IHNpbWlsYXIgY29kZSBpbiBt
a2lzc19jbG9zZSgpLiBIb3dldmVyLCB0aGlzIGZyZWUgaXMgdW5uZWNlc3NhcnkgYXMgdGhlCj4g
PiBmbGFnIG5lZWRzX2ZyZWVfbmV0ZGV2IGlzIHNldCB0byB0cnVlIGluIHNwX3NldHVwKCksIGhl
bmNlIHRoZQo+ID4gdW5yZWdpc3Rlcl9uZXRkZXYoKSB3aWxsIGZyZWUgdGhlIG5ldGRldiBhdXRv
bWF0aWNhbGx5Lgo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBMaW4gTWEgPGxpbm1hQHpqdS5lZHUu
Y24+Cj4gPiAtLS0KPiA+ICBkcml2ZXJzL25ldC9oYW1yYWRpby82cGFjay5jIHwgMiAtLQo+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAyIGRlbGV0aW9ucygtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvaGFtcmFkaW8vNnBhY2suYyBiL2RyaXZlcnMvbmV0L2hhbXJhZGlvLzZwYWNrLmMK
PiA+IGluZGV4IGJmZGY4OWU1NDc1Mi4uMTgwYzhmMDgxNjliIDEwMDY0NAo+ID4gLS0tIGEvZHJp
dmVycy9uZXQvaGFtcmFkaW8vNnBhY2suYwo+ID4gKysrIGIvZHJpdmVycy9uZXQvaGFtcmFkaW8v
NnBhY2suYwo+ID4gQEAgLTY3Nyw4ICs2NzcsNiBAQCBzdGF0aWMgdm9pZCBzaXhwYWNrX2Nsb3Nl
KHN0cnVjdCB0dHlfc3RydWN0ICp0dHkpCj4gPiAgCS8qIEZyZWUgYWxsIDZwYWNrIGZyYW1lIGJ1
ZmZlcnMgYWZ0ZXIgdW5yZWcuICovCj4gPiAgCWtmcmVlKHNwLT5yYnVmZik7Cj4gPiAgCWtmcmVl
KHNwLT54YnVmZik7Cj4gPiAtCj4gPiAtCWZyZWVfbmV0ZGV2KHNwLT5kZXYpOwo+IAo+IHNwIGlz
IG5ldGRldl9wcml2KCkgdGhvLCBzbyB0aGlzIGlzIG5vdyBhIFVBRi4gSSdkIGdvIGZvciByZW1v
dmluZyB0aGUKPiBuZWVkc19mcmVlX25ldGRldiA9IHRydWUgaW5zdGVhZC4KPiAKPiA+ICB9Cj4g
PiAgCj4gPiAgLyogUGVyZm9ybSBJL08gY29udHJvbCBvbiBhbiBhY3RpdmUgNnBhY2sgY2hhbm5l
bC4gKi8KCk9rYXksIHRoYXQgbWFrZSBzZW5zZXMsIHdhaXQgYSBtaW51dGUuCgpUaGFua3MKTGlu

