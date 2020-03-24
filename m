Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E74190604
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 08:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgCXHFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 03:05:21 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:25912 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725951AbgCXHFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 03:05:21 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02O6w7UW031495;
        Tue, 24 Mar 2020 08:04:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=7wFcBKQjS8GhVVGG87TFgIBhk0ZNc73e9zHBQoR6jPY=;
 b=H+KIEHyRnN+J5BtxQqblKuhxxdXZRxg8buLFoEaG1of1OIxaFRRjzifDhHv4j0dllHti
 J4EP0mjdblnV1wdlHVKmcLKYIorYddmi4mRYNaQfbYgYXTDEl5WZh7XSdAts4eK2TIGo
 McPZzs5N073ymvfOtiH1iRCxlxNQBJqcZEyxj238yO8QAe24rhIgX9iO2iv44IPWLgnQ
 7O5VAgMFvfs3boxtLTORHZA1rvl9BPaZMxozdM6gTgRXufBnd+sxFjADdLZZ5NzWLow4
 Zfe4kFzEOaeFAcv/dnWUPOt96kfZiqHMxKzGjuFXwqi1sVF3JwmeewCcyEg7ak2NFA/g DQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2yw8xdx06x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 08:04:53 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2CEB4100050;
        Tue, 24 Mar 2020 08:04:50 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node1.st.com [10.75.127.7])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id F10752123A8;
        Tue, 24 Mar 2020 08:04:49 +0100 (CET)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG3NODE1.st.com
 (10.75.127.7) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Mar
 2020 08:04:49 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1473.003; Tue, 24 Mar 2020 08:04:49 +0100
From:   Christophe ROULLIER <christophe.roullier@st.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 0/2] Convert stm32 dwmac to DT schema
Thread-Topic: [PATCHv2 0/2] Convert stm32 dwmac to DT schema
Thread-Index: AQHV/G8jyopfPfKg2U20W1fFmsf4ZahXS1cA
Date:   Tue, 24 Mar 2020 07:04:49 +0000
Message-ID: <ceaf3163-7387-aa2a-6905-9d4faf92fc93@st.com>
References: <20200317151706.25810-1-christophe.roullier@st.com>
In-Reply-To: <20200317151706.25810-1-christophe.roullier@st.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BE064A5AA0DF74DB1E0A60AD74FCA3B@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_01:2020-03-23,2020-03-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkdlbnRsZSByZW1pbmRlcg0KDQpUaGFua3MgaW4gYWR2YW5jZS4NCkNocmlzdG9waGUu
DQoNCk9uIDE3LzAzLzIwMjAgMTY6MTcsIENocmlzdG9waGUgUm91bGxpZXIgd3JvdGU6DQo+IENv
bnZlcnQgc3RtMzIgZHdtYWMgdG8gRFQgc2NoZW1hDQo+DQo+IENocmlzdG9waGUgUm91bGxpZXIg
KDIpOg0KPiAgICBkdC1iaW5kaW5nczogbmV0OiBkd21hYzogaW5jcmVhc2UgJ21heEl0ZW1zJyBm
b3IgJ2Nsb2NrcycsDQo+ICAgICAgJ2Nsb2NrLW5hbWVzJyBwcm9wZXJ0aWVzDQo+ICAgIGR0LWJp
bmRpbmdzOiBuZXQ6IGR3bWFjOiBDb252ZXJ0IHN0bTMyIGR3bWFjIHRvIERUIHNjaGVtYQ0KPg0K
PiB2MS0+djI6DQo+IHVwZGF0ZSBmcm9tIFJvYiAoc29sdmUgY2hlY2twYXRjaCBlcnJvcnMgd2l0
aCB0cmFpbGluZyBXUywNCj4gcmVuYW1lICJFeGFtcGxlIiwgV3JhcCBsaW5lcykNCj4NCj4gICAu
Li4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvc25wcyxkd21hYy55YW1sICAgfCAgIDggKy0NCj4g
ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvc3RtMzItZHdtYWMudHh0ICAgfCAgNDQgLS0t
LS0NCj4gICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvc3RtMzItZHdtYWMueWFtbCAgfCAx
NjAgKysrKysrKysrKysrKysrKysrDQo+ICAgMyBmaWxlcyBjaGFuZ2VkLCAxNjcgaW5zZXJ0aW9u
cygrKSwgNDUgZGVsZXRpb25zKC0pDQo+ICAgZGVsZXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvc3RtMzItZHdtYWMudHh0DQo+ICAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvc3RtMzItZHdt
YWMueWFtbA0KPg==
