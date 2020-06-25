Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C745920A877
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406783AbgFYW56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 18:57:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:5887 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgFYW55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 18:57:57 -0400
IronPort-SDR: KBKHbv3xo91UaaadV6hCcUbtnk0yvnz2tj6p1vtUTpRzGGFnvWh7eAmV/U/2j96TMbkRS2uoqo
 MsmW1rVX+4tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="229853708"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="229853708"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 15:57:49 -0700
IronPort-SDR: Pan6v6R/kVDYcZOeII3Ys0Fj6VCia2mijRDHPZPUPWfbuvJSpI/BbjHrPxB5O8THTJY3U3eEqq
 3zwOAFGzf2NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="479806462"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga005.fm.intel.com with ESMTP; 25 Jun 2020 15:57:49 -0700
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.87]) by
 FMSMSX105.amr.corp.intel.com ([169.254.4.212]) with mapi id 14.03.0439.000;
 Thu, 25 Jun 2020 15:57:48 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Amit Cohen <amitc@mellanox.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "petrm@mellanox.com" <petrm@mellanox.com>,
        "mlxsw@mellanox.com" <mlxsw@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        Ido Schimmel <idosch@mellanox.com>
Subject: RE: [PATCH net-next 04/10] Documentation: networking:
 ethtool-netlink: Add link extended state
Thread-Topic: [PATCH net-next 04/10] Documentation: networking:
 ethtool-netlink: Add link extended state
Thread-Index: AQHWSgBTOFMxa+mr30+OzF8I7DXdgajoMjOAgAGZ7wCAACeDEA==
Date:   Thu, 25 Jun 2020 22:57:48 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C263AE4C@fmsmsx101.amr.corp.intel.com>
References: <20200624081923.89483-1-idosch@idosch.org>
 <20200624081923.89483-5-idosch@idosch.org>
 <b8aca89b-02f1-047c-a582-dacebfb8e480@intel.com>
 <9718cf64-544a-9efb-409d-ada7c2d927f1@mellanox.com>
