Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77681258D1E
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 13:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgIALCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 07:02:16 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:42438 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgIALAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 07:00:37 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 081AxmmN007970;
        Tue, 1 Sep 2020 05:59:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598957988;
        bh=mW0fgU8pzaTe2NAYIrO8YgARQvFo4Zq3/Iy45SwNZgM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=lLpQYHNPw4fidBrDBgQ0fSQ3m5910EHmHZgsXnalnsixj+/OKQuQC1GiA4uafn4ji
         b72+RH6Tf9h5FNQMlRapChDaRBE6jFobEI4OhVhhwC+B+Z8Rk3Cgd4gUFrjhNphkMm
         ml6rXfFyUEPAItF2HiRMcEpa39iA7gbc0+rhvhBI=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 081AxmWD075810
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 1 Sep 2020 05:59:48 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 1 Sep
 2020 05:59:48 -0500
Received: from DLEE105.ent.ti.com ([fe80::d8b7:9c27:242c:8236]) by
 DLEE105.ent.ti.com ([fe80::d8b7:9c27:242c:8236%17]) with mapi id
 15.01.1979.003; Tue, 1 Sep 2020 05:59:47 -0500
From:   "Bouganim, Raz" <r-bouganim@ti.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
CC:     "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "mauro.chehab@huawei.com" <mauro.chehab@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Tony Lindgren <tony@atomide.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        "Fuqian Huang" <huangfq.daxian@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH] Revert "wlcore: Adding suppoprt for IGTK
 key in wlcore driver"
Thread-Topic: [EXTERNAL] Re: [PATCH] Revert "wlcore: Adding suppoprt for IGTK
 key in wlcore driver"
Thread-Index: AQHWgEK1F29pdNatDkqozfEFdlYolqlTj4tg
Date:   Tue, 1 Sep 2020 10:59:47 +0000
Message-ID: <49d4cdaf6aad40f591e8b2f17e09007c@ti.com>
References: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
 <20200901093129.8A0FAC433B1@smtp.codeaurora.org>
