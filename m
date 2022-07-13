Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFBA573AC0
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 18:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbiGMQCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 12:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbiGMQCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 12:02:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530F32C67F
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 09:02:16 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id l15-20020a17090a660f00b001ef7b1d2289so1725761pjj.9
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 09:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=cm98YvOI0JVwHRgtxdPzjRwoN4rAWAaFiXFBicNxcF4=;
        b=ilweiSzegv/uYYdkRr7XqXjEsyze2YSLGsE2rjVqlgqFAKmQu2EaUKrLJ3Imfp+d1Z
         9uJ2IqgGd1oQvKpsQJ71VhE6F5dwmYsBra8z5m9aUm+DdMRJaFPkdsd6zf42hcYA/1PC
         tR2RxvWR8mz7vKXzoK291Pcvqn3nKRLxy+9RddJTrKl2dz7wISUjAReGD7dTkey3RtKs
         meDsnxnTJwIhLZxKU0erEJWbPIC00zEUebAXqNowAn+rAsfJPrde00/bg5Q8Drmx6Hvz
         l5jSeIC18J7Wy5+CbSAnrszx7lbVspFQT1VUzfbwnGs88Doqp+lPzJLU+t1QzSb+p0V1
         hVNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=cm98YvOI0JVwHRgtxdPzjRwoN4rAWAaFiXFBicNxcF4=;
        b=sgwkPvYjznO4GQ+ZBU4qpAoM8vutKP1G3mTiAiDONhesevI3ImsXeaHCkAMNhzPNE3
         x0D6NXaxm+7RAtacgPpyP37N+Ic0f0x16xLZm0egE5PQyC/efCDDl//AlCMSQF54X8+4
         FVQGe+Wbyk6KPoEdQ1Gk95ysRhUSckMt0D3pCnSpusN1fP9hAFFQ2EznHWGMGcgtY9AD
         Pnqu2OdXxcWv3h6SB8c/z2bZnUlB3RvU6ArtE+zjNTaO/TEiaCb7kdrTDrVbmsQXxR49
         joHqyDw9zziVFdfWfYkCEO74GJvznZXfNfv3uIkpNGeImHV+gg4xxk3kVS0N90CrssAT
         s1Ig==
X-Gm-Message-State: AJIora+FuYPzdpoI+algnMxQ6KcK8b6Yy9ei2XVREpz2hCE8s2y1ntKh
        pfoK0Ykh8NHkAva1jUpiV20tEHI=
X-Google-Smtp-Source: AGRyM1ugDPMwzK2ACOlAiKiDodZOvWVYM95K9gUCEtIMT0cJTFW1/GqDtZcN5//8Vm3WwYyxMmnun10=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:ba04:b0:1ee:e6b0:edff with SMTP id
 s4-20020a17090aba0400b001eee6b0edffmr4500522pjr.153.1657728135859; Wed, 13
 Jul 2022 09:02:15 -0700 (PDT)
Date:   Wed, 13 Jul 2022 09:02:14 -0700
In-Reply-To: <d7f22715be8d477cbc3e6e545c219048@huawei.com>
Message-Id: <Ys7shru6xUa/9XwY@google.com>
Mime-Version: 1.0
References: <20220712120158.56325-1-shaozhengchao@huawei.com>
 <Ys2oPzt7Yn1oMou8@google.com> <f0bf3e9a-15e6-f5c8-1b2a-7866acfcb71b@iogearbox.net>
 <d7f22715be8d477cbc3e6e545c219048@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQw==?= =?utf-8?Q?H?= bpf-next] bpf:
 Don't redirect packets with invalid pkt_len
