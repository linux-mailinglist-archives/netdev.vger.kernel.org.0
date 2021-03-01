Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5483A32785A
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 08:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhCAHlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 02:41:13 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:23772 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232559AbhCAHlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 02:41:04 -0500
Received: by ajax-webmail-mail-app2 (Coremail) ; Mon, 1 Mar 2021 15:41:24
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.85.18]
Date:   Mon, 1 Mar 2021 15:41:24 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Stanislaw Gruszka" <stf_xl@wp.pl>
Cc:     kjlu@umn.edu, "Kalle Valo" <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] iwlegacy: Add missing check in il4965_commit_rxon
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20200917(3e19599d)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <20210301072547.GA118024@wp.pl>
References: <20210228122522.2513-1-dinghao.liu@zju.edu.cn>
 <20210301072547.GA118024@wp.pl>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <5aa56fec.9fb9e.177ecbc1359.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgDXvYikmjxgmSraAQ--.34822W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAg0LBlZdtSi7-wAFsV
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBTdW4sIEZlYiAyOCwgMjAyMSBhdCAwODoyNToyMlBNICswODAwLCBEaW5naGFvIExpdSB3
cm90ZToKPiA+IFRoZXJlIGlzIG9uZSBpbF9zZXRfdHhfcG93ZXIoKSBjYWxsIGluIHRoaXMgZnVu
Y3Rpb24gd2l0aG91dAo+ID4gcmV0dXJuIHZhbHVlIGNoZWNrLiBQcmludCBlcnJvciBtZXNzYWdl
IGFuZCByZXR1cm4gZXJyb3IgY29kZQo+ID4gb24gZmFpbHVyZSBqdXN0IGxpa2UgdGhlIG90aGVy
IGlsX3NldF90eF9wb3dlcigpIGNhbGwuCj4gCj4gV2UgaGF2ZSBmZXcgY2FsbHMgZm9yIGlsX3Nl
dF90eF9wb3dlcigpLCBvbiBzb21lIGNhc2VzIHdlCj4gY2hlY2sgcmV0dXJuIG9uIHNvbWUgbm90
LiBUaGF0IGNvcnJlY3QgYXMgc2V0dGluZyB0eCBwb3dlcgo+IGNhbiBiZSBkZWZlcnJlZCBpbnRl
cm5hbGx5IGlmIG5vdCBwb3NzaWJsZSBhdCB0aGUgbW9tZW50Lgo+IAo+ID4gU2lnbmVkLW9mZi1i
eTogRGluZ2hhbyBMaXUgPGRpbmdoYW8ubGl1QHpqdS5lZHUuY24+Cj4gPiAtLS0KPiA+ICBkcml2
ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2xlZ2FjeS80OTY1LmMgfCA2ICsrKysrLQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiA+IAo+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bGVnYWN5LzQ5NjUuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bGVnYWN5LzQ5NjUuYwo+ID4gaW5kZXggOWZhNTU2
NDg2NTExLi4zMjM1YjhiZTE4OTQgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9pbnRlbC9pd2xlZ2FjeS80OTY1LmMKPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2lu
dGVsL2l3bGVnYWN5LzQ5NjUuYwo+ID4gQEAgLTEzNjEsNyArMTM2MSwxMSBAQCBpbDQ5NjVfY29t
bWl0X3J4b24oc3RydWN0IGlsX3ByaXYgKmlsKQo+ID4gIAkJICogV2UgZG8gbm90IGNvbW1pdCB0
eCBwb3dlciBzZXR0aW5ncyB3aGlsZSBjaGFubmVsIGNoYW5naW5nLAo+ID4gIAkJICogZG8gaXQg
bm93IGlmIHR4IHBvd2VyIGNoYW5nZWQuCj4gPiAgCQkgKi8KPiA+IC0JCWlsX3NldF90eF9wb3dl
cihpbCwgaWwtPnR4X3Bvd2VyX25leHQsIGZhbHNlKTsKPiA+ICsJCXJldCA9IGlsX3NldF90eF9w
b3dlcihpbCwgaWwtPnR4X3Bvd2VyX25leHQsIGZhbHNlKTsKPiA+ICsJCWlmIChyZXQpIHsKPiA+
ICsJCQlJTF9FUlIoIkVycm9yIHNlbmRpbmcgVFggcG93ZXIgKCVkKVxuIiwgcmV0KTsKPiA+ICsJ
CQlyZXR1cm4gcmV0Owo+ID4gKwkJCj4gCj4gVGhpcyBpcyBub3QgZ29vZCBjaGFuZ2UuIFdlIGRv
IG5vdCBjaGVjayByZXR1cm4gdmFsdWUgb2YKPiBpbF9jb21taXRfcnhvbigpLCBleGNlcHQgd2hl
biBjcmVhdGluZyBpbnRlcmZhY2UuIFNvIHRoaXMgY2hhbmdlIG1pZ2h0Cj4gYnJva2UgY3JlYXRp
bmcgaW50ZXJmYWNlLCB3aGF0IHdvcmtlZCBvdGhlcndpc2Ugd2hlbiBpbF9zZXRfdHhfcG93ZXIo
KQo+IHJldHVybmVkIGVycm9yLgo+IAoKSXQncyBjbGVhciB0byBtZSwgVGhhbmtzIGZvciB5b3Vy
IGV4cGxhbmF0aW9uIQoKUmVnYXJkcywKRGluZ2hhbwo=
