Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F442240FB
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 21:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfETTNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 15:13:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:11847 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfETTNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 15:13:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 12:13:49 -0700
X-ExtLoop1: 1
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by FMSMGA003.fm.intel.com with ESMTP; 20 May 2019 12:13:48 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX108.amr.corp.intel.com ([169.254.2.171]) with mapi id 14.03.0415.000;
 Mon, 20 May 2019 12:13:48 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "bp@alien8.de" <bp@alien8.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mroos@linux.ee" <mroos@linux.ee>,
        "luto@kernel.org" <luto@kernel.org>,
        "namit@vmware.com" <namit@vmware.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [PATCH 1/1] vmalloc: Fix issues with flush flag
Thread-Topic: [PATCH 1/1] vmalloc: Fix issues with flush flag
Thread-Index: AQHVDPQ89Mk/2ntUo0SzbjfhLaw0JaZ027yA
Date:   Mon, 20 May 2019 19:13:48 +0000
Message-ID: <174b6e4b5891394ee1695b898d72949d53ff6c98.camel@intel.com>
References: <20190517210123.5702-1-rick.p.edgecombe@intel.com>
         <20190517210123.5702-2-rick.p.edgecombe@intel.com>
In-Reply-To: <20190517210123.5702-2-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.114.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA0B2387AB9936459A251CEF9F13FCB0@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA1LTE3IGF0IDE0OjAxIC0wNzAwLCBSaWNrIEVkZ2Vjb21iIGUgd3JvdGU6
DQo+IE1lZWxpcyBSb29zIHJlcG9ydGVkIGlzc3VlcyB3aXRoIHRoZSBuZXcgVk1fRkxVU0hfUkVT
RVRfUEVSTVMgZmxhZyBvbg0KPiB0aGUNCj4gc3BhcmMgYXJjaGl0ZWN0dXJlLg0KPiANCkFyZ2gs
IHRoaXMgcGF0Y2ggaXMgbm90IGNvcnJlY3QgaW4gdGhlIGZsdXNoIHJhbmdlIGZvciBub24teDg2
LiBJJ2xsDQpzZW5kIGEgcmV2aXNpb24uDQoNCg==
