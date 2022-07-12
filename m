Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA12B5711FF
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 07:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiGLFwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 01:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGLFwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 01:52:53 -0400
Received: from m1550.mail.126.com (m1550.mail.126.com [220.181.15.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63C4992878
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 22:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=0bPDV
        3AUEjVmJt+8L/jdfcS/RqfC7rz2wrwQEguWzMI=; b=O4n4lZ2BG8ejUMkdiAXrZ
        w0+p/GXOdrWHPqTKEmRi7MM+t7Dq+r4pvjFmalu+OwtACCfIQ8WUPKvr0aWTEh4m
        t8UpUOT2SxzCJaSp99wA3F0VVxu556DFZv9+/KVaOo63yZKsKN5mK8LKox+mxdNg
        pBg/Y5uXguXWOUYQqz3XU4=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr50
 (Coremail) ; Tue, 12 Jul 2022 13:51:54 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Tue, 12 Jul 2022 13:51:54 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re:Re: [PATCH v2] net: ftgmac100: Hold reference returned by
 of_get_child_by_name()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220711195807.4f4749ef@kernel.org>
References: <20220710020728.317086-1-windhl@126.com>
 <20220711195807.4f4749ef@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <74791252.3504.181f0f6cb6a.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: MsqowABHnfH7C81iEMNHAA--.457W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGgE8F1-HZe3Y-gABsH
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCkF0IDIwMjItMDctMTIgMTA6NTg6MDcsICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVs
Lm9yZz4gd3JvdGU6Cj5PbiBTdW4sIDEwIEp1bCAyMDIyIDEwOjA3OjI4ICswODAwIExpYW5nIEhl
IHdyb3RlOgo+PiArc3RhdGljIGlubGluZSBzdHJ1Y3QgZGV2aWNlX25vZGUgKmZ0Z21hYzEwMF9o
YXNfY2hpbGRfbm9kZShzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wLCBjb25zdCBjaGFyICpuYW1lKQo+
PiArewo+PiArCXN0cnVjdCBkZXZpY2Vfbm9kZSAqY2hpbGRfbnAgPSBvZl9nZXRfY2hpbGRfYnlf
bmFtZShucCwgIm1kaW8iKTsKPj4gKwo+PiArCW9mX25vZGVfcHV0KGNoaWxkX25wKTsKPj4gKwo+
PiArCXJldHVybiBjaGlsZF9ucDsKPgo+Q291bGQgeW91IG1ha2UgdGhlIHJldHVybiB0eXBlIGJv
b2wgPyBXZSBkb24ndCBoYXZlIGEgcmVmZXJlbmNlIG9uIAo+dGhlIGNoaWxkX25vIG5vZGUsIHdl
IHNob3VsZCBwcm9iYWJseSBub3QgcmV0dXJuIHRoZSBwb2ludGVyLgo+Cj5BbHNvIHRoZSAiaW5s
aW5lIiBrZXl3b3JkIGlzIHVubmVjZXNzYXJ5IHRoZSBjb21waWxlciB3aWxsIGlubGluZSAKPmEg
c21hbGwsIHN0YXRpYyBmdW5jdGlvbiB3aXRoIGEgc2luZ2xlIGNhbGxlciwgYW55d2F5LgoKVGhh
bmtzLCBJIHdpbGwgcHJlcGFyZSB0aGUgbmV3IHZlcnNpb24gcGF0Y2guCgo=
