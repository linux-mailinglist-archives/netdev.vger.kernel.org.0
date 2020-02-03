Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F305150889
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 15:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgBCOiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 09:38:09 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:59906 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727454AbgBCOiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 09:38:09 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013EWqFM006280;
        Mon, 3 Feb 2020 15:37:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=vkT46fYRd5ByDiimEUbRN90OK24egsZjfCTxnkU75vQ=;
 b=CjCO1DahFjtwffpzmc0k8WQ3KetOTOXq/3by+bl2LwoWc1yyR9gg3e0UojI5kQi1sWvL
 2iQCuVeM620vUqJ37d3R/mMb+fALWQqRjEmZj+OGs/3XU+0hqSEuvOxqh51E9h/uWBq2
 +5tEDQbrv5eZYZY+qv+RagPuNyUm7TT5EisNY7Qa51jUR00OSr6FBEoMUJZuOsMLeQwn
 kVIVZpLkEqRnMSz3j1vKe5ii+2FaP9FiLVyE2XKNtUcN8QuWWJBbCcULLi/RC6K94zzk
 Sv+91JljgDMLR8S1diCZmup3ajxlJQFj0JQ8uylJ+xSHPIrLFNzfg+vJ/ahPjR/BXdiq NA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xvyp5sp21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 15:37:50 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 981DA100034;
        Mon,  3 Feb 2020 15:37:49 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node1.st.com [10.75.127.7])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 806052AC3E6;
        Mon,  3 Feb 2020 15:37:49 +0100 (CET)
Received: from SFHDAG3NODE3.st.com (10.75.127.9) by SFHDAG3NODE1.st.com
 (10.75.127.7) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 3 Feb
 2020 15:37:49 +0100
Received: from SFHDAG3NODE3.st.com ([fe80::3507:b372:7648:476]) by
 SFHDAG3NODE3.st.com ([fe80::3507:b372:7648:476%20]) with mapi id
 15.00.1347.000; Mon, 3 Feb 2020 15:37:49 +0100
From:   Benjamin GAIGNARD <benjamin.gaignard@st.com>
To:     Rob Herring <robh@kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "sriram.dash@samsung.com" <sriram.dash@samsung.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: can: Convert M_CAN to json-schema
Thread-Topic: [PATCH] dt-bindings: net: can: Convert M_CAN to json-schema
Thread-Index: AQHV0s68+wzkWnIiYky0zieiiSv6LKgJhXOAgAADLgA=
Date:   Mon, 3 Feb 2020 14:37:49 +0000
Message-ID: <2bb33763-62be-3336-5706-fdc47a61de50@st.com>
References: <20200124155542.2053-1-benjamin.gaignard@st.com>
 <20200203142625.GA19020@bogus>
