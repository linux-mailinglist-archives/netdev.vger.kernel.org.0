Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30174C6B3
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 07:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbfFTFNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 01:13:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:48862 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfFTFNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 01:13:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 22:13:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,395,1557212400"; 
   d="scan'208";a="154011514"
Received: from pgsmsx105.gar.corp.intel.com ([10.221.44.96])
  by orsmga008.jf.intel.com with ESMTP; 19 Jun 2019 22:13:39 -0700
Received: from pgsmsx114.gar.corp.intel.com ([169.254.4.160]) by
 PGSMSX105.gar.corp.intel.com ([169.254.4.28]) with mapi id 14.03.0439.000;
 Thu, 20 Jun 2019 13:13:38 +0800
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        biao huang <biao.huang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Voon, Weifeng" <weifeng.voon@intel.com>
Subject: RE: [PATCH net-next v6 2/5] net: stmmac: introducing support for
 DWC xPCS logics
Thread-Topic: [PATCH net-next v6 2/5] net: stmmac: introducing support for
 DWC xPCS logics
Thread-Index: AQHVGsR8mZhQFRvu0EOiETyHTmqFxaaLcWMAgAET3gCAATg0IIAWWfBQ
Date:   Thu, 20 Jun 2019 05:13:38 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B75C17F73B@pgsmsx114.gar.corp.intel.com>
References: <1559674736-2190-1-git-send-email-weifeng.voon@intel.com>
 <1559674736-2190-3-git-send-email-weifeng.voon@intel.com>
 <05cf54dc-7c40-471e-f08a-7fdf5fe4ef54@gmail.com>
 <78EB27739596EE489E55E81C33FEC33A0B93EF69@DE02WEMBXB.internal.synopsys.com>
 <AF233D1473C1364ABD51D28909A1B1B75C12D381@pgsmsx114.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B75C12D381@pgsmsx114.gar.corp.intel.com>
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

