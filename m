Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B82A2AE76B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 05:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgKKEbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 23:31:32 -0500
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:35878
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1725828AbgKKEbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 23:31:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pku.edu.cn; s=dkim; h=Received:Date:From:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID;
        bh=Bn8aeNYp5BbSXSw4ne6/30znL0vSU+Mk9CE8jqyzc5g=; b=LDRRr0gltGQQC
        mYrPgKuNonFju4fRN9nZ8VK6vbMupoMKaSKGfZifQ7/EzPkXQQEo1Y6qXREIut1O
        vaMzcegBS/Ugj3+Jggxlorddzz8soWWMT/O1KLFEEU4y9YBC4HBHdNPPT0EleR0X
        phl5wxgjpRqjoUIN1AP9DTWHzb2yIU=
Received: by ajax-webmail-mailfront01 (Coremail) ; Wed, 11 Nov 2020 12:31:27
 +0800 (GMT+08:00)
X-Originating-IP: [36.110.33.210]
Date:   Wed, 11 Nov 2020 12:31:27 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5p2c6Iux5p2w?= <leondyj@pku.edu.cn>
To:     netdev@vger.kernel.org
Subject: some question about "/sys/class/net/<iface>/operstate"
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20200917(3e19599d)
 Copyright (c) 2002-2020 www.mailtech.cn
 mispb-1ea67e80-64e4-49d5-bd9f-3beeae24b9f2-pku.edu.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <1a87f1b4.3d6ab.175b592a271.Coremail.leondyj@pku.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: x4FpogBnu6gfaatfOltTAA--.21663W
X-CM-SenderInfo: irzqijyrqxilo6sn3hxhgxhubq/1tbiAgERClPy7yS7eAABsw
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSB3YW50IHRvIHVzZSBpbm90aWZ5IHRvIG1vbml0b3IgL3N5cy9jbGFzcy9uZXQvL29wZXJzdGF0
ZSAgdG8gZGV0ZWN0IHN0YXR1cyBvZiBhIGlmYWNlIGluIHJlYWwgdGltZS4gCndoZW4gSSBpZmRv
d24gJmFtcDsmYW1wOyBpZnVwIGV0aDMsIHRoZSBjb250ZW50IG9mIG9wZXJzdGF0ZSBjaGFuZ2Vk
LCBidXQgdGhlIGZpbGUncyBNb2RpZnkgdGltZSBkaWRuJ3QgY2hhbmdlLiAKSSBkb24ndCBrbm93
IHRoZSByZWFzb24sIGlzIHRoZXJlIGFueSBmaWxlIHdoaWNoIGNhbiBiZSBtb25pdG9yZWQgYnkg
aW5vdGlmeSB0byBnZXQgaWZhY2Ugc3RhdHVzIGluIHJlYWwgdGltZT8gCk11Y2ggYXBwcmVjaWF0
aW9uIGZvciBhbnkgYWR2aWNlISAKCgpiZWxvdyBhcmUgbXkgdGVybWluYWwgbXNnOgogIApbcm9v
dEB5aW5namllLTQtNS0wLTIwMjAxMTA5MTk1NzM5LTEgMTE6MTA6MzkgMDAwMDowMDowYy4wXSRz
dGF0IC9zeXMvY2xhc3MvbmV0L2V0aDMvb3BlcnN0YXRlIApGaWxlOiDigJgvc3lzL2NsYXNzL25l
dC9ldGgzL29wZXJzdGF0ZeKAmQpTaXplOiA0MDk2ICAgICAgICAgICAgQmxvY2tzOiAwICAgICAg
ICAgIElPIEJsb2NrOiA0MDk2ICAgcmVndWxhciBmaWxlCkRldmljZTogMTRoLzIwZCBJbm9kZTog
MjU4MzggICAgICAgTGlua3M6IDEKQWNjZXNzOiAoMDQ0NC8tci0tci0tci0tKSAgVWlkOiAoICAg
IDAvICAgIHJvb3QpICAgR2lkOiAoICAgIDAvICAgIHJvb3QpCkFjY2VzczogMjAyMC0xMS0xMCAy
MDo0MjoxOC41OTIwMDA5NjkgKzA4MDAKTW9kaWZ5OiAyMDIwLTExLTEwIDIwOjQyOjE4LjU5MjAw
MDk2OSArMDgwMApDaGFuZ2U6IDIwMjAtMTEtMTAgMjA6NDI6MTguNTkyMDAwOTY5ICswODAwCkJp
cnRoOiAtCltyb290QHlpbmdqaWUtNC01LTAtMjAyMDExMDkxOTU3MzktMSAxMToxMDo1MCAwMDAw
OjAwOjBjLjBdJGNhdCAvc3lzL2NsYXNzL25ldC9ldGgzL29wZXJzdGF0ZSAKdXAKWW91IGhhdmUg
bmV3IG1haWwgaW4gL3Zhci9zcG9vbC9tYWlsL3Jvb3QKW3Jvb3RAeWluZ2ppZS00LTUtMC0yMDIw
MTEwOTE5NTczOS0xIDExOjExOjA2IDAwMDA6MDA6MGMuMF0kaWZkb3duIGV0aDMKW3Jvb3RAeWlu
Z2ppZS00LTUtMC0yMDIwMTEwOTE5NTczOS0xIDExOjExOjEzIDAwMDA6MDA6MGMuMF0kY2F0IC9z
eXMvY2xhc3MvbmV0L2V0aDMvb3BlcnN0YXRlIApkb3duCltyb290QHlpbmdqaWUtNC01LTAtMjAy
MDExMDkxOTU3MzktMSAxMToxMToxNiAwMDAwOjAwOjBjLjBdJHN0YXQgL3N5cy9jbGFzcy9uZXQv
ZXRoMy9vcGVyc3RhdGUgCkZpbGU6IOKAmC9zeXMvY2xhc3MvbmV0L2V0aDMvb3BlcnN0YXRl4oCZ
ClNpemU6IDQwOTYgICAgICAgICAgICBCbG9ja3M6IDAgICAgICAgICAgSU8gQmxvY2s6IDQwOTYg
ICByZWd1bGFyIGZpbGUKRGV2aWNlOiAxNGgvMjBkIElub2RlOiAyNTgzOCAgICAgICBMaW5rczog
MQpBY2Nlc3M6ICgwNDQ0Ly1yLS1yLS1yLS0pICBVaWQ6ICggICAgMC8gICAgcm9vdCkgICBHaWQ6
ICggICAgMC8gICAgcm9vdCkKQWNjZXNzOiAyMDIwLTExLTEwIDIwOjQyOjE4LjU5MjAwMDk2OSAr
MDgwMApNb2RpZnk6IDIwMjAtMTEtMTAgMjA6NDI6MTguNTkyMDAwOTY5ICswODAwCkNoYW5nZTog
MjAyMC0xMS0xMCAyMDo0MjoxOC41OTIwMDA5NjkgKzA4MDAKQmlydGg6IC0KCgo=
