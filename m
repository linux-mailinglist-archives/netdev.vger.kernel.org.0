Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF2737B533
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 06:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhELFAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 01:00:14 -0400
Received: from m1357.mail.163.com ([220.181.13.57]:62612 "EHLO
        m1357.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhELFAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 01:00:14 -0400
X-Greylist: delayed 931 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2021 01:00:13 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=cosug
        5t8HU39//BFltOJj7rRKLz2TifgDlwd/EQhrQ8=; b=LLIp/6ex0sBGnIpb5Jl9C
        VC9dmRlclgH4sQTKWf0a7bi7MvY3cSOVTWdPqOUZptQruGcQulfq9tR8hgBXnf7o
        5iPe3JFnSaNJ5ZNYlXbNiCxnXuMz4b1AoePiRo13egRzTmyetZg4vvp/2E3ear3j
        7Ko+8pp9ESZz610OcnspDY=
Received: from meijusan$163.com ( [117.131.86.42] ) by ajax-webmail-wmsvr57
 (Coremail) ; Wed, 12 May 2021 12:43:18 +0800 (CST)
X-Originating-IP: [117.131.86.42]
Date:   Wed, 12 May 2021 12:43:18 +0800 (CST)
From:   meijusan <meijusan@163.com>
To:     "David Ahern" <dsahern@gmail.com>
Cc:     "Jakub Kicinski" <kuba@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH] net/ipv4/ip_fragment:fix missing Flags reserved bit
 set in iphdr
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn 163com
In-Reply-To: <28dfa69f-2844-29c4-5405-421520711196@gmail.com>
References: <20210506145905.3884-1-meijusan@163.com>
 <20210507155900.43cd8200@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1368d6c3.bd1.1795900a467.Coremail.meijusan@163.com>
 <28dfa69f-2844-29c4-5405-421520711196@gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <568ddced.29a0.1795ee2e53b.Coremail.meijusan@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: OcGowACn+dDmXJtgDMngAA--.61454W
