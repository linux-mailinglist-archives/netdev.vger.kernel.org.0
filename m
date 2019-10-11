Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DEED3601
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfJKA33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:29:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:45665 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfJKA32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 20:29:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 17:29:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="277958063"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga001.jf.intel.com with ESMTP; 10 Oct 2019 17:29:27 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 10 Oct 2019 17:29:27 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.9]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.216]) with mapi id 14.03.0439.000;
 Thu, 10 Oct 2019 17:29:26 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Josh Hunt <johunt@akamai.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
CC:     Netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH 0/3] igb, ixgbe, i40e UDP segmentation offload support
Thread-Topic: [PATCH 0/3] igb, ixgbe, i40e UDP segmentation offload support
Thread-Index: AQHVf7AvEuwAIS+ExU2JBy/0UpLthKdU2m0AgAArTAD//428AIAAd+iA//+K9NA=
Date:   Fri, 11 Oct 2019 00:29:26 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B9714C792@ORSMSX103.amr.corp.intel.com>
References: <1570658777-13459-1-git-send-email-johunt@akamai.com>
 <CAKgT0UdBPYRnwAuOGhCBAJSRhdHcnw28Tznr0GPAtqe-JWFjTQ@mail.gmail.com>
 <cd8ac880-61fe-b064-6271-993e8c6eee65@akamai.com>
 <CAKgT0UfXgzur2TGv1dNw0PQXAP0C=bNoJY6gnthASeQrHr66AA@mail.gmail.com>
 <0e0e706c-4ce9-c27a-af55-339b4eb6d524@akamai.com>
 <309B89C4C689E141A5FF6A0C5FB2118B9714C727@ORSMSX103.amr.corp.intel.com>
 <71a74c86-18b6-5c6a-8663-e558c43af682@akamai.com>
In-Reply-To: <71a74c86-18b6-5c6a-8663-e558c43af682@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjEzY2JiODEtYjllOC00ZDY3LWFlN2YtODFlNjQzYWRmMDk4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiS3l0SDJKS2RwNzhWcVdnYXF3VXJKbzVCdzVNRVNqbjV5WjVHV1BXbnRSYUpVSzg5OUlHaklta0RWc3JWM1VjeSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9zaCBIdW50IFttYWls
dG86am9odW50QGFrYW1haS5jb21dDQo+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDEwLCAyMDE5
IDU6MjggUE0NCj4gVG86IEJyb3duLCBBYXJvbiBGIDxhYXJvbi5mLmJyb3duQGludGVsLmNvbT47
IEFsZXhhbmRlciBEdXljaw0KPiA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT47IEJvd2Vycywg
QW5kcmV3WA0KPiA8YW5kcmV3eC5ib3dlcnNAaW50ZWwuY29tPg0KPiBDYzogTmV0ZGV2IDxuZXRk
ZXZAdmdlci5rZXJuZWwub3JnPjsgV2lsbGVtIGRlIEJydWlqbg0KPiA8d2lsbGVtYkBnb29nbGUu
Y29tPjsgaW50ZWwtd2lyZWQtbGFuIDxpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZz4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCAwLzNdIGlnYiwgaXhnYmUsIGk0MGUgVURQIHNlZ21lbnRh
dGlvbiBvZmZsb2FkIHN1cHBvcnQNCj4gDQo+IE9uIDEwLzEwLzE5IDU6MjEgUE0sIEJyb3duLCBB
YXJvbiBGIHdyb3RlOg0KPiA+IEFkZGluZyBBbmRyZXcgYXMgaGUgaXMgbW9zdCBsaWtlbHkgZ29p
bmcgdG8gYmUgdGVzdGluZyB0aGlzIHBhdGNoLg0KPiA+DQo+ID4gVW5mb3J0dW5hdGVseSBteSBt
YWlsIHNlcnZlciBmbGFncyBhdHRhY2hlZCBzY3JpcHRzIGFzIHBvdGVudGlhbCB0aHJlYXRzIGFu
ZA0KPiBzdHJpcHMgdGhlbSBvdXQuICBDYW4geW91IHJlc2VudCBpdCBhcyBhbiB0YXIgZmlsZT8g
IEkgZG9uJ3QgYmVsaWV2ZSBpdCdzIHNtYXJ0DQo+IGVub3VnaCB0byBvcGVuIHVwIHRhciBhbmQg
ZmxhZyBpdCBhcyBhIHNjcmlwdC4NCj4gPg0KPiANCj4gSGkgQWFyb24NCj4gDQo+IEl0IGxvb2tz
IGxpa2UgdGhlIG5ldGRldiBhcmNoaXZlIGhhcyB0aGUgZmlsZS4gQ2FuIHlvdSB0cnkgZ3JhYmJp
bmcgaXQNCj4gZnJvbSBoZXJlPw0KDQpZZXMsIEkgY2FuLiAgVGhhbmtzLg0KDQo+IA0KPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMGUwZTcwNmMtNGNlOS1jMjdhLWFmNTUtDQo+IDMz
OWI0ZWI2ZDUyNEBha2FtYWkuY29tLzItdWRwZ3NvX2JlbmNoLnNoDQo+IA0KPiBJZiB0aGF0IGRv
ZXNuJ3Qgd29yayBJIGNhbiB0cnkgeW91ciB0YXIgd29ya2Fyb3VuZC4NCj4gDQo+IFRoYW5rcw0K
PiBKb3NoDQo=
