Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732F12CD885
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbgLCOFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:05:54 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:38513 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436499AbgLCOFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:05:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607004349; x=1638540349;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Sz1uWOpAbiKdq7CwRsnYbQp2HKiW4lKUF+mlSNTFB0I=;
  b=m1kWpf3Zh2xSR/hrNpRfHol6sGzkAe4dtFWJs5b/vVDt2TSUjK448FXO
   9yFPjmUfQmUCm9qm11bfwx8UbnwZX2+3Q7/+33zXDAuu2NCafWok1nR8F
   2WwpUj9QoN2omkO60pAdiJR7eCprkxAVP8bd7VLVjVUFhdG01k8rUK2ec
   8=;
X-IronPort-AV: E=Sophos;i="5.78,389,1599523200"; 
   d="scan'208";a="67143089"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 03 Dec 2020 14:05:02 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 6E124A21BC;
        Thu,  3 Dec 2020 14:05:00 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.146) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 3 Dec 2020 14:04:55 +0000
Subject: Re: [PATCH net-next v1 1/3] vm_sockets: Include flag field in the
 vsock address data structure
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
CC:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-2-andraprs@amazon.com>
 <20201203092155.GB687169@stefanha-x1.localdomain>
 <8fcc1daa-4f03-0240-1dda-4daf2e1f7c44@amazon.com>
 <20201203133807.36t235yemt5f2j4t@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <c4d2b5c0-2429-c30f-6123-121f8f20fe7d@amazon.com>
