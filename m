Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB261501E5
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 08:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgBCHNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 02:13:32 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:57735 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgBCHNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 02:13:32 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 0137DFdH030827, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTEXMB06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 0137DFdH030827
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 3 Feb 2020 15:13:15 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 3 Feb 2020 15:13:15 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Mon, 3 Feb 2020 15:13:15 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
CC:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pmalani@chromium.org" <pmalani@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH firmware] rtl_nic: add firmware files for RTL8153
Thread-Topic: [PATCH firmware] rtl_nic: add firmware files for RTL8153
Thread-Index: AQHV2VLrzTv7CoVKskqY/uIKMmduMqgJDI5A
Date:   Mon, 3 Feb 2020 07:13:15 +0000
Message-ID: <d0d5529f59e643338b7a9cf73f8e7f03@realtek.com>
References: <1394712342-15778-335-Taiwan-albertk@realtek.com>
 <cea329a9-943b-7c15-ffb4-5e58b04d35e3@maciej.szmigiero.name>
In-Reply-To: <cea329a9-943b-7c15-ffb4-5e58b04d35e3@maciej.szmigiero.name>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWFjaWVqIFMuIFN6bWlnaWVybyBbbWFpbHRvOm1haWxAbWFjaWVqLnN6bWlnaWVyby5uYW1lXQ0K
PiBTZW50OiBTdW5kYXksIEZlYnJ1YXJ5IDAyLCAyMDIwIDY6NTcgQU0NClsuLi5dDQo+IFRoaXMg
ZmlsZSBmYWlscyB0byBsb2FkIGZvciBtZToNCj4gdGhvc3Qga2VybmVsOiBbIFQyNTAzXSByODE1
MiAxLTM6MS4wOiB1bnVzZWQgYnA1IGlzIG5vdCB6ZXJvDQo+IHRob3N0IGtlcm5lbDogWyBUMjUw
M10gcjgxNTIgMS0zOjEuMDogY2hlY2sgVVNCIGZpcm13YXJlIGZhaWxlZA0KPiB0aG9zdCBrZXJu
ZWw6IFsgVDI1MDNdIHI4MTUyIDEtMzoxLjA6IHVuYWJsZSB0byBsb2FkIGZpcm13YXJlIHBhdGNo
DQo+IHJ0bF9uaWMvcnRsODE1M2EtNC5mdyAoLTE0KQ0KPiANCj4gTG9va2luZyBhdCB0aGUgYWJv
dmUgZmlsZSBpdCBoYXMgZndfbWFjLT5icF9udW0gc2V0IHRvIDUsDQo+IGJ1dCBmd19tYWMtPmJw
W10gYXJyYXkgaGFzIDYgZWxlbWVudHMgZmlsbGVkLg0KPiANCj4gSWYgSSBmb3JjZSBmd19tYWMt
PmJwX251bSB0byA2IGluIHRoZSBjb2RlIGl0IGxvYWRzIHN1Y2Nlc3NmdWxseSwNCj4gc28gcGVy
aGFwcyBpdCdzIGEgbWlzdGFrZSBpbiB0aGUgZmlybXdhcmUgaGVhZGVyPw0KDQpZZXMuIEkgdXBk
YXRlZCB0aGUgZmlybXdhcmUgYW5kIGZvcmdvdCB0byBtb2RpZnkgdGhlIGJwX251bQ0KYmVmb3Jl
IHJlbGVhc2luZyBpdC4gSSB3aWxsIGZpeCBpdC4gVGhhbmtzLg0KDQpCZXN0IFJlZ2FyZHMsDQpI
YXllcw0K
