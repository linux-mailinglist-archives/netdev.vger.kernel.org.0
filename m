Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0430D6D88D
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 03:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfGSBrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 21:47:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:34298 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbfGSBrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 21:47:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 18:47:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,280,1559545200"; 
   d="scan'208";a="158968965"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 18:47:12 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jul 2019 18:47:11 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.44]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.26]) with mapi id 14.03.0439.000;
 Thu, 18 Jul 2019 18:47:11 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH 1/2] e1000e: add workaround for
 possible stalled packet
Thread-Topic: [Intel-wired-lan] [PATCH 1/2] e1000e: add workaround for
 possible stalled packet
Thread-Index: AQHVPdPhmp9sws8O4UaUAixIR40qew==
Date:   Fri, 19 Jul 2019 01:47:11 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B970D36A9@ORSMSX103.amr.corp.intel.com>
References: <20190708045546.30160-1-kai.heng.feng@canonical.com>
In-Reply-To: <20190708045546.30160-1-kai.heng.feng@canonical.com>
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
LU5vdmVtYmVyLzA1MDY1Ny5odG1sCj4gCj4gVGhpcyB3b3JrcyBhcm91bmQgYSBwb3NzaWJsZSBz
dGFsbGVkIHBhY2tldCBpc3N1ZSwgd2hpY2ggbWF5IG9jY3VyIGR1ZSB0bwo+IGNsb2NrIHJlY292
ZXJ5IGZyb20gdGhlIFBDSCBiZWluZyB0b28gc2xvdywgd2hlbiB0aGUgTEFOIGlzIHRyYW5zaXRp
b25pbmcKPiBmcm9tIEsxIGF0IDFHIGxpbmsgc3BlZWQuCj4gCj4gQnVnemlsbGE6IGh0dHBzOi8v
YnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjA0MDU3Cj4gCj4gU2lnbmVkLW9m
Zi1ieTogS2FpLUhlbmcgRmVuZyA8a2FpLmhlbmcuZmVuZ0BjYW5vbmljYWwuY29tPgo+IC0tLQo+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvaWNoOGxhbi5jIHwgMTAgKysrKysr
KysrKwo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvaWNoOGxhbi5oIHwgIDIg
Ky0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpU
ZXN0ZWQtYnk6IEFhcm9uIEJyb3duIDxhYXJvbi5mLmJyb3duQGludGVsLmNvbT4K
