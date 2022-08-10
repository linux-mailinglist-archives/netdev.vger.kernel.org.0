Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCBB58E9A7
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbiHJJbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 05:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiHJJbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:31:44 -0400
Received: from m13114.mail.163.com (m13114.mail.163.com [220.181.13.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD55C6B17E;
        Wed, 10 Aug 2022 02:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=FryoR
        m8qpMRZLvSSer5jc0v+pkFjWZPVOxn3ZzDbYKI=; b=Qcaadhu4KilUZ30mBk9f3
        W61jbN0r328GpeBmJSMSCCr1FN1bYaqFSDlSqRrcdM5Et47JDwHwu+E84UzRWxzt
        Rmlvt0mSzaf0+azEknTGQUWo6g1Wa4orS8WsUbfmyXB+qDr01O+ySKPyU6GKSsR5
        WGAieDadViqaLLRspsG1FQ=
Received: from slark_xiao$163.com ( [112.97.48.210] ) by
 ajax-webmail-wmsvr114 (Coremail) ; Wed, 10 Aug 2022 17:28:51 +0800 (CST)
X-Originating-IP: [112.97.48.210]
Date:   Wed, 10 Aug 2022 17:28:51 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV32
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <8735e4mvtd.fsf@miraculix.mork.no>
References: <20220810014521.9383-1-slark_xiao@163.com>
 <8735e4mvtd.fsf@miraculix.mork.no>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <e7fdcfc.30e7.1828715d7af.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: csGowACHv9JTevNihIgsAA--.29964W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBDQJZZFaEKSJRGQABsi
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCgoKCgoKCgoKCgoKCkF0IDIwMjItMDgtMTAgMTQ6NTU6NDIsICJCasO4cm4gTW9yayIgPGJq
b3JuQG1vcmsubm8+IHdyb3RlOgo+U2xhcmsgWGlhbyA8c2xhcmtfeGlhb0AxNjMuY29tPiB3cml0
ZXM6Cj4KPj4gVGhlcmUgYXJlIDIgbW9kZWxzIGZvciBNVjMyIHNlcmlhbHMuIE1WMzItVy1BIGlz
IGRlc2lnbmVkCj4+IGJhc2VkIG9uIFF1YWxjb21tIFNEWDYyIGNoaXAsIGFuZCBNVjMyLVctQiBp
cyBkZXNpZ25lZCBiYXNlZAo+PiBvbiBRdWFsY29tbSBTRFg2NSBjaGlwLiBTbyB3ZSB1c2UgMiBk
aWZmZXJlbnQgUElEIHRvIHNlcGFyYXRlIGl0Lgo+Pgo+PiBUZXN0IGV2aWRlbmNlIGFzIGJlbG93
Ogo+PiBUOiAgQnVzPTAzIExldj0wMSBQcm50PTAxIFBvcnQ9MDIgQ250PTAzIERldiM9ICAzIFNw
ZD00ODAgTXhDaD0gMAo+PiBEOiAgVmVyPSAyLjEwIENscz1lZihtaXNjICkgU3ViPTAyIFByb3Q9
MDEgTXhQUz02NCAjQ2Zncz0gIDEKPj4gUDogIFZlbmRvcj0xZTJkIFByb2RJRD0wMGYzIFJldj0w
NS4wNAo+PiBTOiAgTWFudWZhY3R1cmVyPUNpbnRlcmlvbgo+PiBTOiAgUHJvZHVjdD1DaW50ZXJp
b24gUElEIDB4MDBGMyBVU0IgTW9iaWxlIEJyb2FkYmFuZAo+PiBTOiAgU2VyaWFsTnVtYmVyPWQ3
YjRiZThkCj4+IEM6ICAjSWZzPSA0IENmZyM9IDEgQXRyPWEwIE14UHdyPTUwMG1BCj4+IEk6ICBJ
ZiM9MHgwIEFsdD0gMCAjRVBzPSAzIENscz1mZih2ZW5kLikgU3ViPWZmIFByb3Q9NTAgRHJpdmVy
PXFtaV93d2FuCj4+IEk6ICBJZiM9MHgxIEFsdD0gMCAjRVBzPSAzIENscz1mZih2ZW5kLikgU3Vi
PWZmIFByb3Q9NDAgRHJpdmVyPW9wdGlvbgo+PiBJOiAgSWYjPTB4MiBBbHQ9IDAgI0VQcz0gMyBD
bHM9ZmYodmVuZC4pIFN1Yj1mZiBQcm90PTQwIERyaXZlcj1vcHRpb24KPj4gSTogIElmIz0weDMg
QWx0PSAwICNFUHM9IDIgQ2xzPWZmKHZlbmQuKSBTdWI9ZmYgUHJvdD0zMCBEcml2ZXI9b3B0aW9u
Cj4KPlRoZSBwYXRjaCBsb29rcyBuaWNlLCBidXQgSSBoYXZlIGEgY291cGxlIG9mIHF1ZXN0aW9u
cyBzaW5jZSB5b3UncmUgb25lCj5vZiB0aGUgZmlyc3QgcHVzaGluZyBvbmUgb2YgdGhlc2UgU0RY
NnggbW9kZW1zLgo+Cj5JcyB0aGF0IHByb3RvY29sIHBhdHRlcm4gZml4ZWQgb24gdGhpcyBnZW5l
cmF0aW9uIG9mIFF1YWxjb21tIGNoaXBzPyAgSXQKPmxvb2tzIGxpa2UgYW4gZXh0ZW5zaW9uIG9m
IHdoYXQgdGhleSBzdGFydGVkIHdpdGggdGhlIFNEWDU1IGdlbmVyYXRpb24sCj53aGVyZSB0aGUg
RElBRyBwb3J0IHdhcyBpZGVudGlmaWVkIGJ5IGZmL2ZmLzMwIGFjcm9zcyBtdWx0aXBsZSB2ZW5k
b3JzLgo+CiBTZWVtcyB5ZXMuIEkgY2hlY2tlZCBzb21lIGRpZmZlcmVudCB1c2JfY29tcG9zaXRp
b25zIGFuZCBmb3VuZCB0aGF0CiBkaWFnIHBvcnQgaXMgdXNpbmcgcHJvdG9jb2wgJzMwJyBhbHdh
eXMuCgo+U3BlY2lmaWNhbGx5IHdydCB0aGlzIGRyaXZlciBhbmQgcGF0Y2gsIEkgd29uZGVyIGlm
IHdlIGNhbi9zaG91bGQgbWF0Y2gKPm9uIGZmL2ZmLzUwIGluc3RlYWQgb2YgaW50ZXJmYWNlIG51
bWJlciBoZXJlPyAgSSBub3RlIHRoYXQgdGhlIGludGVyZmFjZQoKSSBjaGVja2VkIGFsbCBvdXIg
ZWRpdGVkIHVzYl9jb21wb3NpdGlvbnMgYW5kIGFsbCBRQyBkZWZhdWx0IHVzYiAKY29tcG9zaXRp
b25zKDkwMjUsIDkwZGIsIDkwNjcsOTBkNSw5MDg0LDkwOTEsOTBhZCw5MGI4LDkwZTUpLCAKZmYv
ZmYvNTAgaXMgcm1uZXQgdXNlZCBvbmx5LiAKCj5udW1iZXJzIGFyZSBhbGxvY2F0ZWQgc2VxdWVu
dGlvbmFsbHkuIFByb2JhYmx5IGluIHRoZSBvcmRlciB0aGVzZQo+ZnVuY3Rpb24gYXJlIGVuYWJs
ZWQgYnkgdGhlIGZpcm13YXJlPyBJZiBzbywgYXJlIHdlIHN1cmUgdGhpcyBpcyBzdGF0aWM/CgpU
aGlzIG5lZWRzIG1vcmUgdGltZSB0byBjb25maXJtLiBJIHdpbGwga2VlcCB5b3UgdXBkYXRlZC4K
Cj5PciBjb3VsZCB3ZSByaXNrIGNvbmZpZyB2YXJpYW50cyB3aGVyZSB0aGUgUk1ORVQvUU1JIGZ1
bmN0aW9uIGhhdmUgYQo+ZGlmZmVyZW50IGludGVyZmFjZSBudW1iZXIgZm9yIHRoZSBzYW1lIFBJ
RHM/Cj4KPkFuZCBhbm90aGVyIHBvc3NpYmlsaXR5IHlvdSBtaWdodCBjb25zaWRlci4gIEFzc3Vt
aW5nIHRoYXQgZmYvZmYvNTAKPnVuaXF1ZWx5IGlkZW50aWZpZXMgUk1ORVQvUU1JIGZ1bmN0aW9u
cyByZWdhcmRsZXNzIG9mIFBJRCwgd291bGQgeW91Cj5jb25zaWRlciBhIFZJRCtjbGFzcyBtYXRj
aCB0byBjYXRjaCBhbGwgb2YgdGhlbT8gIFRoaXMgd291bGQgbm90IG9ubHkKPnN1cHBvcnQgYm90
aCB0aGUgUElEcyBvZiB0aGlzIHBhdGNoIGluIG9uZSBnbywgYnV0IGFsc28gYW55IGZ1dHVyZSBQ
SURzCj53aXRob3V0IHRoZSBuZWVkIGZvciBmdXJ0aGVyIGRyaXZlciBwYXRjaGVzLgo+Cj4KPkJq
w7hybgoKSSBoYXZlIGEgY29uY2VybiwgaWYgQ2ludGVyaW9uIG9yIG90aGVyIFZlbmRvcnMsIGxp
a2UgUXVlY3RlbCwgdXNlIG90aGVyIApjaGlwIChzdWNoIGFzIGludGVsLCBtZWRpYXRlY2sgYW5k
IHNvIG9uKSwgdGhpcyBtZXRob2RzIG1heSB3b24ndCB3b3JrLApiZWNhdXNlICB0aGV5IHNoYXJl
IGEgc2FtZSBWSUQuIEFsc28gdGhpcyBtYXkgYmUgY2hhbmdlZCBvbmNlIFF1YWxjb21tIAp1cGRh
dGUgdGhlIHByb3RvY29sIHBhdHRlcm5zIGZvciBmdXR1cmUgY2hpcC4=
