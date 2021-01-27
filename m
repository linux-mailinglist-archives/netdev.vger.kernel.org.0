Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BD2305468
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhA0HWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:22:06 -0500
Received: from mga17.intel.com ([192.55.52.151]:38093 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317496AbhA0Amj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:42:39 -0500
IronPort-SDR: D60GTzJtdhWz6UsN4nmkM+Xsmo2uHVcJ/u3B/1vJ8fub6EubatFMZeUTvdOTPcMhNRa6AIxFK/
 2UBlEfuiwqZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="159771778"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="159771778"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:41:42 -0800
IronPort-SDR: J0EzfGr4nrEyBRxkNDgQwlFlUu/zzTw0wF3XWkGQxuPp9xy1svW6TKDpym/q60P3qHnSeA9a6A
 +xQOGj9rst8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="402924079"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jan 2021 16:41:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 16:41:42 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Jan 2021 16:41:41 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Tue, 26 Jan 2021 16:41:41 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao5N6oA//+n/DCAAMFCAIAAeSAA
Date:   Wed, 27 Jan 2021 00:41:41 +0000
Message-ID: <031c2675aff248bd9c78fada059b5c02@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
In-Reply-To: <20210126005928.GF4147@nvidia.com>
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

PiBTdWJqZWN0OiBSZTogW1BBVENIIDA3LzIyXSBSRE1BL2lyZG1hOiBSZWdpc3RlciBhbiBhdXhp
bGlhcnkgZHJpdmVyIGFuZA0KPiBpbXBsZW1lbnQgcHJpdmF0ZSBjaGFubmVsIE9Qcw0KPiANCj4g
T24gVHVlLCBKYW4gMjYsIDIwMjEgYXQgMTI6NDI6MTZBTSArMDAwMCwgU2FsZWVtLCBTaGlyYXog
d3JvdGU6DQo+IA0KPiA+IEkgdGhpbmsgdGhpcyBlc3NlbnRpYWxseSBtZWFucyBkb2luZyBhd2F5
IHdpdGggLm9wZW4vLmNsb3NlIHBpZWNlLg0KPiANCj4gWWVzLCB0aGF0IHRvbywgYW5kIHByb2Jh
Ymx5IHRoZSBGU00gYXMgd2VsbC4NCj4gDQo+ID4gT3IgYXJlIHlvdSBzYXlpbmcgdGhhdCBpcyBv
az8gIFllcyB3ZSBoYWQgYSBkaXNjdXNzaW9uIGluIHRoZSBwYXN0IGFuZA0KPiA+IEkgdGhvdWdo
dCB3ZSBjb25jbHVkZWQuIEJ1dCBtYXliZSBJIG1pc3VuZGVyc3Rvb2QuDQo+ID4NCj4gPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9saW51eC1yZG1hLzlERDYxRjMwQTgwMkM0NDI5QTAxQ0E0MjAw
RTMwMkE3RENEDQo+ID4gNEZEMDNAZm1zbXN4MTI0LmFtci5jb3JwLmludGVsLmNvbS8NCj4gDQo+
IFdlbGwsIGhhdmluZyBub3cgc2VlbiBob3cgYXV4IGJ1cyBlbmRlZCB1cCBhbmQgdGhlIHdheSBp
dCBlZmZlY3RlZCB0aGUNCj4gbWx4NSBkcml2ZXIsIEkgYW0gbW9yZSBmaXJtbHkgb2YgdGhlIG9w
aW5pb24gdGhpcyBuZWVkcyB0byBiZSBmaXhlZC4gSXQgaXMgZXh0cmVtbHkNCj4gaGFyZCB0byBn
ZXQgZXZlcnl0aGluZyByaWdodCB3aXRoIHR3byBkaWZmZXJlbnQgcmVnaXN0cmF0aW9uIHNjaGVt
ZXMgcnVubmluZyBhcm91bmQuDQo+IA0KPiBZb3UgbmV2ZXIgYW5zd2VyZWQgbXkgcXVlc3Rpb246
DQoNClNvcnJ5IEkgbWlzc2VkIGl0Lg0KPiANCj4gPiBTdGlsbCwgeW91IG5lZWQgdG8gYmUgYWJs
ZSB0byBjb3BlIHdpdGggdGhlIHVzZXIgdW5iaW5kaW5nIHlvdXINCj4gPiBkcml2ZXJzIGluIGFu
eSBvcmRlciB2aWEgc3lzZnMuIFdoYXQgaGFwcGVucyB0byB0aGUgVkZzIHdoZW4gdGhlIFBGIGlz
DQo+ID4gdW5ib3VuZCBhbmQgcmVsZWFzZXMgd2hhdGV2ZXIgcmVzb3VyY2VzPyBUaGlzIGlzIHdo
ZXJlIHRoZSBicm9hZGNvbQ0KPiA+IGRyaXZlciByYW4gaW50byB0cm91Ymxlcy4uDQo+IA0KPiA/
DQoNCmVjaG8gLW4gImljZS5pbnRlbF9yZG1hLjAiID4gL3N5cy9idXMvYXV4aWxpYXJ5L2RyaXZl
cnMvaXJkbWEvdW5iaW5kICA/Pz8NCg0KVGhhdCBJIGJlbGlldmUgd2lsbCB0cmlnZ2VyIGEgZHJ2
LnJlbW92ZSgpIG9uIHRoZSByZG1hIFBGIHNpZGUgd2hpY2ggcmVxdWlyZQ0KdGhlIHJkbWEgVkZz
IHRvIGdvIGRvd24uDQoNClllcywgd2UgY3VycmVudGx5IGhhdmUgYSByZXF1aXJlbWVudCB0aGUg
YXV4IHJkbWEgUEYgZHJpdmVyIHJlbWFpbiBpbml0ZWQgYXQgbGVhc3QgdG8gLnByb2JlKCkNCmZv
ciBWRnMgdG8gc3Vydml2ZS4NCg0KV2UgYXJlIGRvaW5nIGludGVybmFsIHJldmlldywgYnV0IGl0
IGFwcGVhcnMgd2UgY291bGQgcG90ZW50aWFsbHkgZ2V0IHJpZCBvZiB0aGUgLm9wZW4vLmNsb3Nl
IGNhbGxiYWNrcy4NCkFuZCBpdHMgYXNzb2NpYXRlZCBGU00gaW4gaWNlLiANCg0KQnV0IGlmIHdl
IHJlbW92ZSBwZWVyX3JlZ2lzdGVyL3VucmVnaXN0ZXIsIGhvdyBkbyB3ZSBzeW5jaHJvbml6ZSBi
ZXR3ZWVuIHNheSB1bmxvYWQgb2YgdGhlIHJkbWEgZHJpdmVyIA0KYW5kIG5ldGRldiBkcml2ZXIg
c3RvcCBhY2Nlc3NpbmcgdGhlIHByaXYgY2hhbm5lbCBpaWRjX3BlZXJfb3BzIHRoYXQgaXQgdXNl
cyB0byBzZW5kIGV2ZW50cyB0byByZG1hPw0KDQpTaGlyYXoNCg0KDQo=
