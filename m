Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E163348590
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbhCXX4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:56:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:30616 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234986AbhCXXrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 19:47:03 -0400
IronPort-SDR: NhKLm3DW1kdMwd4YqKQ7gemQ7yXZUYVFQkibrWVNKo7sWPSYnEzjPz/BqRN1YRN30dUmCJU6Ib
 W8X8jdTm98GQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="190835113"
X-IronPort-AV: E=Sophos;i="5.81,276,1610438400"; 
   d="scan'208";a="190835113"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 16:47:02 -0700
IronPort-SDR: tRP08Q+xu6jpQ9E4NnU9ipEoIYfLY+nuq+GdEHP9nJTQ4+Td5SDzW/TomeHaJTXMPIymKhxoE6
 qQocyS+Q+G+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,276,1610438400"; 
   d="scan'208";a="608280155"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2021 16:47:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Mar 2021 16:47:02 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Mar 2021 16:47:01 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Wed, 24 Mar 2021 16:47:01 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v2 22/23] RDMA/irdma: Add irdma Kconfig/Makefile and
 remove i40iw
Thread-Topic: [PATCH v2 22/23] RDMA/irdma: Add irdma Kconfig/Makefile and
 remove i40iw
Thread-Index: AQHXIEEpvhu6RECo0kqPlQkAuiI9/KqT8zUA///Hk+A=
Date:   Wed, 24 Mar 2021 23:47:01 +0000
Message-ID: <545549060ffe4e8fb9cf89618566418a@intel.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-23-shiraz.saleem@intel.com>
 <7fdf6b17-064c-e438-c5c5-6cd6218ee1bd@infradead.org>
In-Reply-To: <7fdf6b17-064c-e438-c5c5-6cd6218ee1bd@infradead.org>
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

PiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDIyLzIzXSBSRE1BL2lyZG1hOiBBZGQgaXJkbWEgS2Nv
bmZpZy9NYWtlZmlsZSBhbmQNCj4gcmVtb3ZlIGk0MGl3DQo+IA0KPiBPbiAzLzIzLzIxIDU6MDAg
UE0sIFNoaXJheiBTYWxlZW0gd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5p
YmFuZC9ody9pcmRtYS9LY29uZmlnDQo+ID4gYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEv
S2NvbmZpZw0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAuLjY1
ODU4NDINCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3
L2lyZG1hL0tjb25maWcNCj4gPiBAQCAtMCwwICsxLDExIEBADQo+ID4gKyMgU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjAtb25seSBjb25maWcgSU5GSU5JQkFORF9JUkRNQQ0KPiA+ICsJ
dHJpc3RhdGUgIkludGVsKFIpIEV0aGVybmV0IFByb3RvY29sIERyaXZlciBmb3IgUkRNQSINCj4g
PiArCWRlcGVuZHMgb24gSU5FVA0KPiA+ICsJZGVwZW5kcyBvbiBJUFY2IHx8ICFJUFY2DQo+ID4g
KwlkZXBlbmRzIG9uIFBDSQ0KPiA+ICsJc2VsZWN0IEdFTkVSSUNfQUxMT0NBVE9SDQo+ID4gKwlz
ZWxlY3QgQ09ORklHX0FVWElMSUFSWV9CVVMNCj4gPiArCWhlbHANCj4gPiArCSBUaGlzIGlzIGFu
IEludGVsKFIpIEV0aGVybmV0IFByb3RvY29sIERyaXZlciBmb3IgUkRNQSBkcml2ZXINCj4gPiAr
CSB0aGF0IHN1cHBvcnQgRTgxMCAoaVdBUlAvUm9DRSkgYW5kIFg3MjIgKGlXQVJQKSBuZXR3b3Jr
IGRldmljZXMuDQo+IA0KPiANCj4gPHBzZXVkbyBib3Q+DQo+IA0KPiBQbGVhc2UgZm9sbG93IGNv
ZGluZy1zdHlsZSBmb3IgS2NvbmZpZyBmaWxlczoNCj4gDQo+IGZyb20gRG9jdW1lbnRhdGlvbi9w
cm9jZXNzL2NvZGluZy1zdHlsZS5yc3QsIHNlY3Rpb24gMTApOg0KPiANCj4gRm9yIGFsbCBvZiB0
aGUgS2NvbmZpZyogY29uZmlndXJhdGlvbiBmaWxlcyB0aHJvdWdob3V0IHRoZSBzb3VyY2UgdHJl
ZSwgdGhlDQo+IGluZGVudGF0aW9uIGlzIHNvbWV3aGF0IGRpZmZlcmVudC4gIExpbmVzIHVuZGVy
IGEgYGBjb25maWdgYCBkZWZpbml0aW9uIGFyZSBpbmRlbnRlZA0KPiB3aXRoIG9uZSB0YWIsIHdo
aWxlIGhlbHAgdGV4dCBpcyBpbmRlbnRlZCBhbiBhZGRpdGlvbmFsIHR3byBzcGFjZXMuDQo+IA0K
DQpHb3QgaXQuIFRoYW5rcyENCg==
