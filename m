Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA5AF579B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731203AbfKHTaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:30:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36662 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729896AbfKHTaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:30:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B68B153A6212;
        Fri,  8 Nov 2019 11:30:04 -0800 (PST)
Date:   Fri, 08 Nov 2019 11:30:03 -0800 (PST)
Message-Id: <20191108.113003.601469804110215285.davem@davemloft.net>
To:     ktkhai@virtuozzo.com
Cc:     pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, hare@suse.com, tglx@linutronix.de,
        edumazet@google.com, arnd@arndb.de, axboe@kernel.dk,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] unix: Show number of scm files in fdinfo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157312863230.4594.18421480718399996953.stgit@localhost.localdomain>
References: <157312863230.4594.18421480718399996953.stgit@localhost.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 11:30:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2lyaWxsIFRraGFpIDxrdGtoYWlAdmlydHVvenpvLmNvbT4NCkRhdGU6IFRodSwgMDcg
Tm92IDIwMTkgMTU6MTQ6MTUgKzAzMDANCg0KPiBVbml4IHNvY2tldHMgbGlrZSBhIGJsb2NrIGJv
eC4gWW91IG5ldmVyIGtub3cgd2hhdCBpcyBwZW5kaW5nIHRoZXJlOg0KPiB0aGVyZSBtYXkgYmUg
YSBmaWxlIGRlc2NyaXB0b3IgaG9sZGluZyBhIG1vdW50IG9yIGEgYmxvY2sgZGV2aWNlLA0KPiBv
ciB0aGVyZSBtYXkgYmUgd2hvbGUgdW5pdmVyc2VzIHdpdGggbmFtZXNwYWNlcywgc29ja2V0cyB3
aXRoIHJlY2VpdmUNCj4gcXVldWVzIGZ1bGwgb2Ygc29ja2V0cyBldGMuDQo+IA0KPiBUaGUgcGF0
Y2hzZXQgbWFrZXMgbnVtYmVyIG9mIHBlbmRpbmcgc2NtIGZpbGVzIGJlIHZpc2libGUgaW4gZmRp
bmZvLg0KPiBUaGlzIG1heSBiZSB1c2VmdWwgdG8gZGV0ZXJtaW5lLCB0aGF0IHNvY2tldCBzaG91
bGQgYmUgaW52ZXN0aWdhdGVkDQo+IG9yIHdoaWNoIHRhc2sgc2hvdWxkIGJlIGtpbGxlZCB0byBw
dXQgcmVmZXJlbmNlIGNvdW50ZXIgb24gYSByZXNvdXJzZS4NCg0KVGhpcyBkb2Vzbid0IGV2ZW4g
Y29tcGlsZToNCg0KbmV0L3VuaXgvYWZfdW5peC5jOiBJbiBmdW5jdGlvbiChc2NtX3N0YXRfYWRk
ojoNCi4vaW5jbHVkZS9saW51eC9sb2NrZGVwLmg6MzY1OjUyOiBlcnJvcjogaW52YWxpZCB0eXBl
IGFyZ3VtZW50IG9mIKEtPqIgKGhhdmUgoXNwaW5sb2NrX3SiIHtha2EgoXN0cnVjdCBzcGlubG9j
a6J9KQ0KICNkZWZpbmUgbG9ja2RlcF9pc19oZWxkKGxvY2spICBsb2NrX2lzX2hlbGQoJihsb2Nr
KS0+ZGVwX21hcCkNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBefg0KLi9pbmNsdWRlL2FzbS1nZW5lcmljL2J1Zy5oOjExMzoyNTogbm90ZTogaW4g
ZGVmaW5pdGlvbiBvZiBtYWNybyChV0FSTl9PTqINCiAgaW50IF9fcmV0X3dhcm5fb24gPSAhIShj
b25kaXRpb24pOyAgICBcDQogICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+DQouL2lu
Y2x1ZGUvbGludXgvbG9ja2RlcC5oOjM5MToyNzogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3Jv
IKFsb2NrZGVwX2lzX2hlbGSiDQogICBXQVJOX09OKGRlYnVnX2xvY2tzICYmICFsb2NrZGVwX2lz
X2hlbGQobCkpOyBcDQogICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn4N
Cm5ldC91bml4L2FmX3VuaXguYzoxNTgyOjI6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyCh
bG9ja2RlcF9hc3NlcnRfaGVsZKINCiAgbG9ja2RlcF9hc3NlcnRfaGVsZChzay0+c2tfcmVjZWl2
ZV9xdWV1ZS5sb2NrKTsNCiAgXn5+fn5+fn5+fn5+fn5+fn5+fg0KbmV0L3VuaXgvYWZfdW5peC5j
OiBJbiBmdW5jdGlvbiChc2NtX3N0YXRfZGVsojoNCi4vaW5jbHVkZS9saW51eC9sb2NrZGVwLmg6
MzY1OjUyOiBlcnJvcjogaW52YWxpZCB0eXBlIGFyZ3VtZW50IG9mIKEtPqIgKGhhdmUgoXNwaW5s
b2NrX3SiIHtha2EgoXN0cnVjdCBzcGlubG9ja6J9KQ0KICNkZWZpbmUgbG9ja2RlcF9pc19oZWxk
KGxvY2spICBsb2NrX2lzX2hlbGQoJihsb2NrKS0+ZGVwX21hcCkNCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefg0KLi9pbmNsdWRlL2FzbS1nZW5l
cmljL2J1Zy5oOjExMzoyNTogbm90ZTogaW4gZGVmaW5pdGlvbiBvZiBtYWNybyChV0FSTl9PTqIN
CiAgaW50IF9fcmV0X3dhcm5fb24gPSAhIShjb25kaXRpb24pOyAgICBcDQogICAgICAgICAgICAg
ICAgICAgICAgICAgXn5+fn5+fn5+DQouL2luY2x1ZGUvbGludXgvbG9ja2RlcC5oOjM5MToyNzog
bm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIKFsb2NrZGVwX2lzX2hlbGSiDQogICBXQVJOX09O
KGRlYnVnX2xvY2tzICYmICFsb2NrZGVwX2lzX2hlbGQobCkpOyBcDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICBefn5+fn5+fn5+fn5+fn4NCm5ldC91bml4L2FmX3VuaXguYzoxNTkzOjI6IG5v
dGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyChbG9ja2RlcF9hc3NlcnRfaGVsZKINCiAgbG9ja2Rl
cF9hc3NlcnRfaGVsZChzay0+c2tfcmVjZWl2ZV9xdWV1ZS5sb2NrKTsNCiAgXn5+fn5+fn5+fn5+
fn5+fn5+fg0KbWFrZVsyXTogKioqIFtzY3JpcHRzL01ha2VmaWxlLmJ1aWxkOjI2NjogbmV0L3Vu
aXgvYWZfdW5peC5vXSBFcnJvciAxDQptYWtlWzFdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUuYnVp
bGQ6NTA5OiBuZXQvdW5peF0gRXJyb3IgMg0KbWFrZVsxXTogKioqIFdhaXRpbmcgZm9yIHVuZmlu
aXNoZWQgam9icy4uLi4NCg==
