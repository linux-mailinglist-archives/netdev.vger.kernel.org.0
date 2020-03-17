Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC02188673
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 14:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgCQNzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 09:55:17 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:1395 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726148AbgCQNzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 09:55:16 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02HDhTpk012643;
        Tue, 17 Mar 2020 14:55:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=Gu8RU4M1Yo3oc9oR0Y2I53Ep8ZKZwvbmvsOve/l4pnw=;
 b=YeIk7e4ZHYokxGEvJ18AYwo9q/lhRftRIISV68pYsX4428j05cOV4Wdo3NwrLZRl4QKD
 9ndz/oH7Ew/B4Y5aCOBpxjVQqT2pXjc70DhV/OK/60O5Sd+SzCPoD/6EutHDqcoxoRAb
 q13Qrgj52tkTXLYIbHaLf2w8U/saael70S7apisoDRJNCDq7k+0aCg3MUeZDj7w5Bi/b
 jj6pWVcuAhrVTd5yiEdoeudUUPGYlG17FewmGlaam/QvoRr241JkkJhwtbcVhi8O/nKf
 PxLctnxUiIgCODE3E+Di4H2WPor5ajfAbFbdp6mhZ90tMeYwy5Xj5fzuVfYbp0pADyGn rA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2yrqa9rjf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Mar 2020 14:55:00 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id BAEC1100034;
        Tue, 17 Mar 2020 14:54:55 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 694092AE6AE;
        Tue, 17 Mar 2020 14:54:55 +0100 (CET)
Received: from SFHDAG3NODE3.st.com (10.75.127.9) by SFHDAG3NODE3.st.com
 (10.75.127.9) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 17 Mar
 2020 14:54:55 +0100
Received: from SFHDAG3NODE3.st.com ([fe80::3507:b372:7648:476]) by
 SFHDAG3NODE3.st.com ([fe80::3507:b372:7648:476%20]) with mapi id
 15.00.1347.000; Tue, 17 Mar 2020 14:54:55 +0100
From:   Benjamin GAIGNARD <benjamin.gaignard@st.com>
To:     Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 04/12] docs: dt: fix references to m_can.txt file
Thread-Topic: [PATCH 04/12] docs: dt: fix references to m_can.txt file
Thread-Index: AQHV/F1/4CRB7GeziEugXmY9nZvK7ahMs1sAgAADZYCAAAcHAA==
Date:   Tue, 17 Mar 2020 13:54:55 +0000
Message-ID: <15305686-3795-3af6-ae13-b77ce62e857f@st.com>
References: <cover.1584450500.git.mchehab+huawei@kernel.org>
 <db67f9bc93f062179942f1e095a46b572a442b76.1584450500.git.mchehab+huawei@kernel.org>
 <376dba43-84cc-6bf9-6c69-270c689caf37@pengutronix.de>
 <60f77c6f-0536-1f50-1b49-2f604026a5cb@ti.com>
In-Reply-To: <60f77c6f-0536-1f50-1b49-2f604026a5cb@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.47]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7AAA9F3391F1B41B639F9310C1C4FDE@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_05:2020-03-17,2020-03-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDMvMTcvMjAgMjoyOSBQTSwgRGFuIE11cnBoeSB3cm90ZToNCj4gSGVsbG8NCj4NCj4g
T24gMy8xNy8yMCA4OjE3IEFNLCBNYXJjIEtsZWluZS1CdWRkZSB3cm90ZToNCj4+IE9uIDMvMTcv
MjAgMjoxMCBQTSwgTWF1cm8gQ2FydmFsaG8gQ2hlaGFiIHdyb3RlOg0KPj4+IFRoaXMgZmlsZSB3
YXMgY29udmVydGVkIHRvIGpzb24gYW5kIHJlbmFtZWQuIFVwZGF0ZSBpdHMNCj4+PiByZWZlcmVu
Y2VzIGFjY29yZGluZ2x5Lg0KPj4+DQo+Pj4gRml4ZXM6IDgyNDY3NGI1OWY3MiAoImR0LWJpbmRp
bmdzOiBuZXQ6IGNhbjogQ29udmVydCBNX0NBTiB0byANCj4+PiBqc29uLXNjaGVtYSIpDQo+DQo+
IEkgYW0gdHJ5aW5nIHRvIGZpbmQgb3V0IHdoZXJlIHRoZSBhYm92ZSBjb21taXQgd2FzIGFwcGxp
ZWQNCj4NCj4gSSBkb24ndCBzZWUgaXQgaW4gY2FuLW5leHQgb3IgbGludXgtY2FuLiBJIG5lZWQg
dG8gdXBkYXRlIHRoZSB0Y2FuIGR0IA0KPiBiaW5kaW5nIGZpbGUgYXMgaXQgd2FzIG1pc3NlZC4N
Cj4NCj4gQW5kIEkgYW0gbm90IHN1cmUgd2h5IHRoZSBtYWludGFpbmVycyBvZiB0aGVzZSBmaWxl
cyB3ZXJlIG5vdCBDQydkIG9uIA0KPiB0aGUgY29udmVyc2lvbiBvZiB0aGlzIGJpbmRpbmcuDQoN
Ckl0IHdhcyBtZXJnZWQgaW4gZGV2aWNlLXRyZWUtbmV4dC4NCg0KSSBoYXZlIHB1dCBpbiBjb3B5
IHRoZSBwZW9wbGUgdGhhdCBnZXRfbWFpbnRhaW5lcnMgcHJvdmlkZXMgdG8gbWUuDQpTb3JyeSBp
ZiBJIGZvcmdvdCBzb21lb25lLg0KDQpCZW5qYW1pbg0KPg0KPiBEYW4NCj4NCg==