Pj5Gcm9tOiBKb3NlIEFicmV1IFttYWlsdG86Sm9zZS5BYnJldUBzeW5vcHN5cy5jb21dDQo+PkZy
b206IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPj4NCj4+PiArUnVz
c2VsbCwNCj4+Pg0KPj4+IE9uIDYvNC8yMDE5IDExOjU4IEFNLCBWb29uIFdlaWZlbmcgd3JvdGU6
DQo+Pj4gPiBGcm9tOiBPbmcgQm9vbiBMZW9uZyA8Ym9vbi5sZW9uZy5vbmdAaW50ZWwuY29tPg0K
Pj4+ID4NCj4+PiA+IHhQQ1MgaXMgRFdDIEV0aGVybmV0IFBoeXNpY2FsIENvZGluZyBTdWJsYXll
ciB0aGF0IG1heSBiZSBpbnRlZ3JhdGVkDQo+Pj4gPiBpbnRvIGEgR2JFIGNvbnRyb2xsZXIgdGhh
dCB1c2VzIERXQyBFUW9TIE1BQyBjb250cm9sbGVyLiBBbiBleGFtcGxlIG9mDQo+Pj4gPiBIVyBj
b25maWd1cmF0aW9uIGlzIHNob3duIGJlbG93Oi0NCj4+PiA+DQo+Pj4gPiAgIDwtLS0tLS0tLS0t
LS0tLS0tLUdCRSBDb250cm9sbGVyLS0tLS0tLS0tLT58PC0tRXh0ZXJuYWwgUEhZIGNoaXAtLT4N
Cj4+PiA+DQo+Pj4gPiAgICstLS0tLS0tLS0tKyAgICAgICAgICstLS0tKyAgICArLS0tKyAgICAg
ICAgICAgICAgICstLS0tLS0tLS0tLS0tLSsNCj4+PiA+ICAgfCAgIEVRb1MgICB8IDwtR01JSS0+
fCBEVyB8PC0tPnxQSFl8IDwtLSBTR01JSSAtLT4gfCBFeHRlcm5hbCBHYkUgfA0KPj4+ID4gICB8
ICAgTUFDICAgIHwgICAgICAgICB8eFBDU3wgICAgfElGIHwgICAgICAgICAgICAgICB8IFBIWSBD
aGlwICAgICB8DQo+Pj4gPiAgICstLS0tLS0tLS0tKyAgICAgICAgICstLS0tKyAgICArLS0tKyAg
ICAgICAgICAgICAgICstLS0tLS0tLS0tLS0tLSsNCj4+PiA+ICAgICAgICAgIF4gICAgICAgICAg
ICAgICBeICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF4NCj4+PiA+ICAgICAgICAg
IHwgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4+
PiA+ICAgICAgICAgICstLS0tLS0tLS0tLS0tLS0tLS0tLS1NRElPLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLSsNCj4+PiA+DQo+Pj4gPiB4UENTIGlzIGEgQ2xhdXNlLTQ1IE1ESU8gTWFuYWdlYWJs
ZSBEZXZpY2UgKE1NRCkgYW5kIHdlIG5lZWQgYSB3YXkNCj4+dG8NCj4+PiA+IGRpZmZlcmVudGlh
dGUgaXQgZnJvbSBleHRlcm5hbCBQSFkgY2hpcCB0aGF0IGlzIGRpc2NvdmVyZWQgb3ZlciBNRElP
Lg0KPj4+ID4gVGhlcmVmb3JlLCB4cGNzX3BoeV9hZGRyIGlzIGludHJvZHVjZWQgaW4gc3RtbWFj
IHBsYXRmb3JtIGRhdGENCj4+PiA+IChwbGF0X3N0bW1hY2VuZXRfZGF0YSkgZm9yIGRpZmZlcmVu
dGlhdGluZyB4UENTIGZyb20gJ3BoeV9hZGRyJyB0aGF0DQo+Pj4gPiBiZWxvbmdzIHRvIGV4dGVy
bmFsIFBIWS4NCj4+Pg0KPj4+IEFzc3VtaW5nIHRoaXMgRFcgeFBDUyBjYW4gYmUgZm91bmQgd2l0
aCBkZXNpZ25zIG90aGVyIHRoYW4gU1RNTUFDDQo+PndvdWxkDQo+Pj4gbm90IGl0IG1ha2Ugc2Vu
c2UgdG8gbW9kZWwgdGhpcyBhcyBzb21lIGtpbmQgb2YgUEhZL01ESU8gYnJpZGdlPyBBDQo+Pj4g
bGl0dGxlIGJpdCBsaWtlIHdoYXQgZHJpdmVycy9uZXQvcGh5L3hpbGlueF9nbWlpMnJnbWlpLmMg
dHJpZXMgdG8gZG8/DQo+Pg0KPj5ZZXMsIERXIFhQQ1MgaXMgYSBzZXBhcmF0ZSBJUCB0aGF0IGNh
biBiZSBzb2xkIHdpdGhvdXQgdGhlIE1BQy4NCj4NCj5IaSBGbG9yaWFuLCB0aGFua3MgZm9yIHBv
aW50aW5nIG91dCB0aGUgUEhZIGRyaXZlciBmb3IgR01JSSB0byBSR01JSSBjb252ZXJ0ZXINCj5p
bXBsZW1lbnRhdGlvbi4gSXQgc2VlbXMgbGlrZSBjb21tdW5pdHkgd291bGQgbGlrZSBkd3hwY3Mg
dG8gdGFrZSB0aGUNCj5jb252ZXJ0ZXIgcGh5IGRyaXZlciBkaXJlY3Rpb24uDQo+DQo+V2Ugd291
bGQgbGlrZSB0byBjaGVjayB3aXRoIGNvbW11bml0eSB3aGF0IGlzIHRoZSBNQUMgY29udHJvbGxl
ciB0aGF0IGlzDQo+dXNpbmcgYWJvdmUgUEhZIGRyaXZlciBzbyB0aGF0IHdlIGNhbiBkaWcgZGVl
cGVyIGludG8gdGhlIFBIWSAmIE1BQyBkcml2ZXINCj5hcmNoaXRlY3R1cmUuIFdlIHdvdWxkIGxp
a2UgdG8gbWFwIHRoZSBleGlzdGluZyB1c2FnZSBvZiBkd3hwY3MuYyBpbiAzLzUgb2YNCj50aGlz
IHNlcmllcyBpcyBhcmNoaXRlY3R1cmFsbHkgcmVhZHkgZm9yIFBIWSBkcml2ZXIgZnJhbWV3b3Jr
IG9yIG5ldyBBUElzDQo+d291bGQgbmVlZCB0byBiZSBkZWZpbmVkLg0KDQpKdXN0IHRvIGN5Y2xl
LWJhY2sgdG8gdGhpcyB0cmFjaywgd2UgYXJlIHdvcmtpbmcgdG93YXJkcyBnZXR0aW5nIHRoZSBB
Q1BJIGRldmljZQ0KSUQgZm9yIHRoaXMgSVAuIE1lYW53aGlsZSwgc2luY2UgdGhlIEM0NSBNRElP
IHBhdHljaCBpcyBhbHNvIG5lZWRlZCBieSANCkJpYW8sIHdlIHBsYW4gdG8gbGluZSB1cCB0aGUg
YmVsb3cgcGF0Y2ggZm9yIG1lcmdlLg0KDQpbUEFUQ0ggbmV0LW5leHQgdjYgMS81XSBuZXQ6IHN0
bW1hYzogZW5hYmxlIGNsYXVzZSA0NSBtZGlvIHN1cHBvcnQNCg0KSXMgdGhlcmUgYW55IGNvbmNl
cm4gd2l0aCB0aGlzIGFwcHJvYWNoPyANCg==
