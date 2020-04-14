Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F4A1A72ED
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 07:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405459AbgDNFVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 01:21:15 -0400
Received: from m142-177.yeah.net ([123.58.177.142]:23000 "EHLO
        m142-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405440AbgDNFVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 01:21:13 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2020 01:21:11 EDT
Received: from vivo.com (localhost [127.0.0.1])
        by m142-177.yeah.net (Hmail) with ESMTP id 56B0B644120;
        Tue, 14 Apr 2020 13:14:48 +0800 (CST)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <ABYAfQB-CGWquV67Mtd-zKqb.3.1586841288308.Hmail.wenhu.wang@vivo.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicholas Mc Guire <hofrat@osadl.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbmV0OiBxcnRyOiBzZW5kIG1zZ3MgZnJvbSBsb2NhbCBvZiBzYW1lIGlkIGFzIGJyb2FkY2FzdA==?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com
X-Originating-IP: 58.251.74.226
In-Reply-To: <20200409193600.GR20625@builder.lan>
MIME-Version: 1.0
Received: from wenhu.wang@vivo.com( [58.251.74.226) ] by ajax-webmail ( [127.0.0.1] ) ; Tue, 14 Apr 2020 13:14:48 +0800 (GMT+08:00)
From:   =?UTF-8?B?546L5paH6JmO?= <wenhu.wang@vivo.com>
Date:   Tue, 14 Apr 2020 13:14:48 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZT1VNTU9CQkJCTUpDTkhLSFlXWShZQU
        hPN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kJHlYWEh9ZQUhMSk5PTU9IQ0pJN1dZDB4ZWUEPCQ4eV1kSHx4VD1lB
        WUc6OSI6HSo5Vjg8LAoOLU1MNg8fVgEwChlVSFVKTkNNQ09KSUJLT0xPVTMWGhIXVQweFRMOVQwa
        FRw7DRINFFUYFBZFWVdZEgtZQVlOQ1VJTkpVTE9VSUlNWVdZCAFZQU1MSko3Bg++
X-HM-Tid: 0a71771c7ead6473kurs56b0b644120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkZyb206IEJqb3JuIEFuZGVyc3NvbiA8Ympvcm4uYW5kZXJzc29uQGxpbmFyby5vcmc+CkRhdGU6
IDIwMjAtMDQtMTAgMDM6MzY6MDAKVG86ICBXQU5HIFdlbmh1IDx3ZW5odS53YW5nQHZpdm8uY29t
PgpDYzogICJEYXZpZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0PixKYWt1YiBLaWNp
bnNraSA8a3ViYUBrZXJuZWwub3JnPixDYXJsIEh1YW5nIDxjamh1YW5nQGNvZGVhdXJvcmEub3Jn
PiwKVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+LEFybmQgQmVyZ21hbm4gPGFy
bmRAYXJuZGIuZGU+LApOaWNob2xhcyBNYyBHdWlyZSA8aG9mcmF0QG9zYWRsLm9yZz4sbmV0ZGV2
QHZnZXIua2VybmVsLm9yZyxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnLGtlcm5lbEB2aXZv
LmNvbQpTdWJqZWN0OiBSZTogW1BBVENIIHYyXSBuZXQ6IHFydHI6IHNlbmQgbXNncyBmcm9tIGxv
Y2FsIG9mIHNhbWUgaWQgYXMgYnJvYWRjYXN0Pk9uIFR1ZSAwNyBBcHIgMjA6MzIgUERUIDIwMjAs
IFdBTkcgV2VuaHUgd3JvdGU6Cj4KPj4gRnJvbTogV2FuZyBXZW5odSA8d2VuaHUud2FuZ0B2aXZv
LmNvbT4KPj4gCj4+IElmIHRoZSBsb2NhbCBub2RlIGlkKHFydHJfbG9jYWxfbmlkKSBpcyBub3Qg
bW9kaWZpZWQgYWZ0ZXIgaXRzCj4+IGluaXRpYWxpemF0aW9uLCBpdCBlcXVhbHMgdG8gdGhlIGJy
b2FkY2FzdCBub2RlIGlkKFFSVFJfTk9ERV9CQ0FTVCkuCj4+IFNvIHRoZSBtZXNzYWdlcyBmcm9t
IGxvY2FsIG5vZGUgc2hvdWxkIG5vdCBiZSB0YWtlbiBhcyBicm9hZGNhc3QKPj4gYW5kIGtlZXAg
dGhlIHByb2Nlc3MgZ29pbmcgdG8gc2VuZCB0aGVtIG91dCBhbnl3YXkuCj4+IAo+PiBUaGUgZGVm
aW5pdGlvbnMgYXJlIGFzIGZvbGxvdzoKPj4gc3RhdGljIHVuc2lnbmVkIGludCBxcnRyX2xvY2Fs
X25pZCA9IE5VTUFfTk9fTk9ERTsKPj4gCj4+IEZpeGVzOiBjb21taXQgZmRmNWZkMzk3NTY2ICgi
bmV0OiBxcnRyOiBCcm9hZGNhc3QgbWVzc2FnZXMgb25seSBmcm9tIGNvbnRyb2wgcG9ydCIpCj4+
IFNpZ25lZC1vZmYtYnk6IFdhbmcgV2VuaHUgPHdlbmh1LndhbmdAdml2by5jb20+Cj4+IC0tLQo+
PiBDaGFuZ2xvZzoKPj4gIC0gRm9yIGNvZGluZyBzdHlsZSwgbGluZSB1cCB0aGUgbmV3bGluZSBv
ZiB0aGUgaWYgY29uZGl0aW9uYWwganVkZ2VtZW50Cj4+ICAgIHdpdGggdGhlIG9uZSBleGlzdHMg
YmVmb3JlLgo+PiAKPj4gIG5ldC9xcnRyL3FydHIuYyB8IDcgKysrKy0tLQo+PiAgMSBmaWxlIGNo
YW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPj4gCj4+IGRpZmYgLS1naXQg
YS9uZXQvcXJ0ci9xcnRyLmMgYi9uZXQvcXJ0ci9xcnRyLmMKPj4gaW5kZXggNWE4ZTQyYWQxNTA0
Li41NDVhNjFmOGVmNzUgMTAwNjQ0Cj4+IC0tLSBhL25ldC9xcnRyL3FydHIuYwo+PiArKysgYi9u
ZXQvcXJ0ci9xcnRyLmMKPj4gQEAgLTkwNywyMCArOTA3LDIxIEBAIHN0YXRpYyBpbnQgcXJ0cl9z
ZW5kbXNnKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywgc2l6ZV90IGxl
bikKPj4gIAo+PiAgCW5vZGUgPSBOVUxMOwo+PiAgCWlmIChhZGRyLT5zcV9ub2RlID09IFFSVFJf
Tk9ERV9CQ0FTVCkgewo+PiAtCQllbnF1ZXVlX2ZuID0gcXJ0cl9iY2FzdF9lbnF1ZXVlOwo+PiAt
CQlpZiAoYWRkci0+c3FfcG9ydCAhPSBRUlRSX1BPUlRfQ1RSTCkgewo+PiArCQlpZiAoYWRkci0+
c3FfcG9ydCAhPSBRUlRSX1BPUlRfQ1RSTCAmJgo+PiArCQkJcXJ0cl9sb2NhbF9uaWQgIT0gUVJU
Ul9OT0RFX0JDQVNUKSB7Cj4KPlNvIHRoaXMgd291bGQgbWVhbiB0aGF0IGlmIGxvY2FsX25pZCBp
cyBjb25maWd1cmVkIHRvIGJlIHRoZSBiY2FzdAo+YWRkcmVzcyB0aGVuIHJhdGhlciB0aGFuIHJl
amVjdGluZyBtZXNzYWdlcyB0byBub24tY29udHJvbCBwb3J0cyB3ZSB3aWxsCj5icm9hZGNhc3Qg
dGhlbS4KPgo+V2hhdCBoYXBwZW5zIHdoZW4gc29tZSBvdGhlciBub2RlIGluIHRoZSBuZXR3b3Jr
IHJlcGxpZXM/IFdvdWxkbid0IGl0IGJlCj5iZXR0ZXIgdG8gZXhwbGljaXRseSBwcm9oaWJpdCB1
c2FnZSBvZiB0aGUgYmNhc3QgYWRkcmVzcyBhcyBvdXIgbm9kZQo+YWRkcmVzcz8KCj4+Cj5UaGF0
IHNhaWQsIGluIHRvcnZhbGRzL21hc3RlciBxcnRyX2xvY2FsX25pZCBpcyBubyBsb25nZXIgaW5p
dGlhbGl6ZWQgdG8KPlFSVFJfTk9ERV9CQ0FTVCwgYnV0IDEuIFNvIEkgZG9uJ3QgdGhpbmsgeW91
IG5lZWQgdGhpcyBwYXRjaCBhbnltb3JlLgo+Cj5SZWdhcmRzLAo+Qmpvcm4KCj4KCkhpIEJqb3Ju
LApZb3UgYXJlIHJpZ2h0LiBJIHNlZSB0aGUgcGF0Y2ggdGhhdCBtb2RpZmllZCB0aGUgbmlkIHRv
IDEgaW4gbWFpbmxpbmUgdjUuNy1yYzEsCmFuZCBpdCBpcyBiZXR0ZXIgdG8gc29sdmUgYWxsIHRo
ZSBwcm9ibGVtcy4gQXMgZm9yIHRoaXMgcGF0Y2gsIHRoZSBzaXR1YXRpb24gaXMgdGhhdApJIHdh
bnQgdG8gdXNlIHFydHIgaW4ga2VybmVsIHRvIGRvIHNvbWV0aGluZyBlbHNlKHRvIGRldmVsb3Ag
YW5vdGhlciBkcml2ZXIgSSBuYW1lCml0IFJQTU9OOiBSZW1vdGUgUHJvY2Vzc29yIE1vbml0b3Ip
LCBidXQgdGhlIG5zIG9yIHNlcnZpY2Utcm91dGUgZnVuY3Rpb25hbGl0eQpoYWQgYmVlbiBtaXNz
aW5nLCBzbyBJIHdyaXRlIGFub3RoZXIgZmlsZSBxc3IuYyBhcyB5b3UgaGFkIGNvbW1ldHRlZCB3
aGljaApkaWQgdGhlIHNhbWUgdGhpbmcgd2l0aCBucy5jLgoKVGhlIGJhZCB0aGluZyB3YXMgSSBt
aXNzZWQgdGhlIHBhdGNoIGZyb20gTWFuaXZhbm5hbi4KU28sIGFueXdheSwgdGhpcyBwYXRjaCBp
cyBub3QgbmVlZGVkIGFueW1vcmUuCgpUaGFua3MsCldlbmh1Cgo+PiAgCQkJcmVsZWFzZV9zb2Nr
KHNrKTsKPj4gIAkJCXJldHVybiAtRU5PVENPTk47Cj4+ICAJCX0KPj4gKwkJZW5xdWV1ZV9mbiA9
IHFydHJfYmNhc3RfZW5xdWV1ZTsKPj4gIAl9IGVsc2UgaWYgKGFkZHItPnNxX25vZGUgPT0gaXBj
LT51cy5zcV9ub2RlKSB7Cj4+ICAJCWVucXVldWVfZm4gPSBxcnRyX2xvY2FsX2VucXVldWU7Cj4+
ICAJfSBlbHNlIHsKPj4gLQkJZW5xdWV1ZV9mbiA9IHFydHJfbm9kZV9lbnF1ZXVlOwo+PiAgCQlu
b2RlID0gcXJ0cl9ub2RlX2xvb2t1cChhZGRyLT5zcV9ub2RlKTsKPj4gIAkJaWYgKCFub2RlKSB7
Cj4+ICAJCQlyZWxlYXNlX3NvY2soc2spOwo+PiAgCQkJcmV0dXJuIC1FQ09OTlJFU0VUOwo+PiAg
CQl9Cj4+ICsJCWVucXVldWVfZm4gPSBxcnRyX25vZGVfZW5xdWV1ZTsKPj4gIAl9Cj4+ICAKPj4g
IAlwbGVuID0gKGxlbiArIDMpICYgfjM7Cj4+IC0tIAo+PiAyLjE3LjEKPj4gCg0KDQo=
