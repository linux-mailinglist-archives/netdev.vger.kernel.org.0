Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D56292E27
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgJSTGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:06:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:28167 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730975AbgJSTGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 15:06:04 -0400
IronPort-SDR: yYHiRwqpJWDLpfVSDdTLLYblMZecw7J/XW5pqftl1SjeFmJNcFDchJrV81Gbn8wAYBlQjSXro4
 h4zEaD7XcWAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="164474232"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="164474232"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 12:06:01 -0700
IronPort-SDR: vF4U9Cw6jM3JeIIkSoPVjlgGhxSUHGXS3EBo1OrDabF1Ulhc1TKPFxbB1+HX3HuvZNBKqY087h
 RzexSZSXAL3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="347550174"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 19 Oct 2020 12:06:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 19 Oct 2020 12:05:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 19 Oct 2020 12:05:34 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.1713.004;
 Mon, 19 Oct 2020 12:05:34 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     Shannon Nelson <snelson@pensando.io>
Subject: RE: [iproute2-next v3] devlink: display elapsed time during flash
 update
Thread-Topic: [iproute2-next v3] devlink: display elapsed time during flash
 update
Thread-Index: AQHWonnWKtoNJhPZsE2hQ2IktOcUK6mcZoKAgALpatA=
Date:   Mon, 19 Oct 2020 19:05:34 +0000
Message-ID: <a6814a14af5c45fbad329b9a4f59b4a8@intel.com>
References: <20201014223104.3494850-1-jacob.e.keller@intel.com>
 <f510e3b5-b856-e1a0-3c2b-149b85f9588f@gmail.com>
