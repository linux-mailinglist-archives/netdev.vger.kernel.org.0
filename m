Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32183EAF02
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 05:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbhHMD4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 23:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238130AbhHMD4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 23:56:44 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB65C061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 20:56:17 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 5C67C806B5;
        Fri, 13 Aug 2021 15:56:14 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1628826974;
        bh=6RNUQUme0f8g9AQ2zLft1SoSF8LlcOn8HlAjatW3Y7s=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=jdNHGyII3uqHCUiuHKHQonVhgrOX7fZ3iuO7g45ilJz1Y8ZqKypr29SmUCWXPOI0/
         Vldgc3k4M3xRMwEFLCsOdz8ExqQyGwuQgdvP4daGYnqwQgmRzu4XYc5MMBmxcw2PE4
         Zes4lixW/KgDLYYozjl6MxfrdnCt2gtKhhHnV2x8JPl21/ATuFnpwe4mw32TKyTvHl
         99mBYlCkTMGJw8zaeA6VwiGrfs0LIPHbduawcWXUfGv4sLyi1ijVOm8i0xOlmP7x0+
         QSGYU7rELcVTvNgL/d9lyftovcSIGYvgky3c4CeQBMXJP4NehfLWHqYZGW/z/dG0Gv
         A2kH6R6wh+7vQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6115ed5e0001>; Fri, 13 Aug 2021 15:56:14 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.23; Fri, 13 Aug 2021 15:56:14 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.023; Fri, 13 Aug 2021 15:56:14 +1200
From:   Richard Laing <Richard.Laing@alliedtelesis.co.nz>
To:     Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [RESEND] Conflict between char-misc and netdev
Thread-Topic: [RESEND] Conflict between char-misc and netdev
Thread-Index: AQHXj358xos8ytNW2k+HeQjlGfeGTKtvGhKAgAAD7wCAACN1AIAAxLOA
Date:   Fri, 13 Aug 2021 03:56:13 +0000
Message-ID: <29fe2abc-3065-444b-cc71-d1cbafa3638d@alliedtelesis.co.nz>
References: <20210812133215.GB7897@workstation>
 <20210812065113.04cc1a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210812140518.GC7897@workstation>
 <20210812091212.0034a81c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812091212.0034a81c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.16.78]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3C9483CBDB0A34E908D689009E2A57E@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=aqTM9hRV c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=8KpF8ikWtqQA:10 a=IkcTkHD0fZMA:10 a=MhDmnRu9jo8A:10 a=dw8Ceu96Tw-G5MO2LgAA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA4LzEzLzIxIDQ6MTIgQU0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBXb3VsZCB5b3Ug
bWluZCByZW5kZXJpbmcgdGhhdCBjb21tZW50IHlvdSdyZSByZWZlcnJpbmcgdG8gYXMgYSBjb21t
aXQNCj4gbWVzc2FnZSBhbmQgc2VuZGluZyBhIGZpeC11cCBvciBhIHJldmVydCBwYXRjaCBhZ2Fp
bnN0IG5ldC1uZXh0Pw0KPiBJIHdvdWxkbid0IGJlIGFibGUgdG8gZG8gaXQganVzdGljZS4NCkkg
d291bGQgYWxzbyBiZSBpbnRlcmVzdGVkIGluIHRoZSBjb21tZW50Lg0KDQpJIHdvdWxkIGJlIGhh
cHB5IGlmIHRoZSBwYXRjaCBpcyByZXZlcnRlZCBmcm9tIG5ldC1uZXh0LCBJIGhhdmUgYmVlbiAN
Cmxvb2tpbmcgYXQgYSBtb3JlIGZsZXhpYmxlIGFsdGVybmF0aXZlIGFsbG93aW5nIHRoZSBzaXpl
IHRvIGJlIHNwZWNpZmllZCANCnBlciBjaGFubmVsIHJhdGhlciB0aGFuIGFzIGEgZ2xvYmFsIHZh
bHVlLg0K
