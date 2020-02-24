Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F18216B1FB
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgBXVSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:18:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38544 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXVSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:18:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA7BB121A82C0;
        Mon, 24 Feb 2020 13:18:01 -0800 (PST)
Date:   Mon, 24 Feb 2020 13:18:01 -0800 (PST)
Message-Id: <20200224.131801.2179562246092982372.davem@davemloft.net>
To:     frextrite@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        joel@joelfernandes.org, madhuparnabhowmik10@gmail.com,
        paulmck@kernel.org
Subject: Re: [PATCH 2/2] ipmr: Add lockdep expression to
 ipmr_for_each_table macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200222063835.14328-2-frextrite@gmail.com>
References: <20200222063835.14328-1-frextrite@gmail.com>
        <20200222063835.14328-2-frextrite@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 13:18:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW1vbCBHcm92ZXIgPGZyZXh0cml0ZUBnbWFpbC5jb20+DQpEYXRlOiBTYXQsIDIyIEZl
YiAyMDIwIDEyOjA4OjM2ICswNTMwDQoNCj4gaXBtcl9mb3JfZWFjaF90YWJsZSgpIHVzZXMgbGlz
dF9mb3JfZWFjaF9lbnRyeV9yY3UoKSBmb3INCj4gdHJhdmVyc2luZyBvdXRzaWRlIG9mIGFuIFJD
VSByZWFkLXNpZGUgY3JpdGljYWwgc2VjdGlvbiBidXQNCj4gdW5kZXIgdGhlIHByb3RlY3Rpb24g
b2YgcGVybmV0X29wc19yd3NlbS4gSGVuY2UgYWRkIHRoZQ0KPiBjb3JyZXNwb25kaW5nIGxvY2tk
ZXAgZXhwcmVzc2lvbiB0byBzaWxlbmNlIHRoZSBmb2xsb3dpbmcNCj4gZmFsc2UtcG9zaXRpdmUg
d2FybmluZyBhdCBib290Og0KPiANCj4gWyAgICAwLjY0NTI5Ml0gPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0NCj4gWyAgICAwLjY0NTI5NF0gV0FSTklORzogc3VzcGljaW91cyBSQ1UgdXNh
Z2UNCj4gWyAgICAwLjY0NTI5Nl0gNS41LjQtc3RhYmxlICMxNyBOb3QgdGFpbnRlZA0KPiBbICAg
IDAuNjQ1Mjk3XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBbICAgIDAuNjQ1Mjk5
XSBuZXQvaXB2NC9pcG1yLmM6MTM2IFJDVS1saXN0IHRyYXZlcnNlZCBpbiBub24tcmVhZGVyIHNl
Y3Rpb24hIQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW1vbCBHcm92ZXIgPGZyZXh0cml0ZUBnbWFp
bC5jb20+DQoNClRoaXMgcGF0Y2ggc2VyaWVzIGNhdXNlcyBidWlsZCBwcm9ibGVtcywgcGxlYXNl
IGZpeCBhbmQgcmVzdWJtaXQgdGhlIGVudGlyZQ0Kc2VyaWVzOg0KDQpbZGF2ZW1AbG9jYWxob3N0
IG5ldC1uZXh0XSQgbWFrZSBuZXQvaXB2NC9pcG1yLm8gDQogIENBTEwgICAgc2NyaXB0cy9jaGVj
a3N5c2NhbGxzLnNoDQogIENBTEwgICAgc2NyaXB0cy9hdG9taWMvY2hlY2stYXRvbWljcy5zaA0K
ICBERVNDRU5EICBvYmp0b29sDQogIENDICAgICAgbmV0L2lwdjQvaXBtci5vDQpJbiBmaWxlIGlu
Y2x1ZGVkIGZyb20gLi9pbmNsdWRlL2xpbnV4L3JjdWxpc3QuaDoxMSwNCiAgICAgICAgICAgICAg
ICAgZnJvbSAuL2luY2x1ZGUvbGludXgvcGlkLmg6NSwNCiAgICAgICAgICAgICAgICAgZnJvbSAu
L2luY2x1ZGUvbGludXgvc2NoZWQuaDoxNCwNCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1
ZGUvbGludXgvdWFjY2Vzcy5oOjUsDQogICAgICAgICAgICAgICAgIGZyb20gbmV0L2lwdjQvaXBt
ci5jOjI0Og0KbmV0L2lwdjQvaXBtci5jOiBJbiBmdW5jdGlvbiChaXBtcl9nZXRfdGFibGWiOg0K
Li9pbmNsdWRlL2xpbnV4L3JjdWxpc3QuaDo2MzoyNTogd2FybmluZzogc3VnZ2VzdCBwYXJlbnRo
ZXNlcyBhcm91bmQgoSYmoiB3aXRoaW4goXx8oiBbLVdwYXJlbnRoZXNlc10NCiAgUkNVX0xPQ0tE
RVBfV0FSTighY29uZCAmJiAhcmN1X3JlYWRfbG9ja19hbnlfaGVsZCgpLCAgXA0KLi9pbmNsdWRl
L2xpbnV4L3JjdXBkYXRlLmg6MjYzOjUyOiBub3RlOiBpbiBkZWZpbml0aW9uIG9mIG1hY3JvIKFS
Q1VfTE9DS0RFUF9XQVJOog0KICAgaWYgKGRlYnVnX2xvY2tkZXBfcmN1X2VuYWJsZWQoKSAmJiAh
X193YXJuZWQgJiYgKGMpKSB7IFwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBeDQouL2luY2x1ZGUvbGludXgvcmN1bGlzdC5oOjM4MTo3OiBub3Rl
OiBpbiBleHBhbnNpb24gb2YgbWFjcm8goV9fbGlzdF9jaGVja19yY3WiDQogIGZvciAoX19saXN0
X2NoZWNrX3JjdShkdW1teSwgIyMgY29uZCwgMCksICAgXA0KICAgICAgIF5+fn5+fn5+fn5+fn5+
fn4NCm5ldC9pcHY0L2lwbXIuYzoxMTM6Mjogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIKFs
aXN0X2Zvcl9lYWNoX2VudHJ5X3JjdaINCiAgbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UobXJ0LCAm
bmV0LT5pcHY0Lm1yX3RhYmxlcywgbGlzdCwgXA0KICBefn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0K
bmV0L2lwdjQvaXBtci5jOjEzODoyOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8goWlwbXJf
Zm9yX2VhY2hfdGFibGWiDQogIGlwbXJfZm9yX2VhY2hfdGFibGUobXJ0LCBuZXQpIHsNCiAgXn5+
fn5+fn5+fn5+fn5+fn5+fg0K
