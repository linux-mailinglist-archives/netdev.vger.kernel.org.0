Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB82458F8D7
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiHKIID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbiHKIH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:07:59 -0400
Received: from m13129.mail.163.com (m13129.mail.163.com [220.181.13.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6705790190;
        Thu, 11 Aug 2022 01:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=DqL70
        9qGTyMTAS88M8XemPiyKQgYQ9IwBJHmTNCyxig=; b=MT8L0AC1vo7FWiGkNWg+Y
        WW/aSxswah+eSJVATmHNMbZRdOttIbmyF4+ANdmQvcLtndeYrWhsx0iAVXLT6TJP
        eBlCNWyqrVBcAfi+iWVFn4Qvn5q/5bq8hiPnwAuoJsrSgtyz0jORQgQ73Cit2I8t
        RDrOEuZogJAPdwHTISy9vE=
Received: from slark_xiao$163.com ( [223.104.66.109] ) by
 ajax-webmail-wmsvr129 (Coremail) ; Thu, 11 Aug 2022 16:07:06 +0800 (CST)
X-Originating-IP: [223.104.66.109]
Date:   Thu, 11 Aug 2022 16:07:06 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV32
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <87mtccl1ir.fsf@miraculix.mork.no>
References: <20220810014521.9383-1-slark_xiao@163.com>
 <8735e4mvtd.fsf@miraculix.mork.no>
 <e7fdcfc.30e7.1828715d7af.Coremail.slark_xiao@163.com>
 <61ca0e63.3207.18287214d7a.Coremail.slark_xiao@163.com>
 <87mtccl1ir.fsf@miraculix.mork.no>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <6775a759.2696.1828bf15897.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: gcGowAD3FpOquPRid3smAA--.1559W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbCdQ5aZGBbEtQVOwABsX
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCgoKCgoKCgoKCgoKCkF0IDIwMjItMDgtMTAgMjA6MzU6MjQsICJCasO4cm4gTW9yayIgPGJq
b3JuQG1vcmsubm8+IHdyb3RlOgo+IlNsYXJrIFhpYW8iIDxzbGFya194aWFvQDE2My5jb20+IHdy
aXRlczoKPj4gQXQgMjAyMi0wOC0xMCAxNzoyODo1MSwgIlNsYXJrIFhpYW8iIDxzbGFya194aWFv
QDE2My5jb20+IHdyb3RlOgo+Pgo+Pj5JIGhhdmUgYSBjb25jZXJuLCBpZiBDaW50ZXJpb24gb3Ig
b3RoZXIgVmVuZG9ycywgbGlrZSBRdWVjdGVsLCB1c2Ugb3RoZXIgCj4+PmNoaXAgKHN1Y2ggYXMg
aW50ZWwsIG1lZGlhdGVjayBhbmQgc28gb24pLCB0aGlzIG1ldGhvZHMgbWF5IHdvbid0IHdvcmss
Cj4+Cj4+IE15IGJhZC4gUU1JX1dXQU4gZHJpdmVyIGlzIGRlc2lnbmVkIGZvciBRdWFsY29tbSBi
YXNlZCBjaGlwcyBvbmx5LAo+PiDCoHJpZ2h0PyAKPgo+WWVzLCBidXQgeW91ciBjb25jZXJuIGlz
IHN0aWxsIHZhbGlkIGlmIGFueSBvZiB0aGVtIHJlLXVzZSBmZi9mZi81MCBmb3IKPnNvbWV0aGlu
ZyB3aGljaCBpcyBub3QgUk1ORVQvUU1JLiAgV2UgZG8gbm90IHdhbnQgdGhpcyBkcml2ZXIgdG8g
c3RhcnQKPm1hdGNoaW5nIGEgbm9uLVF1YWxjb21tIGJhc2VkIGRldmljZS4KPgo+Pj5iZWNhdXNl
ICB0aGV5IHNoYXJlIGEgc2FtZSBWSUQuIEFsc28gdGhpcyBtYXkgYmUgY2hhbmdlZCBvbmNlIFF1
YWxjb21tIAo+Pj51cGRhdGUgdGhlIHByb3RvY29sIHBhdHRlcm5zIGZvciBmdXR1cmUgY2hpcC4K
Pgo+WWVzLCB0aGF0JyBhIHJpc2sgc2luY2Ugd2UgaGF2ZSBubyBrbm93bGVkZ2Ugb2YgUXVhbGNv
bW0ncyBwbGFucyBvcgo+dGhvdWdodHMgYXJvdW5kIHRoaXMuIEl0J3MgYWxsIHB1cmUgZ3Vlc3N3
b3JrIGZyb20gbXkgc2lkZS4gIEJ1dCBhcwo+c3VjaCwgaXQgZG9lc24ndCBkaWZmZXIgZnJvbSB0
aGUgcmVzdCBvZiB0aGlzIGRyaXZlciA6LSkgUXVhbGNvbW0gY2FuCj5jaGFuZ2Ugd2hhdGV2ZXIg
dGhleSB3YW50IGFuZCB3ZSdsbCBqdXN0IGhhdmUgdG8gZm9sbG93IHVwIHdpdGggd2hhdGV2ZXIK
PmlzIHJlcXVpcmVkLiBMaWtlIHdoYXQgaGFwcGVuZWQgd2hlbiByYXctaXAgYmVjYW1lIG1hbmRh
dG9yeS4KPgo+SSBkbyBmaW5kIGl0IHVubGlrZWx5IHRoYXQgUXVhbGNvbW0gd2lsbCBldmVyIGNo
YW5nZSB0aGUgbWVhbmluZyBvZiB0aGlzCj5wYXR0ZXJuIG5vdyB0aGF0IHRoZXkndmUgc3RhcnRl
ZCB1c2luZyBpdC4gIFRoYXQgd291bGQgbm90IG1ha2UgYW55Cj5zZW5zZS4gSWYgdGhleSBuZWVk
IHRvIGNyZWF0ZSBhIG5ldyB2ZW5kb3Igc3BlY2lmaWMgZnVuY3Rpb24gdHlwZSwgdGhlbgo+dGhl
eSBjYW4ganVzdCB1c2Ugb25lIG9mIHRoZSAiZnJlZSIgcHJvdG9jb2wgbnVtYmVycyAoYW5kIGFs
c28gc3ViY2xhc3MKPmlmIHRoZXkgcnVuIG91dCBvZiBwcm90b2NvbCBudW1iZXJzKS4KPgo+QnV0
IGl0J3MgeW91ciBjYWxsLiAgSWYgeW91IHdhbnQgdG8gcGxheSBpdCBzYWZlIGFuZCBrZWVwIHRo
ZSBWSUQrUElECj5tYXRjaGluZywgdGhlbiBJJ20gZmluZSB3aXRoIHRoYXQgdG9vLgo+Cj4KPkJq
w7hybgoKVGhlbiBwbGVhc2UgaGVscCBtZSBhcHBseSBpdCBkaXJlY3RseS4gVGhlcmUgaXMgbm8g
bW9yZSBjb21taXQgCnJlcXVlc3QgZm9yIE1WMzIgc2VyaWFscyBpZiB0aGV5IGRvbid0IHVwZGF0
ZSBiYXNlIGxpbmUuCgpUaGFua3MuCg==