In-Reply-To: <f510e3b5-b856-e1a0-3c2b-149b85f9588f@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVy
bkBnbWFpbC5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBPY3RvYmVyIDE3LCAyMDIwIDg6MzUgQU0N
Cj4gVG86IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPjsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgSmlyaSBQaXJrbw0KPiA8amlyaUByZXNudWxsaS51cz4NCj4gQ2M6
IFNoYW5ub24gTmVsc29uIDxzbmVsc29uQHBlbnNhbmRvLmlvPg0KPiBTdWJqZWN0OiBSZTogW2lw
cm91dGUyLW5leHQgdjNdIGRldmxpbms6IGRpc3BsYXkgZWxhcHNlZCB0aW1lIGR1cmluZyBmbGFz
aCB1cGRhdGUNCj4gDQo+IE9uIDEwLzE0LzIwIDQ6MzEgUE0sIEphY29iIEtlbGxlciB3cm90ZToN
Cj4gPiBGb3Igc29tZSBkZXZpY2VzLCB1cGRhdGluZyB0aGUgZmxhc2ggY2FuIHRha2Ugc2lnbmlm
aWNhbnQgdGltZSBkdXJpbmcNCj4gPiBvcGVyYXRpb25zIHdoZXJlIG5vIHN0YXR1cyBjYW4gbWVh
bmluZ2Z1bGx5IGJlIHJlcG9ydGVkLiBUaGlzIGNhbiBiZQ0KPiA+IHNvbWV3aGF0IGNvbmZ1c2lu
ZyB0byBhIHVzZXIgd2hvIHNlZXMgZGV2bGluayBhcHBlYXIgdG8gaGFuZyBvbiB0aGUNCj4gPiB0
ZXJtaW5hbCB3YWl0aW5nIGZvciB0aGUgZGV2aWNlIHRvIHVwZGF0ZS4NCj4gPg0KPiA+IFJlY2Vu
dCBjaGFuZ2VzIHRvIHRoZSBrZXJuZWwgaW50ZXJmYWNlIGFsbG93IHN1Y2ggbG9uZyBydW5uaW5n
IGNvbW1hbmRzDQo+ID4gdG8gcHJvdmlkZSBhIHRpbWVvdXQgdmFsdWUgaW5kaWNhdGluZyBzb21l
IHVwcGVyIGJvdW5kIG9uIGhvdyBsb25nIHRoZQ0KPiA+IHJlbGV2YW50IGFjdGlvbiBjb3VsZCB0
YWtlLg0KPiA+DQo+ID4gUHJvdmlkZSBhIHRpY2tpbmcgY291bnRlciBvZiB0aGUgdGltZSBlbGFw
c2VkIHNpbmNlIHRoZSBwcmV2aW91cyBzdGF0dXMNCj4gPiBtZXNzYWdlIGluIG9yZGVyIHRvIG1h
a2UgaXQgY2xlYXIgdGhhdCB0aGUgcHJvZ3JhbSBpcyBub3Qgc2ltcGx5IHN0dWNrLg0KPiA+DQo+
ID4gRGlzcGxheSB0aGlzIG1lc3NhZ2Ugd2hlbmV2ZXIgdGhlIHN0YXR1cyBtZXNzYWdlIGZyb20g
dGhlIGtlcm5lbA0KPiA+IGluZGljYXRlcyBhIHRpbWVvdXQgdmFsdWUuIEFkZGl0aW9uYWxseSBh
bHNvIGRpc3BsYXkgdGhlIG1lc3NhZ2UgaWYNCj4gPiB3ZSd2ZSByZWNlaXZlZCBubyBzdGF0dXMg
Zm9yIG1vcmUgdGhhbiBjb3VwbGUgb2Ygc2Vjb25kcy4gSWYgd2UgZWxhcHNlDQo+ID4gbW9yZSB0
aGFuIHRoZSB0aW1lb3V0IHByb3ZpZGVkIGJ5IHRoZSBzdGF0dXMgbWVzc2FnZSwgcmVwbGFjZSB0
aGUNCj4gPiB0aW1lb3V0IGRpc3BsYXkgd2l0aCAidGltZW91dCByZWFjaGVkIi4NCj4gPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0K
PiA+IC0tLQ0KPiA+IENoYW5nZXMgc2luY2UgdjINCj4gPiAqIHVzZSBjbG9ja19nZXR0aW1lIG9u
IENMT0NLX01PTk9UT05JQyBpbnN0ZWFkIG9mIGdldHRpbWVvZmRheQ0KPiA+ICogcmVtb3ZlIHVz
ZSBvZiB0aW1lcnN1YiBzaW5jZSB3ZSdyZSBub3cgdXNpbmcgc3RydWN0IHRpbWVzcGVjDQo+ID4N
Cj4gPiAgZGV2bGluay9kZXZsaW5rLmMgfCAxMDUgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTA0IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiANCj4gYXBwbGllZCB0byBpcHJvdXRlMi1uZXh0Lg0K
PiANCj4gVGhlIERFVkxJTksgYXR0cmlidXRlcyBhcmUgcmlkaWN1bG91c2x5IGxvbmcgLS0NCj4g
REVWTElOS19BVFRSX0ZMQVNIX1VQREFURV9TVEFUVVNfVElNRU9VVCBpcyA0MCBjaGFyYWN0ZXJz
IC0tIHdoaWNoDQo+IGZvcmNlcyByZWFsbHkgbG9uZyBjb2RlIGxpbmVzIG9yIG9kZGx5IHdyYXBw
ZWQgbGluZXMuIEdvaW5nIGZvcndhcmQNCj4gcGxlYXNlIGNvbnNpZGVyIGFiYnJldmlhdGlvbnMg
b24gbmFtZSBjb21wb25lbnRzIHRvIHJlZHVjZSB0aGVpciBsZW5ndGhzLg0KDQpUaGlzIGlzIHBy
b2JhYmx5IGEgbGFyZ2VyIGRpc2N1c3Npb24sIHNpbmNlIGJhc2ljYWxseSBldmVyeSBkZXZsaW5r
IGF0dHJpYnV0ZSBuYW1lIGlzIGxvbmcuDQoNCkppcmksIEpha3ViLCBhbnkgdGhvdWdodHMgb24g
dGhpcz8gSSdkIGxpa2UgdG8gc2VlIHdoYXRldmVyIGFiYnJldmlhdGlvbiBzY2hlbWUgd2UgdXNl
IGJlIGNvbnNpc3RlbnQuDQoNClRoYW5rcywNCkpha2UNCg==
