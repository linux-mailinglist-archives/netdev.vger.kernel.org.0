Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1E250B0BC
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 08:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444466AbiDVGl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 02:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349475AbiDVGlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 02:41:25 -0400
Received: from m1541.mail.126.com (m1541.mail.126.com [220.181.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 602BE3FD9F;
        Thu, 21 Apr 2022 23:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=yVM+N
        e5UA83M8xLJzmBVV3Y0VtWxbKAdVuywD6V0vX0=; b=UGDV4TGlRuwu1HMMyiC5C
        yLfXyf58SamRDI9yHEAyr5erYpGF+2oVl5qouEZLygEyYhO1xLr3v2XeTcYFJnE9
        0KiLQST7Auxz4uyKYX4GBqBRUfGtTF+6qaPqnXh+AMRZfZXqQGesxyLndUbu7ueA
        nR3VJ3Op3cOcMlAncuVu7I=
Received: from zhaojunkui2008$126.com ( [112.80.34.205] ) by
 ajax-webmail-wmsvr41 (Coremail) ; Fri, 22 Apr 2022 14:37:55 +0800 (CST)
X-Originating-IP: [112.80.34.205]
Date:   Fri, 22 Apr 2022 14:37:55 +0800 (CST)
From:   z <zhaojunkui2008@126.com>
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     "Jakub Kicinski" <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        bernard@vivo.com
Subject: Re:Re: [PATCH] net/wireless: add debugfs exit function
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210622(1d4788a8)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <877d7hoe2i.fsf@kernel.org>
References: <20220422012830.342993-1-zhaojunkui2008@126.com>
 <877d7hoe2i.fsf@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <3c0443f.3b82.1804ffdcdeb.Coremail.zhaojunkui2008@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: KcqowADn9t5ETWJizOERAA--.42288W
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiuRrqqlpD8lA2UwACs-
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS2FsbGUgVmFsbzoKCj4tLS0tLdPKvP7Urbz+LS0tLS0KPreivP7IyzogS2FsbGUgVmFsbyA8
a3ZhbG9Aa2VybmVsLm9yZz4gCj63osvNyrG85DogMjAyMsTqNNTCMjLI1SAxMzo1Nwo+ytW8/sjL
OiBCZXJuYXJkIFpoYW8gPHpoYW9qdW5rdWkyMDA4QDEyNi5jb20+Cj6zrcvNOiBKYWt1YiBLaWNp
bnNraSA8a3ViYWtpY2lAd3AucGw+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5u
ZXQ+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBNYXR0aGlhcyBCcnVnZ2VyIDxt
YXR0aGlhcy5iZ2dAZ21haWwuY29tPjsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyA+bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQu
b3JnOyBsaW51eC1tZWRpYXRla0BsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOyDV1L78v/wgPGJlcm5hcmRAdml2by5jb20+Cj7W98ziOiBSZTogW1BBVENI
XSBuZXQvd2lyZWxlc3M6IGFkZCBkZWJ1Z2ZzIGV4aXQgZnVuY3Rpb24KCj5CZXJuYXJkIFpoYW8g
PHpoYW9qdW5rdWkyMDA4QDEyNi5jb20+IHdyaXRlczoKCj4+IFRoaXMgcGF0Y2ggYWRkIGV4aXQg
ZGVidWdmcyBmdW5jdGlvbiB0byBtdDc2MDF1Lgo+PiBEZWJ1Z2ZzIG5lZWQgdG8gYmUgY2xlYW51
cCB3aGVuIG1vZHVsZSBpcyB1bmxvYWRlZCBvciBsb2FkIGZhaWwuCgo+ImxvYWQgZmFpbCI/IFBs
ZWFzZSBiZSBtb3JlIHNwZWNpZmljLCBhcmUgeW91IHNheWluZyB0aGF0IHRoZSBzZWNvbmQgbW9k
dWxlIGxvYWQgZmFpbHMgb3Igd2hhdD8KRm9yIHRoaXMgcGFydCwgdGhlcmUgYXJlIHR3byBjYXNl
czoKRmlyc3Qgd2hlbiBtdDc2MDF1IGlzIGxvYWRlZCwgaW4gZnVuY3Rpb24gbXQ3NjAxdV9wcm9i
ZSwgaWYgZnVuY3Rpb24gbXQ3NjAxdV9wcm9iZSBydW4gaW50byBlcnJvciBsYWJsZSBlcnJfaHcs
IG10NzYwMXVfY2xlYW51cCBkaWRuYHQgY2xlYW51cCB0aGUgZGVidWdmcyBub2RlLgpTZWNvbmQg
d2hlbiB0aGUgbW9kdWxlIGRpc2Nvbm5lY3QsIGluIGZ1bmN0aW9uIG10NzYwMXVfZGlzY29ubmVj
dCwgbXQ3NjAxdV9jbGVhbnVwIGRpZG5gdCBjbGVhbnVwIHRoZSBkZWJ1Z2ZzIG5vZGUuCkkgdGhp
bmsgdGhlc2UgYXJlIHRoZSBtdDc2MDF1IHVubG9hZGVkIG9yIGxvYWQgZmFpbCBjYXNlcywgYnV0
IGJvdGggd2l0aCBubyBkZWJ1Z2ZzIGNsZWFudXAgd29yay4KCj4+ICBkcml2ZXJzL25ldC93aXJl
bGVzcy9tZWRpYXRlay9tdDc2MDF1L2RlYnVnZnMuYyB8IDkgKysrKysrKy0tCj4+ICBkcml2ZXJz
L25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2MDF1L2luaXQuYyAgICB8IDEgKwo+PiAgZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3NjAxdS9tdDc2MDF1LmggfCAxICsKCj5UaGUgdGl0
bGUgc2hvdWxkIGJlOgoKPm10NzYwMXU6IGFkZCBkZWJ1Z2ZzIGV4aXQgZnVuY3Rpb24KR290IGl0
LCB0aGFua3OjoQoKPj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3NjAx
dS9kZWJ1Z2ZzLmMKPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3NjAx
dS9kZWJ1Z2ZzLmMKPj4gQEAgLTksNiArOSw4IEBACj4+ICAjaW5jbHVkZSAibXQ3NjAxdS5oIgo+
PiAgI2luY2x1ZGUgImVlcHJvbS5oIgo+PiAgCj4+ICtzdGF0aWMgc3RydWN0IGRlbnRyeSAqZGly
OwoKPkhvdyB3aWxsIHRoaXMgd29yayB3aGVuIHRoZXJlIGFyZSBtdWx0aXBsZSBtdDc2MDF1IGRl
dmljZXM/IEJlY2F1c2Ugb2YgdGhhdCwgYXZvaWQgdXNpbmcgbm9uLWNvbnN0IHN0YXRpYyB2YXJp
YWJsZXMuClNvcnJ5IGZvciBtaXNzaW5nIHRoaXMgcGFydCwgSSB1bmRlcnN0YW5kIHRoYXQgdGhl
IGJldHRlciB3YXkgaXMgdG8gbWFuYWdlIGl0IGluIHRoZSBzdHJ1Y3Qgb2YgdGhlIG1hdGNoZWQg
ZGV2aWNlLCBJIHdvdWxkIGZpeCB0aGlzIGluIHRoZSBuZXh0IHBhdGNoLgpUaGFuayB5b3UgdmVy
eSBtdWNoIQoKQlIvL0Jlcm5hcmQKCj4tLQo+aHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9w
cm9qZWN0L2xpbnV4LXdpcmVsZXNzL2xpc3QvCgo+aHR0cHM6Ly93aXJlbGVzcy53aWtpLmtlcm5l
bC5vcmcvZW4vZGV2ZWxvcGVycy9kb2N1bWVudGF0aW9uL3N1Ym1pdHRpbmdwYXRjaGVzCg==
