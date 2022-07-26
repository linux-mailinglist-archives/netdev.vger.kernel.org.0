Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380C458097F
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbiGZCda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiGZCd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:33:29 -0400
Received: from m1364.mail.163.com (m1364.mail.163.com [220.181.13.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C52B3248DF;
        Mon, 25 Jul 2022 19:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=pLrtd
        kcwQvHdPJ+naDCEI5KTFs+cLRhwjAVaN1b8C9c=; b=VeIurJIwT4PFZjMIocgaU
        k4X81NE07pGEB7QdhqFPEhwSVFbKrqXfeqRGFn9x/ne75YRJOSAJAodA1q7aXPP5
        t3MSHdQOSSy5JGjyp0Q160XG1fyi8No76J11yZ05WxLA7U8ENhIfn/t7Pm3Tw695
        PwxPUxKHhI4CFZ3jhXL7Ho=
Received: from slark_xiao$163.com ( [223.104.68.106] ) by
 ajax-webmail-wmsvr64 (Coremail) ; Tue, 26 Jul 2022 10:31:31 +0800 (CST)
X-Originating-IP: [223.104.68.106]
Date:   Tue, 26 Jul 2022 10:31:31 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, loic.poulain@linaro.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: Re:Re: [PATCH] wireless: ath: Fix typo 'the the' in comment
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <165874719705.30937.12813347117072714125.kvalo@kernel.org>
References: <20220722082653.74553-1-slark_xiao@163.com>
 <165874719705.30937.12813347117072714125.kvalo@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <3621f4e.e19.18238585e4a.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: QMGowABXei4DUt9iJSEsAA--.42339W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBAw1KZGB0LrMXJQAAsb
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCgoKCgoKCgoKCgoKCkF0IDIwMjItMDctMjUgMTk6MDY6NTAsICJLYWxsZSBWYWxvIiA8a3Zh
bG9Aa2VybmVsLm9yZz4gd3JvdGU6Cj5TbGFyayBYaWFvIDxzbGFya194aWFvQDE2My5jb20+IHdy
b3RlOgo+Cj4+IFJlcGxhY2UgJ3RoZSB0aGUnIHdpdGggJ3RoZScgaW4gdGhlIGNvbW1lbnQuCj4+
IAo+PiBTaWduZWQtb2ZmLWJ5OiBTbGFyayBYaWFvIDxzbGFya194aWFvQDE2My5jb20+Cj4KPkZh
aWxzIHRvIGFwcGx5LCBwbGVhc2UgcmViYXNlIG9uIHRvcCBteSBhdGguZ2l0IG1hc3RlciBicmFu
Y2guCj4KPmVycm9yOiBwYXRjaCBmYWlsZWQ6IGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg2
a2wvaGlmLmg6OTIKPmVycm9yOiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL2hpZi5o
OiBwYXRjaCBkb2VzIG5vdCBhcHBseQo+ZXJyb3I6IHBhdGNoIGZhaWxlZDogZHJpdmVycy9uZXQv
d2lyZWxlc3MvYXRoL2F0aDZrbC9zZGlvLmM6MTE4NQo+ZXJyb3I6IGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg2a2wvc2Rpby5jOiBwYXRjaCBkb2VzIG5vdCBhcHBseQo+ZXJyb3I6IHBhdGNo
IGZhaWxlZDogZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL3djbjM2eHgvaGFsLmg6NDE0Mgo+ZXJy
b3I6IGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC93Y24zNnh4L2hhbC5oOiBwYXRjaCBkb2VzIG5v
dCBhcHBseQo+c3RnIGltcG9ydDogRGlmZiBkb2VzIG5vdCBhcHBseSBjbGVhbmx5Cj4KPlBhdGNo
IHNldCB0byBDaGFuZ2VzIFJlcXVlc3RlZC4KPgo+LS0gCj5odHRwczovL3BhdGNod29yay5rZXJu
ZWwub3JnL3Byb2plY3QvbGludXgtd2lyZWxlc3MvcGF0Y2gvMjAyMjA3MjIwODI2NTMuNzQ1NTMt
MS1zbGFya194aWFvQDE2My5jb20vCj4KPmh0dHBzOi8vd2lyZWxlc3Mud2lraS5rZXJuZWwub3Jn
L2VuL2RldmVsb3BlcnMvZG9jdW1lbnRhdGlvbi9zdWJtaXR0aW5ncGF0Y2hlcwoKQmFkIG5ld3Ms
IEkgY2FuJ3QgZ2V0IHlvdXIgYXRoIGNvZGUgY29tcGxldGVseS4gCnVidW50dUBWTS0wLTI3LXVi
dW50dTp+L2F0aCQgITE0MgpnaXQgY2xvbmUgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L2t2YWxvL2F0aC5naXQKQ2xvbmluZyBpbnRvICdhdGgnLi4uCnJlbW90
ZTogRW51bWVyYXRpbmcgb2JqZWN0czogMjAyLCBkb25lLgpyZW1vdGU6IENvdW50aW5nIG9iamVj
dHM6IDEwMCUgKDIwMi8yMDIpLCBkb25lLgpyZW1vdGU6IENvbXByZXNzaW5nIG9iamVjdHM6IDEw
MCUgKDgzLzgzKSwgZG9uZS4KUmVjZWl2aW5nIG9iamVjdHM6IDEwMCUgKDg4OTc2MDYvODg5NzYw
NiksIDIuNDcgR2lCIHwgMTEuOTkgTWlCL3MsIGRvbmUuCnJlbW90ZTogVG90YWwgODg5NzYwNiAo
ZGVsdGEgMTUwKSwgcmV1c2VkIDEzMyAoZGVsdGEgMTE5KSwgcGFjay1yZXVzZWQgODg5NzQwNApl
cnJvcjogaW5kZXgtcGFjayBkaWVkIG9mIHNpZ25hbCA5ODQwMDApCmZhdGFsOiBpbmRleC1wYWNr
IGZhaWxlZAoKdWJ1bnR1QFZNLTAtMjctdWJ1bnR1On4vYXRoJCBnaXQgY2xvbmUgaHR0cHM6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva3ZhbG8vYXRoLmdpdApDbG9u
aW5nIGludG8gJ2F0aCcuLi4KcmVtb3RlOiBFbnVtZXJhdGluZyBvYmplY3RzOiAyMDIsIGRvbmUu
CnJlbW90ZTogQ291bnRpbmcgb2JqZWN0czogMTAwJSAoMjAyLzIwMiksIGRvbmUuCnJlbW90ZTog
Q29tcHJlc3Npbmcgb2JqZWN0czogMTAwJSAoODMvODMpLCBkb25lLgpyZW1vdGU6IFRvdGFsIDg4
OTc2MDYgKGRlbHRhIDE1MCksIHJldXNlZCAxMzMgKGRlbHRhIDExOSksIHBhY2stcmV1c2VkIDg4
OTc0MDQKUmVjZWl2aW5nIG9iamVjdHM6IDEwMCUgKDg4OTc2MDYvODg5NzYwNiksIDIuNDcgR2lC
IHwgMTEuODggTWlCL3MsIGRvbmUuCmVycm9yOiBpbmRleC1wYWNrIGRpZWQgb2Ygc2lnbmFsIDk4
NDAwMCkKZmF0YWw6IGluZGV4LXBhY2sgZmFpbGVkCgp1YnVudHVAVk0tMC0yNy11YnVudHU6fi9h
dGgkIGdpdCBjbG9uZSBodHRwczovL2tlcm5lbC5nb29nbGVzb3VyY2UuY29tL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9rdmFsby9hdGguZ2l0CkNsb25pbmcgaW50byAnYXRoJy4uLgpyZW1vdGU6
IFNlbmRpbmcgYXBwcm94aW1hdGVseSAxLjY3IEdpQiAuLi4KcmVtb3RlOiBDb3VudGluZyBvYmpl
Y3RzOiAyOTMyMywgZG9uZQpyZW1vdGU6IEZpbmRpbmcgc291cmNlczogMTAwJSAoODg5NzYwNi84
ODk3NjA2KQpyZW1vdGU6IFRvdGFsIDg4OTc2MDYgKGRlbHRhIDc1MjQwNzMpLCByZXVzZWQgODg5
NzA0NCAoZGVsdGEgNzUyNDA3MykKUmVjZWl2aW5nIG9iamVjdHM6IDEwMCUgKDg4OTc2MDYvODg5
NzYwNiksIDEuNjcgR2lCIHwgMTEuOTggTWlCL3MsIGRvbmUuCmVycm9yOiBpbmRleC1wYWNrIGRp
ZWQgb2Ygc2lnbmFsIDk0MDczKQpmYXRhbDogaW5kZXgtcGFjayBmYWlsZWQKCkkgdHJpZWQgdGhl
c2UgMyBzZXJ2ZXJzIGJ1dCBhbGwgZmFpbGVkLiBBbnkgb3RoZXIgaWRlYXM/Cg==
