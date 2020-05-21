Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154741DC666
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 06:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgEUEx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 00:53:28 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:22798 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbgEUEx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 00:53:27 -0400
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 21 May 2020 12:51:57
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.77.158]
Date:   Thu, 21 May 2020 12:51:57 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Tony Lindgren" <tony@atomide.com>
Cc:     kjlu@umn.edu, "Kalle Valo" <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Maital Hahn" <maitalm@ti.com>,
        "Fuqian Huang" <huangfq.daxian@gmail.com>,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] wlcore: fix runtime pm imbalance in
 wl1271_op_suspend
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190906(84e8bf8f)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <20200520184854.GY37466@atomide.com>
References: <20200520125724.12832-1-dinghao.liu@zju.edu.cn>
 <20200520184854.GY37466@atomide.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <62e69631.b9cff.1723592e191.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgBHf3jtCMZeUM7mAQ--.37495W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgUHBlZdtOOvVwAIsq
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbtIS07vEb7Iv0x
        C_Xr1lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
        bVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4ylV2xY628lY4IE4IxF12IF4w
        CS07vE84x0c7CEj48ve4kI8wCS07vE84ACjcxK6xIIjxv20xvE14v26w1j6s0DMIAIbVA2
        z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWlV2xY628EF7xvwVC2z280aVAFwI0_Gc
        CE3s1lV2xY628EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wCS07vEe2I262IYc4CY6c8I
        j28IcVAaY2xG8wCS07vE5I8CrVACY4xI64kE6c02F40Ex7xfMIAIbVAv7VC0I7IYx2IY67
        AKxVWUJVWUGwCS07vEYx0Ex4A2jsIE14v26r1j6r4UMIAIbVAm72CE4IkC6x0Yz7v_Jr0_
        Gr1lV2xY64IIrI8v6xkF7I0E8cxan2IY04v7MIAIbVCjxxvEw4WlV2xY6xkIecxEwVAFwV
        W8XwCS07vEc2IjII80xcxEwVAKI48JMIAIbVCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l
        V2xY6xCjnVCjjxCrMIAIbVCFx2IqxVCFs4IE7xkEbVWUJVW8JwCS07vEx2IqxVAqx4xG67
        AKxVWUJVWUGwCS07vEx2IqxVCjr7xvwVAFwI0_JrI_JrWlV2xY6I8E67AF67kF1VAFwI0_
        Jw0_GFylV2xY6IIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lV2xY6IIF0xvE2Ix0cI8IcVCY1x
        0267AKxVW8JVWxJwCS07vEIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lV2xY6IIF0xvE
        x4A2jsIE14v26r1j6r4UMIAIbVCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
        evJa73U
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlcmUgaXMgYSBjaGVjayBhZ2FpbnN0IHJldCBhZnRlciBvdXRfc2xlZXAgdGFnLiBJZiB3bDEy
NzFfY29uZmlndXJlX3N1c3BlbmRfYXAoKQpyZXR1cm5zIGFuIGVycm9yIGNvZGUsIHJldCB3aWxs
IGJlIGNhdWdodCBieSB0aGlzIGNoZWNrIGFuZCBhIHdhcm5pbmcgd2lsbCBiZSBpc3N1ZWQuCgoK
JnF1b3Q7VG9ueSBMaW5kZ3JlbiZxdW90OyAmbHQ7dG9ueUBhdG9taWRlLmNvbSZndDvlhpnpgZPv
vJoKPiAqIERpbmdoYW8gTGl1IDxkaW5naGFvLmxpdUB6anUuZWR1LmNuPiBbMjAwNTIwIDEyOjU4
XToNCj4gPiBXaGVuIHdsY29yZV9od19pbnRlcnJ1cHRfbm90aWZ5KCkgcmV0dXJucyBhbiBlcnJv
ciBjb2RlLA0KPiA+IGEgcGFpcmluZyBydW50aW1lIFBNIHVzYWdlIGNvdW50ZXIgZGVjcmVtZW50
IGlzIG5lZWRlZCB0bw0KPiA+IGtlZXAgdGhlIGNvdW50ZXIgYmFsYW5jZWQuDQo+IA0KPiBXZSBz
aG91bGQgcHJvYmFibHkga2VlcCB0aGUgd2FybmluZyB0aG91Z2gsIG5vdGhpbmcgd2lsbA0KPiBn
ZXQgc2hvd24gZm9yIHdsMTI3MV9jb25maWd1cmVfc3VzcGVuZF9hcCgpIGVycm9ycy4NCj4gDQo+
IE90aGVyd2lzZSBsb29rcyBnb29kIHRvIG1lLg0KPiANCj4gUmVnYXJkcywNCj4gDQo+IFRvbnkN
Cg==