In-Reply-To: <20200203142625.GA19020@bogus>
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
Content-ID: <7A3D62F6D887984D891530B7EF01F1FA@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzMvMjAgMzoyNiBQTSwgUm9iIEhlcnJpbmcgd3JvdGU6DQo+IE9uIEZyaSwgSmFuIDI0
LCAyMDIwIGF0IDA0OjU1OjQyUE0gKzAxMDAsIEJlbmphbWluIEdhaWduYXJkIHdyb3RlOg0KPj4g
Q29udmVydCBNX0NBTiBiaW5kaW5ncyB0byBqc29uLXNjaGVtYQ0KPj4NCj4+IFNpZ25lZC1vZmYt
Ynk6IEJlbmphbWluIEdhaWduYXJkIDxiZW5qYW1pbi5nYWlnbmFyZEBzdC5jb20+DQo+PiAtLS0N
Cj4+ICAgLi4uL2JpbmRpbmdzL25ldC9jYW4vY2FuLXRyYW5zY2VpdmVyLnR4dCAgICAgICAgICAg
fCAgMjQgLS0tLQ0KPj4gICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvY2FuL21fY2FuLnR4
dCAgICAgICAgICB8ICA3NSAtLS0tLS0tLS0tDQo+PiAgIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC9jYW4vbV9jYW4ueWFtbCAgICAgICAgIHwgMTUxICsrKysrKysrKysrKysrKysrKysrKw0K
Pj4gICAzIGZpbGVzIGNoYW5nZWQsIDE1MSBpbnNlcnRpb25zKCspLCA5OSBkZWxldGlvbnMoLSkN
Cj4+ICAgZGVsZXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvY2FuL2Nhbi10cmFuc2NlaXZlci50eHQNCj4gTm8gY2hhbmNlIG90aGVyIGNvbnRyb2xs
ZXJzIGFyZW4ndCBnb2luZyB0byBoYXZlIGEgdHJhbnNjZWl2ZXI/DQoNClRoZXkgY291bGQgLi4u
IEkgbWFkZSBhIHNob3J0IGN1dCBzaW5jZSBib3NoLG1fY2FuIHdhcyB0aGUgb25seSBvbmUgDQpy
ZWZlcmVuY2luZyB0aGlzIHByb3BlcnR5IGFuZCB0aGUgZmlsZS4NCg0KSSB3aWxsIGZpdCB0aGF0
IGluIHYyLiBTYW1lIGZvciB0aGUgY29tbWVudHMgeW91IGhhdmUgZG9uZSBiZWxvdy4NCg0KVGhh
bmtzLA0KDQpCZW5qYW1pbg0KDQo+DQo+PiAgIGRlbGV0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nhbi9tX2Nhbi50eHQNCj4+ICAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvY2FuL21fY2Fu
LnlhbWwNCj4gYm9zY2gsbV9jYW4ueWFtbA0KPg0KPj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvY2FuL21fY2FuLnlhbWwgYi9Eb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nhbi9tX2Nhbi55YW1sDQo+PiBuZXcgZmlsZSBtb2Rl
IDEwMDY0NA0KPj4gaW5kZXggMDAwMDAwMDAwMDAwLi5lZmRiZWQ4MWFmMjkNCj4+IC0tLSAvZGV2
L251bGwNCj4+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvY2Fu
L21fY2FuLnlhbWwNCj4+IEBAIC0wLDAgKzEsMTUxIEBADQo+PiArIyBTUERYLUxpY2Vuc2UtSWRl
bnRpZmllcjogR1BMLTIuMA0KPj4gKyVZQU1MIDEuMg0KPj4gKy0tLQ0KPj4gKyRpZDogaHR0cDov
L2RldmljZXRyZWUub3JnL3NjaGVtYXMvbmV0L2Nhbi9tX2Nhbi55YW1sIw0KPj4gKyRzY2hlbWE6
IGh0dHA6Ly9kZXZpY2V0cmVlLm9yZy9tZXRhLXNjaGVtYXMvY29yZS55YW1sIw0KPj4gKw0KPj4g
K3RpdGxlOiBCb3NjaCBNQ0FOIGNvbnRyb2xsZXIgQmluZGluZ3MNCj4+ICsNCj4+ICtkZXNjcmlw
dGlvbjogQm9zY2ggTUNBTiBjb250cm9sbGVyIGZvciBDQU4gYnVzDQo+PiArDQo+PiArbWFpbnRh
aW5lcnM6DQo+PiArICAtICBTcmlyYW0gRGFzaCA8c3JpcmFtLmRhc2hAc2Ftc3VuZy5jb20+DQo+
PiArDQo+PiArcHJvcGVydGllczoNCj4+ICsgIGNvbXBhdGlibGU6DQo+PiArICAgIGNvbnN0OiBi
b3NjaCxtX2Nhbg0KPj4gKw0KPj4gKyAgcmVnOg0KPj4gKyAgICBpdGVtczoNCj4+ICsgICAgICAt
IGRlc2NyaXB0aW9uOiBNX0NBTiByZWdpc3RlcnMgbWFwDQo+PiArICAgICAgLSBkZXNjcmlwdGlv
bjogbWVzc2FnZSBSQU0NCj4+ICsNCj4+ICsgIHJlZy1uYW1lczoNCj4+ICsgICAgaXRlbXM6DQo+
PiArICAgICAgLSBjb25zdDogbV9jYW4NCj4+ICsgICAgICAtIGNvbnN0OiBtZXNzYWdlX3JhbQ0K
Pj4gKw0KPj4gKyAgaW50ZXJydXB0czoNCj4+ICsgICAgaXRlbXM6DQo+PiArICAgICAgLSBkZXNj
cmlwdGlvbjogaW50ZXJydXB0IGxpbmUwDQo+PiArICAgICAgLSBkZXNjcmlwdGlvbjogaW50ZXJy
dXB0IGxpbmUxDQo+PiArICAgIG1pbkl0ZW1zOiAxDQo+PiArICAgIG1heEl0ZW1zOiAyDQo+PiAr
DQo+PiArICBpbnRlcnJ1cHQtbmFtZXM6DQo+PiArICAgIGl0ZW1zOg0KPj4gKyAgICAgIC0gY29u
c3Q6IGludDANCj4+ICsgICAgICAtIGNvbnN0OiBpbnQxDQo+PiArICAgIG1pbkl0ZW1zOiAxDQo+
PiArICAgIG1heEl0ZW1zOiAyDQo+PiArDQo+PiArICBjbG9ja3M6DQo+PiArICAgIGl0ZW1zOg0K
Pj4gKyAgICAgIC0gZGVzY3JpcHRpb246IHBlcmlwaGVyYWwgY2xvY2sNCj4+ICsgICAgICAtIGRl
c2NyaXB0aW9uOiBidXMgY2xvY2sNCj4+ICsNCj4+ICsgIGNsb2NrLW5hbWVzOg0KPj4gKyAgICBp
dGVtczoNCj4+ICsgICAgICAtIGNvbnN0OiBoY2xrDQo+PiArICAgICAgLSBjb25zdDogY2Nsaw0K
Pj4gKw0KPj4gKyAgYm9zY2gsbXJhbS1jZmc6DQo+PiArICAgIGRlc2NyaXB0aW9uOiB8DQo+PiAr
ICAgICAgICAgICAgICAgICBNZXNzYWdlIFJBTSBjb25maWd1cmF0aW9uIGRhdGEuDQo+PiArICAg
ICAgICAgICAgICAgICBNdWx0aXBsZSBNX0NBTiBpbnN0YW5jZXMgY2FuIHNoYXJlIHRoZSBzYW1l
IE1lc3NhZ2UgUkFNDQo+PiArICAgICAgICAgICAgICAgICBhbmQgZWFjaCBlbGVtZW50KGUuZyBS
eCBGSUZPIG9yIFR4IEJ1ZmZlciBhbmQgZXRjKSBudW1iZXINCj4+ICsgICAgICAgICAgICAgICAg
IGluIE1lc3NhZ2UgUkFNIGlzIGFsc28gY29uZmlndXJhYmxlLCBzbyB0aGlzIHByb3BlcnR5IGlz
DQo+PiArICAgICAgICAgICAgICAgICB0ZWxsaW5nIGRyaXZlciBob3cgdGhlIHNoYXJlZCBvciBw
cml2YXRlIE1lc3NhZ2UgUkFNIGFyZQ0KPj4gKyAgICAgICAgICAgICAgICAgdXNlZCBieSB0aGlz
IE1fQ0FOIGNvbnRyb2xsZXIuDQo+PiArDQo+PiArICAgICAgICAgICAgICAgICBUaGUgZm9ybWF0
IHNob3VsZCBiZSBhcyBmb2xsb3dzOg0KPj4gKyAgICAgICAgICAgICAgICAgPG9mZnNldCBzaWRm
X2VsZW1zIHhpZGZfZWxlbXMgcnhmMF9lbGVtcyByeGYxX2VsZW1zIHJ4Yl9lbGVtcyB0eGVfZWxl
bXMgdHhiX2VsZW1zPg0KPj4gKyAgICAgICAgICAgICAgICAgVGhlICdvZmZzZXQnIGlzIGFuIGFk
ZHJlc3Mgb2Zmc2V0IG9mIHRoZSBNZXNzYWdlIFJBTSB3aGVyZQ0KPj4gKyAgICAgICAgICAgICAg
ICAgdGhlIGZvbGxvd2luZyBlbGVtZW50cyBzdGFydCBmcm9tLiBUaGlzIGlzIHVzdWFsbHkgc2V0
IHRvDQo+PiArICAgICAgICAgICAgICAgICAweDAgaWYgeW91J3JlIHVzaW5nIGEgcHJpdmF0ZSBN
ZXNzYWdlIFJBTS4gVGhlIHJlbWFpbiBjZWxscw0KPj4gKyAgICAgICAgICAgICAgICAgYXJlIHVz
ZWQgdG8gc3BlY2lmeSBob3cgbWFueSBlbGVtZW50cyBhcmUgdXNlZCBmb3IgZWFjaCBGSUZPL0J1
ZmZlci4NCj4+ICsNCj4+ICsgICAgICAgICAgICAgICAgIE1fQ0FOIGluY2x1ZGVzIHRoZSBmb2xs
b3dpbmcgZWxlbWVudHMgYWNjb3JkaW5nIHRvIHVzZXIgbWFudWFsOg0KPj4gKyAgICAgICAgICAg
ICAgICAgMTEtYml0IEZpbHRlcgkwLTEyOCBlbGVtZW50cyAvIDAtMTI4IHdvcmRzDQo+PiArICAg
ICAgICAgICAgICAgICAyOS1iaXQgRmlsdGVyCTAtNjQgZWxlbWVudHMgLyAwLTEyOCB3b3Jkcw0K
Pj4gKyAgICAgICAgICAgICAgICAgUnggRklGTyAwCTAtNjQgZWxlbWVudHMgLyAwLTExNTIgd29y
ZHMNCj4+ICsgICAgICAgICAgICAgICAgIFJ4IEZJRk8gMQkwLTY0IGVsZW1lbnRzIC8gMC0xMTUy
IHdvcmRzDQo+PiArICAgICAgICAgICAgICAgICBSeCBCdWZmZXJzCTAtNjQgZWxlbWVudHMgLyAw
LTExNTIgd29yZHMNCj4+ICsgICAgICAgICAgICAgICAgIFR4IEV2ZW50IEZJRk8JMC0zMiBlbGVt
ZW50cyAvIDAtNjQgd29yZHMNCj4+ICsgICAgICAgICAgICAgICAgIFR4IEJ1ZmZlcnMJMC0zMiBl
bGVtZW50cyAvIDAtNTc2IHdvcmRzDQo+PiArDQo+PiArICAgICAgICAgICAgICAgICBQbGVhc2Ug
cmVmZXIgdG8gMi40LjEgTWVzc2FnZSBSQU0gQ29uZmlndXJhdGlvbiBpbiBCb3NjaA0KPj4gKyAg
ICAgICAgICAgICAgICAgTV9DQU4gdXNlciBtYW51YWwgZm9yIGRldGFpbHMuDQo+PiArICAgIGFs
bE9mOg0KPj4gKyAgICAgIC0gJHJlZjogL3NjaGVtYXMvdHlwZXMueWFtbCMvZGVmaW5pdGlvbnMv
aW50MzItbWF0cml4DQo+IExvb2tzIGxpa2UgdWludDMyLWFycmF5IGJhc2VkIG9uIHRoZSBjb25z
dHJhaW50cy4NCj4NCj4+ICsgICAgICAtIGl0ZW1zOg0KPj4gKyAgICAgICAgIGl0ZW1zOg0KPj4g
KyAgICAgICAgICAgLSBkZXNjcmlwdGlvbjogVGhlICdvZmZzZXQnIGlzIGFuIGFkZHJlc3Mgb2Zm
c2V0IG9mIHRoZSBNZXNzYWdlIFJBTQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgd2hl
cmUgdGhlIGZvbGxvd2luZyBlbGVtZW50cyBzdGFydCBmcm9tLiBUaGlzIGlzIHVzdWFsbHkNCj4+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgIHNldCB0byAweDAgaWYgeW91J3JlIHVzaW5nIGEg
cHJpdmF0ZSBNZXNzYWdlIFJBTS4NCj4+ICsgICAgICAgICAgICAgZGVmYXVsdDogMA0KPj4gKyAg
ICAgICAgICAgLSBkZXNjcmlwdGlvbjogMTEtYml0IEZpbHRlciAwLTEyOCBlbGVtZW50cyAvIDAt
MTI4IHdvcmRzDQo+PiArICAgICAgICAgICAgIG1pbmltdW06IDANCj4+ICsgICAgICAgICAgICAg
bWF4aW11bTogMTI4DQo+PiArICAgICAgICAgICAtIGRlc2NyaXB0aW9uOiAyOS1iaXQgRmlsdGVy
IDAtNjQgZWxlbWVudHMgLyAwLTEyOCB3b3Jkcw0KPj4gKyAgICAgICAgICAgICBtaW5pbXVtOiAw
DQo+PiArICAgICAgICAgICAgIG1heGltdW06IDY0DQo+PiArICAgICAgICAgICAtIGRlc2NyaXB0
aW9uOiBSeCBGSUZPIDAgMC02NCBlbGVtZW50cyAvIDAtMTE1MiB3b3Jkcw0KPj4gKyAgICAgICAg
ICAgICBtaW5pbXVtOiAwDQo+PiArICAgICAgICAgICAgIG1heGltdW06IDY0DQo+PiArICAgICAg
ICAgICAtIGRlc2NyaXB0aW9uOiBSeCBGSUZPIDEgMC02NCBlbGVtZW50cyAvIDAtMTE1MiB3b3Jk
cw0KPj4gKyAgICAgICAgICAgICBtaW5pbXVtOiAwDQo+PiArICAgICAgICAgICAgIG1heGltdW06
IDY0DQo+PiArICAgICAgICAgICAtIGRlc2NyaXB0aW9uOiBSeCBCdWZmZXJzIDAtNjQgZWxlbWVu
dHMgLyAwLTExNTIgd29yZHMNCj4+ICsgICAgICAgICAgICAgbWluaW11bTogMA0KPj4gKyAgICAg
ICAgICAgICBtYXhpbXVtOiA2NA0KPj4gKyAgICAgICAgICAgLSBkZXNjcmlwdGlvbjogVHggRXZl
bnQgRklGTyAwLTMyIGVsZW1lbnRzIC8gMC02NCB3b3Jkcw0KPj4gKyAgICAgICAgICAgICBtaW5p
bXVtOiAwDQo+PiArICAgICAgICAgICAgIG1heGltdW06IDMyDQo+PiArICAgICAgICAgICAtIGRl
c2NyaXB0aW9uOiBUeCBCdWZmZXJzIDAtMzIgZWxlbWVudHMgLyAwLTU3NiB3b3Jkcw0KPj4gKyAg
ICAgICAgICAgICBtaW5pbXVtOiAwDQo+PiArICAgICAgICAgICAgIG1heGltdW06IDMyDQo+PiAr
ICAgICAgICBtYXhJdGVtczogMQ0KPj4gKw0KPj4gKyAgY2FuLXRyYW5zY2VpdmVyOg0KPj4gKyAg
ICB0eXBlOiBvYmplY3QNCj4+ICsNCj4+ICsgICAgcHJvcGVydGllczoNCj4+ICsgICAgICBtYXgt
Yml0cmF0ZToNCj4+ICsgICAgICAgICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRp
b25zL3VpbnQzMg0KPj4gKyAgICAgICAgZGVzY3JpcHRpb246IGEgcG9zaXRpdmUgbm9uIDAgdmFs
dWUgdGhhdCBkZXRlcm1pbmVzIHRoZSBtYXggc3BlZWQgdGhhdA0KPj4gKyAgICAgICAgICAgICAg
ICAgICAgIENBTi9DQU4tRkQgY2FuIHJ1bi4NCj4+ICsgICAgICAgIG1pbmltdW06IDENCj4+ICsN
Cj4+ICtyZXF1aXJlZDoNCj4+ICsgIC0gY29tcGF0aWJsZQ0KPj4gKyAgLSByZWcNCj4+ICsgIC0g
cmVnLW5hbWVzDQo+PiArICAtIGludGVycnVwdHMNCj4+ICsgIC0gaW50ZXJydXB0LW5hbWVzDQo+
PiArICAtIGNsb2Nrcw0KPj4gKyAgLSBjbG9jay1uYW1lcw0KPj4gKyAgLSBib3NjaCxtcmFtLWNm
Zw0KPj4gKw0KPj4gK2FkZGl0aW9uYWxQcm9wZXJ0aWVzOiBmYWxzZQ0KPj4gKw0KPj4gK2V4YW1w
bGVzOg0KPj4gKyAgLSB8DQo+PiArICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9jbG9jay9pbXg2
c3gtY2xvY2suaD4NCj4+ICsgICAgY2FuQDIwZTgwMDAgew0KPj4gKyAgICAgIGNvbXBhdGlibGUg
PSAiYm9zY2gsbV9jYW4iOw0KPj4gKyAgICAgIHJlZyA9IDwweDAyMGU4MDAwIDB4NDAwMD4sIDww
eDAyMjk4MDAwIDB4NDAwMD47DQo+PiArICAgICAgcmVnLW5hbWVzID0gIm1fY2FuIiwgIm1lc3Nh
Z2VfcmFtIjsNCj4+ICsgICAgICBpbnRlcnJ1cHRzID0gPDAgMTE0IDB4MDQ+LCA8MCAxMTQgMHgw
ND47DQo+PiArICAgICAgaW50ZXJydXB0LW5hbWVzID0gImludDAiLCAiaW50MSI7DQo+PiArICAg
ICAgY2xvY2tzID0gPCZjbGtzIElNWDZTWF9DTEtfQ0FORkQ+LA0KPj4gKyAgICAgICAgICAgICAg
IDwmY2xrcyBJTVg2U1hfQ0xLX0NBTkZEPjsNCj4+ICsgICAgICBjbG9jay1uYW1lcyA9ICJoY2xr
IiwgImNjbGsiOw0KPj4gKyAgICAgIGJvc2NoLG1yYW0tY2ZnID0gPDB4MCAwIDAgMzIgMCAwIDAg
MT47DQo+PiArDQo+PiArICAgICAgY2FuLXRyYW5zY2VpdmVyIHsNCj4+ICsgICAgICAgIG1heC1i
aXRyYXRlID0gPDUwMDAwMDA+Ow0KPj4gKyAgICAgIH07DQo+PiArICAgIH07DQo+PiArDQo+PiAr
Li4uDQo+PiAtLSANCj4+IDIuMTUuMA0KPj4=
