Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8066D891
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 03:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfGSBr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 21:47:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:36383 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfGSBr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 21:47:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 18:47:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,280,1559545200"; 
   d="scan'208";a="158969092"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 18:47:55 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jul 2019 18:47:55 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.44]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.148]) with mapi id 14.03.0439.000;
 Thu, 18 Jul 2019 18:47:55 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH 2/2] e1000e: disable force K1-off
 feature
Thread-Topic: [Intel-wired-lan] [PATCH 2/2] e1000e: disable force K1-off
 feature
Thread-Index: AQHVPdP7vBl3T42EgE6ElZb5gwVOlw==
Date:   Fri, 19 Jul 2019 01:47:54 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B970D36B7@ORSMSX103.amr.corp.intel.com>
References: <20190708045546.30160-1-kai.heng.feng@canonical.com>
 <20190708045546.30160-2-kai.heng.feng@canonical.com>
In-Reply-To: <20190708045546.30160-2-kai.heng.feng@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTA4IGF0IDEyOjU1ICswODAwLCBLYWktSGVuZyBGZW5nIHdyb3RlOgo+
IEZvcndhcmRwb3J0IGZyb20gaHR0cDovL21haWxzLmRwZGsub3JnL2FyY2hpdmVzL2Rldi8yMDE2
LU5vdmVtYmVyLzA1MDY1OC5odG1sCj4gCj4gTUFDLVBIWSBkZXN5bmMgbWF5IG9jY3VyIGNhdXNp
bmcgbWlzZGV0ZWN0aW9uIG9mIGxpbmsgdXAgZXZlbnQuCj4gRGlzYWJsaW5nIEsxLW9mZiBmZWF0
dXJlIGNhbiB3b3JrIGFyb3VuZCB0aGUgcHJvYmxlbS4KPiAKPiBCdWd6aWxsYTogaHR0cHM6Ly9i
dWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMDQwNTcKPiAKPiBTaWduZWQtb2Zm
LWJ5OiBLYWktSGVuZyBGZW5nIDxrYWkuaGVuZy5mZW5nQGNhbm9uaWNhbC5jb20+Cj4gLS0tCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2UxMDAwZS9ody5oICAgICAgfCAxICsKPiAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL2ljaDhsYW4uYyB8IDMgKysrCj4gIDIgZmls
ZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCj4gCgpUZXN0ZWQtYnk6IEFhcm9uIEJyb3duIDxh
YXJvbi5mLmJyb3duQGludGVsLmNvbT4K