From:   sdf@google.com
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "song@kernel.org" <song@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDcvMTMsIHNoYW96aGVuZ2NoYW8gd3JvdGU6DQoNCg0KPiAtLS0tLemCruS7tuWOn+S7ti0t
LS0tDQo+IOWPkeS7tuS6ujogRGFuaWVsIEJvcmttYW5uIFttYWlsdG86ZGFuaWVsQGlvZ2VhcmJv
eC5uZXRdDQo+IOWPkemAgeaXtumXtDogMjAyMuW5tDfmnIgxM+aXpSA0OjEyDQo+IOaUtuS7tuS6
ujogc2RmQGdvb2dsZS5jb207IHNoYW96aGVuZ2NoYW8gPHNoYW96aGVuZ2NoYW9AaHVhd2VpLmNv
bT4NCj4g5oqE6YCBOiBicGZAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyAgDQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
IGVkdW1hemV0QGdvb2dsZS5jb207ICANCj4ga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0
LmNvbTsgaGF3a0BrZXJuZWwub3JnOyBhc3RAa2VybmVsLm9yZzsgIA0KPiBhbmRyaWlAa2VybmVs
Lm9yZzsgbWFydGluLmxhdUBsaW51eC5kZXY7IHNvbmdAa2VybmVsLm9yZzsgeWhzQGZiLmNvbTsg
IA0KPiBqb2huLmZhc3RhYmVuZEBnbWFpbC5jb207IGtwc2luZ2hAa2VybmVsLm9yZzsgd2VpeW9u
Z2p1biAoQSkgIA0KPiA8d2VpeW9uZ2p1bjFAaHVhd2VpLmNvbT47IHl1ZWhhaWJpbmcgPHl1ZWhh
aWJpbmdAaHVhd2VpLmNvbT4NCj4g5Li76aKYOiBSZTogW1BBVENIIGJwZi1uZXh0XSBicGY6IERv
bid0IHJlZGlyZWN0IHBhY2tldHMgd2l0aCBpbnZhbGlkICANCj4gcGt0X2xlbg0KDQo+IE9uIDcv
MTIvMjIgNjo1OCBQTSwgc2RmQGdvb2dsZS5jb20gd3JvdGU6DQo+ID4gT24gMDcvMTIsIFpoZW5n
Y2hhbyBTaGFvIHdyb3RlOg0KPiA+PiBTeXpib3QgZm91bmQgYW4gaXNzdWUgWzFdOiBmcV9jb2Rl
bF9kcm9wKCkgdHJ5IHRvIGRyb3AgYSBmbG93IHdoaXRvdXQNCj4gPj4gYW55IHNrYnMsIHRoYXQg
aXMsIHRoZSBmbG93LT5oZWFkIGlzIG51bGwuDQo+ID4+IFRoZSByb290IGNhdXNlLCBhcyB0aGUg
WzJdIHNheXMsIGlzIGJlY2F1c2UgdGhhdA0KPiA+PiBicGZfcHJvZ190ZXN0X3J1bl9za2IoKSBy
dW4gYSBicGYgcHJvZyB3aGljaCByZWRpcmVjdHMgZW1wdHkgc2ticy4NCj4gPj4gU28gd2Ugc2hv
dWxkIGRldGVybWluZSB3aGV0aGVyIHRoZSBsZW5ndGggb2YgdGhlIHBhY2tldCBtb2RpZmllZCBi
eQ0KPiA+PiBicGYgcHJvZyBvciBvdGhlcnMgbGlrZSBicGZfcHJvZ190ZXN0IGlzIHZhbGlkIGJl
Zm9yZSBmb3J3YXJkaW5nIGl0ICANCj4gZGlyZWN0bHkuDQo+ID4NCj4gPj4gTElOSzogWzFdDQo+
ID4+IGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29tL2J1Zz9pZD0wYjg0ZGE4MGMyOTE3NzU3
OTE1YWZhODlmNzczOGE5ZA0KPiA+PiAxNmVjOTZjNQ0KPiA+PiBMSU5LOiBbMl0gaHR0cHM6Ly93
d3cuc3Bpbmljcy5uZXQvbGlzdHMvbmV0ZGV2L21zZzc3NzUwMy5odG1sDQo+ID4NCj4gPj4gUmVw
b3J0ZWQtYnk6IHN5emJvdCs3YTEyOTA5NDg1Yjk0NDI2YWNlYkBzeXprYWxsZXIuYXBwc3BvdG1h
aWwuY29tDQo+ID4+IFNpZ25lZC1vZmYtYnk6IFpoZW5nY2hhbyBTaGFvIDxzaGFvemhlbmdjaGFv
QGh1YXdlaS5jb20+DQo+ID4+IC0tLQ0KPiA+PiDCoCBuZXQvY29yZS9maWx0ZXIuYyB8IDkgKysr
KysrKystDQo+ID4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCj4gPg0KPiA+PiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZmlsdGVyLmMgYi9uZXQvY29y
ZS9maWx0ZXIuYyBpbmRleA0KPiA+PiA0ZWY3N2VjNTI1NWUuLjI3ODAxYjMxNDk2MCAxMDA2NDQN
Cj4gPj4gLS0tIGEvbmV0L2NvcmUvZmlsdGVyLmMNCj4gPj4gKysrIGIvbmV0L2NvcmUvZmlsdGVy
LmMNCj4gPj4gQEAgLTIxMjIsNiArMjEyMiwxMSBAQCBzdGF0aWMgaW50IF9fYnBmX3JlZGlyZWN0
X25vX21hYyhzdHJ1Y3QNCj4gPj4gc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2
LA0KPiA+PiDCoCB7DQo+ID4+IMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IG1sZW4gPSBza2JfbmV0
d29ya19vZmZzZXQoc2tiKTsNCj4gPg0KPiA+PiArwqDCoMKgIGlmICh1bmxpa2VseShza2ItPmxl
biA9PSAwKSkgew0KPiA+PiArwqDCoMKgwqDCoMKgwqAga2ZyZWVfc2tiKHNrYik7DQo+ID4+ICvC
oMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsNCj4gPj4gK8KgwqDCoCB9DQo+ID4+ICsNCj4g
Pj4gwqDCoMKgwqDCoCBpZiAobWxlbikgew0KPiA+PiDCoMKgwqDCoMKgwqDCoMKgwqAgX19za2Jf
cHVsbChza2IsIG1sZW4pOw0KPiA+DQo+ID4+IEBAIC0yMTQzLDcgKzIxNDgsOSBAQCBzdGF0aWMg
aW50IF9fYnBmX3JlZGlyZWN0X2NvbW1vbihzdHJ1Y3Qgc2tfYnVmZg0KPiA+PiAqc2tiLCBzdHJ1
Y3QgbmV0X2RldmljZSAqZGV2LA0KPiA+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdTMyIGZsYWdzKQ0KPiA+PiDCoCB7DQo+ID4+IMKgwqDCoMKgwqAgLyogVmVyaWZ5IHRo
YXQgYSBsaW5rIGxheWVyIGhlYWRlciBpcyBjYXJyaWVkICovDQo+ID4+IC3CoMKgwqAgaWYgKHVu
bGlrZWx5KHNrYi0+bWFjX2hlYWRlciA+PSBza2ItPm5ldHdvcmtfaGVhZGVyKSkgew0KPiA+PiAr
wqDCoMKgIGlmICh1bmxpa2VseShza2ItPm1hY19oZWFkZXIgPj0gc2tiLT5uZXR3b3JrX2hlYWRl
cikgfHwNCj4gPj4gK8KgwqDCoMKgwqDCoMKgIChtaW5fdCh1MzIsIHNrYl9tYWNfaGVhZGVyX2xl
bihza2IpLCBza2ItPmxlbikgPA0KPiA+PiArwqDCoMKgwqDCoMKgwqDCoCAodTMyKWRldi0+bWlu
X2hlYWRlcl9sZW4pKSB7DQo+ID4NCj4gPiBXaHkgY2hlY2sgc2tiLT5sZW4gIT0gMCBhYm92ZSBi
dXQgc2tiLT5sZW4gPCBkZXYtPm1pbl9oZWFkZXJfbGVuIGhlcmU/DQo+ID4gSSBndWVzcyBpdCBk
b2Vzbid0IG1ha2Ugc2Vuc2UgaW4gX19icGZfcmVkaXJlY3Rfbm9fbWFjIGJlY2F1c2Ugd2Uga25v
dw0KPiA+IHRoYXQgbWFjIGlzIGVtcHR5LCBidXQgd2h5IGRvIHdlIGNhcmUgaW4gX19icGZfcmVk
aXJlY3RfY29tbW9uPw0KPiA+IFdoeSBub3QgcHV0IHRoaXMgY2hlY2sgaW4gdGhlIGNvbW1vbiBf
X2JwZl9yZWRpcmVjdD8NCj4gPg0KPiA+IEFsc28sIGl0J3Mgc3RpbGwgbm90IGNsZWFyIHRvIG1l
IHdoZXRoZXIgd2Ugc2hvdWxkIGJha2UgaXQgaW50byB0aGUNCj4gPiBjb3JlIHN0YWNrIHZzIGhh
dmluZyBzb21lIHNwZWNpYWwgY2hlY2tzIGZyb20gdGVzdF9wcm9nX3J1biBvbmx5LiBJJ20NCj4g
PiBhc3N1bWluZyB0aGUgaXNzdWUgaXMgdGhhdCB3ZSBjYW4gY29uc3RydWN0IGlsbGVnYWwgc2ti
cyB3aXRoIHRoYXQNCj4gPiB0ZXN0X3Byb2dfcnVuIGludGVyZmFjZSwgc28gbWF5YmUgc3RhcnQg
YnkgZml4aW5nIHRoYXQ/DQoNCj4gQWdyZWUsIGlkZWFsbHkgd2UgY2FuIHByZXZlbnQgaXQgcmln
aHQgYXQgdGhlIHNvdXJjZSByYXRoZXIgdGhhbiBhZGRpbmcgIA0KPiBtb3JlIHRlc3RzIGludG8g
dGhlIGZhc3QtcGF0aC4NCg0KPiA+IERpZCB5b3UgaGF2ZSBhIGNoYW5jZSB0byBsb29rIGF0IHRo
ZSByZXByb2R1Y2VyIG1vcmUgY2xvc2VseT8gV2hhdA0KPiA+IGV4YWN0bHkgaXMgaXQgZG9pbmc/
DQo+ID4NCj4gPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGtmcmVlX3NrYihza2IpOw0KPiA+PiDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FUkFOR0U7DQo+ID4+IMKgwqDCoMKgwqAgfQ0KPiA+PiAt
LQ0KPiA+PiAyLjE3LjENCg0KPiA+DQoNCg0KPiBIaSBEYW5pZWwgYW5kIHNkZjoNCj4gCVRoYW5r
IHlvdSBmb3IgeW91ciByZXBseS4gSSByZWFkIHRoZSBwb2MgY29kZSBjYXJlZnVsbHksIGFuZCBJ
IHRoaW5rIHRoZSAgDQo+IGN1cnJlbnQgY2FsbCBzdGFjayBpcyBsaWtlOg0KPiBzeXNfYnBmKEJQ
Rl9QUk9HX1RFU1RfUlVOLCAmYXR0ciwgc2l6ZW9mKGF0dHIpKSAtPiAgDQo+IGJwZl9wcm9nX3Rl
c3RfcnVuLT5icGZfcHJvZ190ZXN0X3J1bl9za2IuDQoNCj4gSW4gZnVuY3Rpb24gYnBmX3Byb2df
dGVzdF9ydW5fc2tiLCBwcm9jZWR1cmUgd2lsbCB1c2UgYnVpbGRfc2tiIHRvICANCj4gZ2VuZXJh
dGUgYSBuZXcgc2tiLiBQb2MgY29kZSBwYXNzDQo+IGEgMTRCeXRlIHBhY2tldCBmb3IgZGlyZWN0
LiBGaXJzdCAsc2tiLT5sZW4gPSAxNCwgYnV0IGFmdGVyIHRyYW5zIGV0aCAgDQo+IHR5cGUsIHRo
ZSBsZW4gPSAwOyBidXQgaXNfbDIgaXMgZmFsc2UsDQo+IHNvIGxlbj0wIHdoZW4gcnVuIGJwZl90
ZXN0X3J1bi4gSXMgaXQgcG9zc2libGUgdG8gYWRkIGNoZWNrIGluICANCj4gY29udmVydF9fX3Nr
Yl90b19za2I/IFdoZW4gc2tiLT5sZW49MCwNCj4gd2UgZHJvcCB0aGUgcGFja2V0Lg0KDQpOb3Qg
c3VyZSBpdCBiZWxvbmdzIGluIGNvbnZlcnRfX19za2JfdG9fc2tiLCBidXQgY2hlY2tpbmcgc29t
ZXdoZXJlIGJlZm9yZQ0KY29udmVydF9fX3NrYl90b19za2Igc2VlbXMgbGlrZSBhIGdvb2Qgd2F5
IHRvIGdvPw0KDQo+IEJ1dCwgaWYgc29tZSBvdGhlciBwYXRocyBjYWxsIGJwZiByZWRpcmVjdCB3
aXRoIHNrYi0+bGVuPTAsIHRoaXMgaXMgbm90ICANCj4gZWZmZWN0aXZlLCBzdWNoIGFzIHNvbWUg
ZHJpdmVyIGNhbGwgcmVkaXJlY3QgZnVjdGlvbi4NCj4gSSBkb24ndCBrbm93IGlmIEknbSB0aGlu
a2luZyByaWdodC4NCg0KSSB0aGluayB0aGUgY29uc2Vuc3VzIHNvIGZhciB0aGF0IGl0J3Mgb25s
eSBicGZfcHJvZ190ZXN0X3J1biB0aGF0DQpnZW5lcmF0ZXMgdGhlc2UgdHlwZXMgb2YgcGFja2V0
cywgc28gbGV0J3Mgc3RhcnQgd2l0aCBmaXhpbmcgdGhhdC4NCg==
