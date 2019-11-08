Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51957F515F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfKHQni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:43:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:28635 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbfKHQni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 11:43:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 08:43:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,282,1569308400"; 
   d="scan'208";a="193213375"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga007.jf.intel.com with ESMTP; 08 Nov 2019 08:43:37 -0800
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 8 Nov 2019 08:43:37 -0800
Received: from orsmsx113.amr.corp.intel.com ([169.254.9.28]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.154]) with mapi id 14.03.0439.000;
 Fri, 8 Nov 2019 08:43:37 -0800
From:   "Creeley, Brett" <brett.creeley@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Arkady Gilinsky <arcadyg@gmail.com>
Subject: RE: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface between
 VF and PF
Thread-Topic: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface
 between VF and PF
Thread-Index: AQHVktE9LXQEe1tn8E2yMWCX6YmauKd7neLQgABu5ACAALtz8IAA2KwAgAMFkICAANqjAA==
Date:   Fri, 8 Nov 2019 16:43:36 +0000
Message-ID: <3508A0C5D531054DBDD98909F6FA64FA11B3EB75@ORSMSX113.amr.corp.intel.com>
References: <1572845537.13810.225.camel@harmonicinc.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B3936D@ORSMSX113.amr.corp.intel.com>
         <1572931430.13810.227.camel@harmonicinc.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B39863@ORSMSX113.amr.corp.intel.com>
         <1573018214.10368.1.camel@harmonicinc.com>
 <d078d3efc784805a67ba1a1c6e94fb4ec1c0aec6.camel@intel.com>
