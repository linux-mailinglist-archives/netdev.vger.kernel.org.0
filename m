Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27503316D8
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfEaV6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:58:05 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:6802 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfEaV6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:58:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559339881; x=1590875881;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BKmZWZmr7edKPtrntfJ/tSENtBamCGLSoA3AplRK2Ck=;
  b=a/34oYUXw3yAGcLs0gZK9bkmE9VMnyxz8U/yQsYIIDElEz8m4PZBE68g
   M9rXcIzX6GrieT+PfZqrV9SEcnhyrjzp8d/2+Ce088cex6qqq9EtTliX9
   HL6JJnnS/nElV6L3tAsAQKT1I2p6UuajQ3lZ87KS4A7+eOWex8Jdp8xc5
   w=;
X-IronPort-AV: E=Sophos;i="5.60,536,1549929600"; 
   d="scan'208";a="398889638"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 31 May 2019 21:57:59 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 3AAE1A23A6;
        Fri, 31 May 2019 21:57:59 +0000 (UTC)
Received: from EX13D04EUB002.ant.amazon.com (10.43.166.51) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 21:57:58 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D04EUB002.ant.amazon.com (10.43.166.51) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 21:57:57 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1367.000;
 Fri, 31 May 2019 21:57:51 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Jubran, Samih" <sameehj@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra properties
 retrieval via get_priv_flags
Thread-Topic: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra
 properties retrieval via get_priv_flags
Thread-Index: AQHVFgPvMYBpiBMpoE+40BgsmYX+s6aE5viAgABvb4A=
Date:   Fri, 31 May 2019 21:57:51 +0000
Message-ID: <30FE74C2-429B-4837-84D5-E973F33AF35F@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
 <20190529095004.13341-3-sameehj@amazon.com>
 <20190531081901.GC15954@unicorn.suse.cz>
