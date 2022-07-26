Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C67E580A0F
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 05:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiGZDlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 23:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiGZDk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 23:40:59 -0400
Received: from m1364.mail.163.com (m1364.mail.163.com [220.181.13.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B403286E1;
        Mon, 25 Jul 2022 20:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=flpUe
        m58YAoTcXJ82LuX06om1ZuFHuEYfDcGpRXmvoc=; b=I1OEeQK6ml3iekdysux4v
        5sY3F/sj2+6eJC0sLN+cYhCMKMCx7RBLq8hpgISEovwhr4Bidli4uNiaWtB1KMX1
        dYlTsCJrAxP1warPhei8zX8cKQvqIiIBzuco5nKHOAg76S41uiYqnGY5O7GdmY1B
        xDxRGAxsGnh0hXUdGBQfyI=
Received: from slark_xiao$163.com ( [223.104.68.106] ) by
 ajax-webmail-wmsvr64 (Coremail) ; Tue, 26 Jul 2022 11:40:13 +0800 (CST)
X-Originating-IP: [223.104.68.106]
Date:   Tue, 26 Jul 2022 11:40:13 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, loic.poulain@linaro.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: Re:Re:Re: [PATCH] wireless: ath: Fix typo 'the the' in comment
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <3621f4e.e19.18238585e4a.Coremail.slark_xiao@163.com>
References: <20220722082653.74553-1-slark_xiao@163.com>
 <165874719705.30937.12813347117072714125.kvalo@kernel.org>
 <3621f4e.e19.18238585e4a.Coremail.slark_xiao@163.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <4f9a54ad.1551.1823897425b.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: QMGowAD3Ei8dYt9iey4sAA--.43141W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBDQZKZFaEKEuXawABsp
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCgoKCgoKCgoKCgoKCkF0IDIwMjItMDctMjYgMTA6MzE6MzEsICJTbGFyayBYaWFvIiA8c2xh
cmtfeGlhb0AxNjMuY29tPiB3cm90ZToKPgo+Cj4KPgo+Cj4KPgo+Cj4KPgo+Cj4KPgo+Cj4KPgo+
QXQgMjAyMi0wNy0yNSAxOTowNjo1MCwgIkthbGxlIFZhbG8iIDxrdmFsb0BrZXJuZWwub3JnPiB3
cm90ZToKPj5TbGFyayBYaWFvIDxzbGFya194aWFvQDE2My5jb20+IHdyb3RlOgo+Pgo+Pj4gUmVw
bGFjZSAndGhlIHRoZScgd2l0aCAndGhlJyBpbiB0aGUgY29tbWVudC4KPj4+IAo+Pj4gU2lnbmVk
LW9mZi1ieTogU2xhcmsgWGlhbyA8c2xhcmtfeGlhb0AxNjMuY29tPgo+Pgo+PkZhaWxzIHRvIGFw
cGx5LCBwbGVhc2UgcmViYXNlIG9uIHRvcCBteSBhdGguZ2l0IG1hc3RlciBicmFuY2guCj4+Cj4+
ZXJyb3I6IHBhdGNoIGZhaWxlZDogZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDZrbC9oaWYu
aDo5Mgo+PmVycm9yOiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL2hpZi5oOiBwYXRj
aCBkb2VzIG5vdCBhcHBseQo+PmVycm9yOiBwYXRjaCBmYWlsZWQ6IGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg2a2wvc2Rpby5jOjExODUKPj5lcnJvcjogZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YXRoL2F0aDZrbC9zZGlvLmM6IHBhdGNoIGRvZXMgbm90IGFwcGx5Cj4+ZXJyb3I6IHBhdGNoIGZh
aWxlZDogZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL3djbjM2eHgvaGFsLmg6NDE0Mgo+PmVycm9y
OiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvd2NuMzZ4eC9oYWwuaDogcGF0Y2ggZG9lcyBub3Qg
YXBwbHkKPj5zdGcgaW1wb3J0OiBEaWZmIGRvZXMgbm90IGFwcGx5IGNsZWFubHkKPj4KPj5QYXRj
aCBzZXQgdG8gQ2hhbmdlcyBSZXF1ZXN0ZWQuCj4+Cj4+LS0gCj4+aHR0cHM6Ly9wYXRjaHdvcmsu
a2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LXdpcmVsZXNzL3BhdGNoLzIwMjIwNzIyMDgyNjUzLjc0
NTUzLTEtc2xhcmtfeGlhb0AxNjMuY29tLwo+Pgo+Pmh0dHBzOi8vd2lyZWxlc3Mud2lraS5rZXJu
ZWwub3JnL2VuL2RldmVsb3BlcnMvZG9jdW1lbnRhdGlvbi9zdWJtaXR0aW5ncGF0Y2hlcwo+Cj5C
YWQgbmV3cywgSSBjYW4ndCBnZXQgeW91ciBhdGggY29kZSBjb21wbGV0ZWx5LiAKPnVidW50dUBW
TS0wLTI3LXVidW50dTp+L2F0aCQgITE0Mgo+Z2l0IGNsb25lIGdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9rdmFsby9hdGguZ2l0Cj5DbG9uaW5nIGludG8gJ2F0
aCcuLi4KPnJlbW90ZTogRW51bWVyYXRpbmcgb2JqZWN0czogMjAyLCBkb25lLgo+cmVtb3RlOiBD
b3VudGluZyBvYmplY3RzOiAxMDAlICgyMDIvMjAyKSwgZG9uZS4KPnJlbW90ZTogQ29tcHJlc3Np
bmcgb2JqZWN0czogMTAwJSAoODMvODMpLCBkb25lLgo+UmVjZWl2aW5nIG9iamVjdHM6IDEwMCUg
KDg4OTc2MDYvODg5NzYwNiksIDIuNDcgR2lCIHwgMTEuOTkgTWlCL3MsIGRvbmUuCj5yZW1vdGU6
IFRvdGFsIDg4OTc2MDYgKGRlbHRhIDE1MCksIHJldXNlZCAxMzMgKGRlbHRhIDExOSksIHBhY2st
cmV1c2VkIDg4OTc0MDQKPmVycm9yOiBpbmRleC1wYWNrIGRpZWQgb2Ygc2lnbmFsIDk4NDAwMCkK
PmZhdGFsOiBpbmRleC1wYWNrIGZhaWxlZAo+Cj51YnVudHVAVk0tMC0yNy11YnVudHU6fi9hdGgk
IGdpdCBjbG9uZSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9rdmFsby9hdGguZ2l0Cj5DbG9uaW5nIGludG8gJ2F0aCcuLi4KPnJlbW90ZTogRW51bWVyYXRp
bmcgb2JqZWN0czogMjAyLCBkb25lLgo+cmVtb3RlOiBDb3VudGluZyBvYmplY3RzOiAxMDAlICgy
MDIvMjAyKSwgZG9uZS4KPnJlbW90ZTogQ29tcHJlc3Npbmcgb2JqZWN0czogMTAwJSAoODMvODMp
LCBkb25lLgo+cmVtb3RlOiBUb3RhbCA4ODk3NjA2IChkZWx0YSAxNTApLCByZXVzZWQgMTMzIChk
ZWx0YSAxMTkpLCBwYWNrLXJldXNlZCA4ODk3NDA0Cj5SZWNlaXZpbmcgb2JqZWN0czogMTAwJSAo
ODg5NzYwNi84ODk3NjA2KSwgMi40NyBHaUIgfCAxMS44OCBNaUIvcywgZG9uZS4KPmVycm9yOiBp
bmRleC1wYWNrIGRpZWQgb2Ygc2lnbmFsIDk4NDAwMCkKPmZhdGFsOiBpbmRleC1wYWNrIGZhaWxl
ZAo+Cj51YnVudHVAVk0tMC0yNy11YnVudHU6fi9hdGgkIGdpdCBjbG9uZSBodHRwczovL2tlcm5l
bC5nb29nbGVzb3VyY2UuY29tL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9rdmFsby9hdGguZ2l0
Cj5DbG9uaW5nIGludG8gJ2F0aCcuLi4KPnJlbW90ZTogU2VuZGluZyBhcHByb3hpbWF0ZWx5IDEu
NjcgR2lCIC4uLgo+cmVtb3RlOiBDb3VudGluZyBvYmplY3RzOiAyOTMyMywgZG9uZQo+cmVtb3Rl
OiBGaW5kaW5nIHNvdXJjZXM6IDEwMCUgKDg4OTc2MDYvODg5NzYwNikKPnJlbW90ZTogVG90YWwg
ODg5NzYwNiAoZGVsdGEgNzUyNDA3MyksIHJldXNlZCA4ODk3MDQ0IChkZWx0YSA3NTI0MDczKQo+
UmVjZWl2aW5nIG9iamVjdHM6IDEwMCUgKDg4OTc2MDYvODg5NzYwNiksIDEuNjcgR2lCIHwgMTEu
OTggTWlCL3MsIGRvbmUuCj5lcnJvcjogaW5kZXgtcGFjayBkaWVkIG9mIHNpZ25hbCA5NDA3MykK
PmZhdGFsOiBpbmRleC1wYWNrIGZhaWxlZAo+Cj5JIHRyaWVkIHRoZXNlIDMgc2VydmVycyBidXQg
YWxsIGZhaWxlZC4gQW55IG90aGVyIGlkZWFzPwoKSSBmaXggaXQgYnkgYWRkaW5nIHZpcnR1YWwg
bWVtb3J5IGluIG15IFZNLiBBbmQgdmVyc2lvbiB2MiBoYXMgYmVlbiBzZW50IGZvciB0aGlzIGNo
YW5nZXMuClNlZW1zIHNvbWUgZmlsZXMgaGFzIGJlZW4gZml4ZWQgYWxyZWFkeS4gCgpUaGFua3MK

