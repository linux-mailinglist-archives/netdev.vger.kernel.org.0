Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C791A2E63
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 06:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgDIEZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 00:25:49 -0400
Received: from m177129.mail.qiye.163.com ([123.58.177.129]:25964 "EHLO
        m177129.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgDIEZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 00:25:48 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2020 00:25:44 EDT
Received: from vivo.com (wm-2.qy.internal [127.0.0.1])
        by m177129.mail.qiye.163.com (Hmail) with ESMTP id 760465C0DCC;
        Thu,  9 Apr 2020 12:18:56 +0800 (CST)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AO2AwwA*CAWlXsmj18xkSqo6.3.1586405936469.Hmail.wenhu.wang@vivo.com>
To:     David Miller <davem@davemloft.net>
Cc:     akpm@linux-foundation.org, kuba@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        bjorn.andersson@linaro.org, hofrat@osadl.org, allison@lohutok.net,
        johannes.berg@intel.com, arnd@arndb.de, cjhuang@codeaurora.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel@vivo.com
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBSRVNFTkRdIG5ldDogcXJ0cjogc3VwcG9ydCBxcnRyIHNlcnZpY2UgYW5kIGxvb2t1cCByb3V0ZQ==?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com
X-Originating-IP: 58.251.74.227
In-Reply-To: <20200408.143327.2268546094613330028.davem@davemloft.net>
MIME-Version: 1.0
Received: from wenhu.wang@vivo.com( [58.251.74.227) ] by ajax-webmail ( [127.0.0.1] ) ; Thu, 9 Apr 2020 12:18:56 +0800 (GMT+08:00)
From:   =?UTF-8?B?546L5paH6JmO?= <wenhu.wang@vivo.com>
Date:   Thu, 9 Apr 2020 12:18:56 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZT1VDTkNLS0tJTENPTElCWVdZKFlBSE
        83V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kJHlYWEh9ZQUhMSkhPT0tIQkxON1dZDB4ZWUEPCQ4eV1kSHx4VD1lB
        WUc6NEk6DAw6UTg6LBcjCBYRSkMDECgKFE1VSFVKTkNNT0tOQkhDTU5OVTMWGhIXVQweFRMOVQwa
        FRw7DRINFFUYFBZFWVdZEgtZQVlOQ1VJTkpVTE9VSUlMWVdZCAFZQU9NTkw3Bg++
X-HM-Tid: 0a715d298de16447kurs760465c0dcc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PgpEYXRlOiAyMDIwLTA0LTA5
IDA1OjMzOjI3ClRvOiAgd2VuaHUud2FuZ0B2aXZvLmNvbQpDYzogIGFrcG1AbGludXgtZm91bmRh
dGlvbi5vcmcsa3ViYUBrZXJuZWwub3JnLGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnLHRnbHhA
bGludXRyb25peC5kZSxiam9ybi5hbmRlcnNzb25AbGluYXJvLm9yZyxob2ZyYXRAb3NhZGwub3Jn
LGFsbGlzb25AbG9odXRvay5uZXQsam9oYW5uZXMuYmVyZ0BpbnRlbC5jb20sYXJuZEBhcm5kYi5k
ZSxjamh1YW5nQGNvZGVhdXJvcmEub3JnLGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcsbmV0
ZGV2QHZnZXIua2VybmVsLm9yZyxrZXJuZWxAdml2by5jb20KU3ViamVjdDogUmU6IFtQQVRDSCBS
RVNFTkRdIG5ldDogcXJ0cjogc3VwcG9ydCBxcnRyIHNlcnZpY2UgYW5kIGxvb2t1cCByb3V0ZT5G
cm9tOiBXYW5nIFdlbmh1IDx3ZW5odS53YW5nQHZpdm8uY29tPgo+RGF0ZTogV2VkLCAgOCBBcHIg
MjAyMCAwMzo0NjozNSAtMDcwMAo+Cj4+IFFTUiBpbXBsZW1lbnRzIG1haW50ZW5hbmNlIG9mIHFy
dHIgc2VydmljZXMgYW5kIGxvb2t1cHMuIEl0IHdvdWxkCj4+IGJlIGhlbHBmdWwgZm9yIGRldmVs
b3BlcnMgdG8gd29yayB3aXRoIFFSVFIgd2l0aG91dCB0aGUgbm9uZS1vcGVuc291cmNlCj4+IHVz
ZXItc3BhY2UgaW1wbGVtZW50YXRpb24gcGFydCBvZiBJUEMgUm91dGVyLgo+PiAKPj4gQXMgd2Ug
a25vdywgdGhlIGV4dHJlbWVseSBpbXBvcnRhbnQgcG9pbnQgb2YgSVBDIFJvdXRlciBpcyB0aGUg
c3VwcG9ydAo+PiBvZiBzZXJ2aWNlcyBmb3JtIGRpZmZlcmVudCBub2Rlcy4gQnV0IFFSVFIgd2Fz
IHB1c2hlZCBpbnRvIG1haW5saW5lCj4+IHdpdGhvdXQgcm91dGUgcHJvY2VzcyBzdXBwb3J0IG9m
IHNlcnZpY2VzLCBhbmQgdGhlIHJvdXRlciBwb3J0IHByb2Nlc3MKPj4gaXMgaW1wbGVtZW50ZWQg
aW4gdXNlci1zcGFjZSBhcyBub25lLW9wZW5zb3VyY2UgY29kZXMsIHdoaWNoIGlzIGFuCj4+IGdy
ZWF0IHVuY29udmVuaWVuY2UgZm9yIGRldmVsb3BlcnMuCj4+IAo+PiBRU1IgYWxzbyBpbXBsZW1l
bnRzIGEgaW50ZXJmYWNlIHZpYSBjaGFyZGV2IGFuZCBhIHNldCBvZiBzeXNmcyBjbGFzcwo+PiBm
aWxlcyBmb3IgdGhlIGNvbW11bmljYXRpb24gYW5kIGRlYnVnZ2luZyBpbiB1c2VyLXNwYWNlLiBX
ZSBjYW4gZ2V0Cj4+IHNlcnZpY2UgYW5kIGxvb2t1cCBlbnRyaWVzIGNvbnZlbmllbnRseSB2aWEg
c3lzZnMgZmlsZSBpbiAvc3lzL2NsYXNzL3Fzci8uCj4+IEN1cnJlbnRseSBhZGQtc2VydmVyLCBk
ZWwtc2VydmVyLCBhZGQtbG9va3VwIGFuZCBkZWwtbG9va3VwIGNvbnRyb2wKPj4gcGFja2F0ZXRz
IGFyZSBwcm9jZXNzZWQgYW5kIGVuaGFuY2VtZW50cyBjb3VsZCBiZSB0YWtlbiBlYXNpbHkgdXBv
bgo+PiBjdXJyZW50bHkgaW1wbGVtZW50YXRpb24uCj4+IAo+PiBTaWduZWQtb2ZmLWJ5OiBXYW5n
IFdlbmh1IDx3ZW5odS53YW5nQHZpdm8uY29tPgo+Cj5OZXcgZmVhdHVyZXMgYXJlIG9ubHkgYXBw
cm9wcmlhdGUgZm9yIG5ldC1uZXh0IHdoaWNoIGlzIGNsb3NlZCByaWdodCBub3cuCgpTZWUuIEFu
ZCBzZWVtcyBsaWtlIHRoZSB2NS43LXJjMSBpcyBwcm9iYWJseSB0byBiZSByZWxlYXNlZCBuZXh0
IG1vbmRheSBvciBzby4KSSB3aWxsIHNlbmQgYSBuZXcgcGF0Y2ggdGFnZWQgd2l0aCBbUEFUQ0gg
bmV0LW5leHRdIHRoZW4uCgpQbGVhc2UgZGVwcmVjYXRlIHRoZSBjdXJyZW50IGNvbW1pdC4KClRo
YW5rcywgV2VuaHUuDQoNCg==
