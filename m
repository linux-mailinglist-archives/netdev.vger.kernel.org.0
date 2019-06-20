Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78844DC4E
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 23:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfFTVNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 17:13:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:1293 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfFTVNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 17:13:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 14:13:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="335627118"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga005.jf.intel.com with ESMTP; 20 Jun 2019 14:13:06 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.248]) by
 ORSMSX107.amr.corp.intel.com ([169.254.1.18]) with mapi id 14.03.0439.000;
 Thu, 20 Jun 2019 14:13:06 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>
Subject: Re: [PATCH net-next v4 2/7] etf: Add skip_sock_check
Thread-Topic: [PATCH net-next v4 2/7] etf: Add skip_sock_check
Thread-Index: AQHVJsYYwRIEYLZLfUSMExk3vowbhKakqMmAgADY6oA=
Date:   Thu, 20 Jun 2019 21:13:05 +0000
Message-ID: <16905BC8-A604-4A74-A9BA-4FCA6F40FE55@intel.com>
References: <1560966016-28254-1-git-send-email-vedang.patel@intel.com>
 <1560966016-28254-3-git-send-email-vedang.patel@intel.com>
 <c304970a-1973-cdce-17b5-682f28856306@cogentembedded.com>
In-Reply-To: <c304970a-1973-cdce-17b5-682f28856306@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.150]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2EE590B8DFA63B42AF55B316B696B47E@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVuIDIwLCAyMDE5LCBhdCAxOjE2IEFNLCBTZXJnZWkgU2h0eWx5b3YgPHNlcmdl
aS5zaHR5bHlvdkBjb2dlbnRlbWJlZGRlZC5jb20+IHdyb3RlOg0KPiANCj4gT24gMTkuMDYuMjAx
OSAyMDo0MCwgVmVkYW5nIFBhdGVsIHdyb3RlOg0KPiANCj4+IEN1cnJlbnRseSwgZXRmIGV4cGVj
dHMgYSBzb2NrZXQgd2l0aCBTT19UWFRJTUUgb3B0aW9uIHNldCBmb3IgZWFjaCBwYWNrZXQNCj4+
IGl0IGVuY291bnRlcnMuIFNvLCBpdCB3aWxsIGRyb3AgYWxsIG90aGVyIHBhY2tldHMuIEJ1dCwg
aW4gdGhlIGZ1dHVyZQ0KPj4gY29tbWl0cyB3ZSBhcmUgcGxhbm5pbmcgdG8gYWRkIGZ1bmN0aW9u
YWxpdHkgd2hpY2ggd2hlcmUgdHN0YW1wIHZhbHVlIHdpbGwNCj4gDQo+ICAgT25lIG9mICJ3aGlj
aCIgYW5kICJ3aGVyZSIsIG5vdCBib3RoLiA6LSkNCj4gDQpZZWFoLiBJdOKAmXMgYSB0eXBvLiBX
aWxsIGZpeCBpdCBpbiBuZXh0IHZlcnNpb24uDQoNClRoYW5rcywNClZlZGFuZw0KPj4gYmUgc2V0
IGJ5IGFub3RoZXIgcWRpc2MuIEFsc28sIHNvbWUgcGFja2V0cyB3aGljaCBhcmUgZ2VuZXJhdGVk
IGZyb20gd2l0aGluDQo+PiB0aGUga2VybmVsIChlLmcuIElDTVAgcGFja2V0cykgZG8gbm90IGhh
dmUgYW55IHNvY2tldCBhc3NvY2lhdGVkIHdpdGggdGhlbS4NCj4+IFNvLCB0aGlzIGNvbW1pdCBh
ZGRzIHN1cHBvcnQgZm9yIHNraXBfc29ja19jaGVjay4gV2hlbiB0aGlzIG9wdGlvbiBpcyBzZXQs
DQo+PiBldGYgd2lsbCBza2lwIGNoZWNraW5nIGZvciBhIHNvY2tldCBhbmQgb3RoZXIgYXNzb2Np
YXRlZCBvcHRpb25zIGZvciBhbGwNCj4+IHNrYnMuDQo+PiBTaWduZWQtb2ZmLWJ5OiBWZWRhbmcg
UGF0ZWwgPHZlZGFuZy5wYXRlbEBpbnRlbC5jb20+DQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdl
aQ0KDQo=
