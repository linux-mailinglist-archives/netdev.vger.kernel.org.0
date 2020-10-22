Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1DF2957E7
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 07:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507936AbgJVF2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 01:28:39 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:53686 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502763AbgJVF2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 01:28:39 -0400
Received: by ajax-webmail-mail-app2 (Coremail) ; Thu, 22 Oct 2020 13:28:14
 +0800 (GMT+08:00)
X-Originating-IP: [210.32.148.79]
Date:   Thu, 22 Oct 2020 13:28:14 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Oliver Hartkopp" <socketcan@hartkopp.net>
Cc:     kjlu@umn.edu, "Wolfgang Grandegger" <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] can: vxcan: Fix memleak in vxcan_newlink
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.12 build 20200616(0f5d8152)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <986c27bf-29b4-a4f7-1dcd-4cb5a446334b@hartkopp.net>
References: <20201021052150.25914-1-dinghao.liu@zju.edu.cn>
 <986c27bf-29b4-a4f7-1dcd-4cb5a446334b@hartkopp.net>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <7799c305.e430.1754ec76e07.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgB3XJxuGJFf7mY4AA--.9419W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgABBlZdtQiRQQAAsj
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbX0S07vEb7Iv0x
        C_Ar1lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAKPiBPbiAyMS4xMC4yMCAwNzoyMSwgRGluZ2hhbyBMaXUgd3JvdGU6Cj4gPiBXaGVuIHJ0bmxf
Y29uZmlndXJlX2xpbmsoKSBmYWlscywgcGVlciBuZWVkcyB0byBiZQo+ID4gZnJlZWQganVzdCBs
aWtlIHdoZW4gcmVnaXN0ZXJfbmV0ZGV2aWNlKCkgZmFpbHMuCj4gPiAKPiA+IFNpZ25lZC1vZmYt
Ynk6IERpbmdoYW8gTGl1IDxkaW5naGFvLmxpdUB6anUuZWR1LmNuPgo+IAo+IEFja2VkLWJ5OiBP
bGl2ZXIgSGFydGtvcHAgPHNvY2tldGNhbkBoYXJ0a29wcC5uZXQ+Cj4gCj4gQnR3LiBhcyB0aGUg
dnhjYW4uYyBkcml2ZXIgYmFzZXMgb24gdmV0aC5jIHRoZSBzYW1lIGlzc3VlIGNhbiBiZSBmb3Vu
ZCAKPiB0aGVyZSEKPiAKPiBBdCB0aGlzIHBvaW50Ogo+IGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4u
Y29tL2xpbnV4L2xhdGVzdC9zb3VyY2UvZHJpdmVycy9uZXQvdmV0aC5jI0wxMzk4Cj4gCj4gZXJy
X3JlZ2lzdGVyX2RldjoKPiAgICAgICAgICAvKiBub3RoaW5nIHRvIGRvICovCj4gZXJyX2NvbmZp
Z3VyZV9wZWVyOgo+ICAgICAgICAgIHVucmVnaXN0ZXJfbmV0ZGV2aWNlKHBlZXIpOwo+ICAgICAg
ICAgIHJldHVybiBlcnI7IDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8Cj4gCj4gZXJyX3JlZ2lzdGVy
X3BlZXI6Cj4gICAgICAgICAgZnJlZV9uZXRkZXYocGVlcik7Cj4gICAgICAgICAgcmV0dXJuIGVy
cjsKPiB9Cj4gCj4gSU1PIHRoZSByZXR1cm4gbXVzdCBiZSByZW1vdmVkIHRvIGZhbGwgdGhyb3Vn
aCB0aGUgbmV4dCBsYWJlbCBhbmQgZnJlZSAKPiB0aGUgbmV0ZGV2aWNlIHRvby4KPiAKPiBXb3Vs
ZCB5b3UgbGlrZSBzbyBzZW5kIGEgcGF0Y2ggZm9yIHZldGguYyB0b28/Cj4gCgpTdXJlLgoKUmVn
YXJkcywKRGluZ2hhbwo=
