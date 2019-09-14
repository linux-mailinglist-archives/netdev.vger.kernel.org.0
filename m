Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07209B2939
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 03:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbfINBEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 21:04:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:24801 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfINBEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 21:04:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 18:04:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="386585070"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga006.fm.intel.com with ESMTP; 13 Sep 2019 18:04:00 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 13 Sep 2019 18:04:00 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.221]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.225]) with mapi id 14.03.0439.000;
 Fri, 13 Sep 2019 18:03:59 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Lyude Paul <lyude@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Tang, Feng" <feng.tang@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] igb/igc: Don't warn on fatal read failures when the
 device is removed
Thread-Topic: [PATCH] igb/igc: Don't warn on fatal read failures when the
 device is removed
Thread-Index: AQHVaphKjuHnK0NY0keIdDYW5WflHg==
Date:   Sat, 14 Sep 2019 01:03:59 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B971184D0@ORSMSX103.amr.corp.intel.com>
References: <20190822183318.27634-1-lyude@redhat.com>
In-Reply-To: <20190822183318.27634-1-lyude@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTIyIGF0IDE0OjMzIC0wNDAwLCBMeXVkZSBQYXVsIHdyb3RlOgo+IEZh
dGFsIHJlYWQgZXJyb3JzIGFyZSB3b3J0aCB3YXJuaW5nIGFib3V0LCB1bmxlc3Mgb2YgY291cnNl
IHRoZSBkZXZpY2UKPiB3YXMganVzdCB1bnBsdWdnZWQgZnJvbSB0aGUgbWFjaGluZSAtIHNvbWV0
aGluZyB0aGF0J3MgYSByYXRoZXIgbm9ybWFsCj4gb2NjdXJlbmNlIHdoZW4gdGhlIGlnYi9pZ2Mg
YWRhcHRlciBpcyBsb2NhdGVkIG9uIGEgVGh1bmRlcmJvbHQgZG9jay4gU28sCj4gbGV0J3Mgb25s
eSBXQVJOKCkgaWYgdGhlcmUncyBhIGZhdGFsIHJlYWQgZXJyb3Igd2hpbGUgdGhlIGRldmljZSBp
cwo+IHN0aWxsIHByZXNlbnQuCj4gCj4gVGhpcyBmaXhlcyB0aGUgZm9sbG93aW5nIFdBUk4gc3Bs
YXQgdGhhdCdzIGJlZW4gYXBwZWFyaW5nIHdoZW5ldmVyIEkKPiB1bnBsdWcgbXkgQ2FsZGlnaXQg
VFMzIFRodW5kZXJib2x0IGRvY2sgZnJvbSBteSBsYXB0b3A6Cj4gCj4gICBpZ2IgMDAwMDowOTow
MC4wIGVucDlzMDogUENJZSBsaW5rIGxvc3QKPiAgIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0t
LS0tLS0tLS0tLQo+ICAgaWdiOiBGYWlsZWQgdG8gcmVhZCByZWcgMHgxOCEKPiAgIFdBUk5JTkc6
IENQVTogNyBQSUQ6IDUxNiBhdAo+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2ln
Yl9tYWluLmM6NzU2IGlnYl9yZDMyKzB4NTcvMHg2YSBbaWdiXQo+ICAgTW9kdWxlcyBsaW5rZWQg
aW46IGlnYiBkY2EgdGh1bmRlcmJvbHQgZnVzZSB2ZmF0IGZhdCBlbGFuX2kyYyBtZWlfd2R0Cj4g
ICBtZWlfaGRjcCBpOTE1IHdtaV9ibW9mIGludGVsX3dtaV90aHVuZGVyYm9sdCBpVENPX3dkdAo+
ICAgaVRDT192ZW5kb3Jfc3VwcG9ydCB4ODZfcGtnX3RlbXBfdGhlcm1hbCBpbnRlbF9wb3dlcmNs
YW1wIGpveWRldgo+ICAgY29yZXRlbXAgY3JjdDEwZGlmX3BjbG11bCBjcmMzMl9wY2xtdWwgaTJj
X2FsZ29fYml0IGdoYXNoX2NsbXVsbmlfaW50ZWwKPiAgIGludGVsX2NzdGF0ZSBkcm1fa21zX2hl
bHBlciBpbnRlbF91bmNvcmUgc3lzY29weWFyZWEgc3lzZmlsbHJlY3QKPiAgIHN5c2ltZ2JsdCBm
Yl9zeXNfZm9wcyBpbnRlbF9yYXBsX3BlcmYgaW50ZWxfeGhjaV91c2Jfcm9sZV9zd2l0Y2ggbWVp
X21lCj4gICBkcm0gcm9sZXMgaWRtYTY0IGkyY19pODAxIHVjc2lfYWNwaSB0eXBlY191Y3NpIG1l
aSBpbnRlbF9scHNzX3BjaQo+ICAgcHJvY2Vzc29yX3RoZXJtYWxfZGV2aWNlIHR5cGVjIGludGVs
X3BjaF90aGVybWFsIGludGVsX3NvY19kdHNfaW9zZgo+ICAgaW50ZWxfbHBzcyBpbnQzNDAzX3Ro
ZXJtYWwgdGhpbmtwYWRfYWNwaSB3bWkgaW50MzQweF90aGVybWFsX3pvbmUKPiAgIGxlZHRyaWdf
YXVkaW8gaW50MzQwMF90aGVybWFsIGFjcGlfdGhlcm1hbF9yZWwgYWNwaV9wYWQgdmlkZW8KPiAg
IHBjY19jcHVmcmVxIGlwX3RhYmxlcyBzZXJpb19yYXcgbnZtZSBudm1lX2NvcmUgY3JjMzJjX2lu
dGVsIHVhcwo+ICAgdXNiX3N0b3JhZ2UgZTEwMDBlIGkyY19kZXYKPiAgIENQVTogNyBQSUQ6IDUx
NiBDb21tOiBrd29ya2VyL3UxNjozIE5vdCB0YWludGVkIDUuMi4wLXJjMUx5dWRlLVRlc3QrICMx
NAo+ICAgSGFyZHdhcmUgbmFtZTogTEVOT1ZPIDIwTDhTMk44MDAvMjBMOFMyTjgwMCwgQklPUyBO
MjJFVDM1VyAoMS4xMiApIDA0LzA5LzIwMTgKPiAgIFdvcmtxdWV1ZToga2FjcGlfaG90cGx1ZyBh
Y3BpX2hvdHBsdWdfd29ya19mbgo+ICAgUklQOiAwMDEwOmlnYl9yZDMyKzB4NTcvMHg2YSBbaWdi
XQo+ICAgQ29kZTogODcgYjggZmMgZmYgZmYgNDggYzcgNDcgMDggMDAgMDAgMDAgMDAgNDggYzcg
YzYgMzMgNDIgOWIgYzAgNGMgODkKPiAgIGM3IGU4IDQ3IDQ1IGNkIGRjIDg5IGVlIDQ4IGM3IGM3
IDQzIDQyIDliIGMwIGU4IGMxIDk0IDcxIGRjIDwwZj4gMGIgZWIKPiAgIDA4IDhiIDAwIGZmIGMw
IDc1IGIwIGViIGM4IDQ0IDg5IGUwIDVkIDQxIDVjIGMzIDBmIDFmIDQ0Cj4gICBSU1A6IDAwMTg6
ZmZmZmJhNTgwMWNmN2M0OCBFRkxBR1M6IDAwMDEwMjg2Cj4gICBSQVg6IDAwMDAwMDAwMDAwMDAw
MDAgUkJYOiBmZmZmOWU3OTU2NjA4ODQwIFJDWDogMDAwMDAwMDAwMDAwMDAwNwo+ICAgUkRYOiAw
MDAwMDAwMDAwMDAwMDAwIFJTSTogZmZmZmJhNTgwMWNmN2IyNCBSREk6IGZmZmY5ZTc5NWUzZDZh
MDAKPiAgIFJCUDogMDAwMDAwMDAwMDAwMDAxOCBSMDg6IDAwMDAwMDAwOWRlYzRhMDEgUjA5OiBm
ZmZmZmZmZjllNjEwMThmCj4gICBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiBmZmZmYmE1ODAx
Y2Y3YWU1IFIxMjogMDAwMDAwMDBmZmZmZmZmZgo+ICAgUjEzOiBmZmZmOWU3OTU2NjA4ODQwIFIx
NDogZmZmZjllNzk1YTZmMTBiMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKPiAgIEZTOiAgMDAwMDAw
MDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmOWU3OTVlM2MwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAw
MDAwMDAwMDAKPiAgIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAw
NTAwMzMKPiAgIENSMjogMDAwMDU2NDMxN2JjNDA4OCBDUjM6IDAwMDAwMDAxMGUwMGEwMDYgQ1I0
OiAwMDAwMDAwMDAwMzYwNmUwCj4gICBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAw
MDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMAo+ICAgRFIzOiAwMDAwMDAwMDAwMDAwMDAw
IERSNjogMDAwMDAwMDBmZmZlMGZmMCBEUjc6IDAwMDAwMDAwMDAwMDA0MDAKPiAgIENhbGwgVHJh
Y2U6Cj4gICAgaWdiX3JlbGVhc2VfaHdfY29udHJvbCsweDFhLzB4MzAgW2lnYl0KPiAgICBpZ2Jf
cmVtb3ZlKzB4YzUvMHgxNGIgW2lnYl0KPiAgICBwY2lfZGV2aWNlX3JlbW92ZSsweDNiLzB4OTMK
PiAgICBkZXZpY2VfcmVsZWFzZV9kcml2ZXJfaW50ZXJuYWwrMHhkNy8weDE3ZQo+ICAgIHBjaV9z
dG9wX2J1c19kZXZpY2UrMHgzNi8weDc1Cj4gICAgcGNpX3N0b3BfYnVzX2RldmljZSsweDY2LzB4
NzUKPiAgICBwY2lfc3RvcF9idXNfZGV2aWNlKzB4NjYvMHg3NQo+ICAgIHBjaV9zdG9wX2FuZF9y
ZW1vdmVfYnVzX2RldmljZSsweGYvMHgxOQo+ICAgIHRyaW1fc3RhbGVfZGV2aWNlcysweGM1LzB4
MTNhCj4gICAgPyBfX3BtX3J1bnRpbWVfcmVzdW1lKzB4NmUvMHg3Ygo+ICAgIHRyaW1fc3RhbGVf
ZGV2aWNlcysweDEwMy8weDEzYQo+ICAgID8gX19wbV9ydW50aW1lX3Jlc3VtZSsweDZlLzB4N2IK
PiAgICB0cmltX3N0YWxlX2RldmljZXMrMHgxMDMvMHgxM2EKPiAgICBhY3BpcGhwX2NoZWNrX2Jy
aWRnZSsweGQ4LzB4ZjUKPiAgICBhY3BpcGhwX2hvdHBsdWdfbm90aWZ5KzB4ZjcvMHgxNGIKPiAg
ICA/IGFjcGlwaHBfY2hlY2tfYnJpZGdlKzB4ZjUvMHhmNQo+ICAgIGFjcGlfZGV2aWNlX2hvdHBs
dWcrMHgzNTcvMHgzYjUKPiAgICBhY3BpX2hvdHBsdWdfd29ya19mbisweDFhLzB4MjMKPiAgICBw
cm9jZXNzX29uZV93b3JrKzB4MWE3LzB4Mjk2Cj4gICAgd29ya2VyX3RocmVhZCsweDFhOC8weDI0
Ywo+ICAgID8gcHJvY2Vzc19zY2hlZHVsZWRfd29ya3MrMHgyYy8weDJjCj4gICAga3RocmVhZCsw
eGU5LzB4ZWUKPiAgICA/IGt0aHJlYWRfZGVzdHJveV93b3JrZXIrMHg0MS8weDQxCj4gICAgcmV0
X2Zyb21fZm9yaysweDM1LzB4NDAKPiAgIC0tLVsgZW5kIHRyYWNlIDI1MmJmMTAzNTJjNjNkMjIg
XS0tLQo+IAo+IFNpZ25lZC1vZmYtYnk6IEx5dWRlIFBhdWwgPGx5dWRlQHJlZGhhdC5jb20+Cj4g
Rml4ZXM6IDQ3ZTE2NjkyYjI2YiAoImlnYi9pZ2M6IHdhcm4gd2hlbiBmYXRhbCByZWFkIGZhaWx1
cmUgaGFwcGVucyIpCj4gQ2M6IEZlbmcgVGFuZyA8ZmVuZy50YW5nQGludGVsLmNvbT4KPiBDYzog
U2FzaGEgTmVmdGluIDxzYXNoYS5uZWZ0aW5AaW50ZWwuY29tPgo+IENjOiBKZWZmIEtpcnNoZXIg
PGplZmZyZXkudC5raXJzaGVyQGludGVsLmNvbT4KPiBDYzogaW50ZWwtd2lyZWQtbGFuQGxpc3Rz
Lm9zdW9zbC5vcmcKPiAtLS0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9t
YWluLmMgfCAzICsrLQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4u
YyB8IDMgKystCj4gIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQo+IAoKVGVzdGVkLWJ5OiBBYXJvbiBCcm93biA8YWFyb24uZi5icm93bkBpbnRlbC5jb20+
Cg==