X-CM-SenderInfo: xphly3xvdqqiywtou0bp/1tbiFgyPHl44P95hDgADsg
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkF0IDIwMjEtMDUtMTEgMTE6MDU6NTQsICJEYXZpZCBBaGVybiIgPGRzYWhlcm5AZ21haWwuY29t
PiB3cm90ZToKPk9uIDUvMTAvMjEgNzoxOCBQTSwgbWVpanVzYW4gd3JvdGU6Cj4+IAo+PiBBdCAy
MDIxLTA1LTA4IDA2OjU5OjAwLCAiSmFrdWIgS2ljaW5za2kiIDxrdWJhQGtlcm5lbC5vcmc+IHdy
b3RlOgo+Pj4gT24gVGh1LCAgNiBNYXkgMjAyMSAyMjo1OTowNSArMDgwMCBtZWlqdXNhbiB3cm90
ZToKPj4+PiBpcCBmcmFnIHdpdGggdGhlIGlwaGRyIGZsYWdzIHJlc2VydmVkIGJpdCBzZXQsdmlh
IHJvdXRlcixpcCBmcmFnIHJlYXNtIG9yCj4+Pj4gZnJhZ21lbnQsY2F1c2luZyB0aGUgcmVzZXJ2
ZWQgYml0IGlzIHJlc2V0IHRvIHplcm8uCj4+Pj4KPj4+PiBLZWVwIHJlc2VydmVkIGJpdCBzZXQg
aXMgbm90IG1vZGlmaWVkIGluIGlwIGZyYWcgIGRlZnJhZyBvciBmcmFnbWVudC4KPj4+Pgo+Pj4+
IFNpZ25lZC1vZmYtYnk6IG1laWp1c2FuIDxtZWlqdXNhbkAxNjMuY29tPgo+Pj4KPj4+IENvdWxk
IHlvdSBwbGVhc2UgcHJvdmlkZSBtb3JlIGJhY2tncm91bmQgb24gd2h5IHdlJ2Qgd2FudCB0byBk
byB0aGlzPwo+PiAKPj4+IFByZWZlcmFibHkgd2l0aCByZWZlcmVuY2VzIHRvIHJlbGV2YW50IChu
b24tQXByaWwgRm9vbHMnIERheSkgUkZDcy4KPj4gCj4+IFtiYWNrZ3JvdW5kXQo+PiB0aGUgU2lt
cGxlIG5ldHdvcmsgdXNhZ2Ugc2NlbmFyaW9zOiB0aGUgb25lIFBDIHNvZnR3YXJlPC0tLT5saW51
eCByb3V0ZXIoTDMpL2xpbnV4IGJyaWRlZ2UoTDIsYnJpZGdlLW5mLWNhbGwtaXB0YWJsZXMpPC0t
LT50aGUgb3RoZXIgUEMgc29mdHdhcmUKPj4gMSl0aGUgUEMgc29mdHdhcmUgc2VuZCB0aGUgaXAg
cGFja2V0IHdpdGggdGhlIGlwaGRyIGZsYWdzIHJlc2VydmVkIGJpdCBpcyBzZXQsIHdoZW4gaXAg
cGFja2V0KG5vdCBmcmFnbWVudHMgKSB2aWEgdGhlIG9uZSBsaW51eCByb3V0ZXIvbGludXggYnJp
ZGdlLGFuZCB0aGUgaXBoZHIgZmxhZ3MgcmVzZXJ2ZWQgYml0IGlzIG5vdCBtb2RpZmllZDsKPj4g
MilidXQgdGhlIGlwIGZyYWdtZW50cyB2aWEgcm91dGVyLHRoZSBsaW51eCBJUCByZWFzc2VtYmx5
IG9yIGZyYWdtZW50YXRpb24gLGNhdXNpbmcgdGhlIHJlc2VydmVkIGJpdCBpcyByZXNldCB0byB6
ZXJvLFdoaWNoIGxlYWRzIHRvIFRoZSBvdGhlciBQQyBzb2Z0d2FyZSBkZXBlbmRpbmcgb24gdGhl
IHJlc2VydmVkIGJpdCBzZXQgIHByb2Nlc3MgdGhlIFBhY2tldCBmYWlsZWQuCj4+IFtyZmNdCj4+
IFJGQzc5MQo+PiBCaXQgMDogcmVzZXJ2ZWQsIG11c3QgYmUgemVybwo+PiBSRkMzNTE0Cj4+IElu
dHJvZHVjdGlvbiBUaGlzIGJpdCAsIGJ1dCBUaGUgc2NlbmUgc2VlbXMgZGlmZmVyZW50IGZyb20g
dXOjrHdlIGV4cGVjdCBLZWVwIHJlc2VydmVkIGJpdCBzZXQgaXMgbm90IG1vZGlmaWVkIHdoZW4g
Zm9yd2FyZCB0aGUgbGludXggcm91dGVyCj4+IAo+PiAKPj4gCj4+IAo+PiAKPgo+V2h5IHByb2Nl
c3MgdGhlIHBhY2tldCBhdCBhbGw/IElmIGEgcmVzZXJ2ZWQgYml0IG11c3QgYmUgMCBhbmQgaXQg
aXMKCj5ub3QsIGRyb3AgdGhlIHBhY2tldC4KClNvcnJ5LCBteSBiYWNrZ3JvdW5kIGRlc2NyaXB0
aW9uIGlzIG5vdCBjbGVhcmx5IGRlc2NyaWJlZAoKIHRoZSBTaW1wbGUgbmV0d29yayB1c2FnZSBz
Y2VuYXJpb3M6IG9uZSBQQyBzb2Z0d2FyZTwtLS0+bGludXggcm91dGVyKEwzKS9saW51eCBicmlk
ZWdlKEwyLGJyaWRnZS1uZi1jYWxsLWlwdGFibGVzKTwtLS0+dGhlIG90aGVyIFBDIHNvZnR3YXJl
CiAxKXRoZSBQQyBzb2Z0d2FyZSBzZW5kIHRoZSBpcCBwYWNrZXQgd2l0aCB0aGUgaXBoZHIgZmxh
Z3MgcmVzZXJ2ZWQgYml0IGlzIHNldCAxLFRoZSBwYWNrZXQgY2FuIHBhc3MgdGhyb3VnaCB0aGUg
cm91dGVyIG5vcm1hbGx5LCBhbmQgdGhlIHJlc2VydmVkIGZsYWdzIGJpdCBoYXZlIG5vdCBiZWVu
IG1vZGlmaWVkOwogMilXaGVuIHRoZSBpcCBmcmFnbWVudCBwYWNrZXQgcGFzc2VzIHRocm91Z2gg
dGhlIGxpbnV4IHJvdXRlciwgdGhlIGxpbnV4IG5ldHdvcmsgcHJvdG9jb2wgc3RhY2sncyByZS1m
cmFnbWVudGF0aW9uIGZ1bmN0aW9uIG9mIHRoZSBJUCBmcmFnbWVudCBjYXVzZXMgdGhlIGZpcnN0
IGJpdCBvZiB0aGUgcmVzZXJ2ZWQgZmllbGQgb2YgdGhlIGlwIGhlYWRlciB0byBiZSBjbGVhcmVk
IHRvIDAuIFdoZW4gdGhlIHBhY2tldCByZWFjaGVzIHRoZSBzb2Z0d2FyZSBvZiBhbm90aGVyIHBj
LCB0aGUgUEMgc29mdHdhcmUgY2hlY2tzIHRoZSByZXNlcnZlZCBiaXQgYW5kIGZpbmRzIHRoYXQg
dGhlIHJlc2VydmVkIGJpdCBpcyBub3QgMCwgIGRpc2NhcmQgdGhlIHBhY2tldC4KCiBJZiBhY2Nv
cmRpbmcgdG8gcmZjNzkxLCB0aGUgcmVzZXJ2ZWQgYml0IG11c3QgYmUgMCwgaG93IGRvZXMgdGhl
IGtlcm5lbCBwcm90b2NvbCBzdGFjayBkZWFsIHdpdGggZnJhZ21lbnRlZCBwYWNrZXRzIG9yIG5v
bi1mcmFnbWVudGVkIHBhY2tldHMgdGhhdCBjYXJyeSB0aGUgcmVzZXJ2ZWQgZmllbGQgYml0IGFz
IDE/IEkgcGVyc29uYWxseSB0aGluayB0aGF0IGVpdGhlciBhbGwgb2YgdGhlbSBhcmUgdHJhbnNt
aXR0ZWQgdHJhbnNwYXJlbnRseSBvciBhbGwgb2YgdGhlbSBhcmUgZGlzY2FyZGVkLiBUaGlzIG5l
ZWRzIHRvIGJlIGRpc2N1c3NlZC4KCg==
