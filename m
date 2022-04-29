Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3940C51410B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 05:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbiD2DUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 23:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiD2DUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 23:20:51 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCB38506E5;
        Thu, 28 Apr 2022 20:17:31 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Fri, 29 Apr 2022 11:17:19
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.2.40]
Date:   Fri, 29 Apr 2022 11:17:19 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     "Duoming Zhou" <duoming@zju.edu.cn>,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: Re: [PATCH net v4] nfc: ... device_is_registered() is data
 race-able
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <YmqgxNkXVetmrtde@kroah.com>
References: <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
 <YmpEZQ7EnOIWlsy8@kroah.com>
 <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
 <YmpNZOaJ1+vWdccK@kroah.com>
 <15d09db2.2f76.1806f5c4187.Coremail.linma@zju.edu.cn>
 <YmpcUNf7O+OK6/Ax@kroah.com> <20220428060628.713479b2@kernel.org>
 <f51aa1.41ae.180705614b5.Coremail.linma@zju.edu.cn>
 <YmqYgu++0OuhfFxy@kroah.com>
 <6ad27014.42f6.1807072bb39.Coremail.linma@zju.edu.cn>
 <YmqgxNkXVetmrtde@kroah.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2060fc1.5388.1807352ac69.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: cS_KCgDnzkW_WGtiRdkFAg--.10358W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwMOElNG3GhjUwAHsK
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gdGhlcmUsCgo+IAo+IFRoYXQgaXMgd2hhdCBwcm9wZXIgcmVmZXJlbmNlIGNvdW50aW5n
IGlzIHN1cHBvc2VkIHRvIGJlIGZvci4gIFBlcmhhcHMKPiB5b3UgYXJlIHJ1bm5pbmcgaW50byBh
IGRyaXZlciBzdWJzeXN0ZW0gdGhhdCBpcyBub3QgZG9pbmcgdGhhdCB3ZWxsLCBvcgo+IGF0IGFs
bD8KPiAKPiBUcnkgYWRkaW5nIHRoZSBuZWVkZWQgcmVmZXJlbmNlcyBhbmQgdGhlIHVzZS1hZnRl
ci1mcmVlIHNob3VsZCBhbG1vc3QgYmUKPiBpbXBvc3NpYmxlIHRvIGhhcHBlbi4KPiAKClRoYXQn
cyB0cnVlLCBpZiBhbGwgdGhlIHJlbGV2YW50IHJlc291cmNlcyBhcmUgbWFuYWdlZCBwcm9wZXJs
eSBieSB0aGUgcmVmZXJlbmNlCmNvdW50LCBldmVyeXRoaW5nIHdpbGwgYmUgZWFzaWVyLgoKPiB0
aGFua3MsCj4gCj4gZ3JlZyBrLWgKClRoYW5rcwpMaW4gTWEKCg==
