Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED75F186616
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgCPIFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:05:46 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:4442 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729745AbgCPIFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 04:05:46 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02G7vZsG023088;
        Mon, 16 Mar 2020 09:05:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=74p6j09OgCD44qKERldrfn1TGhnsclJWh4IGsQrPgUs=;
 b=NOO+6cnr0gI9l59bNS7o++DFseCA5paZlami+ViY1zcsWowTSrCxjbugKLYdzh/iDMDJ
 +V/vXWUWwMj7VqYkO2V+Rx3+i8vuFNBbM7RBG0vU3yEfUIZbnL8RBM84CVeIEX+XhnRh
 gLEOHX/Udwi2x8K7bw9PMIOikLyRunp/magUpPp6DCNlbCNEX9YmSnCGnqdybEnbHLh7
 /fWx5Fv+bnhnB2OhrFgicDQgo80cBOZq3cHc4kBCfKnBVZnPCWmQ0So+sluy86vVoOo9
 MMzc98iysNKWk7vaZgqclhuFWMs72lcVJY2ykvLhEB72oixGMKtqK1C9GJAkB25i+UPN ew== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2yrqaye8pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 09:05:30 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4847F100039;
        Mon, 16 Mar 2020 09:05:29 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 36DE821E687;
        Mon, 16 Mar 2020 09:05:29 +0100 (CET)
Received: from SFHDAG3NODE3.st.com (10.75.127.9) by SFHDAG3NODE3.st.com
 (10.75.127.9) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 16 Mar
 2020 09:05:28 +0100
Received: from SFHDAG3NODE3.st.com ([fe80::3507:b372:7648:476]) by
 SFHDAG3NODE3.st.com ([fe80::3507:b372:7648:476%20]) with mapi id
 15.00.1347.000; Mon, 16 Mar 2020 09:05:28 +0100
From:   Benjamin GAIGNARD <benjamin.gaignard@st.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Rob Herring <robh@kernel.org>
CC:     Dan Murphy <dmurphy@ti.com>, Sriram Dash <sriram.dash@samsung.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: adjust to MCAN MMIO schema conversion
Thread-Topic: [PATCH] MAINTAINERS: adjust to MCAN MMIO schema conversion
Thread-Index: AQHV+p7q/dc7FHitnU+am9MRNeQXR6hKzU0A
Date:   Mon, 16 Mar 2020 08:05:28 +0000
Message-ID: <28f8b502-1f33-1da2-e2b8-3a727db58eea@st.com>
References: <20200315075356.8596-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20200315075356.8596-1-lukas.bulwahn@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.44]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B429A41A546874391B681CDAA92AAC5@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-16_02:2020-03-12,2020-03-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDMvMTUvMjAgODo1MyBBTSwgTHVrYXMgQnVsd2FobiB3cm90ZToNCj4gQ29tbWl0IDgy
NDY3NGI1OWY3MiAoImR0LWJpbmRpbmdzOiBuZXQ6IGNhbjogQ29udmVydCBNX0NBTiB0byBqc29u
LXNjaGVtYSIpDQo+IG1pc3NlZCB0byBhZGp1c3QgdGhlIE1DQU4gTU1JTyBERVZJQ0UgRFJJVkVS
IGVudHJ5IGluIE1BSU5UQUlORVJTLg0KPg0KPiBTaW5jZSB0aGVuLCAuL3NjcmlwdHMvZ2V0X21h
aW50YWluZXIucGwgLS1zZWxmLXRlc3QgY29tcGxhaW5zOg0KPg0KPiAgICB3YXJuaW5nOiBubyBm
aWxlIG1hdGNoZXMgXA0KPiAgICBGOiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
bmV0L2Nhbi9tX2Nhbi50eHQNCj4NCj4gVXBkYXRlIE1BSU5UQUlORVJTIGVudHJ5IHRvIGxvY2F0
aW9uIG9mIGNvbnZlcnRlZCBzY2hlbWEuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IEx1a2FzIEJ1bHdh
aG4gPGx1a2FzLmJ1bHdhaG5AZ21haWwuY29tPg0KUmV2aWV3ZWQtYnk6IEJlbmphbWluIEdhaWdu
YXJkIDxiZW5qYW1pbi5nYWlnbmFyZEBzdC5jb20+DQoNClRoYW5rcw0KPiAtLS0NCj4gYXBwbGll
cyBjbGVhbmx5IG9uIG5leHQtMjAyMDAzMTMNCj4NCj4gQmVuamFtaW4sIHBsZWFzZSBhY2suDQo+
IFJvYiwgcGxlYXNlIHBpY2sgdGhpcyBwYXRjaCAoaXQgaXMgbm90IHVyZ2VudCwgdGhvdWdoKS4N
Cj4NCj4gICBNQUlOVEFJTkVSUyB8IDIgKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJ
TlRBSU5FUlMNCj4gaW5kZXggMzJhOTVkMTYyZjA2Li5lYmMzZDkxMjk0YzYgMTAwNjQ0DQo+IC0t
LSBhL01BSU5UQUlORVJTDQo+ICsrKyBiL01BSU5UQUlORVJTDQo+IEBAIC0xMDMyMyw3ICsxMDMy
Myw3IEBAIE06CURhbiBNdXJwaHkgPGRtdXJwaHlAdGkuY29tPg0KPiAgIE06CVNyaXJhbSBEYXNo
IDxzcmlyYW0uZGFzaEBzYW1zdW5nLmNvbT4NCj4gICBMOglsaW51eC1jYW5Admdlci5rZXJuZWwu
b3JnDQo+ICAgUzoJTWFpbnRhaW5lZA0KPiAtRjoJRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL25ldC9jYW4vbV9jYW4udHh0DQo+ICtGOglEb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvbmV0L2Nhbi9ib3NjaCxtX2Nhbi55YW1sDQo+ICAgRjoJZHJpdmVycy9uZXQvY2Fu
L21fY2FuL21fY2FuLmMNCj4gICBGOglkcml2ZXJzL25ldC9jYW4vbV9jYW4vbV9jYW4uaA0KPiAg
IEY6CWRyaXZlcnMvbmV0L2Nhbi9tX2Nhbi9tX2Nhbl9wbGF0Zm9ybS5jDQo=