Date:   Thu, 3 Dec 2020 16:04:44 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203133807.36t235yemt5f2j4t@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D11UWC004.ant.amazon.com (10.43.162.101) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwMy8xMi8yMDIwIDE1OjM4LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBU
aHUsIERlYyAwMywgMjAyMCBhdCAxMjozMjowOFBNICswMjAwLCBQYXJhc2NoaXYsIEFuZHJhLUly
aW5hIHdyb3RlOgo+Pgo+Pgo+PiBPbiAwMy8xMi8yMDIwIDExOjIxLCBTdGVmYW4gSGFqbm9jemkg
d3JvdGU6Cj4+PiBPbiBUdWUsIERlYyAwMSwgMjAyMCBhdCAwNToyNTowM1BNICswMjAwLCBBbmRy
YSBQYXJhc2NoaXYgd3JvdGU6Cj4+Pj4gdnNvY2sgZW5hYmxlcyBjb21tdW5pY2F0aW9uIGJldHdl
ZW4gdmlydHVhbCBtYWNoaW5lcyBhbmQgdGhlIGhvc3QgdGhleQo+Pj4+IGFyZSBydW5uaW5nIG9u
LiBXaXRoIHRoZSBtdWx0aSB0cmFuc3BvcnQgc3VwcG9ydCAoZ3Vlc3QtPmhvc3QgYW5kCj4+Pj4g
aG9zdC0+Z3Vlc3QpLCBuZXN0ZWQgVk1zIGNhbiBhbHNvIHVzZSB2c29jayBjaGFubmVscyBmb3Ig
Cj4+Pj4gY29tbXVuaWNhdGlvbi4KPj4+Pgo+Pj4+IEluIGFkZGl0aW9uIHRvIHRoaXMsIGJ5IGRl
ZmF1bHQsIGFsbCB0aGUgdnNvY2sgcGFja2V0cyBhcmUgCj4+Pj4gZm9yd2FyZGVkIHRvCj4+Pj4g
dGhlIGhvc3QsIGlmIG5vIGhvc3QtPmd1ZXN0IHRyYW5zcG9ydCBpcyBsb2FkZWQuIFRoaXMgYmVo
YXZpb3IgY2FuIGJlCj4+Pj4gaW1wbGljaXRseSB1c2VkIGZvciBlbmFibGluZyB2c29jayBjb21t
dW5pY2F0aW9uIGJldHdlZW4gc2libGluZyBWTXMuCj4+Pj4KPj4+PiBBZGQgYSBmbGFnIGZpZWxk
IGluIHRoZSB2c29jayBhZGRyZXNzIGRhdGEgc3RydWN0dXJlIHRoYXQgY2FuIGJlIAo+Pj4+IHVz
ZWQgdG8KPj4+PiBleHBsaWNpdGx5IG1hcmsgdGhlIHZzb2NrIGNvbm5lY3Rpb24gYXMgYmVpbmcg
dGFyZ2V0ZWQgZm9yIGEgY2VydGFpbgo+Pj4+IHR5cGUgb2YgY29tbXVuaWNhdGlvbi4gVGhpcyB3
YXksIGNhbiBkaXN0aW5ndWlzaCBiZXR3ZWVuIG5lc3RlZCBWTXMgCj4+Pj4gYW5kCj4+Pj4gc2li
bGluZyBWTXMgdXNlIGNhc2VzIGFuZCBjYW4gYWxzbyBzZXR1cCB0aGVtIGF0IHRoZSBzYW1lIHRp
bWUuIFRpbGwKPj4+PiBub3csIGNvdWxkIGVpdGhlciBoYXZlIG5lc3RlZCBWTXMgb3Igc2libGlu
ZyBWTXMgYXQgYSB0aW1lIHVzaW5nIHRoZQo+Pj4+IHZzb2NrIGNvbW11bmljYXRpb24gc3RhY2su
Cj4+Pj4KPj4+PiBVc2UgdGhlIGFscmVhZHkgYXZhaWxhYmxlICJzdm1fcmVzZXJ2ZWQxIiBmaWVs
ZCBhbmQgbWFyayBpdCBhcyBhIGZsYWcKPj4+PiBmaWVsZCBpbnN0ZWFkLiBUaGlzIGZsYWcgY2Fu
IGJlIHNldCB3aGVuIGluaXRpYWxpemluZyB0aGUgdnNvY2sgCj4+Pj4gYWRkcmVzcwo+Pj4+IHZh
cmlhYmxlIHVzZWQgZm9yIHRoZSBjb25uZWN0KCkgY2FsbC4KPj4+Pgo+Pj4+IFNpZ25lZC1vZmYt
Ynk6IEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4+PiAtLS0KPj4+PiDC
oGluY2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmggfCAxOCArKysrKysrKysrKysrKysrKy0K
Pj4+PiDCoDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+
Pj4KPj4+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZtX3NvY2tldHMuaCAKPj4+
PiBiL2luY2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmgKPj4+PiBpbmRleCBmZDBlZDcyMjE2
NDVkLi41OGRhNWE5MTQxM2FjIDEwMDY0NAo+Pj4+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC92
bV9zb2NrZXRzLmgKPj4+PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvdm1fc29ja2V0cy5oCj4+
Pj4gQEAgLTExNCw2ICsxMTQsMjIgQEAKPj4+PiDCoCNkZWZpbmUgVk1BRERSX0NJRF9IT1NUIDIK
Pj4+PiArLyogVGhpcyBzb2NrYWRkcl92bSBmbGFnIHZhbHVlIGNvdmVycyB0aGUgY3VycmVudCBk
ZWZhdWx0IHVzZSBjYXNlOgo+Pj4+ICsgKiBsb2NhbCB2c29jayBjb21tdW5pY2F0aW9uIGJldHdl
ZW4gZ3Vlc3QgYW5kIGhvc3QgYW5kIG5lc3RlZCBWTXMgCj4+Pj4gc2V0dXAuCj4+Pj4gKyAqIElu
IGFkZGl0aW9uIHRvIHRoaXMsIGltcGxpY2l0bHksIHRoZSB2c29jayBwYWNrZXRzIGFyZSAKPj4+
PiBmb3J3YXJkZWQgdG8gdGhlIGhvc3QKPj4+PiArICogaWYgbm8gaG9zdC0+Z3Vlc3QgdnNvY2sg
dHJhbnNwb3J0IGlzIHNldC4KPj4+PiArICovCj4+Pj4gKyNkZWZpbmUgVk1BRERSX0ZMQUdfREVG
QVVMVF9DT01NVU5JQ0FUSU9OwqDCoCAweDAwMDAKPj4+PiArCj4+Pj4gKy8qIFNldCB0aGlzIGZs
YWcgdmFsdWUgaW4gdGhlIHNvY2thZGRyX3ZtIGNvcnJlc3BvbmRpbmcgZmllbGQgaWYgCj4+Pj4g
dGhlIHZzb2NrCj4+Pj4gKyAqIGNoYW5uZWwgbmVlZHMgdG8gYmUgc2V0dXAgYmV0d2VlbiB0d28g
c2libGluZyBWTXMgcnVubmluZyBvbiAKPj4+PiB0aGUgc2FtZSBob3N0Lgo+Pj4+ICsgKiBUaGlz
IHdheSBjYW4gZXhwbGljaXRseSBkaXN0aW5ndWlzaCBiZXR3ZWVuIHZzb2NrIGNoYW5uZWxzIAo+
Pj4+IGNyZWF0ZWQgZm9yIG5lc3RlZAo+Pj4+ICsgKiBWTXMgKG9yIGxvY2FsIGNvbW11bmljYXRp
b24gYmV0d2VlbiBndWVzdCBhbmQgaG9zdCkgYW5kIHRoZSAKPj4+PiBvbmVzIGNyZWF0ZWQgZm9y
Cj4+Pj4gKyAqIHNpYmxpbmcgVk1zLiBBbmQgdnNvY2sgY2hhbm5lbHMgZm9yIG11bHRpcGxlIHVz
ZSBjYXNlcyAobmVzdGVkIAo+Pj4+IC8gc2libGluZyBWTXMpCj4+Pj4gKyAqIGNhbiBiZSBzZXR1
cCBhdCB0aGUgc2FtZSB0aW1lLgo+Pj4+ICsgKi8KPj4+PiArI2RlZmluZSBWTUFERFJfRkxBR19T
SUJMSU5HX1ZNU19DT01NVU5JQ0FUSU9OwqDCoMKgwqDCoMKgIDB4MDAwMQo+Pj4gdnNvY2sgaGFz
IHRoZSBoMmcgYW5kIGcyaCBjb25jZXB0LiBJdCB3b3VsZCBiZSBtb3JlIGdlbmVyYWwgdG8gY2Fs
bCAKPj4+IHRoaXMKPj4+IGZsYWcgVk1BRERSX0ZMQUdfRzJIIG9yIGxlc3MgY3J5cHRpY2FsbHkg
Vk1BRERSX0ZMQUdfVE9fSE9TVC4KPgo+IEkgYWdyZWUsIFZNQUREUl9GTEFHX1RPX0hPU1QgaXMg
bW9yZSBnZW5lcmFsIGFuZCBpdCdzIGNsZWFyZXIgdGhhdCBpcyB1cAo+IHRvIHRoZSBob3N0IHdo
ZXJlIHRvIGZvcndhcmQgdGhlIHBhY2tldCAoc2libGluZyBpZiBzdXBwb3J0ZWQsIG9yCj4gd2hh
dGV2ZXIpLgoKT2ssIHRoZW4gVk1BRERSX0ZMQUdfVE9fSE9TVCBpdCBpcy4gOikgSSBhbHNvIHVw
ZGF0ZWQgdGhlIGNvbW1pdCAKbWVzc2FnZXMgLyBjb21tZW50cyB0byByZWZsZWN0IHRoaXMgbW9y
ZSBnZW5lcmFsIGFuZ2xlLCB3aXRoIG9uZSBvZiB0aGUgCmN1cnJlbnQgdXNlIGNhc2VzIGJlaW5n
IGd1ZXN0IHRvIGd1ZXN0IGNvbW11bmljYXRpb24uCgpUaGFua3MsCkFuZHJhCgo+Cj4+Cj4+IFRo
YW5rcyBmb3IgdGhlIGZlZWRiYWNrLCBTdGVmYW4uCj4+Cj4+IEkgY2FuIHVwZGF0ZSB0aGUgbmFt
aW5nIHRvIGJlIG1vcmUgZ2VuZXJhbCwgc3VjaCBhc8OCICJfVE9fSE9TVCIsIGFuZAo+PiBrZWVw
IHRoZSB1c2UgY2FzZXMgKGUuZy4gZ3Vlc3QgPC0+IGhvc3QgLyBuZXN0ZWQgLyBzaWJsaW5nIFZN
cwo+PiBjb21tdW5pY2F0aW9uKSBtZW50aW9uIGluIHRoZSBjb21tZW50cyBzbyB0aGF0IHdvdWxk
IHJlbGF0ZSBtb3JlIHRvCj4+IHRoZSBtb3RpdmF0aW9uIGJlaGluZCBpdC4KPj4KPj4gQW5kcmEK
Pj4KPj4+Cj4+PiBUaGF0IHdheSBpdCBqdXN0IHRlbGxzIHRoZSBkcml2ZXIgaW4gd2hpY2ggZGly
ZWN0aW9uIHRvIHNlbmQgcGFja2V0cwo+Pj4gd2l0aG91dCBpbXBseWluZyB0aGF0IHNpYmxpbmcg
Y29tbXVuaWNhdGlvbiBpcyBwb3NzaWJsZSAoaXQncyBub3QKPj4+IGFsbG93ZWQgYnkgZGVmYXVs
dCBvbiBhbnkgdHJhbnNwb3J0KS4KPj4+Cj4+PiBJIGRvbid0IGhhdmUgYSBzdHJvbmcgb3Bpbmlv
biBvbiB0aGlzIGJ1dCB3YW50ZWQgdG8gc3VnZ2VzdCB0aGUgaWRlYS4KPj4+Cj4+PiBTdGVmYW4K
Pj4KPj4KPj4KPj4KPj4gQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwu
IHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIAo+PiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29y
IDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIAo+PiBSZWdpc3RlcmVkIGlu
IFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4KPj4KPgoKCgoKQW1h
em9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNl
OiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHks
IDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVt
YmVyIEoyMi8yNjIxLzIwMDUuCg==

