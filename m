Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2EA2160BCF
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 08:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgBQHnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 02:43:20 -0500
Received: from mga03.intel.com ([134.134.136.65]:27436 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgBQHnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 02:43:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Feb 2020 23:43:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,451,1574150400"; 
   d="scan'208";a="348444297"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2020 23:43:17 -0800
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 16 Feb 2020 23:43:17 -0800
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.100]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.135]) with mapi id 14.03.0439.000;
 Sun, 16 Feb 2020 23:43:17 -0800
From:   "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "sgarzare@redhat.com" <sgarzare@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Enhance virtio-vsock connection semantics
Thread-Topic: [PATCH v3 0/2] Enhance virtio-vsock connection semantics
Thread-Index: AQHV4yyrh/V/2txMb02EtEAkK2wIxKgfPQmAgABOjYA=
Date:   Mon, 17 Feb 2020 07:43:16 +0000
Message-ID: <7ff548d8be1cd3f47d24c86818f0cf230a731beb.camel@intel.com>
References: <20200214114802.23638-1-sebastien.boeuf@intel.com>
         <20200216.190207.1866082797316332373.davem@davemloft.net>
In-Reply-To: <20200216.190207.1866082797316332373.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.25.223]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A60BB74A859774792AAE0DCE265A924@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTAyLTE2IGF0IDE5OjAyIC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNlYmFzdGllbiBCb2V1ZiA8c2ViYXN0aWVuLmJvZXVmQGludGVsLmNvbT4NCj4gRGF0
ZTogRnJpLCAxNCBGZWIgMjAyMCAxMjo0ODowMCArMDEwMA0KPiANCj4gPiBUaGlzIHNlcmllcyBp
bXByb3ZlcyB0aGUgc2VtYW50aWNzIGJlaGluZCB0aGUgd2F5IHZpcnRpby12c29jaw0KPiA+IHNl
cnZlcg0KPiA+IGFjY2VwdHMgY29ubmVjdGlvbnMgY29taW5nIGZyb20gdGhlIGNsaWVudC4gV2hl
bmV2ZXIgdGhlIHNlcnZlcg0KPiA+IHJlY2VpdmVzIGEgY29ubmVjdGlvbiByZXF1ZXN0IGZyb20g
dGhlIGNsaWVudCwgaWYgaXQgaXMgYm91bmQgdG8NCj4gPiB0aGUNCj4gPiBzb2NrZXQgYnV0IG5v
dCB5ZXQgbGlzdGVuaW5nLCBpdCB3aWxsIGFuc3dlciB3aXRoIGEgUlNUIHBhY2tldC4gVGhlDQo+
ID4gcG9pbnQgaXMgdG8gZW5zdXJlIGVhY2ggcmVxdWVzdCBmcm9tIHRoZSBjbGllbnQgaXMgcXVp
Y2tseQ0KPiA+IHByb2Nlc3NlZA0KPiA+IHNvIHRoYXQgdGhlIGNsaWVudCBjYW4gZGVjaWRlIGFi
b3V0IHRoZSBzdHJhdGVneSBvZiByZXRyeWluZyBvcg0KPiA+IG5vdC4NCj4gPiANCj4gPiBUaGUg
c2VyaWVzIGluY2x1ZGVzIGFsb25nIHdpdGggdGhlIGltcHJvdmVtZW50IHBhdGNoIGEgbmV3IHRl
c3QgdG8NCj4gPiBlbnN1cmUgdGhlIGJlaGF2aW9yIGlzIGNvbnNpc3RlbnQgYWNyb3NzIGFsbCBo
eXBlcnZpc29ycyBkcml2ZXJzLg0KPiANCj4gU2VyaWVzIGFwcGxpZWQgdG8gbmV0LW5leHQsIHRo
YW5rcyBTZWJhc3RpZW4uDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2gsIEkgcmVhbGx5IGFwcHJlY2lh
dGUgaG93IHF1aWNrbHkgdGhpbmdzIHdlbnQgOikNCg0KU2ViYXN0aWVuDQotLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K
SW50ZWwgQ29ycG9yYXRpb24gU0FTIChGcmVuY2ggc2ltcGxpZmllZCBqb2ludCBzdG9jayBjb21w
YW55KQpSZWdpc3RlcmVkIGhlYWRxdWFydGVyczogIkxlcyBNb250YWxldHMiLSAyLCBydWUgZGUg
UGFyaXMsIAo5MjE5NiBNZXVkb24gQ2VkZXgsIEZyYW5jZQpSZWdpc3RyYXRpb24gTnVtYmVyOiAg
MzAyIDQ1NiAxOTkgUi5DLlMuIE5BTlRFUlJFCkNhcGl0YWw6IDQsNTcyLDAwMCBFdXJvcwoKVGhp
cyBlLW1haWwgYW5kIGFueSBhdHRhY2htZW50cyBtYXkgY29udGFpbiBjb25maWRlbnRpYWwgbWF0
ZXJpYWwgZm9yCnRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50KHMpLiBBbnkg
cmV2aWV3IG9yIGRpc3RyaWJ1dGlvbgpieSBvdGhlcnMgaXMgc3RyaWN0bHkgcHJvaGliaXRlZC4g
SWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkCnJlY2lwaWVudCwgcGxlYXNlIGNvbnRhY3QgdGhl
IHNlbmRlciBhbmQgZGVsZXRlIGFsbCBjb3BpZXMuCg==

