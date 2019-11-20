Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C17A21031CD
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKTCzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:55:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:1605 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbfKTCzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 21:55:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 18:55:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,220,1571727600"; 
   d="scan'208";a="215674664"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga001.fm.intel.com with ESMTP; 19 Nov 2019 18:55:22 -0800
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 19 Nov 2019 18:55:21 -0800
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.179]) by
 ORSMSX112.amr.corp.intel.com ([169.254.3.26]) with mapi id 14.03.0439.000;
 Tue, 19 Nov 2019 18:55:21 -0800
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        "joe@perches.com" <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "zdai@linux.vnet.ibm.com" <zdai@linux.vnet.ibm.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "smorumu1@in.ibm.com" <smorumu1@in.ibm.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [next-queue/net-next PATCH] e1000e: Use netdev_info instead of
 pr_info for link messages
Thread-Topic: [next-queue/net-next PATCH] e1000e: Use netdev_info instead of
 pr_info for link messages
Thread-Index: AQHVkAyCtXdab5ln90CZFebY7a8qMKeTesIw
Date:   Wed, 20 Nov 2019 02:55:20 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B97179772@ORSMSX103.amr.corp.intel.com>
References: <cf197ef61703cbaa64ac522cf5d191b4b74f64d6.camel@linux.intel.com>
 <20191031165537.24154.48242.stgit@localhost.localdomain>
In-Reply-To: <20191031165537.24154.48242.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTVlNWE2OWEtMmRhMC00OWIwLTljN2EtZTMwOTIwNzJiNzZmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiS0dUY1hPNFJuaGordjY2VUtDSEt5a3JIQmhEWmNGXC9TQk9TMURwQ1NtRVcwQVZFT0FjYzVJUjNLeWJSaGw0ZkIifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFsZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+IFNl
bnQ6IFRodXJzZGF5LCBPY3RvYmVyIDMxLCAyMDE5IDk6NTkgQU0NCj4gVG86IGpvZUBwZXJjaGVz
LmNvbTsgS2lyc2hlciwgSmVmZnJleSBUIDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5jb20+Ow0K
PiBkYXZlbUBkYXZlbWxvZnQubmV0DQo+IENjOiB6ZGFpQGxpbnV4LnZuZXQuaWJtLmNvbTsgbmhv
cm1hbkByZWRoYXQuY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBzbW9ydW11MUBpbi5p
Ym0uY29tOyBpbnRlbC13aXJlZC0NCj4gbGFuQGxpc3RzLm9zdW9zbC5vcmc7IEJyb3duLCBBYXJv
biBGIDxhYXJvbi5mLmJyb3duQGludGVsLmNvbT47DQo+IHNhc3NtYW5uQHJlZGhhdC5jb20NCj4g
U3ViamVjdDogW25leHQtcXVldWUvbmV0LW5leHQgUEFUQ0hdIGUxMDAwZTogVXNlIG5ldGRldl9p
bmZvIGluc3RlYWQgb2YNCj4gcHJfaW5mbyBmb3IgbGluayBtZXNzYWdlcw0KPiANCj4gRnJvbTog
QWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuaC5kdXlja0BsaW51eC5pbnRlbC5jb20+DQo+IA0K
PiBSZXBsYWNlIHRoZSBwcl9pbmZvIGNhbGxzIHdpdGggbmV0ZGV2X2luZm8gaW4gYWxsIGNhc2Vz
IHJlbGF0ZWQgdG8gdGhlDQo+IG5ldGRldmljZSBsaW5rIHN0YXRlLg0KPiANCj4gQXMgYSByZXN1
bHQgb2YgdGhpcyBwYXRjaCB0aGUgbGluayBtZXNzYWdlcyB3aWxsIGNoYW5nZSBhcyBzaG93biBi
ZWxvdy4NCj4gQmVmb3JlOg0KPiBlMTAwMGU6IGVuczMgTklDIExpbmsgaXMgRG93bg0KPiBlMTAw
MGU6IGVuczMgTklDIExpbmsgaXMgVXAgMTAwMCBNYnBzIEZ1bGwgRHVwbGV4LCBGbG93IENvbnRy
b2w6IFJ4L1R4DQo+IA0KPiBBZnRlcjoNCj4gZTEwMDBlIDAwMDA6MDA6MDMuMCBlbnMzOiBOSUMg
TGluayBpcyBEb3duDQo+IGUxMDAwZSAwMDAwOjAwOjAzLjAgZW5zMzogTklDIExpbmsgaXMgVXAg
MTAwMCBNYnBzIEZ1bGwgRHVwbGV4LCBGbG93IENvbnRyb2w6DQo+IFJ4L1R4DQo+IA0KPiBTdWdn
ZXN0ZWQtYnk6IEpvZSBQZXJjaGVzIDxqb2VAcGVyY2hlcy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVyLmguZHV5Y2tAbGludXguaW50ZWwuY29tPg0KPiAt
LS0NCj4gDQo+IFNpbmNlIEpvZSBoYXNuJ3QgZ290dGVuIGJhY2sgdG8gbWUgb24gaWYgaGUgd2Fu
dGVkIHRvIGRvIHRoZSBwYXRjaCBvciBpZg0KPiBoZSB3YW50ZWQgbWUgdG8gZG8gaXQgSSBqdXN0
IHdlbnQgYWhlYWQgYW5kIGRpZCBpdC4gVGhpcyBzaG91bGQgYWRkcmVzcyB0aGUNCj4gY29uY2Vy
bnMgaGUgaGFkIGFib3V0IHRoZSBtZXNzYWdlIGZvcm1hdHRpbmcgaW4gImUxMDAwZTogVXNlIHJ0
bmxfbG9jayB0bw0KPiBwcmV2ZW50IHJhY2UiLg0KPiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2UxMDAwZS9uZXRkZXYuYyB8ICAgIDkgKysrKystLS0tDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCg0KVGVzdGVkLWJ5OiBBYXJv
biBCcm93biA8YWFyb24uZi5icm93bkBpbnRlbC5jb20+DQo=