In-Reply-To: <20200901093129.8A0FAC433B1@smtp.codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.21.82]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2UgYXJlIGdvaW5nIHRvIHJlbGVhc2UgYSBuZXcgRlcgdmVyc2lvbiA4LjkuMC4wLjgzIHRoYXQg
Y29udGFpbnMgc3VwcG9ydCB3aXRoIHRoZSBuZXcgSUdUSyBrZXkuDQoNCkluIGFkZGl0aW9uLCB3
ZSBhbHNvIGdvaW5nIHRvIHJlbGVhc2UgYSBuZXcgcGF0Y2ggdGhhdCBtYW5kYXRlcyB0aGUgZHJp
dmVyIHRvIHdvcmsgd2l0aCBhbiA4LjkuMC4wLjgzIEZXIHZlcnNpb24gb3IgYWJvdmUuDQoNCldl
IGdvaW5nIHRvIHB1c2ggaXQgdG9kYXkvdG9tb3Jyb3cuDQoNCltQQVRDSF0gd2wxOHh4OiBVcGRh
dGUgdGhlIGxhdGVzdCBmaXJtd2FyZSBzdXBwb3J0ZWQNClRoaXMgcGF0Y2ggbWFuZGF0ZXMgdGhl
IGRyaXZlciB0byB3b3JrIHdpdGggYW4gOC45LjAuMC44MyBGVyB2ZXJzaW9uIG9yIGFib3ZlLg0K
VGhpcyBpcyB0byBmaXggYSBrZXJuZWwgcGFuaWMgY2F1c2VkIGJ5IGVzdGFibGlzaGluZyBhIFBN
Ri9XUEEzIGNvbm5lY3Rpb24gd2l0aCBvbGRlciBGVyB2ZXJzaW9ucy4NCg0KWW91IGNhbiBnZXQg
dGhlIGxhdGVzdCBmaXJtd2FyZSBhdDoNCmdpdDovL2dpdC50aS5jb20vd2lsaW5rOC13bGFuL3ds
MTh4eF9mdy5naXQNCg0KU2lnbmVkLW9mZi1ieTogUmF6IEJvdWdhbmltIDxyLWJvdWdhbmltQHRp
LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3RpL3dsMTh4eC93bDE4eHguaCB8IDIg
Ky0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3RpL3dsMTh4eC93bDE4eHguaCBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3RpL3dsMTh4eC93bDE4eHguaA0KaW5kZXggYjY0MmUwYy4uMDNhZDdm
NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3RpL3dsMTh4eC93bDE4eHguaA0K
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvdGkvd2wxOHh4L3dsMTh4eC5oDQpAQCAtMTUsNyAr
MTUsNyBAQA0KICNkZWZpbmUgV0wxOFhYX0lGVFlQRV9WRVIJOQ0KICNkZWZpbmUgV0wxOFhYX01B
Sk9SX1ZFUglXTENPUkVfRldfVkVSX0lHTk9SRQ0KICNkZWZpbmUgV0wxOFhYX1NVQlRZUEVfVkVS
CVdMQ09SRV9GV19WRVJfSUdOT1JFDQotI2RlZmluZSBXTDE4WFhfTUlOT1JfVkVSCTU4DQorI2Rl
ZmluZSBXTDE4WFhfTUlOT1JfVkVSCTgzDQogDQogI2RlZmluZSBXTDE4WFhfQ01EX01BWF9TSVpF
ICAgICAgICAgIDc0MA0KIA0KLS0NCjEuOS4xDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
RnJvbToga3ZhbG89Y29kZWF1cm9yYS5vcmdAbWcuY29kZWF1cm9yYS5vcmcgW21haWx0bzprdmFs
bz1jb2RlYXVyb3JhLm9yZ0BtZy5jb2RlYXVyb3JhLm9yZ10gT24gQmVoYWxmIE9mIEthbGxlIFZh
bG8NClNlbnQ6IFR1ZXNkYXksIFNlcHRlbWJlciAxLCAyMDIwIDEyOjMxIFBNDQpUbzogTWF1cm8g
Q2FydmFsaG8gQ2hlaGFiDQpDYzogbGludXhhcm1AaHVhd2VpLmNvbTsgbWF1cm8uY2hlaGFiQGh1
YXdlaS5jb207IE1hdXJvIENhcnZhbGhvIENoZWhhYjsgSm9obiBTdHVsdHo7IE1hbml2YW5uYW4g
U2FkaGFzaXZhbTsgRGF2aWQgUy4gTWlsbGVyOyBKYWt1YiBLaWNpbnNraTsgSGFobiwgTWFpdGFs
OyBHdXN0YXZvIEEuIFIuIFNpbHZhOyBCb3VnYW5pbSwgUmF6OyBUb255IExpbmRncmVuOyBEaW5n
aGFvIExpdTsgSm9oYW5uZXMgQmVyZzsgRnVxaWFuIEh1YW5nOyBsaW51eC13aXJlbGVzc0B2Z2Vy
Lmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmcNClN1YmplY3Q6IFtFWFRFUk5BTF0gUmU6IFtQQVRDSF0gUmV2ZXJ0ICJ3bGNvcmU6
IEFkZGluZyBzdXBwb3BydCBmb3IgSUdUSyBrZXkgaW4gd2xjb3JlIGRyaXZlciINCg0KTWF1cm8g
Q2FydmFsaG8gQ2hlaGFiIDxtY2hlaGFiK2h1YXdlaUBrZXJuZWwub3JnPiB3cm90ZToNCg0KPiBU
aGlzIHBhdGNoIGNhdXNlcyBhIHJlZ3Jlc3Npb24gYmV0d2VuIEtlcm5lbCA1LjcgYW5kIDUuOCBh
dCB3bGNvcmU6DQo+IHdpdGggaXQgYXBwbGllZCwgV2lGaSBzdG9wcyB3b3JraW5nLCBhbmQgdGhl
IEtlcm5lbCBzdGFydHMgcHJpbnRpbmcNCj4gdGhpcyBtZXNzYWdlIGV2ZXJ5IHNlY29uZDoNCj4g
DQo+ICAgIHdsY29yZTogUEhZIGZpcm13YXJlIHZlcnNpb246IFJldiA4LjIuMC4wLjI0Mg0KPiAg
ICB3bGNvcmU6IGZpcm13YXJlIGJvb3RlZCAoUmV2IDguOS4wLjAuNzkpDQo+ICAgIHdsY29yZTog
RVJST1IgY29tbWFuZCBleGVjdXRlIGZhaWx1cmUgMTQNCj4gICAgLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tDQo+ICAgIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEzMyBhdCBkcml2
ZXJzL25ldC93aXJlbGVzcy90aS93bGNvcmUvbWFpbi5jOjc5NSB3bDEyeHhfcXVldWVfcmVjb3Zl
cnlfd29yay5wYXJ0LjArMHg2Yy8weDc0IFt3bGNvcmVdDQo+ICAgIE1vZHVsZXMgbGlua2VkIGlu
OiB3bDE4eHggd2xjb3JlIG1hYzgwMjExIGxpYmFyYzQgY2ZnODAyMTEgcmZraWxsIHNuZF9zb2Nf
aGRtaV9jb2RlYyBjcmN0MTBkaWZfY2Ugd2xjb3JlX3NkaW8gYWR2NzUxMSBjZWMga2lyaW45eHhf
ZHJtKEMpIGtpcmluOXh4X2R3X2RybV9kc2koQykgZHJtX2ttc19oZWxwZXIgZHJtIGlwX3RhYmxl
cyB4X3RhYmxlcyBpcHY2IG5mX2RlZnJhZ19pcHY2DQo+ICAgIENQVTogMCBQSUQ6IDEzMyBDb21t
OiBrd29ya2VyLzA6MSBUYWludGVkOiBHICAgICAgICBXQyAgICAgICAgNS44LjArICMxODYNCj4g
ICAgSGFyZHdhcmUgbmFtZTogSGlLZXk5NzAgKERUKQ0KPiAgICBXb3JrcXVldWU6IGV2ZW50c19m
cmVlemFibGUgaWVlZTgwMjExX3Jlc3RhcnRfd29yayBbbWFjODAyMTFdDQo+ICAgIHBzdGF0ZTog
NjAwMDAwMDUgKG5aQ3YgZGFpZiAtUEFOIC1VQU8gQlRZUEU9LS0pDQo+ICAgIHBjIDogd2wxMnh4
X3F1ZXVlX3JlY292ZXJ5X3dvcmsucGFydC4wKzB4NmMvMHg3NCBbd2xjb3JlXQ0KPiAgICBsciA6
IHdsMTJ4eF9xdWV1ZV9yZWNvdmVyeV93b3JrKzB4MjQvMHgzMCBbd2xjb3JlXQ0KPiAgICBzcCA6
IGZmZmY4MDAwMTI2YzNhNjANCj4gICAgeDI5OiBmZmZmODAwMDEyNmMzYTYwIHgyODogMDAwMDAw
MDAwMDAwMjVkZQ0KPiAgICB4Mjc6IDAwMDAwMDAwMDAwMDAwMTAgeDI2OiAwMDAwMDAwMDAwMDAw
MDA1DQo+ICAgIHgyNTogZmZmZjAwMDFhNWQ0OWU4MCB4MjQ6IGZmZmY4MDAwMDkyY2Y1ODANCj4g
ICAgeDIzOiBmZmZmMDAwMWI3YzEyNjIzIHgyMjogZmZmZjAwMDFiNmZjZjJlOA0KPiAgICB4MjE6
IGZmZmYwMDAxYjdlNDYyMDAgeDIwOiAwMDAwMDAwMGZmZmZmZmZiDQo+ICAgIHgxOTogZmZmZjAw
MDFhNzhlNjQwMCB4MTg6IDAwMDAwMDAwMDAwMDAwMzANCj4gICAgeDE3OiAwMDAwMDAwMDAwMDAw
MDAxIHgxNjogMDAwMDAwMDAwMDAwMDAwMQ0KPiAgICB4MTU6IGZmZmYwMDAxYjdlNDY2NzAgeDE0
OiBmZmZmZmZmZmZmZmZmZmZmDQo+ICAgIHgxMzogZmZmZjgwMDA5MjZjMzdkNyB4MTI6IGZmZmY4
MDAwMTI2YzM3ZTANCj4gICAgeDExOiBmZmZmODAwMDExZTAxMDAwIHgxMDogZmZmZjgwMDAxMjA1
MjZkMA0KPiAgICB4OSA6IDAwMDAwMDAwMDAwMDAwMDAgeDggOiAzNDMxMjA2NTcyNzU2YzY5DQo+
ICAgIHg3IDogNjE2NjIwNjU3NDc1NjM2NSB4NiA6IDAwMDAwMDAwMDAwMDBjMmMNCj4gICAgeDUg
OiAwMDAwMDAwMDAwMDAwMDAwIHg0IDogZmZmZjAwMDFiZjEzNjFlOA0KPiAgICB4MyA6IGZmZmYw
MDAxYmYxNzkwYjAgeDIgOiAwMDAwMDAwMDAwMDAwMDAwDQo+ICAgIHgxIDogZmZmZjAwMDFhNWQ0
OWU4MCB4MCA6IDAwMDAwMDAwMDAwMDAwMDENCj4gICAgQ2FsbCB0cmFjZToNCj4gICAgIHdsMTJ4
eF9xdWV1ZV9yZWNvdmVyeV93b3JrLnBhcnQuMCsweDZjLzB4NzQgW3dsY29yZV0NCj4gICAgIHds
MTJ4eF9xdWV1ZV9yZWNvdmVyeV93b3JrKzB4MjQvMHgzMCBbd2xjb3JlXQ0KPiAgICAgd2wxMjcx
X2NtZF9zZXRfc3RhX2tleSsweDI1OC8weDI1YyBbd2xjb3JlXQ0KPiAgICAgd2wxMjcxX3NldF9r
ZXkrMHg3Yy8weDJkYyBbd2xjb3JlXQ0KPiAgICAgd2xjb3JlX3NldF9rZXkrMHhlNC8weDM2MCBb
d2xjb3JlXQ0KPiAgICAgd2wxOHh4X3NldF9rZXkrMHg0OC8weDFkMCBbd2wxOHh4XQ0KPiAgICAg
d2xjb3JlX29wX3NldF9rZXkrMHhhNC8weDE4MCBbd2xjb3JlXQ0KPiAgICAgaWVlZTgwMjExX2tl
eV9lbmFibGVfaHdfYWNjZWwrMHhiMC8weDJkMCBbbWFjODAyMTFdDQo+ICAgICBpZWVlODAyMTFf
cmVlbmFibGVfa2V5cysweDcwLzB4MTEwIFttYWM4MDIxMV0NCj4gICAgIGllZWU4MDIxMV9yZWNv
bmZpZysweGEwMC8weGNhMCBbbWFjODAyMTFdDQo+ICAgICBpZWVlODAyMTFfcmVzdGFydF93b3Jr
KzB4YzQvMHhmYyBbbWFjODAyMTFdDQo+ICAgICBwcm9jZXNzX29uZV93b3JrKzB4MWNjLzB4MzUw
DQo+ICAgICB3b3JrZXJfdGhyZWFkKzB4MTNjLzB4NDcwDQo+ICAgICBrdGhyZWFkKzB4MTU0LzB4
MTYwDQo+ICAgICByZXRfZnJvbV9mb3JrKzB4MTAvMHgzMA0KPiAgICAtLS1bIGVuZCB0cmFjZSBi
MWY3MjJhYmY5YWY1OTE5IF0tLS0NCj4gICAgd2xjb3JlOiBXQVJOSU5HIGNvdWxkIG5vdCBzZXQg
a2V5cw0KPiAgICB3bGNvcmU6IEVSUk9SIENvdWxkIG5vdCBhZGQgb3IgcmVwbGFjZSBrZXkNCj4g
ICAgd2xhbjA6IGZhaWxlZCB0byBzZXQga2V5ICg0LCBmZjpmZjpmZjpmZjpmZjpmZikgdG8gaGFy
ZHdhcmUgKC01KQ0KPiAgICB3bGNvcmU6IEhhcmR3YXJlIHJlY292ZXJ5IGluIHByb2dyZXNzLiBG
VyB2ZXI6IFJldiA4LjkuMC4wLjc5DQo+ICAgIHdsY29yZTogcGM6IDB4MCwgaGludF9zdHM6IDB4
MDAwMDAwNDAgY291bnQ6IDM5DQo+ICAgIHdsY29yZTogZG93bg0KPiAgICB3bGNvcmU6IGRvd24N
Cj4gICAgaWVlZTgwMjExIHBoeTA6IEhhcmR3YXJlIHJlc3RhcnQgd2FzIHJlcXVlc3RlZA0KPiAg
ICBtbWNfaG9zdCBtbWMwOiBCdXMgc3BlZWQgKHNsb3QgMCkgPSA0MDAwMDBIeiAoc2xvdCByZXEg
NDAwMDAwSHosIGFjdHVhbCA0MDAwMDBIWiBkaXYgPSAwKQ0KPiAgICBtbWNfaG9zdCBtbWMwOiBC
dXMgc3BlZWQgKHNsb3QgMCkgPSAyNTAwMDAwMEh6IChzbG90IHJlcSAyNTAwMDAwMEh6LCBhY3R1
YWwgMjUwMDAwMDBIWiBkaXYgPSAwKQ0KPiAgICB3bGNvcmU6IFBIWSBmaXJtd2FyZSB2ZXJzaW9u
OiBSZXYgOC4yLjAuMC4yNDINCj4gICAgd2xjb3JlOiBmaXJtd2FyZSBib290ZWQgKFJldiA4Ljku
MC4wLjc5KQ0KPiAgICB3bGNvcmU6IEVSUk9SIGNvbW1hbmQgZXhlY3V0ZSBmYWlsdXJlIDE0DQo+
ICAgIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQ0KPiANCj4gVGVzdGVkIG9u
IEhpa2V5IDk3MC4NCj4gDQo+IFRoaXMgcmV2ZXJ0cyBjb21taXQgMmI3YWFkZDNiOWUxN2U4Yjgx
ZWViOGQ5Y2M0Njc1NmFlNDY1ODI2NS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1hdXJvIENhcnZh
bGhvIENoZWhhYiA8bWNoZWhhYitodWF3ZWlAa2VybmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTog
TWF1cm8gQ2FydmFsaG8gQ2hlaGFiIDxtY2hlaGFiK2h1YXdlaUBrZXJuZWwub3JnPg0KDQpBbnkg
dXBkYXRlcz8gSWYgSSBkb24ndCBoZWFyIGFueXRoaW5nIEkgd2lsbCBqdXN0IHF1ZXVlIHRoaXMg
dG8gdjUuOS4NCg0KUmVtaW5kZXIgdG8gbXlzZWxmOiByZW1vdmUgTWF1cm8ncyBkdXBsaWNhdGUg
cy1vLWIgdGFnLCB0aGF0J3MgYSBwYXRjaHdvcmsgYnVnDQoNCi0tIA0KaHR0cHM6Ly9wYXRjaHdv
cmsua2VybmVsLm9yZy9wYXRjaC8xMTczNzE5My8NCg0KaHR0cHM6Ly93aXJlbGVzcy53aWtpLmtl
cm5lbC5vcmcvZW4vZGV2ZWxvcGVycy9kb2N1bWVudGF0aW9uL3N1Ym1pdHRpbmdwYXRjaGVzDQoN
Cg==
