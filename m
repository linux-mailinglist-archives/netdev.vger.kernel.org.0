Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0B88711C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 06:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405357AbfHIEvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 00:51:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfHIEvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 00:51:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9708214051854;
        Thu,  8 Aug 2019 21:51:36 -0700 (PDT)
Date:   Thu, 08 Aug 2019 21:51:33 -0700 (PDT)
Message-Id: <20190808.215133.2134703818400431096.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     jakub.kicinski@netronome.com, maciejromanfijalkowski@gmail.com,
        netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and
 rx_max_agg_num dynamically
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18D0FFE@RTITMBSVM03.realtek.com.tw>
References: <0835B3720019904CB8F7AA43166CEEB2F18D0F3F@RTITMBSVM03.realtek.com.tw>
        <20190808114325.5c346d3a@cakuba.netronome.com>
        <0835B3720019904CB8F7AA43166CEEB2F18D0FFE@RTITMBSVM03.realtek.com.tw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 21:51:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSGF5ZXMgV2FuZyA8aGF5ZXN3YW5nQHJlYWx0ZWsuY29tPg0KRGF0ZTogRnJpLCA5IEF1
ZyAyMDE5IDAzOjM4OjUzICswMDAwDQoNCj4gSmFrdWIgS2ljaW5za2kgW2pha3ViLmtpY2luc2tp
QG5ldHJvbm9tZS5jb21dDQo+IFsuLl0+IFRoZSBrZXJuZWwgY291bGQgc3VwcG9ydCBpdC4gQW5k
IEkgaGFzIGZpbmlzaGVkIGl0Lg0KPj4gPiBIb3dldmVyLCB3aGVuIEkgd2FudCB0byB0ZXN0IGl0
IGJ5IGV0aHRvb2wsIEkgY291bGRuJ3QgZmluZCBzdWl0YWJsZSBjb21tYW5kLg0KPj4gPiBJIGNv
dWxkbid0IGZpbmQgcmVsYXRpdmUgZmVhdHVyZSBpbiB0aGUgc291cmNlIGNvZGUgb2YgZXRodG9v
bCwgZWl0aGVyLg0KPiANCj4+IEl0J3MgcG9zc2libGUgaXQncyBub3QgaW1wbGVtZW50ZWQgaW4g
dGhlIHVzZXIgc3BhY2UgdG9vbCDwn6SUDQo+Pg0KPj4gTG9va3MgbGlrZSBpdCBnb3QgcG9zdGVk
IGhlcmU6DQo+Pg0KPj4gaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbmV0ZGV2L21zZzI5
OTg3Ny5odG1sDQo+Pg0KPj4gQnV0IHBlcmhhcHMgbmV2ZXIgZmluaXNoZWQ/DQo+IA0KPiBNYXkg
SSBpbXBsZW1lbnQgYm90aCBzeXNmcyBhbmQgc2V0X3R1bmFsYmUgZm9yIGNvcHlicmVhayBmaXJz
dA0KPiBiZWZvcmUgdGhlIHVzZXIgc3BhY2UgdG9vbCBpcyByZWFkeT8gT3RoZXJ3aXNlLCB0aGUg
dXNlciBjb3VsZG4ndA0KPiBjaGFuZ2UgdGhlIGNvcHlicmVhayBub3cuDQoNCk5vLCBmaXggdGhl
IHRvb2wgcGxlYXNlLg0K
