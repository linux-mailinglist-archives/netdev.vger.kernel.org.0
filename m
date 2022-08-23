Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EF759E507
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242631AbiHWOSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241876AbiHWOS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:18:27 -0400
Received: from zg8tmtyylji0my4xnjqunzqa.icoremail.net (zg8tmtyylji0my4xnjqunzqa.icoremail.net [162.243.164.74])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id F0976204976;
        Tue, 23 Aug 2022 04:32:33 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Tue, 23 Aug 2022 19:26:34
 +0800 (GMT+08:00)
X-Originating-IP: [218.12.19.15]
Date:   Tue, 23 Aug 2022 19:26:34 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Brian Norris" <briannorris@chromium.org>
Cc:     "Greg KH" <gregkh@linuxfoundation.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "amit karwar" <amitkarwar@gmail.com>,
        "Ganapathi Bhat" <ganapathi017@gmail.com>,
        "Sharvari Harisangam" <sharvari.harisangam@nxp.com>,
        "Xinming Hu" <huxinming820@gmail.com>, kvalo@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v7 1/2] devcoredump: remove the useless gfp_t parameter
 in dev_coredumpv and dev_coredumpm
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <CA+ASDXNN81VczMTUt8=AyeytbMjy2vAGi_aVW_MNha9D99Z5VA@mail.gmail.com>
References: <cover.1660739276.git.duoming@zju.edu.cn>
 <b861ce56ba555109a67f85a146a785a69f0a3c95.1660739276.git.duoming@zju.edu.cn>
 <YvzicURy8t2JdQke@kroah.com>
 <176e7de7.8a223.182ac1fbc47.Coremail.duoming@zju.edu.cn>
 <Yv5TefZcrUPY1Qjc@kroah.com>
 <5108e03b.8c156.182b1a2973f.Coremail.duoming@zju.edu.cn>
 <CA+ASDXNN81VczMTUt8=AyeytbMjy2vAGi_aVW_MNha9D99Z5VA@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <7f94efe8.90d97.182ca7446e2.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgD3_6tquQRj087PAw--.56628W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgULAVZdtbI0NQAZsZ
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBNb24sIDIyIEF1ZyAyMDIyIDExOjIxOjM2IC0wNzAwIEJyaWFuIE5vcnJpcyB3
cm90ZToKCj4gSGksCj4gCj4gT24gVGh1LCBBdWcgMTgsIDIwMjIgYXQgODo0NyBBTSA8ZHVvbWlu
Z0B6anUuZWR1LmNuPiB3cm90ZToKPiA+IE9uIFRodSwgMTggQXVnIDIwMjIgMTY6NTg6MDEgKzAy
MDAgR3JlZyBLSCB3cm90ZToKPiA+ID4gTm8sIHRoYXQgaXMgbm90IG5lY2Vzc2FyeS4gIERvIHRo
ZSB3b3JrIG5vdyBzbyB0aGF0IHRoZXJlIGlzIG5vIGZsYWcgZGF5Cj4gPiA+IGFuZCB5b3UgZG9u
J3QgaGF2ZSB0byB3b3JyeSBhYm91dCBuZXcgdXNlcnMsIGl0IHdpbGwgYWxsICJqdXN0IHdvcmsi
Lgo+ID4KPiA+IERvIHlvdSBtZWFuIHdlIHNob3VsZCByZXBsYWNlIGRldl9zZXRfbmFtZSgpIGlu
IGRldl9jb3JlZHVtcG0oKSB0byBzb21lIG90aGVyCj4gPiBmdW5jdGlvbnMgdGhhdCBjb3VsZCB3
b3JrIGJvdGggaW4gaW50ZXJydXB0IGNvbnRleHQgYW5kIHByb2Nlc3MgY29udGV4dD8KPiAKPiBO
by4KPiAKPiBJIGJlbGlldmUgdGhlIHN1Z2dlc3Rpb24gaXMgdGhhdCByYXRoZXIgdGhhbiBjaGFu
Z2UgdGhlIHNpZ25hdHVyZSBmb3IKPiBkZXZfY29yZWR1bXB2KCkgKHdoaWNoIG1lYW5zIGV2ZXJ5
b25lIGhhcyB0byBhZ3JlZSBvbiB0aGUgbmV3Cj4gc2lnbmF0dXJlIG9uIGRheSAxKSwgeW91IHNo
b3VsZCBpbnRyb2R1Y2UgYSBuZXcgQVBJLCBsaWtlCj4gZGV2X2NvcmVkdW1wdl9ub2F0b21pYygp
IChJJ20gbm90IGdvb2QgYXQgbmFtaW5nIFsxXSkgd2l0aCB0aGUKPiBzaWduYXR1cmUgeW91IHdh
bnQsIGFuZCB0aGVuIG1pZ3JhdGUgdXNlcnMgb3Zlci4gT25jZSB3ZSBoYXZlIGEKPiByZWxlYXNl
IHdpdGggbm8gdXNlcnMgb2YgdGhlIG9sZCBBUEksIHdlIGRyb3AgaXQuCj4gCj4gVGhlcmUgYXJl
IHBsZW50eSBvZiBleGFtcGxlcyBvZiB0aGUga2VybmVsIGNvbW11bml0eSBkb2luZyBzaW1pbGFy
Cj4gdHJhbnNpdGlvbnMuIFlvdSBjYW4gc2VhcmNoIGFyb3VuZCBmb3IgZXhhbXBsZXMsIGJ1dCBh
IHF1aWNrIHNlYXJjaCBvZgo+IG15IG93biBzaG93cyBzb21ldGhpbmcgbGlrZSB0aGlzOgo+IGh0
dHBzOi8vbHduLm5ldC9BcnRpY2xlcy83MzU4ODcvCj4gKEluIHBhcnRpY3VsYXIsIHRpbWVyX3Nl
dHVwKCkgd2FzIGludHJvZHVjZWQsIGFuZCBhbGwgc2V0dXBfdGltZXIoKQo+IHVzZXJzIHdlcmUg
bWlncmF0ZWQgdG8gaXQgd2l0aGluIGEgcmVsZWFzZSBvciB0d28uKQo+IAo+IEJyaWFuCj4gCj4g
WzFdIFNlcmlvdXNseSwgZGV2X2NvcmVkdW1wdl9ub2F0b21pYygpIGlzIG5vdCBhIG5hbWUgSSB3
YW50IHRvIHNlZQo+IGxhc3QgdmVyeSBsb25nLiBNYXliZSBzb21lIG90aGVyIHRyaXZpYWwgbW9k
aWZpY2F0aW9uPyBFeGFtcGxlczoKPiAKPiBkZXZfY29yZV9kdW1wdigpCj4gZGV2X2NvcmVkdW1w
X3YoKQo+IGRldmljZV9jb3JlZHVtcHYoKQo+IC4uLgoKVGhhbmsgeW91IHZlcnkgbXVjaCBmb3Ig
eW91ciB0aW1lciBhbmQgc3VnZ2VzdGlvbnMhCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQ==

