Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2061D285FCF
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 15:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgJGNKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 09:10:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:23514 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgJGNKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 09:10:10 -0400
IronPort-SDR: 2uXP6dcFVmHEidklmYFW35gNkSfedFWEiAjxH0Pm6nlnGpW5x16dLYnqGomi1/jTjTTsJ4+Tre
 a6HEsGxQLqZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="164163344"
X-IronPort-AV: E=Sophos;i="5.77,346,1596524400"; 
   d="scan'208";a="164163344"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 06:09:57 -0700
IronPort-SDR: iE+mIb/JJV75SaQ5kJf0t0ESVcHA8dc6ozfnQ3gCzKdr8LMvG21UWJlUuIO9Cl5RalMnhhl4xF
 DmcD24cKsM8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,346,1596524400"; 
   d="scan'208";a="297487083"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 07 Oct 2020 06:09:57 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 06:09:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 06:09:56 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Wed, 7 Oct 2020 06:09:56 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm0x+bCEx5k0iU0+RSRzmm941iKmKoH2AgACGDICAAB03gIAAAc6AgAAE8QD//4wBYIAAk8gAgAB9aYCAADAfAA==
Date:   Wed, 7 Oct 2020 13:09:55 +0000
Message-ID: <cd80aad674ee48faaaedc8698c9b23e2@intel.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201006172650.GO1874917@unreal>
 <3ff1445d86564ef3aae28d1d1a9a19ea@intel.com>
 <20201006192036.GQ1874917@unreal>
 <CAPcyv4iC_KGOx7Jwax-GWxFJbfUM-2+ymSuf4zkCxG=Yob5KnQ@mail.gmail.com>
In-Reply-To: <CAPcyv4iC_KGOx7Jwax-GWxFJbfUM-2+ymSuf4zkCxG=Yob5KnQ@mail.gmail.com>
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

PiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDEvNl0gQWRkIGFuY2lsbGFyeSBidXMgc3VwcG9ydA0K
PiANCj4gT24gVHVlLCBPY3QgNiwgMjAyMCBhdCAxMjoyMSBQTSBMZW9uIFJvbWFub3Zza3kgPGxl
b25Aa2VybmVsLm9yZz4gd3JvdGU6DQo+ID4NCj4gPiBPbiBUdWUsIE9jdCAwNiwgMjAyMCBhdCAw
NTo0MTowMFBNICswMDAwLCBTYWxlZW0sIFNoaXJheiB3cm90ZToNCj4gPiA+ID4gU3ViamVjdDog
UmU6IFtQQVRDSCB2MiAxLzZdIEFkZCBhbmNpbGxhcnkgYnVzIHN1cHBvcnQNCj4gPiA+ID4NCj4g
PiA+ID4gT24gVHVlLCBPY3QgMDYsIDIwMjAgYXQgMDU6MDk6MDlQTSArMDAwMCwgUGFyYXYgUGFu
ZGl0IHdyb3RlOg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBGcm9tOiBMZW9uIFJvbWFub3Zza3kg
PGxlb25Aa2VybmVsLm9yZz4NCj4gPiA+ID4gPiA+IFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIgNiwg
MjAyMCAxMDozMyBQTQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IE9uIFR1ZSwgT2N0IDA2LCAy
MDIwIGF0IDEwOjE4OjA3QU0gLTA1MDAsIFBpZXJyZS1Mb3VpcyBCb3NzYXJ0IHdyb3RlOg0KPiA+
ID4gPiA+ID4gPiBUaGFua3MgZm9yIHRoZSByZXZpZXcgTGVvbi4NCj4gPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+ID4gPiA+IEFkZCBzdXBwb3J0IGZvciB0aGUgQW5jaWxsYXJ5IEJ1cywgYW5jaWxs
YXJ5X2RldmljZSBhbmQNCj4gYW5jaWxsYXJ5X2RyaXZlci4NCj4gPiA+ID4gPiA+ID4gPiA+IEl0
IGVuYWJsZXMgZHJpdmVycyB0byBjcmVhdGUgYW4gYW5jaWxsYXJ5X2RldmljZSBhbmQNCj4gPiA+
ID4gPiA+ID4gPiA+IGJpbmQgYW4gYW5jaWxsYXJ5X2RyaXZlciB0byBpdC4NCj4gPiA+ID4gPiA+
ID4gPg0KPiA+ID4gPiA+ID4gPiA+IEkgd2FzIHVuZGVyIGltcHJlc3Npb24gdGhhdCB0aGlzIG5h
bWUgaXMgZ29pbmcgdG8gYmUgY2hhbmdlZC4NCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4g
SXQncyBwYXJ0IG9mIHRoZSBvcGVucyBzdGF0ZWQgaW4gdGhlIGNvdmVyIGxldHRlci4NCj4gPiA+
ID4gPiA+DQo+ID4gPiA+ID4gPiBvaywgc28gd2hhdCBhcmUgdGhlIHZhcmlhbnRzPw0KPiA+ID4g
PiA+ID4gc3lzdGVtIGJ1cyAoc3lzYnVzKSwgc2JzeXN0ZW0gYnVzIChzdWJidXMpLCBjcm9zc2J1
cyA/DQo+ID4gPiA+ID4gU2luY2UgdGhlIGludGVuZGVkIHVzZSBvZiB0aGlzIGJ1cyBpcyB0bw0K
PiA+ID4gPiA+IChhKSBjcmVhdGUgc3ViIGRldmljZXMgdGhhdCByZXByZXNlbnQgJ2Z1bmN0aW9u
YWwgc2VwYXJhdGlvbicNCj4gPiA+ID4gPiBhbmQNCj4gPiA+ID4gPiAoYikgc2Vjb25kIHVzZSBj
YXNlIGZvciBzdWJmdW5jdGlvbnMgZnJvbSBhIHBjaSBkZXZpY2UsDQo+ID4gPiA+ID4NCj4gPiA+
ID4gPiBJIHByb3Bvc2VkIGJlbG93IG5hbWVzIGluIHYxIG9mIHRoaXMgcGF0Y2hzZXQuDQo+ID4g
PiA+IA0KPiA+ID4gPiA+IChhKSBzdWJkZXZfYnVzDQo+ID4gPiA+DQo+ID4gPiA+IEl0IHNvdW5k
cyBnb29kLCBqdXN0IGNhbiB3ZSBhdm9pZCAiXyIgaW4gdGhlIG5hbWUgYW5kIGNhbGwgaXQgc3Vi
ZGV2Pw0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IFdoYXQgaXMgd3Jvbmcgd2l0aCBuYW1pbmcgdGhl
IGJ1cyAnYW5jaWxsYXJ5IGJ1cyc/IEkgZmVlbCBpdCdzIGEgZml0dGluZyBuYW1lLg0KPiA+ID4g
QW4gYW5jaWxsYXJ5IHNvZnR3YXJlIGJ1cyBmb3IgYW5jaWxsYXJ5IGRldmljZXMgY2FydmVkIG9m
ZiBhIHBhcmVudCBkZXZpY2UNCj4gcmVnaXN0ZXJlZCBvbiBhIHByaW1hcnkgYnVzLg0KPiA+DQo+
ID4gR3JlZyBzdW1tYXJpemVkIGl0IHZlcnkgd2VsbCwgZXZlcnkgaW50ZXJuYWwgY29udmVyc2F0
aW9uIGFib3V0IHRoaXMNCj4gPiBwYXRjaCB3aXRoIG15IGNvbGxlYWd1ZXMgKG5vbi1lbmdsaXNo
IHNwZWFrZXJzKSBzdGFydHMgd2l0aCB0aGUgcXVlc3Rpb246DQo+ID4gIldoYXQgZG9lcyBhbmNp
bGxhcnkgbWVhbj8iDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxzYS1kZXZlbC8yMDIw
MTAwMTA3MTQwMy5HQzMxMTkxQGtyb2FoLmNvbS8NCj4gPg0KPiA+ICJGb3Igbm9uLW5hdGl2ZSBl
bmdsaXNoIHNwZWFrZXJzIHRoaXMgaXMgZ29pbmcgdG8gYmUgcm91Z2gsIGdpdmVuIHRoYXQNCj4g
PiBJIGFzIGEgbmF0aXZlIGVuZ2xpc2ggc3BlYWtlciBoYWQgdG8gZ28gbG9vayB1cCB0aGUgd29y
ZCBpbiBhDQo+ID4gZGljdGlvbmFyeSB0byBmdWxseSB1bmRlcnN0YW5kIHdoYXQgeW91IGFyZSB0
cnlpbmcgdG8gZG8gd2l0aCB0aGF0DQo+ID4gbmFtZS4iDQo+IA0KPiBJIHN1Z2dlc3RlZCAiYXV4
aWxpYXJ5IiBpbiBhbm90aGVyIHNwbGludGVyZWQgdGhyZWFkIG9uIHRoaXMgcXVlc3Rpb24uDQo+
IEluIHRlcm1zIG9mIHdoYXQgdGhlIGtlcm5lbCBpcyBhbHJlYWR5IHVzaW5nOg0KPiANCj4gJCBn
aXQgZ3JlcCBhdXhpbGlhcnkgfCB3YyAtbA0KPiA1MDcNCj4gJCBnaXQgZ3JlcCBhbmNpbGxhcnkg
fCB3YyAtbA0KPiAxNTMNCj4gDQo+IEVtcGlyaWNhbGx5LCAiYXV4aWxpYXJ5IiBpcyBtb3JlIGNv
bW1vbiBhbmQgY2xvc2VseSBtYXRjaGVzIHRoZSBpbnRlbmRlZCBmdW5jdGlvbg0KPiBvZiB0aGVz
ZSBkZXZpY2VzIHJlbGF0aXZlIHRvIHRoZWlyIHBhcmVudCBkZXZpY2UuDQoNCmF1eGlsaWFyeSBi
dXMgaXMgYSBiZWZpdHRpbmcgbmFtZSBhcyB3ZWxsLg0K