In-Reply-To: <20190531081901.GC15954@unicorn.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.130]
Content-Type: text/plain; charset="utf-8"
Content-ID: <652057C26C91DF4EA4E111EB05E9CF11@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWljaGFsLA0KVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzLg0KDQrvu79PbiA1LzMxLzE5LCAx
OjIwIEFNLCAiTWljaGFsIEt1YmVjZWsiIDxta3ViZWNla0BzdXNlLmN6PiB3cm90ZToNCg0KICAg
IE9uIFdlZCwgTWF5IDI5LCAyMDE5IGF0IDEyOjQ5OjU1UE0gKzAzMDAsIHNhbWVlaGpAYW1hem9u
LmNvbSB3cm90ZToNCiAgICA+IEZyb206IEFydGh1ciBLaXlhbm92c2tpIDxha2l5YW5vQGFtYXpv
bi5jb20+DQogICAgPiANCiAgICA+IFRoaXMgY29tbWl0IGFkZHMgYSBtZWNoYW5pc20gZm9yIGV4
cG9zaW5nIGRpZmZlcmVudCBkcml2ZXINCiAgICA+IHByb3BlcnRpZXMgdmlhIGV0aHRvb2wncyBw
cml2X2ZsYWdzLg0KICAgID4gDQogICAgPiBJbiB0aGlzIGNvbW1pdCB3ZToNCiAgICA+IA0KICAg
ID4gQWRkIGNvbW1hbmRzLCBzdHJ1Y3RzIGFuZCBkZWZpbmVzIG5lY2Vzc2FyeSBmb3IgaGFuZGxp
bmcNCiAgICA+IGV4dHJhIHByb3BlcnRpZXMNCiAgICA+IA0KICAgID4gQWRkIGZ1bmN0aW9ucyBm
b3I6DQogICAgPiBBbGxvY2F0aW9uL2Rlc3RydWN0aW9uIG9mIGEgYnVmZmVyIGZvciBleHRyYSBw
cm9wZXJ0aWVzIHN0cmluZ3MuDQogICAgPiBSZXRyZWl2YWwgb2YgZXh0cmEgcHJvcGVydGllcyBz
dHJpbmdzIGFuZCBmbGFncyBmcm9tIHRoZSBuZXR3b3JrIGRldmljZS4NCiAgICA+IA0KICAgID4g
SGFuZGxlIHRoZSBhbGxvY2F0aW9uIG9mIGEgYnVmZmVyIGZvciBleHRyYSBwcm9wZXJ0aWVzIHN0
cmluZ3MuDQogICAgPiANCiAgICA+ICogSW5pdGlhbGl6ZSBidWZmZXIgd2l0aCBleHRyYSBwcm9w
ZXJ0aWVzIHN0cmluZ3MgZnJvbSB0aGUNCiAgICA+ICAgbmV0d29yayBkZXZpY2UgYXQgZHJpdmVy
IHN0YXJ0dXAuDQogICAgPiANCiAgICA+IFVzZSBldGh0b29sJ3MgZ2V0X3ByaXZfZmxhZ3MgdG8g
ZXhwb3NlIGV4dHJhIHByb3BlcnRpZXMgb2YNCiAgICA+IHRoZSBFTkEgZGV2aWNlDQogICAgPiAN
CiAgICA+IFNpZ25lZC1vZmYtYnk6IEFydGh1ciBLaXlhbm92c2tpIDxha2l5YW5vQGFtYXpvbi5j
b20+DQogICAgPiBTaWduZWQtb2ZmLWJ5OiBTYW1lZWggSnVicmFuIDxzYW1lZWhqQGFtYXpvbi5j
b20+DQogICAgPiAtLS0NCiAgICAuLi4NCiAgICA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9hbWF6b24vZW5hL2VuYV9jb20uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpv
bi9lbmEvZW5hX2NvbS5jDQogICAgPiBpbmRleCBiZDBkNzg1YjIuLjkzNWU4ZmE4ZCAxMDA2NDQN
CiAgICA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX2NvbS5jDQog
ICAgPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9jb20uYw0KICAg
ID4gQEAgLTE4NzcsNiArMTg3Nyw2MiBAQCBpbnQgZW5hX2NvbV9nZXRfbGlua19wYXJhbXMoc3Ry
dWN0IGVuYV9jb21fZGV2ICplbmFfZGV2LA0KICAgID4gIAlyZXR1cm4gZW5hX2NvbV9nZXRfZmVh
dHVyZShlbmFfZGV2LCByZXNwLCBFTkFfQURNSU5fTElOS19DT05GSUcpOw0KICAgID4gIH0NCiAg
ICA+ICANCiAgICA+ICtpbnQgZW5hX2NvbV9leHRyYV9wcm9wZXJ0aWVzX3N0cmluZ3NfaW5pdChz
dHJ1Y3QgZW5hX2NvbV9kZXYgKmVuYV9kZXYpDQogICAgPiArew0KICAgID4gKwlzdHJ1Y3QgZW5h
X2FkbWluX2dldF9mZWF0X3Jlc3AgcmVzcDsNCiAgICA+ICsJc3RydWN0IGVuYV9leHRyYV9wcm9w
ZXJ0aWVzX3N0cmluZ3MgKmV4dHJhX3Byb3BlcnRpZXNfc3RyaW5ncyA9DQogICAgPiArCQkJJmVu
YV9kZXYtPmV4dHJhX3Byb3BlcnRpZXNfc3RyaW5nczsNCiAgICA+ICsJdTMyIHJjOw0KICAgID4g
Kw0KICAgID4gKwlleHRyYV9wcm9wZXJ0aWVzX3N0cmluZ3MtPnNpemUgPSBFTkFfQURNSU5fRVhU
UkFfUFJPUEVSVElFU19DT1VOVCAqDQogICAgPiArCQlFTkFfQURNSU5fRVhUUkFfUFJPUEVSVElF
U19TVFJJTkdfTEVOOw0KICAgID4gKw0KICAgID4gKwlleHRyYV9wcm9wZXJ0aWVzX3N0cmluZ3Mt
PnZpcnRfYWRkciA9DQogICAgPiArCQlkbWFfYWxsb2NfY29oZXJlbnQoZW5hX2Rldi0+ZG1hZGV2
LA0KICAgID4gKwkJCQkgICBleHRyYV9wcm9wZXJ0aWVzX3N0cmluZ3MtPnNpemUsDQogICAgPiAr
CQkJCSAgICZleHRyYV9wcm9wZXJ0aWVzX3N0cmluZ3MtPmRtYV9hZGRyLA0KICAgID4gKwkJCQkg
ICBHRlBfS0VSTkVMKTsNCiAgICANCiAgICBEbyB5b3UgbmVlZCB0byBmZXRjaCB0aGUgcHJpdmF0
ZSBmbGFnIG5hbWVzIG9uIGVhY2ggRVRIVE9PTF9HU1RSSU5HDQogICAgcmVxdWVzdD8gSSBzdXBw
b3NlIHRoZXkgY291bGQgY2hhbmdlIGUuZy4gb24gYSBmaXJtd2FyZSB1cGRhdGUgYnV0IHRoZW4N
CiAgICBldmVuIHRoZSBjb3VudCBjb3VsZCBjaGFuZ2Ugd2hpY2ggeW91IGRvIG5vdCBzZWVtIHRv
IGhhbmRsZS4gSXMgdGhlcmUNCiAgICBhIHJlYXNvbiBub3QgdG8gZmV0Y2ggdGhlIG5hbWVzIG9u
Y2Ugb24gaW5pdCByYXRoZXIgdGhlbiBhY2Nlc3NpbmcgdGhlDQogICAgZGV2aWNlIG1lbW9yeSBl
YWNoIHRpbWU/DQogICAgDQogICAgTXkgcG9pbnQgaXMgdGhhdCBldGh0b29sX29wczo6Z2V0X3N0
cmluZ3MoKSBkb2VzIG5vdCByZXR1cm4gYSB2YWx1ZQ0KICAgIHdoaWNoIGluZGljYXRlcyB0aGF0
IGl0J3Mgc3VwcG9zZWQgdG8gYmUgYSB0cml2aWFsIG9wZXJhdGlvbiB3aGljaA0KICAgIGNhbm5v
dCBmYWlsLCB1c3VhbGx5IGEgc2ltcGxlIGNvcHkgd2l0aGluIGtlcm5lbCBtZW1vcnkuDQoNCmVu
YV9jb21fZXh0cmFfcHJvcGVydGllc19zdHJpbmdzX2luaXQoKSBpcyBjYWxsZWQgaW4gcHJvYmUo
KSBvbmx5LCBhbmQgbm90IGZvciBldmVyeSBFVEhUT09MX0dTVFJJTkcNCnJlcXVlc3QuIEZvciB0
aGUgbGF0dGVyIHdlIHVzZSBlbmFfZ2V0X3N0cmluZ3MoKS4gQW5kIGp1c3QgdG8gbWFrZSBzdXJl
IHdlIGFyZSBvbiB0aGUgc2FtZSBwYWdlLCBleHRyYV9wcm9wZXJ0aWVzX3N0cmluZ3MtPnZpcnRf
YWRkciANCnBvaW50cyB0byB0aGUgaG9zdCBtZW1vcnkgYW5kIG5vdCB0byB0aGUgZGV2aWNlIG1l
bW9yeS4gSSBiZWxpZXZlIHRoaXMgc2hvdWxkIGFuc3dlciB5b3VyIGNvbmNlcm4uDQogICAgDQog
ICAgPiArCWlmICh1bmxpa2VseSghZXh0cmFfcHJvcGVydGllc19zdHJpbmdzLT52aXJ0X2FkZHIp
KSB7DQogICAgPiArCQlwcl9lcnIoIkZhaWxlZCB0byBhbGxvY2F0ZSBleHRyYSBwcm9wZXJ0aWVz
IHN0cmluZ3NcbiIpOw0KICAgID4gKwkJcmV0dXJuIDA7DQogICAgPiArCX0NCiAgICA+ICsNCiAg
ICA+ICsJcmMgPSBlbmFfY29tX2dldF9mZWF0dXJlX2V4KGVuYV9kZXYsICZyZXNwLA0KICAgID4g
KwkJCQkgICAgRU5BX0FETUlOX0VYVFJBX1BST1BFUlRJRVNfU1RSSU5HUywNCiAgICA+ICsJCQkJ
ICAgIGV4dHJhX3Byb3BlcnRpZXNfc3RyaW5ncy0+ZG1hX2FkZHIsDQogICAgPiArCQkJCSAgICBl
eHRyYV9wcm9wZXJ0aWVzX3N0cmluZ3MtPnNpemUpOw0KICAgID4gKwlpZiAocmMpIHsNCiAgICA+
ICsJCXByX2RlYnVnKCJGYWlsZWQgdG8gZ2V0IGV4dHJhIHByb3BlcnRpZXMgc3RyaW5nc1xuIik7
DQogICAgPiArCQlnb3RvIGVycjsNCiAgICA+ICsJfQ0KICAgID4gKw0KICAgID4gKwlyZXR1cm4g
cmVzcC51LmV4dHJhX3Byb3BlcnRpZXNfc3RyaW5ncy5jb3VudDsNCiAgICA+ICtlcnI6DQogICAg
PiArCWVuYV9jb21fZGVsZXRlX2V4dHJhX3Byb3BlcnRpZXNfc3RyaW5ncyhlbmFfZGV2KTsNCiAg
ICA+ICsJcmV0dXJuIDA7DQogICAgPiArfQ0KICAgIC4uLg0KICAgID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX2V0aHRvb2wuYyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX2V0aHRvb2wuYw0KICAgID4gaW5kZXggZmU1OTZiYzMw
Li42NWJjNWEyYjIgMTAwNjQ0DQogICAgPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6
b24vZW5hL2VuYV9ldGh0b29sLmMNCiAgICA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Ft
YXpvbi9lbmEvZW5hX2V0aHRvb2wuYw0KICAgIC4uLg0KICAgID4gK3N0YXRpYyB2b2lkIGdldF9w
cml2YXRlX2ZsYWdzX3N0cmluZ3Moc3RydWN0IGVuYV9hZGFwdGVyICphZGFwdGVyLCB1OCAqZGF0
YSkNCiAgICA+ICt7DQogICAgPiArCXN0cnVjdCBlbmFfY29tX2RldiAqZW5hX2RldiA9IGFkYXB0
ZXItPmVuYV9kZXY7DQogICAgPiArCXU4ICpzdHJpbmdzID0gZW5hX2Rldi0+ZXh0cmFfcHJvcGVy
dGllc19zdHJpbmdzLnZpcnRfYWRkcjsNCiAgICA+ICsJaW50IGk7DQogICAgPiArDQogICAgPiAr
CWlmICh1bmxpa2VseSghc3RyaW5ncykpIHsNCiAgICA+ICsJCWFkYXB0ZXItPmVuYV9leHRyYV9w
cm9wZXJ0aWVzX2NvdW50ID0gMDsNCiAgICA+ICsJCW5ldGlmX2VycihhZGFwdGVyLCBkcnYsIGFk
YXB0ZXItPm5ldGRldiwNCiAgICA+ICsJCQkgICJGYWlsZWQgdG8gYWxsb2NhdGUgZXh0cmEgcHJv
cGVydGllcyBzdHJpbmdzXG4iKTsNCiAgICA+ICsJCXJldHVybjsNCiAgICA+ICsJfQ0KICAgIA0K
ICAgIFRoaXMgaXMgYSBiaXQgY29uZnVzaW5nLCBJTUhPLiBJJ20gYXdhcmUgd2Ugc2hvdWxkbid0
IHJlYWxseSBnZXQgaGVyZSBhcw0KICAgIHdpdGggc3RyaW5ncyBudWxsLCBjb3VudCB3b3VsZCBi
ZSB6ZXJvIGFuZCBldGh0b29sX2dldF9zdHJpbmdzKCkNCiAgICB3b3VsZG4ndCBjYWxsIHRoZSAt
PmdldF9zdHJpbmdzKCkgY2FsbGJhY2suIEJ1dCBpZiB3ZSBldmVyIGRvLCBpdCBtYWtlcw0KICAg
IGxpdHRsZSBzZW5zZSB0byBjb21wbGFpbiBhYm91dCBmYWlsZWQgYWxsb2NhdGlvbiAod2hpY2gg
aGFwcGVuZWQgb25jZSBvbg0KICAgIGluaXQpIGVhY2ggdGltZSB1c2Vyc3BhY2UgbWFrZXMgRVRI
VE9PTF9HU1RSSU5HUyByZXF1ZXN0IGZvciBwcml2YXRlDQogICAgZmxhZ3MuDQoNCkkgYmVsaWV2
ZSB3ZSBzdGlsbCB3YW50IHRvIGNoZWNrIHZhbGlkaXR5IG9mIHRoZSBzdHJpbmdzIHBvaW50ZXIg
dG8ga2VlcCB0aGUgZHJpdmVyIHJlc2lsaWVudCwgaG93ZXZlciBJIGFncmVlIHRoYXQgDQp0aGUg
bG9nZ2VkIG1lc3NhZ2UgaXMgY29uZnVzaW5nLiBMZXQgdXMgcmV3b3JrIHRoaXMgY29tbWl0ICAN
CiAgICANCiAgICA+ICsNCiAgICA+ICsJZm9yIChpID0gMDsgaSA8IGFkYXB0ZXItPmVuYV9leHRy
YV9wcm9wZXJ0aWVzX2NvdW50OyBpKyspIHsNCiAgICA+ICsJCXNucHJpbnRmKGRhdGEsIEVUSF9H
U1RSSU5HX0xFTiwgIiVzIiwNCiAgICA+ICsJCQkgc3RyaW5ncyArIEVOQV9BRE1JTl9FWFRSQV9Q
Uk9QRVJUSUVTX1NUUklOR19MRU4gKiBpKTsNCiAgICANCiAgICBzbnByaW50ZigpIGlzIGEgYml0
IG92ZXJraWxsIGhlcmUsIHdoYXQgeW91IGFyZSBkb2luZyBpcyByYXRoZXINCiAgICBzdHJsY3B5
KCkgb3Igc3Ryc2NweSgpLiBPciBtYXliZSBzdHJuY3B5KCkgYXMgc3RyaW5ncyByZXR1cm5lZCBi
eQ0KICAgIC0+Z2V0X3N0cmluZ3MoKSBkbyBub3QgaGF2ZSB0byBiZSBudWxsIHRlcm1pbmF0ZWQu
DQogICAgDQogICAgPiArCQlkYXRhICs9IEVUSF9HU1RSSU5HX0xFTjsNCiAgICA+ICsJfQ0KICAg
ID4gK30NCiAgICANCiAgICBNaWNoYWwgS3ViZWNlaw0KICAgIA0KDQo=
