Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D217F39DFF7
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhFGPI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:08:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:6390 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230220AbhFGPI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 11:08:59 -0400
IronPort-SDR: Tn0B088jX1vSATr0hr98Ui7B+lzGvhiSXjh3taJtTx6HWRhLgT6JjVtqV2ObOfTlBh+ogbm0vr
 GSzWSXr4/jLQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="268494214"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="268494214"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 08:04:43 -0700
IronPort-SDR: FApYxLovI4SBpzRJ6KZbR4ouEh3qP105Fe7dsVIA1Eb8X+kF5Fn/168wjWDNdjk9T2GUhMhN+z
 0OyJyM6Rjivw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="449116807"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 07 Jun 2021 08:04:43 -0700
Received: from bgsmsx601.gar.corp.intel.com (10.109.78.80) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 7 Jun 2021 08:04:42 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 BGSMSX601.gar.corp.intel.com (10.109.78.80) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 7 Jun 2021 20:34:40 +0530
Received: from bgsmsx606.gar.corp.intel.com ([10.67.234.8]) by
 BGSMSX606.gar.corp.intel.com ([10.67.234.8]) with mapi id 15.01.2242.008;
 Mon, 7 Jun 2021 20:34:40 +0530
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>
Subject: RE: WWAN rtnetlink follow-up
Thread-Topic: WWAN rtnetlink follow-up
Thread-Index: AQHXWSsAhfL5kcLBvUuJnYp5dxwMPasIpYlg
Date:   Mon, 7 Jun 2021 15:04:40 +0000
Message-ID: <5d9c826782d74aefbdf297324362afe7@intel.com>
References: <CAMZdPi-MrOAfLu6SaxdEqrZyUM=pyq7U8=dokmxdB+6-C3W3aA@mail.gmail.com>
In-Reply-To: <CAMZdPi-MrOAfLu6SaxdEqrZyUM=pyq7U8=dokmxdB+6-C3W3aA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.223.10.1]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTG9pYywNCg0KSSBoYXZlIHZlcmlmaWVkIElPU00gZHJpdmVyIGJ5IGNoZXJyeS1waWNraW5n
IHRoZSBiZWxvdyBbRklYVVBdIG9uIHRvcCBvZiBKb2hhbm5lcyAmIFNlcmdleSBSRkMgcGF0Y2gu
DQpEYXRhIHBhdGggaXMgZnVuY3Rpb25hbC4gSSB3aWxsIHJlc3VibWl0IHRoZSBJT1NNIERyaXZl
ciBwYXRjaGVzLiANCmh0dHBzOi8vZ2l0LmxpbmFyby5vcmcvcGVvcGxlL2xvaWMucG91bGFpbi9s
aW51eC5naXQvY29tbWl0Lz9oPXd3YW4tZGV2JmlkPWZkN2U2ZDc4ZWJhZDk5MzBkMjJlNWI1ZjQz
MGNhZTlhZDVmYzg5ZmUNCmh0dHBzOi8vZ2l0LmxpbmFyby5vcmcvcGVvcGxlL2xvaWMucG91bGFp
bi9saW51eC5naXQvY29tbWl0Lz9oPXd3YW4tZGV2JmlkPTZmYjdjYmQwYzBiZGUwZGU4NzI3NDRl
ODllZTg3ZTM2ZWQ4ZWM2YTcNCg0KUkZDIFNlcmllczoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L25ldGRldi8yMDIxMDYwMjA4Mjg0MC44NTgyOC0xLWpvaGFubmVzQHh4eHh4eHh4eHh4eHh4eHgv
DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMTA2MDMwNDQ5NTQuODA5MS0xLXJ5
YXphbm92LnMuYUBnbWFpbC5jb20vDQoNClJlZ2FyZHMsDQpNIENoZXRhbiBLdW1hcg0KDQo+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IExvaWMgUG91bGFpbiA8bG9pYy5wb3Vs
YWluQGxpbmFyby5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgSnVuZSA0LCAyMDIxIDM6NTggUE0NCj4g
VG86IEt1bWFyLCBNIENoZXRhbiA8bS5jaGV0YW4ua3VtYXJAaW50ZWwuY29tPjsgSm9oYW5uZXMg
QmVyZw0KPiA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD47IFNlcmdleSBSeWF6YW5vdiA8cnlh
emFub3Yucy5hQGdtYWlsLmNvbT4NCj4gQ2M6IE5ldHdvcmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc+OyBKYWt1YiBLaWNpbnNraQ0KPiA8a3ViYUBrZXJuZWwub3JnPjsgRGF2
aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRGFuIFdpbGxpYW1zDQo+IDxkY2J3QHJl
ZGhhdC5jb20+DQo+IFN1YmplY3Q6IFdXQU4gcnRuZXRsaW5rIGZvbGxvdy11cA0KPiANCj4gSGkg
Zm9sa3MsDQo+IA0KPiBUaGFua3MgZm9yIHlvdXIgaW52b2x2ZW1lbnQgYW5kIGdyZWF0IHdvcmsg
b24gdGhpcyBXV0FOIHRvcGljLiBJJ3ZlIHBpY2tlZA0KPiB5b3VyIHBhdGNoZXMgaW4gbXkgdHJl
ZSBmb3IgdGVzdGluZyAod2l0aCBhIFF1YWxjb21tIE1ISQ0KPiBtb2RlbSk6DQo+IGh0dHBzOi8v
Z2l0LmxpbmFyby5vcmcvcGVvcGxlL2xvaWMucG91bGFpbi9saW51eC5naXQvbG9nLz9oPXd3YW4t
ZGV2DQo+IA0KPiBUaGlzIGlzIG1pbmltYWwgc3VwcG9ydCBmb3Igbm93IHNpbmNlIG1oaV9uZXQg
b25seSBzdXBwb3J0cyBvbmUgbGluaywNCj4gRXNzZW50aWFsbHkgZm9yIHRlc3RpbmcgcHVycG9z
ZXMsIGJ1dCBJIHBsYW4gdG8gcmV3b3JrIGl0IHRvIHN1cHBvcnQgbW9yZSB0aGFuDQo+IG9uZSBv
bmNlIHd3YW4gcnRuZXRsaW5rIGlzIGFjY2VwdGVkIGFuZCBtZXJnZWQsIFRoaXMgbGltaXRhdGlv
biB3aWxsIG5vdA0KPiBleGlzdCBmb3IgdGhlIEludGVsIElPU00gZHJpdmVyLg0KPiANCj4gSSdt
IHByb2JhYmx5IGdvaW5nIHRvIHJlYmFzZSB0aGF0IGFuZCBzcXVhc2ggdGhlIGZpeCBjb21taXRz
IChmcm9tIFNlcmdleQ0KPiBhbmQgSSkgdG8gSm9oYW5uZXMgY2hhbmdlcyBpZiBldmVyeW9uZSBh
Z3JlZXMuIFRoZW4gSSdsbCBzdWJtaXQgdGhlIGVudGlyZQ0KPiBzZXJpZXMuDQo+IA0KPiBOb3Qg
c3VyZSB3aGF0IGlzIHRoZSBwcm9jZWR1cmUgZm9yIGlwcm91dGUyLCBzaG91bGQgaXQgYmUgaW5j
bHVkZWQgaW4gdGhlDQo+IHNlcmllcyBvciBiZSBwYXJ0IG9mIGEgZGVkaWNhdGVkIG9uZT8NCj4g
DQo+IENoZXRhbiwgeW91IGNhbiB1c2UgdGhhdCB0cmVlIGZvciB5b3VyIGlvc20gd29yaywgb3Ig
Y2hlcnJ5LXBpY2sgdGhlIFtGSVhVUF0NCj4gY2hhbmdlcyBpZiB5b3UgYWxyZWFkeSB3b3JrIG9u
IHRoZSBzdWJtaXR0ZWQgUkZDIHNlcmllcy4NCj4gDQo+IFJlZnM6DQo+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL25ldGRldi8yMDIxMDYwMjA4Mjg0MC44NTgyOC0xLQ0KPiBqb2hhbm5lc0B4eHh4
eHh4eHh4eHh4eHh4Lw0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMTA2MDMw
NDQ5NTQuODA5MS0xLQ0KPiByeWF6YW5vdi5zLmFAZ21haWwuY29tLw0KPiANCj4gVGhhbmtzLA0K
PiBMb2ljDQo=