In-Reply-To: <d078d3efc784805a67ba1a1c6e94fb4ec1c0aec6.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzEwYjA3MDYtMzk1OS00ZDRmLWJiYWUtNWY5NTVkODViNWY0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiXC9rMXR6cGt5NFRIMUpcL3FCRnhvQ2xCaTh4M1MzNm0rR0dOZVdqcXJiRm9CbVVJNUtQRFg0YnErY0NsOVwvN3p5ZiJ9
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLaXJzaGVyLCBKZWZmcmV5IFQg
PGplZmZyZXkudC5raXJzaGVyQGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVy
IDcsIDIwMTkgMTE6MzkgQU0NCj4gVG86IEFya2FkeSBHaWxpbnNreSA8YXJrYWR5LmdpbGluc2t5
QGhhcm1vbmljaW5jLmNvbT47IENyZWVsZXksIEJyZXR0IDxicmV0dC5jcmVlbGV5QGludGVsLmNv
bT47IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnDQo+IENjOiBBcmthZHkgR2lsaW5za3kgPGFyY2FkeWdAZ21haWwuY29tPg0KPiBTdWJq
ZWN0OiBSZTogW0VYVEVSTkFMXSBSRTogW1BBVENIIG5ldF0gaTQwZS9pYXZmOiBGaXggbXNnIGlu
dGVyZmFjZSBiZXR3ZWVuIFZGIGFuZCBQRg0KPiANCj4gT24gV2VkLCAyMDE5LTExLTA2IGF0IDA1
OjMwICswMDAwLCBBcmthZHkgR2lsaW5za3kgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDE5LTExLTA1
IGF0IDE2OjU1ICswMDAwLCBDcmVlbGV5LCBCcmV0dCB3cm90ZToNCj4gPiA+ID4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4gRnJvbTogQXJrYWR5IEdpbGluc2t5IDxhcmthZHku
Z2lsaW5za3lAaGFybW9uaWNpbmMuY29tPg0KPiA+ID4gPiBTZW50OiBNb25kYXksIE5vdmVtYmVy
IDQsIDIwMTkgOToyNCBQTQ0KPiA+ID4gPiBUbzogQ3JlZWxleSwgQnJldHQgPGJyZXR0LmNyZWVs
ZXlAaW50ZWwuY29tPjsNCj4gPiA+ID4gaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IEtpcnNoZXIsDQo+ID4gPiA+IEplZmZyZXkgVA0KPiA+
ID4gPiA8amVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29tPg0KPiA+ID4gPiBDYzogQXJrYWR5IEdp
bGluc2t5IDxhcmNhZHlnQGdtYWlsLmNvbT4NCj4gPiA+ID4gU3ViamVjdDogUmU6IFtFWFRFUk5B
TF0gUkU6IFtQQVRDSCBuZXRdIGk0MGUvaWF2ZjogRml4IG1zZyBpbnRlcmZhY2UNCj4gPiA+ID4g
YmV0d2VlbiBWRiBhbmQgUEYNCj4gPiA+ID4gPiBzdGF0aWMgYm9vbCBpNDBlX3ZjX3ZlcmlmeV92
cXNfYml0bWFwcyhzdHJ1Y3QgdmlydGNobmxfcXVldWVfc2VsZWN0DQo+ID4gPiA+ID4gKnZxcykN
Cj4gPiA+ID4gPiB7DQo+ID4gPiA+ID4gICAgLyogdGhpcyB3aWxsIGNhdGNoIGFueSBjaGFuZ2Vz
IG1hZGUgdG8gdGhlIHZpcnRjaG5sX3F1ZXVlX3NlbGVjdA0KPiA+ID4gPiA+IGJpdG1hcCAqLw0K
PiA+ID4gPiA+ICAgIGlmIChzaXplb2YodnFzLT5yeF9xdWV1ZXMpICE9IHNpemVvZih1MzIpIHx8
DQo+ID4gPiA+ID4gICAgICAgICBzaXplb2YodnFzLT50eF9xdWV1ZXMpICE9IHNpemVvZih1MzIp
KQ0KPiA+ID4gPiA+ICAgICAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiA+ID4gPg0KPiA+ID4gPiBJ
ZiBzbywgdGhlbiBpcyBpdCBiZXR0ZXIgdG8gY2hlY2sgdGhlIHR5cGUgb2YgdGhlIGZpZWxkcyBp
biBjb21waWxlLQ0KPiA+ID4gPiB0aW1lIHJhdGhlciB0aGFuIGluIHJ1bnRpbWUgPw0KPiA+ID4g
PiBTb21ldGhpbmcgbGlrZSB0aGlzOg0KPiA+ID4gPiBCVUlMRF9CVUdfT04oc2l6ZW9mKHZxcy0+
cnhfcXVldWVzKSAhPSBzaXplb2YodTMyKSk7DQo+ID4gPiA+IEJVSUxEX0JVR19PTihzaXplb2Yo
dnFzLT50eF9xdWV1ZXMpICE9IHNpemVvZih1MzIpKTsNCj4gPiA+ID4gVGhpcyBpcyBub3QgcmVx
dWlyZWQgY29tcGFyaXNvbiBlYWNoIHRpbWUgd2hlbiBmdW5jdGlvbiBpcyBjYWxsZWQgYW5kDQo+
ID4gPiA+IG1hZGUgY29kZSBtb3JlIG9wdGltaXplZC4NCj4gPiA+DQo+ID4gPiBJIGRvbid0IHRo
aW5rIHRoaXMgaXMgcmVxdWlyZWQgd2l0aCB0aGUgY2hhbmdlIHlvdSBzdWdnZXN0ZWQgYmVsb3cu
DQo+ID4gQWdyZWUuDQo+ID4gSWYgb3RoZXIgY29kZSBpbiBkcml2ZXIgbm90IG5lZWQgdG8gYmUg
YWRqdXN0ZWQvdmVyaWZpZWQsIHRoZW4gdGhpcyBjaGVjaw0KPiA+IGlzIG5vdCBuZWVkZWQuDQo+
ID4gPiA+ID4gICAgaWYgKCh2cXMtPnJ4X3F1ZXVlcyA9PSAwICYmIHZxcy0+dHhfcXVldWVzID09
IDApIHx8DQo+ID4gPiA+ID4gICAgICAgICAgaHdlaWdodDMyKHZxcy0+cnhfcXVldWVzKSA+IEk0
MEVfTUFYX1ZGX1FVRVVFUyB8fA0KPiA+ID4gPiA+ICAgICAgICAgIGh3ZWlnaHQzMih2cXMtPnR4
X3F1ZXVlcykgPiBJNDBFX01BWF9WRl9RVUVVRVMpDQo+ID4gPiA+ID4gICAgICAgICAgICByZXR1
cm4gZmFsc2U7DQo+ID4gPiA+DQo+ID4gPiA+IEFnYWluLCBmcm9tIG9wdGltaXphdGlvbiBQT1Yg
aXQgaXMgYmV0dGVyIHRvIGhhdmUgY29uc3RhbnQgY2hhbmdlZA0KPiA+ID4gPiB0aGFuIHZhcmlh
YmxlLA0KPiA+ID4gPiBzaW5jZSBpdCBpcyBjb21waWxlIHRpbWUgYW5kIG5vdCBydW4gdGltZSBh
Y3Rpb246DQo+ID4gPiA+ICAgICAgaWYgKCh2cXMtPnJ4X3F1ZXVlcyA9PSAwICYmIHZxcy0+dHhf
cXVldWVzID09IDApIHx8DQo+ID4gPiA+ICAgICAgICAgICAgdnFzLT5yeF9xdWV1ZXMgPj0gKEJJ
VChJNDBFX01BWF9WRl9RVUVVRVMpKSB8fA0KPiA+ID4gPg0KPiA+ID4gPiAgICAgICB2cXMtPnR4
X3F1ZXVlcyA+PSAoQklUKEk0MEVfTUFYX1ZGX1FVRVVFUykpKQ0KPiA+ID4gPiAgICAgICAgICAg
ICAgcmV0dXJuIGZhbHNlOw0KPiA+ID4NCj4gPiA+IFRoaXMgc2VlbXMgbXVjaCBiZXR0ZXIgdGhh
biBteSBzb2x1dGlvbi4gSXQgZml4ZXMgdGhlIG9yaWdpbmFsIGlzc3VlLA0KPiA+ID4gaGFuZGxl
cyBpZiB0aGUNCj4gPiA+IHZxcy0+W3J8dF14X3F1ZXVlcyB2YXJpYWJsZXMgaGF2ZSBjaGFuZ2Vk
IGluIHNpemUsIGFuZCB0aGUgcXVldWUgYml0bWFwDQo+ID4gPiBjb21wYXJpc29uDQo+ID4gPiB1
c2VzIGEgY29uc3RhbnQuIFRoYW5rcyENCj4gPiBUaGFua3MgdG8geW91IGZvciBmZWVkYmFjay4N
Cj4gPiBJIGFtIHRyeWluZyB0byB1bmRlcnN0YW5kIGlmIHRoaXMgcGF0Y2ggd2lsbCBlbnRlciBp
bnRvIG9mZmljaWFsIGtlcm5lbA0KPiA+IHRyZWUNCj4gPiBhbmQsIG5vdCBsZXNzIGltcG9ydGFu
dCBmcm9tIG15IFBPViwgdG8gb2ZmaWNpYWwgSW50ZWwgZHJpdmVycy4NCj4gPiBCcmV0dC9KZWZm
cmV5LCBjb3VsZCB5b3UsIHBsZWFzZSwgYXNzaXN0IHRvIG1ha2Ugc3VyZSB0aGF0IHRoaXMgZml4
LCBvcg0KPiA+IGZpeCBzdWdnZXN0ZWQgYnkgQnJldHQsDQo+ID4gd2lsbCBiZSBpbnRlZ3JhdGVk
IGludG8gSW50ZWwgaTQwZS9pYXZmIGRyaXZlcnMgPw0KPiA+IE9yIG1heSBiZSBJIHNob3VsZCB3
cml0ZSBtYWlsIHN0cmFpZ2h0IHRvIEludGVsIHN1cHBvcnQgPw0KPiANCj4gQXMgQnJldHQgcG9p
bnRlZCBvdXQsIHRoZXJlIGFyZSBpc3N1ZXMgd2l0aCB0aGlzIHBhdGNoLiBQbGVhc2UgbWFrZSB0
aGUNCj4gc3VnZ2VzdGVkIGNoYW5nZXMgYW5kIHJlLXN1Ym1pdCB0aGUgcGF0Y2ggdG8NCj4gaW50
ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmcNCg0KSmVmZi9BcmthZHk6IEkgaGF2ZSBhbHJl
YWR5IHN1Ym1pdHRlZCBwYXRjaGVzIGZvciB0aGlzIGludGVybmFsbHkgZm9yDQpvZmZpY2lhbCBJ
bnRlbCBkcml2ZXJzLiBBcG9sb2dpZXMgZm9yIHRoZSBkZWxheWVkIHJlc3BvbnNlLg0K
