Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9CB24AE84
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 07:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHTFma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 01:42:30 -0400
Received: from mail.zju.edu.cn ([61.164.42.155]:36668 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbgHTFma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 01:42:30 -0400
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 20 Aug 2020 13:42:11
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.85.18]
Date:   Thu, 20 Aug 2020 13:42:11 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     Ajay.Kathat@microchip.com
Cc:     kjlu@umn.edu, Claudiu.Beznea@microchip.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        Eugen.Hristev@microchip.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] staging: wilc1000: Fix memleak in wilc_sdio_probe
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.12 build 20200616(0f5d8152)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <0f59db10-4aec-4ce6-2695-43ddf5017cb2@microchip.com>
References: <20200819115014.28955-1-dinghao.liu@zju.edu.cn>
 <0f59db10-4aec-4ce6-2695-43ddf5017cb2@microchip.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <3b9f1c74.ba0a.1740a63917b.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgBH_94zDT5fcJftAg--.44373W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgoSBlZdtPnBhAAMsT
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbAIS07vEb7Iv0x
        C_Xr1lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
        bVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4ylV2xY628lY4IE4IxF12IF4w
        CS07vE84x0c7CEj48ve4kI8wCS07vE84ACjcxK6xIIjxv20xvE14v26w1j6s0DMIAIbVA2
        z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIAIbVA2z4x0Y4vEx4A2jsIE14v26r
        xl6s0DMIAIbVA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lV2xY62AIxVAIcxkEcVAq
        07x20xvEncxIr21lV2xY6c02F40EFcxC0VAKzVAqx4xG6I80ewCS07vEYx0E2Ix0cI8IcV
        AFwI0_Jr0_Jr4lV2xY6cIj6I8E87Iv67AKxVWUJVW8JwCS07vEOx8S6xCaFVCjc4AY6r1j
        6r4UMIAIbVACI402YVCY1x02628vn2kIc2xKxwCS07vE7I0Y64k_MIAIbVCY0x0Ix7I2Y4
        AK64vIr41lV2xY6xAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCS07vE4x8a6x804xWlV2xY
        6xC20s026xCaFVCjc4AY6r1j6r4UMIAIbVC20s026c02F40E14v26r1j6r18MIAIbVC20s
        026x8GjcxK67AKxVWUGVWUWwCS07vEx4CE17CEb7AF67AKxVWUtVW8ZwCS07vEIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCS07vEIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIAIbV
        CI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCS07vEIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        V2xY6IIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpBamF5LkthdGhhdEBtaWNyb2NoaXAuY29t5YaZ6YGT77yaCj4gVGhhbmtzIGZvciBzdWJtaXR0
aW5nIHRoZSBwYXRjaC4gVGhlIGNvZGUgY2hhbmdlcyBsb29rcyBva2F5IHRvIG1lLgo+IAo+IFRo
ZSBkcml2ZXIgaXMgbm93IG1vdmVkIG91dCBvZiBzdGFnaW5nIHNvICdzdGFnaW5nJyBwcmVmaXgg
aXMgbm90Cj4gcmVxdWlyZWQgaW4gc3ViamVjdC4gRm9yIGZ1dHVyZSBwYXRjaGVzIG9uIHdpbGMg
ZHJpdmVyLCB0aGUgJ3N0YWdpbmcnCj4gcHJlZml4IGNhbiBiZSByZW1vdmVkLgo+IAo+IEZvciB0
aGlzIHBhdGNoLCBJIGFtIG5vdCBzdXJlIGlmIEthbGxlIGNhbiBhcHBseSBhcyBpcyBvdGhlcndp
c2UgcGxlYXNlCj4gc3VibWl0IGEgcGF0Y2ggYnkgcmVtb3ZpbmcgJ3N0YWdpbmcnIGZyb20gc3Vi
amVjdCBzbyBpdCBjYW4gYmUgYXBwbGllZAo+IGRpcmVjdGx5Lgo+IAo+IFJlZ2FyZHMsCj4gQWph
eQo+IAoKVGhhbmtzIGZvciB5b3VyIGNvcnJlY3Rpb24uIEknbGwgc2VuZCBhIG5ldyBwYXRjaCBz
b29uLgoKUmVnYXJkcywKRGluZ2hhbwo=
