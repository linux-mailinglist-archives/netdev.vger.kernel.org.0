Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8616D6133D3
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiJaKkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiJaKko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:40:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333AED105
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667212843; x=1698748843;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=fjKIgiLi/amStiDKjCW0IRTllCh6c+oJYuQyTButUm8=;
  b=uIi6ZfWOABycysAb38debH8wH3zPpcRiwqxyvbGUgtaNhhoa7euzChW4
   p+xztup3RfVAsQD9dWuTMQg4uV7BjUFKHxJpj8p0g6ydpApPzR7twFR4c
   Nj4EAfzV6NvmAAxdo6vpVWSEtJ2aSul9f18bkOFFSrJX29d03CjJRyviR
   kwr2jfg9begsS2l4ckxQcjHpDfFbaqO0DraB8LMIUhEx7yNpPZDbPR1g1
   v3NBwKdjMMlGYAOTWUHklLZzBsPdVaIBpmvilGUjsEzS+sLlZ6Y5gqaXo
   VeJE1x2Wu9fESa33HrheechtpkpWT5fZ4rG91/Tgdi1QjJXnDzsxW9knq
   A==;
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="187032338"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Oct 2022 03:40:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 31 Oct 2022 03:40:43 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 31 Oct 2022 03:40:42 -0700
Message-ID: <b6a2a8c9331d12dc6f7148be210acfea17f16479.camel@microchip.com>
Subject: Re: [PATCH net-next v5 2/6] net: dcb: add new apptrust attribute
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Date:   Mon, 31 Oct 2022 11:40:42 +0100
In-Reply-To: <20221028131403.1055694-3-daniel.machon@microchip.com>
References: <20221028131403.1055694-1-daniel.machon@microchip.com>
         <20221028131403.1055694-3-daniel.machon@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGFuaWVsLAoKT24gRnJpLCAyMDIyLTEwLTI4IGF0IDE1OjEzICswMjAwLCBEYW5pZWwgTWFj
aG9uIHdyb3RlOgo+IEFkZCBuZXcgYXBwdHJ1c3QgZXh0ZW5zaW9uIGF0dHJpYnV0ZXMgdG8gdGhl
IDgwMjFRYXogQVBQIG1hbmFnZWQgb2JqZWN0Lgo+IAo+IFR3byBuZXcgYXR0cmlidXRlcywgRENC
X0FUVFJfRENCX0FQUF9UUlVTVF9UQUJMRSBhbmQKPiBEQ0JfQVRUUl9EQ0JfQVBQX1RSVVNULCBo
YXMgYmVlbiBhZGRlZC4gVHJ1c3RlZCBzZWxlY3RvcnMgYXJlIHBhc3NlZCBpbgo+IHRoZSBuZXN0
ZWQgYXR0cmlidXRlIERDQl9BVFRSX0RDQl9BUFBfVFJVU1QsIGluIG9yZGVyIG9mIHByZWNlZGVu
Y2UuCj4gCj4gVGhlIG5ldyBhdHRyaWJ1dGVzIGFyZSBtZWFudCB0byBhbGxvdyBkcml2ZXJzLCB3
aG9zZSBodyBzdXBwb3J0cyB0aGUKPiBub3Rpb24gb2YgdHJ1c3QsIHRvIGJlIGFibGUgdG8gc2V0
IHdoZXRoZXIgYSBwYXJ0aWN1bGFyIGFwcCBzZWxlY3RvciBpcwo+IHRydXN0ZWQgLSBhbmQgaW4g
d2hpY2ggb3JkZXIuCj4gCj4gU2lnbmVkLW9mZi1ieTogRGFuaWVsIE1hY2hvbiA8ZGFuaWVsLm1h
Y2hvbkBtaWNyb2NoaXAuY29tPgo+IC0tLQoKLi4uc25pcC4uLgoKPiBAIC0xMTg1LDYgKzExODYs
MjkgQEAgc3RhdGljIGludCBkY2JubF9pZWVlX2ZpbGwoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3Ry
dWN0IG5ldF9kZXZpY2UgKm5ldGRldikKPiDCoMKgwqDCoMKgwqDCoMKgc3Bpbl91bmxvY2tfYmgo
JmRjYl9sb2NrKTsKPiDCoMKgwqDCoMKgwqDCoMKgbmxhX25lc3RfZW5kKHNrYiwgYXBwKTsKPiDC
oAo+ICvCoMKgwqDCoMKgwqDCoGlmIChvcHMtPmRjYm5sX2dldGFwcHRydXN0KSB7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHU4IHNlbGVjdG9yc1tJRUVFXzgwMjFRQVpfQVBQX1NF
TF9NQVggKyAxXSA9IHswfTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW50IG5z
ZWxlY3RvcnMsIGk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBhcHB0cnVz
dCA9IG5sYV9uZXN0X3N0YXJ0KHNrYiwgRENCX0FUVFJfRENCX0FQUF9UUlVTVF9UQUJMRSk7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghYXBwKQoKYXBwdHJ1c3Q/Cgo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FTVNH
U0laRTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVyciA9IG9wcy0+ZGNi
bmxfZ2V0YXBwdHJ1c3QobmV0ZGV2LCBzZWxlY3RvcnMsICZuc2VsZWN0b3JzKTsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKCFlcnIpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZvciAoaSA9IDA7IGkgPCBuc2VsZWN0b3JzOyBp
KyspIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBlcnIgPSBubGFfcHV0X3U4KHNrYiwgRENCX0FUVFJfRENCX0FQUF9UUlVT
VCwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZWxlY3RvcnNbaV0p
Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGlmIChlcnIpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbmxhX25lc3RfY2Fu
Y2VsKHNrYiwgYXBwdHJ1c3QpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gZXJyOwo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoH0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oH0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+ICsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgbmxhX25lc3RfZW5kKHNrYiwgYXBwdHJ1c3QpOwo+ICvCoMKgwqDC
oMKgwqDCoH0KPiArCj4gCgouLi5zbmlwLi4uCgo+IMKgZXJyOgo+IMKgwqDCoMKgwqDCoMKgwqBl
cnIgPSBubGFfcHV0X3U4KHNrYiwgRENCX0FUVFJfSUVFRSwgZXJyKTsKPiDCoMKgwqDCoMKgwqDC
oMKgZGNibmxfaWVlZV9ub3RpZnkobmV0ZGV2LCBSVE1fU0VURENCLCBEQ0JfQ01EX0lFRUVfU0VU
LCBzZXEsIDApOwoKQlIKU3RlZW4K

