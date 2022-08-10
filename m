Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8FF58E9ED
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiHJJn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 05:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiHJJn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:43:57 -0400
X-Greylist: delayed 733 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Aug 2022 02:43:54 PDT
Received: from m13114.mail.163.com (m13114.mail.163.com [220.181.13.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D6375005F;
        Wed, 10 Aug 2022 02:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=2VIQQ
        95gk95C9WT9eCAq0QCaLRckhjSmiqdbBAKp79Q=; b=gj87QYmU3HkOFsQhtIVIE
        X9Jk7mdtV5neLx6LqoFnqCtD8uBNBY+9aQXrZYJ+LAygHdu9xp+P4ODH+uN6O8OK
        LVflaBwXtcF6hKv4MWiwxYSWSLN4D47Zub6pIYnKTbmvcDnDWFZKakJvxvgPJJc/
        fzI0cYnyvFbJA4ojwTGBkQ=
Received: from slark_xiao$163.com ( [112.97.48.210] ) by
 ajax-webmail-wmsvr114 (Coremail) ; Wed, 10 Aug 2022 17:41:22 +0800 (CST)
X-Originating-IP: [112.97.48.210]
Date:   Wed, 10 Aug 2022 17:41:22 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re:Re:Re: [PATCH] net: usb: qmi_wwan: Add support for Cinterion
 MV32
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <e7fdcfc.30e7.1828715d7af.Coremail.slark_xiao@163.com>
References: <20220810014521.9383-1-slark_xiao@163.com>
 <8735e4mvtd.fsf@miraculix.mork.no>
 <e7fdcfc.30e7.1828715d7af.Coremail.slark_xiao@163.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <61ca0e63.3207.18287214d7a.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: csGowAD3L9NCffNioYosAA--.32997W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBDRpZZFaEKSJ5BQABsO
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCkF0IDIwMjItMDgtMTAgMTc6Mjg6NTEsICJTbGFyayBYaWFvIiA8c2xhcmtfeGlhb0AxNjMu
Y29tPiB3cm90ZToKPkF0IDIwMjItMDgtMTAgMTQ6NTU6NDIsICJCasO4cm4gTW9yayIgPGJqb3Ju
QG1vcmsubm8+IHdyb3RlOgo+PlNsYXJrIFhpYW8gPHNsYXJrX3hpYW9AMTYzLmNvbT4gd3JpdGVz
Ogo+Pgo+Pj4gVGhlcmUgYXJlIDIgbW9kZWxzIGZvciBNVjMyIHNlcmlhbHMuIE1WMzItVy1BIGlz
IGRlc2lnbmVkCj4+PiBiYXNlZCBvbiBRdWFsY29tbSBTRFg2MiBjaGlwLCBhbmQgTVYzMi1XLUIg
aXMgZGVzaWduZWQgYmFzZWQKPj4+IG9uIFF1YWxjb21tIFNEWDY1IGNoaXAuIFNvIHdlIHVzZSAy
IGRpZmZlcmVudCBQSUQgdG8gc2VwYXJhdGUgaXQuCj4+Pgo+Pj4gVGVzdCBldmlkZW5jZSBhcyBi
ZWxvdzoKPj4+IFQ6ICBCdXM9MDMgTGV2PTAxIFBybnQ9MDEgUG9ydD0wMiBDbnQ9MDMgRGV2Iz0g
IDMgU3BkPTQ4MCBNeENoPSAwCj4+PiBEOiAgVmVyPSAyLjEwIENscz1lZihtaXNjICkgU3ViPTAy
IFByb3Q9MDEgTXhQUz02NCAjQ2Zncz0gIDEKPj4+IFA6ICBWZW5kb3I9MWUyZCBQcm9kSUQ9MDBm
MyBSZXY9MDUuMDQKPj4+IFM6ICBNYW51ZmFjdHVyZXI9Q2ludGVyaW9uCj4+PiBTOiAgUHJvZHVj
dD1DaW50ZXJpb24gUElEIDB4MDBGMyBVU0IgTW9iaWxlIEJyb2FkYmFuZAo+Pj4gUzogIFNlcmlh
bE51bWJlcj1kN2I0YmU4ZAo+Pj4gQzogICNJZnM9IDQgQ2ZnIz0gMSBBdHI9YTAgTXhQd3I9NTAw
bUEKPj4+IEk6ICBJZiM9MHgwIEFsdD0gMCAjRVBzPSAzIENscz1mZih2ZW5kLikgU3ViPWZmIFBy
b3Q9NTAgRHJpdmVyPXFtaV93d2FuCj4+PiBJOiAgSWYjPTB4MSBBbHQ9IDAgI0VQcz0gMyBDbHM9
ZmYodmVuZC4pIFN1Yj1mZiBQcm90PTQwIERyaXZlcj1vcHRpb24KPj4+IEk6ICBJZiM9MHgyIEFs
dD0gMCAjRVBzPSAzIENscz1mZih2ZW5kLikgU3ViPWZmIFByb3Q9NDAgRHJpdmVyPW9wdGlvbgo+
Pj4gSTogIElmIz0weDMgQWx0PSAwICNFUHM9IDIgQ2xzPWZmKHZlbmQuKSBTdWI9ZmYgUHJvdD0z
MCBEcml2ZXI9b3B0aW9uCj4+Cj4+VGhlIHBhdGNoIGxvb2tzIG5pY2UsIGJ1dCBJIGhhdmUgYSBj
b3VwbGUgb2YgcXVlc3Rpb25zIHNpbmNlIHlvdSdyZSBvbmUKPj5vZiB0aGUgZmlyc3QgcHVzaGlu
ZyBvbmUgb2YgdGhlc2UgU0RYNnggbW9kZW1zLgo+Pgo+PklzIHRoYXQgcHJvdG9jb2wgcGF0dGVy
biBmaXhlZCBvbiB0aGlzIGdlbmVyYXRpb24gb2YgUXVhbGNvbW0gY2hpcHM/ICBJdAo+Pmxvb2tz
IGxpa2UgYW4gZXh0ZW5zaW9uIG9mIHdoYXQgdGhleSBzdGFydGVkIHdpdGggdGhlIFNEWDU1IGdl
bmVyYXRpb24sCj4+d2hlcmUgdGhlIERJQUcgcG9ydCB3YXMgaWRlbnRpZmllZCBieSBmZi9mZi8z
MCBhY3Jvc3MgbXVsdGlwbGUgdmVuZG9ycy4KPj4KPiBTZWVtcyB5ZXMuIEkgY2hlY2tlZCBzb21l
IGRpZmZlcmVudCB1c2JfY29tcG9zaXRpb25zIGFuZCBmb3VuZCB0aGF0Cj4gZGlhZyBwb3J0IGlz
IHVzaW5nIHByb3RvY29sICczMCcgYWx3YXlzLgo+Cj4+U3BlY2lmaWNhbGx5IHdydCB0aGlzIGRy
aXZlciBhbmQgcGF0Y2gsIEkgd29uZGVyIGlmIHdlIGNhbi9zaG91bGQgbWF0Y2gKPj5vbiBmZi9m
Zi81MCBpbnN0ZWFkIG9mIGludGVyZmFjZSBudW1iZXIgaGVyZT8gIEkgbm90ZSB0aGF0IHRoZSBp
bnRlcmZhY2UKPgo+SSBjaGVja2VkIGFsbCBvdXIgZWRpdGVkIHVzYl9jb21wb3NpdGlvbnMgYW5k
IGFsbCBRQyBkZWZhdWx0IHVzYiAKPmNvbXBvc2l0aW9ucyg5MDI1LCA5MGRiLCA5MDY3LDkwZDUs
OTA4NCw5MDkxLDkwYWQsOTBiOCw5MGU1KSwgCj5mZi9mZi81MCBpcyBybW5ldCB1c2VkIG9ubHku
IAo+Cj4+bnVtYmVycyBhcmUgYWxsb2NhdGVkIHNlcXVlbnRpb25hbGx5LiBQcm9iYWJseSBpbiB0
aGUgb3JkZXIgdGhlc2UKPj5mdW5jdGlvbiBhcmUgZW5hYmxlZCBieSB0aGUgZmlybXdhcmU/IElm
IHNvLCBhcmUgd2Ugc3VyZSB0aGlzIGlzIHN0YXRpYz8KPgo+VGhpcyBuZWVkcyBtb3JlIHRpbWUg
dG8gY29uZmlybS4gSSB3aWxsIGtlZXAgeW91IHVwZGF0ZWQuCj4KPj5PciBjb3VsZCB3ZSByaXNr
IGNvbmZpZyB2YXJpYW50cyB3aGVyZSB0aGUgUk1ORVQvUU1JIGZ1bmN0aW9uIGhhdmUgYQo+PmRp
ZmZlcmVudCBpbnRlcmZhY2UgbnVtYmVyIGZvciB0aGUgc2FtZSBQSURzPwo+Pgo+PkFuZCBhbm90
aGVyIHBvc3NpYmlsaXR5IHlvdSBtaWdodCBjb25zaWRlci4gIEFzc3VtaW5nIHRoYXQgZmYvZmYv
NTAKPj51bmlxdWVseSBpZGVudGlmaWVzIFJNTkVUL1FNSSBmdW5jdGlvbnMgcmVnYXJkbGVzcyBv
ZiBQSUQsIHdvdWxkIHlvdQo+PmNvbnNpZGVyIGEgVklEK2NsYXNzIG1hdGNoIHRvIGNhdGNoIGFs
bCBvZiB0aGVtPyAgVGhpcyB3b3VsZCBub3Qgb25seQo+PnN1cHBvcnQgYm90aCB0aGUgUElEcyBv
ZiB0aGlzIHBhdGNoIGluIG9uZSBnbywgYnV0IGFsc28gYW55IGZ1dHVyZSBQSURzCj4+d2l0aG91
dCB0aGUgbmVlZCBmb3IgZnVydGhlciBkcml2ZXIgcGF0Y2hlcy4KPj4KPj4KPj5CasO4cm4KPgo+
SSBoYXZlIGEgY29uY2VybiwgaWYgQ2ludGVyaW9uIG9yIG90aGVyIFZlbmRvcnMsIGxpa2UgUXVl
Y3RlbCwgdXNlIG90aGVyIAo+Y2hpcCAoc3VjaCBhcyBpbnRlbCwgbWVkaWF0ZWNrIGFuZCBzbyBv
biksIHRoaXMgbWV0aG9kcyBtYXkgd29uJ3Qgd29yaywKCk15IGJhZC4gUU1JX1dXQU4gZHJpdmVy
IGlzIGRlc2lnbmVkIGZvciBRdWFsY29tbSBiYXNlZCBjaGlwcyBvbmx5LArCoHJpZ2h0PyAKCj5i
ZWNhdXNlICB0aGV5IHNoYXJlIGEgc2FtZSBWSUQuIEFsc28gdGhpcyBtYXkgYmUgY2hhbmdlZCBv
bmNlIFF1YWxjb21tIAo+dXBkYXRlIHRoZSBwcm90b2NvbCBwYXR0ZXJucyBmb3IgZnV0dXJlIGNo
aXAuCgoK
