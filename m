Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA423ADF3C
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 17:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFTPpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 11:45:02 -0400
Received: from mga12.intel.com ([192.55.52.136]:51915 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229658AbhFTPo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Jun 2021 11:44:59 -0400
IronPort-SDR: 3c6kY7sjcyOnVNpo4Umb/F9HHgtx5fIHn+9z01/wMjHevIE9gwOsr+MVFhOSO3Hl+uhJZUX/S+
 ZLBL+SrTBA+Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10021"; a="186424560"
X-IronPort-AV: E=Sophos;i="5.83,287,1616482800"; 
   d="scan'208";a="186424560"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2021 08:42:45 -0700
IronPort-SDR: ZP0WQ6q8hCJ29RLPFzGbZQxl0NsG0yA/kr0+h4Q1jt/dFuIrg+pNqqrDuLE/yhs+KOWQR2B/Ia
 SAndkue06NMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,287,1616482800"; 
   d="scan'208";a="486228353"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 20 Jun 2021 08:42:45 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 20 Jun 2021 08:42:44 -0700
Received: from bgsmsx606.gar.corp.intel.com (10.67.234.8) by
 BGSMSX606.gar.corp.intel.com (10.67.234.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 20 Jun 2021 21:12:41 +0530
Received: from bgsmsx606.gar.corp.intel.com ([10.67.234.8]) by
 BGSMSX606.gar.corp.intel.com ([10.67.234.8]) with mapi id 15.01.2242.008;
 Sun, 20 Jun 2021 21:12:41 +0530
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>
Subject: RE: [PATCH net-next 06/10] net: iosm: drop custom netdev(s) removing
Thread-Topic: [PATCH net-next 06/10] net: iosm: drop custom netdev(s) removing
Thread-Index: AQHXYX2m63nCp9sPx0irlRcXob+UqKscsGEAgABerrA=
Date:   Sun, 20 Jun 2021 15:42:41 +0000
Message-ID: <1d31c18cebf74ff29b5e388c4cd26361@intel.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
 <20210615003016.477-7-ryazanov.s.a@gmail.com>
 <CAHNKnsR5X8Axttk_YX=fpi5h6iV191fLJ6MZqrLvhZvPe==mXA@mail.gmail.com>
In-Reply-To: <CAHNKnsR5X8Axttk_YX=fpi5h6iV191fLJ6MZqrLvhZvPe==mXA@mail.gmail.com>
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

SGkgU2VyZ2V5LA0KDQo+IE9uIFR1ZSwgSnVuIDE1LCAyMDIxIGF0IDM6MzAgQU0gU2VyZ2V5IFJ5
YXphbm92DQo+IDxyeWF6YW5vdi5zLmFAZ21haWwuY29tPiB3cm90ZToNCj4gPiBTaW5jZSB0aGUg
bGFzdCBjb21taXQsIHRoZSBXV0FOIGNvcmUgd2lsbCByZW1vdmUgYWxsIG91ciBuZXR3b3JrDQo+
ID4gaW50ZXJmYWNlcyBmb3IgdXMgYXQgdGhlIHRpbWUgb2YgdGhlIFdXQU4gbmV0ZGV2IG9wcyB1
bnJlZ2lzdGVyaW5nLg0KPiA+IFRoZXJlZm9yZSwgd2UgY2FuIHNhZmVseSBkcm9wIHRoZSBjdXN0
b20gY29kZSB0aGF0IGNsZWFuaW5nIHRoZSBsaXN0DQo+ID4gb2YgY3JlYXRlZCBuZXRkZXZzLiBB
bnl3YXkgaXQgbm8gbG9uZ2VyIHJlbW92ZXMgYW55IG5ldGRldiwgc2luY2UgYWxsDQo+ID4gbmV0
ZGV2cyB3ZXJlIHJlbW92ZWQgZWFybGllciBpbiB0aGUgd3dhbl91bnJlZ2lzdGVyX29wcygpIGNh
bGwuDQo+IA0KPiBBcmUgeW91IE9rIHdpdGggdGhpcyBjaGFuZ2U/IEkgcGxhbiB0byBzdWJtaXQg
YSBuZXh0IHZlcnNpb24gb2YgdGhlIHNlcmllcy4gSWYNCj4geW91IGhhdmUgYW55IG9iamVjdGlv
bnMsIEkgY2FuIGFkZHJlc3MgdGhlbSBpbiBWMi4NCg0KQ2hhbmdlcyBsb29rcyBmaW5lLg0KIA0K
PiBCVFcsIGlmIElPU00gbW9kZW1zIGhhdmUgYSBkZWZhdWx0IGRhdGEgY2hhbm5lbCwgSSBjYW4g
YWRkIGEgc2VwYXJhdGUNCj4gcGF0Y2ggdG8gdGhlIHNlcmllcyB0byBjcmVhdGUgYSBkZWZhdWx0
IG5ldHdvcmsgaW50ZXJmYWNlIGZvciBJT1NNIGlmIHlvdSB0ZWxsDQo+IG1lIHdoaWNoIGxpbmsg
aWQgaXMgdXNlZCBmb3IgdGhlIGRlZmF1bHQgZGF0YSBjaGFubmVsLg0KDQpMaW5rIGlkIDEgaXMg
YWx3YXlzIGFzc29jaWF0ZWQgYXMgZGVmYXVsdCBkYXRhIGNoYW5uZWwuIA0KDQpUaGFua3MsDQpS
ZXZpZXdlZC1ieTogTSBDaGV0YW4gS3VtYXIgPG0uY2hldGFuLmt1bWFyQGludGVsLmNvbT4NCg==
