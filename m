Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4BC56976B
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiGGB3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbiGGB3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:29:02 -0400
Received: from m1564.mail.126.com (m1564.mail.126.com [220.181.15.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 967C32E691
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 18:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=YDZAz
        PAcaIprSkku2lXRjWLcpGgxEZcO6MeVEZKsFN0=; b=YEL4OodqwfkjIrLPGiOPP
        Fe+Sw3U/6GERE9c26lqtR0B1IxRAgvR14uJlvbTF0M7OMI8c5IaCJ8RxC2ayfEGR
        VWw9SBT/pJuTfybCAQ3bX4AdJoxTfJNbd1OkUNCdGcPy+6uDhWWRY3eXl/rOCKes
        i622AIp6khyLiEKDAi2aeE=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr64
 (Coremail) ; Thu, 7 Jul 2022 09:28:34 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Thu, 7 Jul 2022 09:28:34 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re:Re: [PATCH] ftgmac100: Hold reference returned by
 of_get_child_by_name()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220706093459.2885de93@kernel.org>
References: <20220704151819.279513-1-windhl@126.com>
 <20220705184805.2619caca@kernel.org>
 <41ae7b8e.5fda.181d2b8d4ff.Coremail.windhl@126.com>
 <20220706093459.2885de93@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <585084ab.1002.181d645e69b.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: QMqowACXpnLCNsZikfVGAA--.53458W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbiuBU3F2JVkPxrugABsG
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKQXQgMjAyMi0wNy0wNyAwMDozNDo1OSwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwu
b3JnPiB3cm90ZToKPk9uIFdlZCwgNiBKdWwgMjAyMiAxNjo1NTozNyArMDgwMCAoQ1NUKSBMaWFu
ZyBIZSB3cm90ZToKPj4gPlNpbmNlIHdlIGRvbid0IGNhcmUgYWJvdXQgdGhlIHZhbHVlIG9mIHRo
ZSBub2RlIHdlIHNob3VsZCBhZGQgYSBoZWxwZXIKPj4gPndoaWNoIGNoZWNrcyBmb3IgcHJlc2Vu
Y2Ugb2YgdGhlIG5vZGUgYW5kIHJlbGVhc2VzIHRoZSByZWZlcmVuY2UsCj4+ID5yYXRoZXIgdGhh
biBoYXZlIHRvIGRvIHRoYXQgaW4gdGhpcyBsYXJnZSBmdW5jdGlvbi4KPj4gPgo+PiA+UGxlYXNl
IGFsc28gYWRkIGEgRml4ZXMgdGFnLiAgCj4+IAo+PiBIaSwgSmFrdWIsCj4+IAo+PiBDYW4geW91
IHRlbGwgbWUgd2hlcmUgdG8gYWRkIHN1Y2ggaGVscGVyPwo+PiAKPj4geW91IG1lYW4gYWRkIGEg
aGVscGVyIGluIG9mLmggZm9yIGNvbW1vbiB1c2FzZ2Ugb3IganVzdCBhZGQgaXQgaW4gdGhpcyBm
aWxlPwo+Cj5JIHdhcyB3b25kZXJpbmcgYWJvdXQgdGhhdC4gU2luY2UgdGhpcyBpcyBhIGZpeCBs
ZXQncyBrZWVwIGl0IHNpbXBsZQo+YW5kIGFkZCB0aGUgaGVscGVyIGRpcmVjdGx5IGluIHRoZSBz
YW1lIHNvdXJjZSBmaWxlLgo+CgpUaGFua3MsIEkgd2lsbCBmaXJzdCBtYWtlIGEgcXVpY2sgcGF0
Y2ggZm9yIHRoaXMgYnVnLgoKCj5JZiB5b3UgaGF2ZSBtb3JlIHRpbWUgdG8gc3BlbmQgb24gdGhp
cyB0cnkgc2VhcmNoaW5nIGFyb3VuZCB0aGUgdHJlZSB0bwo+c2VlIGlmIHRoZXJlIGFyZSBtb3Jl
IHBsYWNlcyB3aGVyZSBzdWNoIGhlbHBlciB3b3VsZCBoZWxwLiBJZiB0aGVyZSBhcmUKPndlIGNh
biBtb3ZlIHRoZSBoZWxwZXIgdG8gb2YuaCBhbmQgY29udmVydCB0aGUgdXNlcnMgaW4gLW5leHQu
CgpZZXMsIEkgaGF2ZSBmb3VuZCBtYW55IHNpbWlsYXIgYnVncyBhbmQgc2VudCBtYW55IHNpbWls
YXIgcGF0Y2hlcywgSSB3b3VsZCBsaWtlIAp0cnkgdG8gbWFrZSBhIGNvbW1vbiBoZWxwZXIgaW4g
b2YuaC4KClRoYW5rcywgCgpMaWFuZwo=
