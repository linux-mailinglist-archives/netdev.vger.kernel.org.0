Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB961FC0E9
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 23:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgFPVUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 17:20:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:55911 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgFPVUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 17:20:09 -0400
IronPort-SDR: HuHeWNLP+q7mLuCg4JkjW2t2orvKQGysuL4FkjDGp6xRpebp8GuNq3Xbv8WIDYP2NmcNNnzp7Y
 I4TuZTiI11NQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 14:20:08 -0700
IronPort-SDR: pd8IGOukXezEe3OY+umSJxFmYOhb3VRSZ/EyUl9sEMKboWL0vnbtrFgjG6ZL96JVxSERcHCp2P
 AKWJL2AN9TDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,519,1583222400"; 
   d="scan'208";a="291203371"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga002.jf.intel.com with ESMTP; 16 Jun 2020 14:20:08 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 16 Jun 2020 14:20:08 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.32]) with mapi id 14.03.0439.000;
 Tue, 16 Jun 2020 14:20:08 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Thelen <gthelen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] e1000e: add ifdef to avoid dead code
Thread-Topic: [PATCH] e1000e: add ifdef to avoid dead code
Thread-Index: AQHWQhKmTMhQGPWEEkalMgzeJC4tg6jbzRAA///16rA=
Date:   Tue, 16 Jun 2020 21:20:07 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449871E142@ORSMSX112.amr.corp.intel.com>
References: <20200614061122.35928-1-gthelen@google.com>
 <b88dc544-9f1b-75af-244e-9967ffeacf0e@gmail.com>
In-Reply-To: <b88dc544-9f1b-75af-244e-9967ffeacf0e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFcmljIER1bWF6ZXQgPGVyaWMu
ZHVtYXpldEBnbWFpbC5jb20+DQo+IE9uIDYvMTMvMjAgMTE6MTEgUE0sIEdyZWcgVGhlbGVuIHdy
b3RlOg0KPiA+IENvbW1pdCBlMDg2YmEyZmNjZGEgKCJlMTAwMGU6IGRpc2FibGUgczBpeCBlbnRy
eSBhbmQgZXhpdCBmbG93cyBmb3IgTUUNCj4gPiBzeXN0ZW1zIikgYWRkZWQgZTEwMDBlX2NoZWNr
X21lKCkgYnV0IGl0J3Mgb25seSBjYWxsZWQgZnJvbQ0KPiA+IENPTkZJR19QTV9TTEVFUCBwcm90
ZWN0ZWQgY29kZS4gIFRodXMgYnVpbGRzIHdpdGhvdXQgQ09ORklHX1BNX1NMRUVQDQo+ID4gc2Vl
Og0KPiA+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jOjEzNzox
Mzogd2FybmluZzoNCj4gPiAnZTEwMDBlX2NoZWNrX21lJyBkZWZpbmVkIGJ1dCBub3QgdXNlZCBb
LVd1bnVzZWQtZnVuY3Rpb25dDQo+ID4NCj4gPiBBZGQgQ09ORklHX1BNX1NMRUVQIGlmZGVmIGd1
YXJkIHRvIGF2b2lkIGRlYWQgY29kZS4NCj4gPg0KPiA+IEZpeGVzOiBlMDg2YmEyZmNjZGEgKCJl
MTAwMGU6IGRpc2FibGUgczBpeCBlbnRyeSBhbmQgZXhpdCBmbG93cyBmb3IgTUUNCj4gPiBzeXN0
ZW1zIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBHcmVnIFRoZWxlbiA8Z3RoZWxlbkBnb29nbGUuY29t
Pg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvbmV0ZGV2
LmMgfCAyICsrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gDQo+IFJl
dmlld2VkLWJ5OiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+DQpbS2lyc2hlciwg
SmVmZnJleSBUXSANCg0KVGhpcyBwYXRjaCBpcyBub3QgbmVjZXNzYXJ5LCBhZnRlciBBcm5kJ3Mg
cGF0Y2guICBIZXJlIGlzIGhpcyBwYXRjaDoNCmh0dHA6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9w
cm9qZWN0L2ludGVsLXdpcmVkLWxhbi9wYXRjaC8yMDIwMDUyNzEzNDcxNi45NDgxNDgtMS1hcm5k
QGFybmRiLmRlLw0KIGFuZCBJIHdpbGwgYmUgcHVzaGluZyBpdCB0byBEYXZlJ3MgbmV0IHRyZWUg
bGF0ZXIgdG9uaWdodC4NCg==
