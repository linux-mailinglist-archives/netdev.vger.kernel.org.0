Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5BE22D547
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 07:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgGYFzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 01:55:31 -0400
Received: from mail.zju.edu.cn ([61.164.42.155]:40140 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbgGYFza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 01:55:30 -0400
Received: by ajax-webmail-mail-app3 (Coremail) ; Sat, 25 Jul 2020 13:55:09
 +0800 (GMT+08:00)
X-Originating-IP: [210.32.144.186]
Date:   Sat, 25 Jul 2020 13:55:09 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "David Miller" <davem@davemloft.net>
Cc:     kjlu@umn.edu, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] octeontx2-af: Fix use of uninitialized pointer bmap
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190906(84e8bf8f)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <20200724.165722.526735468993909990.davem@davemloft.net>
References: <20200724080657.19182-1-dinghao.liu@zju.edu.cn>
 <20200724.165722.526735468993909990.davem@davemloft.net>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4107fd31.2d71b.173848a1987.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgA3Ut49yRtf8O1nAQ--.19856W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAggHBlZdtPRcawAWsh
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbX0S07vEb7Iv0x
        C_JF4lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
        bVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4ylV2xY628lY4IE4IxF12IF4w
        CS07vE84x0c7CEj48ve4kI8wCS07vE84ACjcxK6xIIjxv20xvE14v26w1j6s0DMIAIbVA2
        z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIAIbVA2z4x0Y4vEx4A2jsIE14v26r
        xl6s0DMIAIbVA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lV2xY62AIxVAIcxkEcVAq
        07x20xvEncxIr21lV2xY6c02F40EFcxC0VAKzVAqx4xG6I80ewCS07vEYx0E2Ix0cI8IcV
        AFwI0_Jr0_Jr4lV2xY6cIj6I8E87Iv67AKxVWUJVW8JwCS07vEOx8S6xCaFVCjc4AY6r1j
        6r4UMIAIbVCjxxvEw4WlV2xY6xkIecxEwVAFwVW8WwCS07vEc2IjII80xcxEwVAKI48JMI
        AIbVCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1lV2xY6xCjnVCjjxCrMIAIbVCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCS07vEx2IqxVAqx4xG67AKxVWUJVWUGwCS07vEx2IqxVCjr7xvwV
        AFwI0_JrI_JrWlV2xY6I8E67AF67kF1VAFwI0_Jw0_GFylV2xY6IIF0xvE2Ix0cI8IcVAF
        wI0_Jr0_JF4lV2xY6IIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCS07vEIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lV2xY6IIF0xvEx4A2jsIE14v26r1j6r4UMIAIbVCI42IY
        6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEaW5naGFvIExpdSA8ZGluZ2hhby5saXVAemp1LmVkdS5jbj4KPiBEYXRlOiBGcmks
IDI0IEp1bCAyMDIwIDE2OjA2OjU3ICswODAwCj4gCj4gPiBJZiByZXEtPmN0eXBlIGRvZXMgbm90
IG1hdGNoIGFueSBvZiBOSVhfQVFfQ1RZUEVfQ1EsCj4gPiBOSVhfQVFfQ1RZUEVfU1Egb3IgTklY
X0FRX0NUWVBFX1JRLCBwb2ludGVyIGJtYXAgd2lsbCByZW1haW4KPiA+IHVuaW5pdGlhbGl6ZWQg
YW5kIGJlIGFjY2Vzc2VkIGluIHRlc3RfYml0KCksIHdoaWNoIGNhbiBsZWFkCj4gPiB0byBrZXJu
YWwgY3Jhc2guCj4gCj4gVGhpcyBjYW4gbmV2ZXIgaGFwcGVuLgo+IAo+ID4gRml4IHRoaXMgYnkg
cmV0dXJuaW5nIGFuIGVycm9yIGNvZGUgaWYgdGhpcyBjYXNlIGlzIHRyaWdnZXJlZC4KPiA+IAo+
ID4gU2lnbmVkLW9mZi1ieTogRGluZ2hhbyBMaXUgPGRpbmdoYW8ubGl1QHpqdS5lZHUuY24+Cj4g
Cj4gSSBzdHJvbmdseSBkaXNsaWtlIGNoYW5nZXMgbGlrZSB0aGlzLgo+IAo+IE1vc3QgY2FsbGVy
cyBvZiBuaXhfbGZfaHdjdHhfZGlzYWJsZSgpIGluc2lkZSBvZiBydnVfbml4LmMgc2V0Cj4gcmVx
LT5jdHlwZSB0byBvbmUgb2YgdGhlIGhhbmRsZWQgdmFsdWVzLgo+IAo+IFRoZSBvbmx5IG90aGVy
IGNhc2UsIHJ2dV9tYm94X2hhbmRsZXJfbml4X2h3Y3R4X2Rpc2FibGUoKSwgaXMgYQo+IGNvbXBs
ZXRlbHkgdW51c2VkIGZ1bmN0aW9uIGFuZCBzaG91bGQgYmUgcmVtb3ZlZC4KPiAKPiBUaGVyZSBp
cyBubyBmdW5jdGlvbmFsIHByb2JsZW0gaW4gdGhpcyBjb2RlIGF0IGFsbC4KPiAKPiBJdCBpcyBu
b3QgcG9zc2libGUgc2hvdyBhIGNvZGUgcGF0aCB3aGVyZSB0aGUgc3RhdGVkIHByb2JsZW0gY2Fu
Cj4gYWN0dWFsbHkgb2NjdXIuCgpJdCdzIGNsZWFyIHRvIG1lIG5vdy4gVGhhbmtzLgoKUmVnYXJk
cywKRGluZ2hhbw==
