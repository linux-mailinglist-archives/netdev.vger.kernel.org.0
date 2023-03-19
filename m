Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D046C013E
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 13:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjCSMBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 08:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCSMBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 08:01:33 -0400
X-Greylist: delayed 1830 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Mar 2023 05:01:28 PDT
Received: from m1550.mail.126.com (m1550.mail.126.com [220.181.15.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8CCD158BA
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 05:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=kqgB9ANYp1U9Il55xhqT0/0a4YXjfFmuB0qefsJNr1Q=; b=P
        xE1gUinXovcl5+m6v726hUVRBR/MP3mRKmWOdjBvK6l1b38JC6dgweQHuOl/l/pG
        FD2xf5G0gl7IVeaEcjCRTIlMvk65dkfIuQavfJ88Ad5Eq63RDpZN4E67PxVGHQMi
        1c1JmYSq0+7Df6McgeRxH7EajWpKcTjKS8NQubmYhI=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr50
 (Coremail) ; Sun, 19 Mar 2023 19:30:30 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Sun, 19 Mar 2023 19:30:30 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re:Re: [PATCH] ethernet: sun: add check for the mdesc_grab()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 126com
In-Reply-To: <20230317222944.64f66377@kernel.org>
References: <20230315060021.1741151-1-windhl@126.com>
 <20230317222944.64f66377@kernel.org>
X-NTES-SC: AL_QuycC/6Zukwo5iWZZekXnkwQhu05Ucq4u/8l1YVVP5E0uCrj3QwyZ3h5HnL1//C0OQmWtx+MbgNs5stoWpZzdIk0abbXhFNEP0ukJx5Q6W2w
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <2ddbb6b4.1453.186f9a2a1f0.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: MsqowADXBVJX8hZkB1EfAA--.47529W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbiuBs3F2JVmgNN-gACsc
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkF0IDIwMjMtMDMtMTggMTM6Mjk6NDQsICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVsLm9y
Zz4gd3JvdGU6Cj5PbiBXZWQsIDE1IE1hciAyMDIzIDE0OjAwOjIxICswODAwIExpYW5nIEhlIHdy
b3RlOgo+PiAgCWhwID0gbWRlc2NfZ3JhYigpOwo+PiAgCj4+ICsJaWYgKCFocCkKPj4gKwkJcmV0
dXJuIC1FTk9ERVY7Cj4KPm5vIGVtcHR5IGxpbmUgYmV0d2VlbiB0aGUgZnVuY3Rpb24gY2FsbCBh
bmQgZXJyb3IgY2hlY2ssIHBsZWFzZQoKSGksIEpha3ViLAoKVGhhbmtzIHZlcnkgbXVjaCBmb3Ig
eW91ciByZXZpZXcgYW5kIHJlcGx5LgoKV2hpbGUgSSBoYXZlIGFscmVhZHkgcHJlcGFyZWQgdGhl
IG5ldyB2ZXJzaW9uIHBhdGNoLCAgbXkgbGFzdCBwYXRjaApoYXMgYmVlbiBSZXZpZXdlZC1ieSBQ
aW90ciBSYWN6eW5za2kgYW5kIGFwcGxpZWQgdG8gbmV0ZGV2L25ldC5naXQKYnkgRGF2aWQgUy5N
aWxsZXIuCgpTbyBzaG91bGQgSSBzZW5kIHRoZSBuZXcgcGF0Y2ggYWdhaW4/IAoKClRoYW5rcywK
CkxpYW5nCg==
