Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABAC38212
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 02:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfFGAXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 20:23:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:11184 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbfFGAXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 20:23:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 17:23:10 -0700
X-ExtLoop1: 1
Received: from pgsmsx105.gar.corp.intel.com ([10.221.44.96])
  by fmsmga006.fm.intel.com with ESMTP; 06 Jun 2019 17:23:08 -0700
Received: from pgsmsx114.gar.corp.intel.com ([169.254.4.99]) by
 PGSMSX105.gar.corp.intel.com ([169.254.4.53]) with mapi id 14.03.0415.000;
 Fri, 7 Jun 2019 08:23:07 +0800
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH net-next v6 2/5] net: stmmac: introducing support for
 DWC xPCS logics
Thread-Topic: [PATCH net-next v6 2/5] net: stmmac: introducing support for
 DWC xPCS logics
Thread-Index: AQHVGsR8mZhQFRvu0EOiETyHTmqFxaaLcWMAgAET3gCAATg0IA==
Date:   Fri, 7 Jun 2019 00:23:06 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B75C12D381@pgsmsx114.gar.corp.intel.com>
References: <1559674736-2190-1-git-send-email-weifeng.voon@intel.com>
 <1559674736-2190-3-git-send-email-weifeng.voon@intel.com>
 <05cf54dc-7c40-471e-f08a-7fdf5fe4ef54@gmail.com>
 <78EB27739596EE489E55E81C33FEC33A0B93EF69@DE02WEMBXB.internal.synopsys.com>
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B93EF69@DE02WEMBXB.internal.synopsys.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMmQ4ZWFhNWMtOTIxZS00YmRmLWJhNDUtZTkxZDZkMTQ2ZDBmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNzY2c2YxY0p5Z2RUcVwvM3RWOTFabHVBaHBvR3ZKZm1aUUV3dGNoWWsrdWtYSG1hRW5YcEpGc0lVWVVKUWxsclwvIn0=
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogSm9zZSBBYnJldSBbbWFpbHRvOkpv
c2UuQWJyZXVAc3lub3BzeXMuY29tXQ0KPlNlbnQ6IFdlZG5lc2RheSwgSnVuZSA1LCAyMDE5IDk6
MTMgUE0NCj5UbzogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+OyBWb29u
LCBXZWlmZW5nDQo+PHdlaWZlbmcudm9vbkBpbnRlbC5jb20+OyBEYXZpZCBTLiBNaWxsZXIgPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPk1heGltZSBDb3F1ZWxpbiA8bWNvcXVlbGluLnN0bTMyQGdt
YWlsLmNvbT47IFJ1c3NlbGwgS2luZw0KPjxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+Q2M6IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEdpdXNl
cHBlDQo+Q2F2YWxsYXJvIDxwZXBwZS5jYXZhbGxhcm9Ac3QuY29tPjsgQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPjsNCj5BbGV4YW5kcmUgVG9yZ3VlIDxhbGV4YW5kcmUudG9yZ3VlQHN0LmNv
bT47IGJpYW8gaHVhbmcNCj48Ymlhby5odWFuZ0BtZWRpYXRlay5jb20+OyBPbmcsIEJvb24gTGVv
bmcNCj48Ym9vbi5sZW9uZy5vbmdAaW50ZWwuY29tPjsgS3dlaCwgSG9jayBMZW9uZw0KPjxob2Nr
Lmxlb25nLmt3ZWhAaW50ZWwuY29tPg0KPlN1YmplY3Q6IFJFOiBbUEFUQ0ggbmV0LW5leHQgdjYg
Mi81XSBuZXQ6IHN0bW1hYzogaW50cm9kdWNpbmcgc3VwcG9ydCBmb3INCj5EV0MgeFBDUyBsb2dp
Y3MNCj4NCj5Gcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4N
Cj4+ICtSdXNzZWxsLA0KPj4NCj4+IE9uIDYvNC8yMDE5IDExOjU4IEFNLCBWb29uIFdlaWZlbmcg
d3JvdGU6DQo+PiA+IEZyb206IE9uZyBCb29uIExlb25nIDxib29uLmxlb25nLm9uZ0BpbnRlbC5j
b20+DQo+PiA+DQo+PiA+IHhQQ1MgaXMgRFdDIEV0aGVybmV0IFBoeXNpY2FsIENvZGluZyBTdWJs
YXllciB0aGF0IG1heSBiZSBpbnRlZ3JhdGVkDQo+PiA+IGludG8gYSBHYkUgY29udHJvbGxlciB0
aGF0IHVzZXMgRFdDIEVRb1MgTUFDIGNvbnRyb2xsZXIuIEFuIGV4YW1wbGUgb2YNCj4+ID4gSFcg
Y29uZmlndXJhdGlvbiBpcyBzaG93biBiZWxvdzotDQo+PiA+DQo+PiA+ICAgPC0tLS0tLS0tLS0t
LS0tLS0tR0JFIENvbnRyb2xsZXItLS0tLS0tLS0tPnw8LS1FeHRlcm5hbCBQSFkgY2hpcC0tPg0K
Pj4gPg0KPj4gPiAgICstLS0tLS0tLS0tKyAgICAgICAgICstLS0tKyAgICArLS0tKyAgICAgICAg
ICAgICAgICstLS0tLS0tLS0tLS0tLSsNCj4+ID4gICB8ICAgRVFvUyAgIHwgPC1HTUlJLT58IERX
IHw8LS0+fFBIWXwgPC0tIFNHTUlJIC0tPiB8IEV4dGVybmFsIEdiRSB8DQo+PiA+ICAgfCAgIE1B
QyAgICB8ICAgICAgICAgfHhQQ1N8ICAgIHxJRiB8ICAgICAgICAgICAgICAgfCBQSFkgQ2hpcCAg
ICAgfA0KPj4gPiAgICstLS0tLS0tLS0tKyAgICAgICAgICstLS0tKyAgICArLS0tKyAgICAgICAg
ICAgICAgICstLS0tLS0tLS0tLS0tLSsNCj4+ID4gICAgICAgICAgXiAgICAgICAgICAgICAgIF4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXg0KPj4gPiAgICAgICAgICB8ICAgICAg
ICAgICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8DQo+PiA+ICAgICAg
ICAgICstLS0tLS0tLS0tLS0tLS0tLS0tLS1NRElPLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsN
Cj4+ID4NCj4+ID4geFBDUyBpcyBhIENsYXVzZS00NSBNRElPIE1hbmFnZWFibGUgRGV2aWNlIChN
TUQpIGFuZCB3ZSBuZWVkIGEgd2F5DQo+dG8NCj4+ID4gZGlmZmVyZW50aWF0ZSBpdCBmcm9tIGV4
dGVybmFsIFBIWSBjaGlwIHRoYXQgaXMgZGlzY292ZXJlZCBvdmVyIE1ESU8uDQo+PiA+IFRoZXJl
Zm9yZSwgeHBjc19waHlfYWRkciBpcyBpbnRyb2R1Y2VkIGluIHN0bW1hYyBwbGF0Zm9ybSBkYXRh
DQo+PiA+IChwbGF0X3N0bW1hY2VuZXRfZGF0YSkgZm9yIGRpZmZlcmVudGlhdGluZyB4UENTIGZy
b20gJ3BoeV9hZGRyJyB0aGF0DQo+PiA+IGJlbG9uZ3MgdG8gZXh0ZXJuYWwgUEhZLg0KPj4NCj4+
IEFzc3VtaW5nIHRoaXMgRFcgeFBDUyBjYW4gYmUgZm91bmQgd2l0aCBkZXNpZ25zIG90aGVyIHRo
YW4gU1RNTUFDDQo+d291bGQNCj4+IG5vdCBpdCBtYWtlIHNlbnNlIHRvIG1vZGVsIHRoaXMgYXMg
c29tZSBraW5kIG9mIFBIWS9NRElPIGJyaWRnZT8gQQ0KPj4gbGl0dGxlIGJpdCBsaWtlIHdoYXQg
ZHJpdmVycy9uZXQvcGh5L3hpbGlueF9nbWlpMnJnbWlpLmMgdHJpZXMgdG8gZG8/DQo+DQo+WWVz
LCBEVyBYUENTIGlzIGEgc2VwYXJhdGUgSVAgdGhhdCBjYW4gYmUgc29sZCB3aXRob3V0IHRoZSBN
QUMuDQoNCkhpIEZsb3JpYW4sIHRoYW5rcyBmb3IgcG9pbnRpbmcgb3V0IHRoZSBQSFkgZHJpdmVy
IGZvciBHTUlJIHRvIFJHTUlJIGNvbnZlcnRlcg0KaW1wbGVtZW50YXRpb24uIEl0IHNlZW1zIGxp
a2UgY29tbXVuaXR5IHdvdWxkIGxpa2UgZHd4cGNzIHRvIHRha2UgdGhlDQpjb252ZXJ0ZXIgcGh5
IGRyaXZlciBkaXJlY3Rpb24uIA0KDQpXZSB3b3VsZCBsaWtlIHRvIGNoZWNrIHdpdGggY29tbXVu
aXR5IHdoYXQgaXMgdGhlIE1BQyBjb250cm9sbGVyIHRoYXQgaXMNCnVzaW5nIGFib3ZlIFBIWSBk
cml2ZXIgc28gdGhhdCB3ZSBjYW4gZGlnIGRlZXBlciBpbnRvIHRoZSBQSFkgJiBNQUMgZHJpdmVy
DQphcmNoaXRlY3R1cmUuIFdlIHdvdWxkIGxpa2UgdG8gbWFwIHRoZSBleGlzdGluZyB1c2FnZSBv
ZiBkd3hwY3MuYyBpbiAzLzUgb2YNCnRoaXMgc2VyaWVzIGlzIGFyY2hpdGVjdHVyYWxseSByZWFk
eSBmb3IgUEhZIGRyaXZlciBmcmFtZXdvcmsgb3IgbmV3IEFQSXMNCndvdWxkIG5lZWQgdG8gYmUg
ZGVmaW5lZC4gDQoNClRoYW5rcw0KQm9vbiBMZW9uZw0K
