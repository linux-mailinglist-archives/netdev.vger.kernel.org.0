Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F91F87038
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 05:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404980AbfHIDjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 23:39:02 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:40607 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729490AbfHIDjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 23:39:01 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x793ct12024707, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x793ct12024707
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 9 Aug 2019 11:38:55 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Fri, 9 Aug
 2019 11:38:54 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and rx_max_agg_num dynamically
Thread-Topic: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and
 rx_max_agg_num dynamically
Thread-Index: AQHVTEjAduvqUw50CkySh6Q/0oky4abuKLuAgALKe5D//6zrgIAAi5Rw///n74CAARidjQ==
Date:   Fri, 9 Aug 2019 03:38:53 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D0FFE@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-289-albertk@realtek.com>
        <1394712342-15778-294-albertk@realtek.com>
        <20190806151007.75a8dd2c@cakuba.netronome.com>
        <0835B3720019904CB8F7AA43166CEEB2F18D0D8E@RTITMBSVM03.realtek.com.tw>
        <20190808134959.00006a58@gmail.com>
        <0835B3720019904CB8F7AA43166CEEB2F18D0F3F@RTITMBSVM03.realtek.com.tw>,<20190808114325.5c346d3a@cakuba.netronome.com>
In-Reply-To: <20190808114325.5c346d3a@cakuba.netronome.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [150.117.242.253]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SmFrdWIgS2ljaW5za2kgW2pha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb21dClsuLl0+IFRoZSBr
ZXJuZWwgY291bGQgc3VwcG9ydCBpdC4gQW5kIEkgaGFzIGZpbmlzaGVkIGl0Lgo+ID4gSG93ZXZl
ciwgd2hlbiBJIHdhbnQgdG8gdGVzdCBpdCBieSBldGh0b29sLCBJIGNvdWxkbid0IGZpbmQgc3Vp
dGFibGUgY29tbWFuZC4KPiA+IEkgY291bGRuJ3QgZmluZCByZWxhdGl2ZSBmZWF0dXJlIGluIHRo
ZSBzb3VyY2UgY29kZSBvZiBldGh0b29sLCBlaXRoZXIuCgo+IEl0J3MgcG9zc2libGUgaXQncyBu
b3QgaW1wbGVtZW50ZWQgaW4gdGhlIHVzZXIgc3BhY2UgdG9vbCDwn6SUCj4KPiBMb29rcyBsaWtl
IGl0IGdvdCBwb3N0ZWQgaGVyZToKPgo+IGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL25l
dGRldi9tc2cyOTk4NzcuaHRtbAo+Cj4gQnV0IHBlcmhhcHMgbmV2ZXIgZmluaXNoZWQ/CgpNYXkg
SSBpbXBsZW1lbnQgYm90aCBzeXNmcyBhbmQgc2V0X3R1bmFsYmUgZm9yIGNvcHlicmVhayBmaXJz
dApiZWZvcmUgdGhlIHVzZXIgc3BhY2UgdG9vbCBpcyByZWFkeT8gT3RoZXJ3aXNlLCB0aGUgdXNl
ciBjb3VsZG4ndApjaGFuZ2UgdGhlIGNvcHlicmVhayBub3cuCgpCZXN0IFJlZ2FyZHMsCkhheWVz
Cg==
