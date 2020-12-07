Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5772D1959
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgLGTUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:20:44 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:45943 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgLGTUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607368843; x=1638904843;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=hxKTfM//5YEvZ6W0CS6LHyswofJMOPaGP5WLOMDbBQk=;
  b=RxsUW+rzYx+Qd8NF0xHiYLjI+LRYAQTUgpXi3iU2xCJsWrBZsVPUjgbF
   dpF3QJY7gVACMSytrJWCcra2NiQz12U8PAx8LvMqy4/kNlZAeFE2TwWbJ
   lDRkj2MAhP8SC+iEEcFMq00DXjpQcLJBYTbWJUvao7itrQ77fmQJcjdn0
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="69636348"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 Dec 2020 19:20:06 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 75049A1892;
        Mon,  7 Dec 2020 19:18:17 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.146) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 19:18:11 +0000
Subject: Re: [PATCH net-next v2 0/4] vsock: Add flags field in the vsock
 address
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201207100525.v4z7rlewnwubjphu@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <eb53647a-dbf4-ace4-3cf8-a55c1fbb0c7a@amazon.com>
Date:   Mon, 7 Dec 2020 21:18:02 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207100525.v4z7rlewnwubjphu@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D44UWC002.ant.amazon.com (10.43.162.169) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwNy8xMi8yMDIwIDEyOjA1LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBIaSBB
bmRyYSwKPgo+IE9uIEZyaSwgRGVjIDA0LCAyMDIwIGF0IDA3OjAyOjMxUE0gKzAyMDAsIEFuZHJh
IFBhcmFzY2hpdiB3cm90ZToKPj4gdnNvY2sgZW5hYmxlcyBjb21tdW5pY2F0aW9uIGJldHdlZW4g
dmlydHVhbCBtYWNoaW5lcyBhbmQgdGhlIGhvc3QgCj4+IHRoZXkgYXJlCj4+IHJ1bm5pbmcgb24u
IE5lc3RlZCBWTXMgY2FuIGJlIHNldHVwIHRvIHVzZSB2c29jayBjaGFubmVscywgYXMgdGhlIG11
bHRpCj4+IHRyYW5zcG9ydCBzdXBwb3J0IGhhcyBiZWVuIGF2YWlsYWJsZSBpbiB0aGUgbWFpbmxp
bmUgc2luY2UgdGhlIHY1LjUgCj4+IExpbnV4IGtlcm5lbAo+PiBoYXMgYmVlbiByZWxlYXNlZC4K
Pj4KPj4gSW1wbGljaXRseSwgaWYgbm8gaG9zdC0+Z3Vlc3QgdnNvY2sgdHJhbnNwb3J0IGlzIGxv
YWRlZCwgYWxsIHRoZSAKPj4gdnNvY2sgcGFja2V0cwo+PiBhcmUgZm9yd2FyZGVkIHRvIHRoZSBo
b3N0LiBUaGlzIGJlaGF2aW9yIGNhbiBiZSB1c2VkIHRvIHNldHVwIAo+PiBjb21tdW5pY2F0aW9u
Cj4+IGNoYW5uZWxzIGJldHdlZW4gc2libGluZyBWTXMgdGhhdCBhcmUgcnVubmluZyBvbiB0aGUg
c2FtZSBob3N0LiBPbmUgCj4+IGV4YW1wbGUgY2FuCj4+IGJlIHRoZSB2c29jayBjaGFubmVscyB0
aGF0IGNhbiBiZSBlc3RhYmxpc2hlZCB3aXRoaW4gQVdTIE5pdHJvIEVuY2xhdmVzCj4+IChzZWUg
RG9jdW1lbnRhdGlvbi92aXJ0L25lX292ZXJ2aWV3LnJzdCkuCj4+Cj4+IFRvIGJlIGFibGUgdG8g
ZXhwbGljaXRseSBtYXJrIGEgY29ubmVjdGlvbiBhcyBiZWluZyB1c2VkIGZvciBhIAo+PiBjZXJ0
YWluIHVzZSBjYXNlLAo+PiBhZGQgYSBmbGFncyBmaWVsZCBpbiB0aGUgdnNvY2sgYWRkcmVzcyBk
YXRhIHN0cnVjdHVyZS4gVGhlIAo+PiAic3ZtX3Jlc2VydmVkMSIgZmllbGQKPj4gaGFzIGJlZW4g
cmVwdXJwb3NlZCB0byBiZSB0aGUgZmxhZ3MgZmllbGQuIFRoZSB2YWx1ZSBvZiB0aGUgZmxhZ3Mg
Cj4+IHdpbGwgdGhlbiBiZQo+PiB0YWtlbiBpbnRvIGNvbnNpZGVyYXRpb24gd2hlbiB0aGUgdnNv
Y2sgdHJhbnNwb3J0IGlzIGFzc2lnbmVkLiBUaGlzIAo+PiB3YXkgY2FuCj4+IGRpc3Rpbmd1aXNo
IGJldHdlZW4gZGlmZmVyZW50IHVzZSBjYXNlcywgc3VjaCBhcyBuZXN0ZWQgVk1zIC8gbG9jYWwg
Cj4+IGNvbW11bmljYXRpb24KPj4gYW5kIHNpYmxpbmcgVk1zLgo+Cj4gdGhlIHNlcmllcyBzZWVt
cyBpbiBhIGdvb2Qgc2hhcGUsIEkgbGVmdCBzb21lIG1pbm9yIGNvbW1lbnRzLgo+IEkgcnVuIG15
IHRlc3Qgc3VpdGUgKHZzb2NrX3Rlc3QsIGlwZXJmMywgbmMpIHdpdGggbmVzdGVkIFZNcyAoUUVN
VS9LVk0pLAo+IGFuZCBldmVyeXRoaW5nIGxvb2tzIGdvb2QuCgpUaGFua3MsIFN0ZWZhbm8sIGZv
ciByZXZpZXcgYW5kIGNoZWNraW5nIGl0IG91dCBmb3IgdGhlIG5lc3RlZCBjYXNlIGFzIHdlbGwu
CgpJJ2xsIHNlbmQgb3V0IHYzIGluY2x1ZGluZyB0aGUgYWRkcmVzc2VkIGZlZWRiYWNrIGFuZCB0
aGUgUmIgdGFncy4KCj4KPiBOb3RlOiBJJ2xsIGJlIG9mZmxpbmUgdG9kYXkgYW5kIHRvbW9ycm93
LCBzbyBJIG1heSBtaXNzIGZvbGxvd3Vwcy4KCk9rLCBucCwgdGhhbmtzIGZvciB0aGUgaGVhZHMt
dXAuCgpBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4g
cmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJ
YXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEu
IFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