In-Reply-To: <9718cf64-544a-9efb-409d-ada7c2d927f1@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW1pdCBDb2hlbiA8YW1p
dGNAbWVsbGFub3guY29tPg0KPiBTZW50OiBUaHVyc2RheSwgSnVuZSAyNSwgMjAyMCA2OjM1IEFN
DQo+IFRvOiBLZWxsZXIsIEphY29iIEUgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4gQ2M6
IElkbyBTY2hpbW1lbCA8aWRvc2NoQGlkb3NjaC5vcmc+OyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IGppcmlAbWVsbGFub3gu
Y29tOw0KPiBwZXRybUBtZWxsYW5veC5jb207IG1seHN3QG1lbGxhbm94LmNvbTsgbWt1YmVjZWtA
c3VzZS5jejsNCj4gYW5kcmV3QGx1bm4uY2g7IGYuZmFpbmVsbGlAZ21haWwuY29tOyBsaW51eEBy
ZW1wZWwtcHJpdmF0LmRlOyBJZG8gU2NoaW1tZWwNCj4gPGlkb3NjaEBtZWxsYW5veC5jb20+DQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDQvMTBdIERvY3VtZW50YXRpb246IG5ldHdv
cmtpbmc6IGV0aHRvb2wtDQo+IG5ldGxpbms6IEFkZCBsaW5rIGV4dGVuZGVkIHN0YXRlDQo+IA0K
PiBPbiAyNC1KdW4tMjAgMjI6MDcsIEphY29iIEtlbGxlciB3cm90ZToNCj4gPg0KPiA+DQo+ID4g
T24gNi8yNC8yMDIwIDE6MTkgQU0sIElkbyBTY2hpbW1lbCB3cm90ZToNCj4gPj4gRnJvbTogQW1p
dCBDb2hlbiA8YW1pdGNAbWVsbGFub3guY29tPg0KPiA+Pg0KPiA+PiBBZGQgbGluayBleHRlbmRl
ZCBzdGF0ZSBhdHRyaWJ1dGVzLg0KPiA+Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBBbWl0IENvaGVu
IDxhbWl0Y0BtZWxsYW5veC5jb20+DQo+ID4+IFJldmlld2VkLWJ5OiBQZXRyIE1hY2hhdGEgPHBl
dHJtQG1lbGxhbm94LmNvbT4NCj4gPj4gUmV2aWV3ZWQtYnk6IEppcmkgUGlya28gPGppcmlAbWVs
bGFub3guY29tPg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBJZG8gU2NoaW1tZWwgPGlkb3NjaEBtZWxs
YW5veC5jb20+DQo+ID4NCj4gPiBJIHJlYWxseSBsaWtlIHRoaXMgY29uY2VwdC4NCj4gPg0KPiA+
IFJldmlld2VkLWJ5OiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4g
Pg0KPiA+PiAtLS0NCj4gPj4gIERvY3VtZW50YXRpb24vbmV0d29ya2luZy9ldGh0b29sLW5ldGxp
bmsucnN0IHwgMTEwDQo+ICsrKysrKysrKysrKysrKysrKy0NCj4gPj4gIDEgZmlsZSBjaGFuZ2Vk
LCAxMDYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPj4NCj4gPj4gZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9ldGh0b29sLW5ldGxpbmsucnN0DQo+IGIvRG9j
dW1lbnRhdGlvbi9uZXR3b3JraW5nL2V0aHRvb2wtbmV0bGluay5yc3QNCj4gPj4gaW5kZXggODI0
NzBjMzZjMjdhLi5hN2NjNTNmOTA1ZjUgMTAwNjQ0DQo+ID4+IC0tLSBhL0RvY3VtZW50YXRpb24v
bmV0d29ya2luZy9ldGh0b29sLW5ldGxpbmsucnN0DQo+ID4+ICsrKyBiL0RvY3VtZW50YXRpb24v
bmV0d29ya2luZy9ldGh0b29sLW5ldGxpbmsucnN0DQo+ID4+IEBAIC00NDMsMTAgKzQ0MywxMSBA
QCBzdXBwb3J0cy4NCj4gPj4gIExJTktTVEFURV9HRVQNCj4gPj4gID09PT09PT09PT09PT0NCj4g
Pj4NCj4gPj4gLVJlcXVlc3RzIGxpbmsgc3RhdGUgaW5mb3JtYXRpb24uIEF0IHRoZSBtb21lbnQs
IG9ubHkgbGluayB1cC9kb3duIGZsYWcgKGFzDQo+ID4+IC1wcm92aWRlZCBieSBgYEVUSFRPT0xf
R0xJTktgYCBpb2N0bCBjb21tYW5kKSBpcyBwcm92aWRlZCBidXQgc29tZSBmdXR1cmUNCj4gPj4g
LWV4dGVuc2lvbnMgYXJlIHBsYW5uZWQgKGUuZy4gbGluayBkb3duIHJlYXNvbikuIFRoaXMgcmVx
dWVzdCBkb2VzIG5vdCBoYXZlDQo+IGFueQ0KPiA+PiAtYXR0cmlidXRlcy4NCj4gPj4gK1JlcXVl
c3RzIGxpbmsgc3RhdGUgaW5mb3JtYXRpb24uIExpbmsgdXAvZG93biBmbGFnIChhcyBwcm92aWRl
ZCBieQ0KPiA+PiArYGBFVEhUT09MX0dMSU5LYGAgaW9jdGwgY29tbWFuZCkgaXMgcHJvdmlkZWQu
IE9wdGlvbmFsbHksIGV4dGVuZGVkIHN0YXRlDQo+IG1pZ2h0DQo+ID4+ICtiZSBwcm92aWRlZCBh
cyB3ZWxsLiBJbiBnZW5lcmFsLCBleHRlbmRlZCBzdGF0ZSBkZXNjcmliZXMgcmVhc29ucyBmb3Ig
d2h5IGENCj4gcG9ydA0KPiA+PiAraXMgZG93biwgb3Igd2h5IGl0IG9wZXJhdGVzIGluIHNvbWUg
bm9uLW9idmlvdXMgbW9kZS4gVGhpcyByZXF1ZXN0IGRvZXMNCj4gbm90IGhhdmUNCj4gPj4gK2Fu
eSBhdHRyaWJ1dGVzLg0KPiA+Pg0KPiA+DQo+ID4gT2ssIHNvIGJhc2ljYWxseSBpbiBhZGRpdGlv
biB0byB0aGUgc3RhbmRhcmQgRVRIVE9PTF9HTElOSyBkYXRhLCB3ZSBhbHNvDQo+ID4gYWRkIGFk
ZGl0aW9uYWwgb3B0aW9uYWwgZXh0ZW5kZWQgYXR0cmlidXRlcyBvdmVyIHRoZSBuZXRsaW5rIGlu
dGVyZmFjZS4NCj4gPiBOZWF0Lg0KPiA+DQo+ID4+ICBSZXF1ZXN0IGNvbnRlbnRzOg0KPiA+Pg0K
PiA+PiBAQCAtNDYxLDE2ICs0NjIsMTE3IEBAIEtlcm5lbCByZXNwb25zZSBjb250ZW50czoNCj4g
Pj4gICAgYGBFVEhUT09MX0FfTElOS1NUQVRFX0xJTktgYCAgICAgICAgICBib29sICAgIGxpbmsg
c3RhdGUgKHVwL2Rvd24pDQo+ID4+ICAgIGBgRVRIVE9PTF9BX0xJTktTVEFURV9TUUlgYCAgICAg
ICAgICAgdTMyICAgICBDdXJyZW50IFNpZ25hbCBRdWFsaXR5IEluZGV4DQo+ID4+ICAgIGBgRVRI
VE9PTF9BX0xJTktTVEFURV9TUUlfTUFYYGAgICAgICAgdTMyICAgICBNYXggc3VwcG9ydCBTUUkg
dmFsdWUNCj4gPj4gKyAgYGBFVEhUT09MX0FfTElOS1NUQVRFX0VYVF9TVEFURWBgICAgICB1OCAg
ICAgIGxpbmsgZXh0ZW5kZWQgc3RhdGUNCj4gPj4gKyAgYGBFVEhUT09MX0FfTElOS1NUQVRFX0VY
VF9TVUJTVEFURWBgICB1OCAgICAgIGxpbmsgZXh0ZW5kZWQgc3Vic3RhdGUNCj4gPj4gICAgPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ICA9PT09PT0NCj4gPT09PT09PT09PT09
PT09PT09PT09PT09PT09PQ0KPiA+DQo+ID4gT2sgc28gd2UgaGF2ZSBjYXRlZ29yaWVzIChzdGF0
ZSkgYW5kIGVhY2ggY2F0ZWdvcnkgY2FuIGhhdmUgc3ViLXN0YXRlcw0KPiA+IGluZGljYXRpbmcg
dGhlIHNwZWNpZmljIGZhaWx1cmUuIEdvb2QuDQo+ID4NCj4gPj4NCj4gPj4gIEZvciBtb3N0IE5J
QyBkcml2ZXJzLCB0aGUgdmFsdWUgb2YgYGBFVEhUT09MX0FfTElOS1NUQVRFX0xJTktgYCByZXR1
cm5zDQo+ID4+ICBjYXJyaWVyIGZsYWcgcHJvdmlkZWQgYnkgYGBuZXRpZl9jYXJyaWVyX29rKClg
YCBidXQgdGhlcmUgYXJlIGRyaXZlcnMgd2hpY2gNCj4gPj4gIGRlZmluZSB0aGVpciBvd24gaGFu
ZGxlci4NCj4gPj4NCj4gPj4gK2BgRVRIVE9PTF9BX0xJTktTVEFURV9FWFRfU1RBVEVgYCBhbmQN
Cj4gYGBFVEhUT09MX0FfTElOS1NUQVRFX0VYVF9TVUJTVEFURWBgIGFyZQ0KPiA+PiArb3B0aW9u
YWwgdmFsdWVzLiBldGh0b29sIGNvcmUgY2FuIHByb3ZpZGUgZWl0aGVyIGJvdGgNCj4gPj4gK2Bg
RVRIVE9PTF9BX0xJTktTVEFURV9FWFRfU1RBVEVgYCBhbmQNCj4gYGBFVEhUT09MX0FfTElOS1NU
QVRFX0VYVF9TVUJTVEFURWBgLA0KPiA+PiArb3Igb25seSBgYEVUSFRPT0xfQV9MSU5LU1RBVEVf
RVhUX1NUQVRFYGAsIG9yIG5vbmUgb2YgdGhlbS4NCj4gPj4gKw0KPiA+PiAgYGBMSU5LU1RBVEVf
R0VUYGAgYWxsb3dzIGR1bXAgcmVxdWVzdHMgKGtlcm5lbCByZXR1cm5zIHJlcGx5IG1lc3NhZ2Vz
IGZvcg0KPiBhbGwNCj4gPj4gIGRldmljZXMgc3VwcG9ydGluZyB0aGUgcmVxdWVzdCkuDQo+ID4+
DQo+ID4NCj4gPiBHb29kIHRvIGNsYXJpZnkgdGhhdCBpdCBpcyBhbGxvd2VkIHRvIHNwZWNpZnkg
b25seSB0aGUgbWFpbiBzdGF0ZSwgaWYgYQ0KPiA+IHN1YnN0YXRlIGlzbid0IGtub3duLg0KPiA+
DQo+IA0KPiBJIGRlc2NyaWJlZCBhYm92ZSBhbGwgdGhlIG9wdGlvbnM6DQo+ICJldGh0b29sIGNv
cmUgY2FuIHByb3ZpZGUgZWl0aGVyICgxKSBib3RoIGBgRVRIVE9PTF9BX0xJTktTVEFURV9FWFRf
U1RBVEVgYA0KPiBhbmQgYGBFVEhUT09MX0FfTElOS1NUQVRFX0VYVF9TVUJTVEFURWBgLCBvciAo
Mikgb25seQ0KPiBgYEVUSFRPT0xfQV9MSU5LU1RBVEVfRVhUX1NUQVRFYGAsDQo+IG9yICgzKSBu
b25lIG9mIHRoZW0iDQo+IA0KPiBJIHRoaW5rIHRoYXQgIzIgaXMgd2hhdCB5b3Ugd2FudCwgbm8/
DQo+IA0KDQpJIG1lYW50IHRoaXMgYXMgYSAiZXhjZWxsZW50LCBJJ20gZ2xhZCB0aGlzIGlzIGRv
bmUiLCBub3QgYXMgYSAicGxlYXNlIGRvIHNvbWV0aGluZyIuDQoNClRoYW5rcywNCkpha2UNCg==
