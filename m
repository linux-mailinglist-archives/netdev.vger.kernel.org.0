Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4BE5A0548
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiHYApU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiHYApT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:45:19 -0400
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8EB2162A93;
        Wed, 24 Aug 2022 17:45:16 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 25 Aug 2022 08:44:55
 +0800 (GMT+08:00)
X-Originating-IP: [218.12.16.111]
Date:   Thu, 25 Aug 2022 08:44:55 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Brian Norris" <briannorris@chromium.org>
Cc:     "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "amit karwar" <amitkarwar@gmail.com>,
        "Ganapathi Bhat" <ganapathi017@gmail.com>,
        "Sharvari Harisangam" <sharvari.harisangam@nxp.com>,
        "Xinming Hu" <huxinming820@gmail.com>, kvalo@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] Add new APIs of devcoredump and fix bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <CA+ASDXNf5JV9mj8mbm1OGZ_zd4d8srFc=E++Amg4MoQjqjS_TA@mail.gmail.com>
References: <cover.1661252818.git.duoming@zju.edu.cn>
 <CA+ASDXNf5JV9mj8mbm1OGZ_zd4d8srFc=E++Amg4MoQjqjS_TA@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <27a2a8a7.99f01.182d2758bc9.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgA3OMwIxgZjn4DhAw--.25954W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwNAVZdtbKGFwAAsf
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

SGVsbG8sCgpPbiBXZWQsIDI0IEF1ZyAyMDIyIDEzOjQyOjA5IC0wNzAwIEJyaWFuIE5vcnJpcyB3
cm90ZToKCj4gT24gVHVlLCBBdWcgMjMsIDIwMjIgYXQgNDoyMSBBTSBEdW9taW5nIFpob3UgPGR1
b21pbmdAemp1LmVkdS5jbj4gd3JvdGU6Cj4gPgo+ID4gVGhlIGZpcnN0IHBhdGNoIGFkZHMgbmV3
IEFQSXMgdG8gc3VwcG9ydCBtaWdyYXRpb24gb2YgdXNlcnMKPiA+IGZyb20gb2xkIGRldmljZSBj
b3JlZHVtcCByZWxhdGVkIEFQSXMuCj4gPgo+ID4gVGhlIHNlY29uZCBwYXRjaCBmaXggc2xlZXAg
aW4gYXRvbWljIGNvbnRleHQgYnVncyBvZiBtd2lmaWV4Cj4gPiBjYXVzZWQgYnkgZGV2X2NvcmVk
dW1wdigpLgo+ID4KPiA+IER1b21pbmcgWmhvdSAoMik6Cj4gPiAgIGRldmNvcmVkdW1wOiBhZGQg
bmV3IEFQSXMgdG8gc3VwcG9ydCBtaWdyYXRpb24gb2YgdXNlcnMgZnJvbSBvbGQKPiA+ICAgICBk
ZXZpY2UgY29yZWR1bXAgcmVsYXRlZCBBUElzCj4gPiAgIG13aWZpZXg6IGZpeCBzbGVlcCBpbiBh
dG9taWMgY29udGV4dCBidWdzIGNhdXNlZCBieSBkZXZfY29yZWR1bXB2Cj4gCj4gSSB3b3VsZCBo
YXZlIGV4cGVjdGVkIGEgdGhpcmQgcGF0Y2ggaW4gaGVyZSwgdGhhdCBhY3R1YWxseSBjb252ZXJ0
cwo+IGV4aXN0aW5nIHVzZXJzLiBUaGVuIGluIHRoZSBmb2xsb3dpbmcgcmVsZWFzZSBjeWNsZSwg
Y2xlYW4gdXAgYW55IG5ldwo+IHVzZXJzIG9mIHRoZSBvbGQgQVBJIHRoYXQgcG9wIHVwIGluIHRo
ZSBtZWFudGltZSBhbmQgZHJvcCB0aGUgb2xkIEFQSS4KPiAKPiBCdXQgSSdsbCBkZWZlciB0byB0
aGUgcGVvcGxlIHdobyB3b3VsZCBhY3R1YWxseSBiZSBtZXJnaW5nIHlvdXIgY29kZS4KPiBUZWNo
bmljYWxseSBpdCBjb3VsZCBhbHNvIHdvcmsgdG8gc2ltcGx5IHByb3ZpZGUgdGhlIEFQSSB0aGlz
IGN5Y2xlLAo+IGFuZCBjb252ZXJ0IGV2ZXJ5b25lIGluIHRoZSBuZXh0LgoKVGhhbmsgeW91ciBm
b3IgeW91ciB0aW1lIGFuZCByZXBseS4KCklmIHRoaXMgcGF0Y2ggc2V0IGlzIG1lcmdlZCBpbnRv
IHRoZSBsaW51eC1uZXh0IHRyZWUsIEkgd2lsbCBzZW5kIHRoZSAKdGhpcmQgcGF0Y2ggd2hpY2gg
dGFyZ2V0cyBhdCBsaW51eC1uZXh0IHRyZWUgYW5kIGNvbnZlcnRzIGV4aXN0aW5nIHVzZXJzIAph
dCBsYXRlciB0aW1lciBvZiB0aGlzIHJlbGVhc2UgY3ljbGUuIEJlY2F1c2UgdGhlcmUgYXJlIG5l
dyB1c2VycyB0aGF0IAptYXkgdXNlIHRoZSBvbGQgQVBJcyBjb21lcyBpbnRvIGxpbnV4LW5leHQg
dHJlZSBkdXJpbmcgdGhlIHJlbWFpbmluZyB0aW1lCm9mIHRoaXMgcmVsZWFzZSBjeWNsZS4KCkJl
c3QgcmVnYXJkcywKRHVvbWluZyBaaG91
