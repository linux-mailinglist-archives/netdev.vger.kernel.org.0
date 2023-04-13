Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708786E08AC
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjDMIMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjDMIMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:12:33 -0400
X-Greylist: delayed 1805 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 01:12:31 PDT
Received: from m13101.mail.163.com (m13101.mail.163.com [220.181.13.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 826BE5FC6;
        Thu, 13 Apr 2023 01:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=E6HHa+EW/H7LizN+yMuSv+QRz6F6NX0Zorf2OBzHy54=; b=X
        fGT9eq8gVNZJF83gDEX/sJkbVs2gMUMDsYBH984AmRAjQZ0uSEV7Il+HhYsMjY9S
        6s+anbaqIrn0yBV2jMe9Cyz/McF6YHz8aYDLU+bZSXHTa5cT5IXbgLucWbsGTUmT
        R1U1TUpVqRM6KTO3lfLjd0J19ZZf8QPih4uMtovegc=
Received: from slark_xiao$163.com ( [223.104.77.216] ) by
 ajax-webmail-wmsvr101 (Coremail) ; Thu, 13 Apr 2023 15:25:35 +0800 (CST)
X-Originating-IP: [223.104.77.216]
Date:   Thu, 13 Apr 2023 15:25:35 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     "Loic Poulain" <loic.poulain@linaro.org>
Cc:     ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH net] wwan: core: add print for wwan port
 attach/disconnect
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 163com
In-Reply-To: <CAMZdPi9gHzPaKcwoRR8-gQtiSxQupL=QickXqNE2owVs-nOrxg@mail.gmail.com>
References: <20230412114402.1119956-1-slark_xiao@163.com>
 <CAMZdPi9gHzPaKcwoRR8-gQtiSxQupL=QickXqNE2owVs-nOrxg@mail.gmail.com>
X-NTES-SC: AL_QuyTA/+cv08o4ymYZekXnkoShO85W8a1s/0m3INTOZ00vSvMyB06cUJOPWP1+96CGguSjSWSXihHzP9Xb4xTQZMDrenJFR7PT2MY6idbEuep
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <5372bdf6.533d.1877981651f.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: ZcGowACnxsJvrjdk420JAA--.30659W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiMA9QZFWB1j9fjwAAsm
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXQgMjAyMy0wNC0xMyAxNTowNzoyMSwgIkxvaWMgUG91bGFpbiIgPGxvaWMucG91bGFpbkBsaW5h
cm8ub3JnPiB3cm90ZToKPk9uIFdlZCwgMTIgQXByIDIwMjMgYXQgMTM6NDUsIFNsYXJrIFhpYW8g
PHNsYXJrX3hpYW9AMTYzLmNvbT4gd3JvdGU6Cj4+Cj4+IFJlZmVyIHRvIFVTQiBzZXJpYWwgZGV2
aWNlIG9yIG5ldCBkZXZpY2UsIHRoZXJlIGlzIG5vdGljZSB0bwo+PiBsZXQgZW5kIHVzZXIga25v
dyB0aGUgc3RhdHVzIG9mIGRldmljZSwgbGlrZSBhdHRhY2hlZCBvcgo+PiBkaXNjb25uZWN0ZWQu
IEFkZCBhdHRhY2gvZGlzY29ubmVjdCBwcmludCBmb3Igd3dhbiBkZXZpY2UgYXMKPj4gd2VsbC4g
VGhpcyBjaGFuZ2Ugd29ya3MgZm9yIE1ISSBkZXZpY2UgYW5kIFVTQiBkZXZpY2UuCj4KPlRoaXMg
Y2hhbmdlIHdvcmtzIGZvciB3d2FuIHBvcnQgZGV2aWNlcywgd2hhdGV2ZXIgdGhlIGJ1cyBpcy4K
PgpTdXJlLiBTaW5jZSB3d2FuIHN1cHBvcnQgVVNCIGRldmljZSBhcyB3ZWxsIGFmdGVyIGludGVn
cmF0aW5nCldXQU4gZnJhbWV3b3JrIGludG8gY2RjLXdkbS4KPj4KPj4gU2lnbmVkLW9mZi1ieTog
U2xhcmsgWGlhbyA8c2xhcmtfeGlhb0AxNjMuY29tPgo+PiAtLS0KPj4gIGRyaXZlcnMvbmV0L3d3
YW4vd3dhbl9jb3JlLmMgfCA1ICsrKysrCj4+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25z
KCspCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93d2FuL3d3YW5fY29yZS5jIGIvZHJp
dmVycy9uZXQvd3dhbi93d2FuX2NvcmUuYwo+PiBpbmRleCAyZTFjMDFjZjAwYTkuLmQzYWM2YzVi
MGIyNiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9uZXQvd3dhbi93d2FuX2NvcmUuYwo+PiArKysg
Yi9kcml2ZXJzL25ldC93d2FuL3d3YW5fY29yZS5jCj4+IEBAIC00OTIsNiArNDkyLDggQEAgc3Ry
dWN0IHd3YW5fcG9ydCAqd3dhbl9jcmVhdGVfcG9ydChzdHJ1Y3QgZGV2aWNlICpwYXJlbnQsCj4+
ICAgICAgICAgaWYgKGVycikKPj4gICAgICAgICAgICAgICAgIGdvdG8gZXJyb3JfcHV0X2Rldmlj
ZTsKPj4KPj4gKyAgICAgICBkZXZfaW5mbygmd3dhbmRldi0+ZGV2LCAiJXMgY29udmVydGVyIG5v
dyBhdHRhY2hlZCB0byAlc1xuIiwKPj4gKyAgICAgICAgICAgICAgICB3d2FuX3BvcnRfZGV2X3R5
cGUubmFtZSwgcG9ydC0+ZGV2LmtvYmoubmFtZSk7Cj4KPllvdSBzaG91bGQgdXNlIGBkZXZfbmFt
ZSgpYCBpbnN0ZWFkIG9mIGRpcmVjdCByZWZlcmVuY2UgdG8ga29iai4KPgpXaWxsIHVwZGF0ZSB0
aGlzIGluIHYyLgo+V2h5ICdjb252ZXJ0ZXInID8gSWYgeW91IHJlYWxseSB3YW50IHRvIHByaW50
LCBpdCBzaG91bGQgYmUgc29tZXRoaW5nIGxpa2U6Cj53d2FuMDogd3dhbjBhdDEgcG9ydCBhdHRh
Y2hlZApUaGlzIHJlZmVyIHRvIFVTQiBkZXZpY2UgYXR0YWNoZWQgaW5mbzoKICA2OTYuNDQ0NTEx
XSB1c2IgMi0zOiBHU00gbW9kZW0gKDEtcG9ydCkgY29udmVydGVyIG5vdyBhdHRhY2hlZCB0byB0
dHlVU0IwClsgIDY5Ni40NDQ4NzddIHVzYiAyLTM6IEdTTSBtb2RlbSAoMS1wb3J0KSBjb252ZXJ0
ZXIgbm93IGF0dGFjaGVkIHRvIHR0eVVTQjEKWyAgNjk2LjQ0NTA2NV0gdXNiIDItMzogR1NNIG1v
ZGVtICgxLXBvcnQpIGNvbnZlcnRlciBub3cgYXR0YWNoZWQgdG8gdHR5VVNCMgpjdXJyZW50bHks
IHdlIHdpbGwgcHJpbnQgaXQgYXMgYmVsb3cgd2l0aCBhYm92ZSBwYXRjaDoKWyAgMjMzLjE5MjEy
M10gd3dhbiB3d2FuMDogd3dhbl9wb3J0IGNvbnZlcnRlciBub3cgYXR0YWNoZWQgdG8gd3dhbjBt
YmltMApbICA2OTQuNTMwNzgxXSB3d2FuIHd3YW4wOiB3d2FuX3BvcnQgY29udmVydGVyIG5vdyBk
aXNjb25uZWN0ZWQgZnJvbSB3d2FuMG1iaW0wCj4KPj4gICAgICAgICByZXR1cm4gcG9ydDsKPj4K
Pj4gIGVycm9yX3B1dF9kZXZpY2U6Cj4+IEBAIC01MTcsNiArNTE5LDkgQEAgdm9pZCB3d2FuX3Jl
bW92ZV9wb3J0KHN0cnVjdCB3d2FuX3BvcnQgKnBvcnQpCj4+Cj4+ICAgICAgICAgc2tiX3F1ZXVl
X3B1cmdlKCZwb3J0LT5yeHEpOwo+PiAgICAgICAgIGRldl9zZXRfZHJ2ZGF0YSgmcG9ydC0+ZGV2
LCBOVUxMKTsKPj4gKwo+PiArICAgICAgIGRldl9pbmZvKCZ3d2FuZGV2LT5kZXYsICIlcyBjb252
ZXJ0ZXIgbm93IGRpc2Nvbm5lY3RlZCBmcm9tICVzXG4iLAo+PiArICAgICAgICAgICAgICAgIHd3
YW5fcG9ydF9kZXZfdHlwZS5uYW1lLCBwb3J0LT5kZXYua29iai5uYW1lKTsKPj4gICAgICAgICBk
ZXZpY2VfdW5yZWdpc3RlcigmcG9ydC0+ZGV2KTsKPj4KPj4gICAgICAgICAvKiBSZWxlYXNlIHJl
bGF0ZWQgd3dhbiBkZXZpY2UgKi8KPj4gLS0KPj4gMi4zNC4xCj4+Cj4KPlJlZ2FyZHMsCj5Mb2lj
Cg==
