Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E9E2D9C6B
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439984AbgLNQU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:20:28 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:4070 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440011AbgLNQUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:20:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607962813; x=1639498813;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=t/H8c8G/4npZL6OBxF7Pi9envp6gR5mxp0GUeGX14SE=;
  b=strR1j+6HnstJkyTjhNPRCdJ/71WE4jjhjepzCz4bio7SUOcE/dUrgGI
   +j/Gqtuzc3nhsjJgR+hVHAmob8ibDKlAlIrrahB63QVwnYZif5dgRDLE9
   2gsnjbPsBzAfXIGaphn2bnzMSptoCSLqjI/mNLRUENOhNukih+pIc/HGI
   4=;
X-IronPort-AV: E=Sophos;i="5.78,420,1599523200"; 
   d="scan'208";a="102860056"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 14 Dec 2020 16:19:07 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id D1801A1DFA;
        Mon, 14 Dec 2020 16:19:04 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.211) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 16:18:59 +0000
Subject: Re: [PATCH net-next v3 0/4] vsock: Add flags field in the vsock
 address
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201211103241.17751-1-andraprs@amazon.com>
 <20201211152413.iezrw6qswzhpfa3j@steredhat>
 <20201212091608.4ffd1154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201214081312.g6nrzf2ibawhnryr@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <ec793431-f2a3-9542-a9de-0040be0b87bd@amazon.com>
Date:   Mon, 14 Dec 2020 18:18:50 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201214081312.g6nrzf2ibawhnryr@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.211]
X-ClientProxiedBy: EX13D07UWA002.ant.amazon.com (10.43.160.77) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAxNC8xMi8yMDIwIDEwOjEzLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBT
YXQsIERlYyAxMiwgMjAyMCBhdCAwOToxNjowOEFNIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90
ZToKPj4gT24gRnJpLCAxMSBEZWMgMjAyMCAxNjoyNDoxMyArMDEwMCBTdGVmYW5vIEdhcnphcmVs
bGEgd3JvdGU6Cj4+PiBPbiBGcmksIERlYyAxMSwgMjAyMCBhdCAxMjozMjozN1BNICswMjAwLCBB
bmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+PiA+dnNvY2sgZW5hYmxlcyBjb21tdW5pY2F0aW9uIGJl
dHdlZW4gdmlydHVhbCBtYWNoaW5lcyBhbmQgdGhlIGhvc3QgCj4+PiB0aGV5IGFyZQo+Pj4gPnJ1
bm5pbmcgb24uIE5lc3RlZCBWTXMgY2FuIGJlIHNldHVwIHRvIHVzZSB2c29jayBjaGFubmVscywg
YXMgdGhlIAo+Pj4gbXVsdGkKPj4+ID50cmFuc3BvcnQgc3VwcG9ydCBoYXMgYmVlbiBhdmFpbGFi
bGUgaW4gdGhlIG1haW5saW5lIHNpbmNlIHRoZSB2NS41IAo+Pj4gTGludXgga2VybmVsCj4+PiA+
aGFzIGJlZW4gcmVsZWFzZWQuCj4+PiA+Cj4+PiA+SW1wbGljaXRseSwgaWYgbm8gaG9zdC0+Z3Vl
c3QgdnNvY2sgdHJhbnNwb3J0IGlzIGxvYWRlZCwgYWxsIHRoZSAKPj4+IHZzb2NrIHBhY2tldHMK
Pj4+ID5hcmUgZm9yd2FyZGVkIHRvIHRoZSBob3N0LiBUaGlzIGJlaGF2aW9yIGNhbiBiZSB1c2Vk
IHRvIHNldHVwIAo+Pj4gY29tbXVuaWNhdGlvbgo+Pj4gPmNoYW5uZWxzIGJldHdlZW4gc2libGlu
ZyBWTXMgdGhhdCBhcmUgcnVubmluZyBvbiB0aGUgc2FtZSBob3N0LiBPbmUgCj4+PiBleGFtcGxl
IGNhbgo+Pj4gPmJlIHRoZSB2c29jayBjaGFubmVscyB0aGF0IGNhbiBiZSBlc3RhYmxpc2hlZCB3
aXRoaW4gQVdTIE5pdHJvIAo+Pj4gRW5jbGF2ZXMKPj4+ID4oc2VlIERvY3VtZW50YXRpb24vdmly
dC9uZV9vdmVydmlldy5yc3QpLgo+Pj4gPgo+Pj4gPlRvIGJlIGFibGUgdG8gZXhwbGljaXRseSBt
YXJrIGEgY29ubmVjdGlvbiBhcyBiZWluZyB1c2VkIGZvciBhIAo+Pj4gY2VydGFpbiB1c2UgY2Fz
ZSwKPj4+ID5hZGQgYSBmbGFncyBmaWVsZCBpbiB0aGUgdnNvY2sgYWRkcmVzcyBkYXRhIHN0cnVj
dHVyZS4gVGhlIHZhbHVlIG9mIAo+Pj4gdGhlIGZsYWdzCj4+PiA+ZmllbGQgaXMgdGFrZW4gaW50
byBjb25zaWRlcmF0aW9uIHdoZW4gdGhlIHZzb2NrIHRyYW5zcG9ydCBpcyAKPj4+IGFzc2lnbmVk
LiBUaGlzIHdheQo+Pj4gPmNhbiBkaXN0aW5ndWlzaCBiZXR3ZWVuIGRpZmZlcmVudCB1c2UgY2Fz
ZXMsIHN1Y2ggYXMgbmVzdGVkIFZNcyAvIAo+Pj4gbG9jYWwKPj4+ID5jb21tdW5pY2F0aW9uIGFu
ZCBzaWJsaW5nIFZNcy4KPj4+ID4KPj4+ID5UaGUgZmxhZ3MgZmllbGQgY2FuIGJlIHNldCBpbiB0
aGUgdXNlciBzcGFjZSBhcHBsaWNhdGlvbiBjb25uZWN0IAo+Pj4gbG9naWMuIE9uIHRoZQo+Pj4g
Pmxpc3RlbiBwYXRoLCB0aGUgZmllbGQgY2FuIGJlIHNldCBpbiB0aGUga2VybmVsIHNwYWNlIGxv
Z2ljLgo+Pj4gPgo+Pj4KPj4+IEkgcmV2aWV3ZWQgYWxsIHRoZSBwYXRjaGVzIGFuZCB0aGV5IGFy
ZSBpbiBhIGdvb2Qgc2hhcGUhCj4+Pgo+Pj4gTWF5YmUgdGhlIGxhc3QgdGhpbmcgdG8gYWRkIGlz
IGEgZmxhZ3MgY2hlY2sgaW4gdGhlCj4+PiB2c29ja19hZGRyX3ZhbGlkYXRlKCksIHRvIGF2b2lk
IHRoYXQgZmxhZ3MgdGhhdCB3ZSBkb24ndCBrbm93IGhvdyB0bwo+Pj4gaGFuZGxlIGFyZSBzcGVj
aWZpZWQuCj4+PiBGb3IgZXhhbXBsZSBpZiBpbiB0aGUgZnV0dXJlIHdlIGFkZCBuZXcgZmxhZ3Mg
dGhhdCB0aGlzIHZlcnNpb24gb2YgdGhlCj4+PiBrZXJuZWwgaXMgbm90IGFibGUgdG8gc2F0aXNm
eSwgd2Ugc2hvdWxkIHJldHVybiBhbiBlcnJvciB0byB0aGUKPj4+IGFwcGxpY2F0aW9uLgo+Pj4K
Pj4+IEkgbWVhbiBzb21ldGhpbmcgbGlrZSB0aGlzOgo+Pj4KPj4+IMKgwqDCoMKgIGRpZmYgLS1n
aXQgYS9uZXQvdm13X3Zzb2NrL3Zzb2NrX2FkZHIuYyAKPj4+IGIvbmV0L3Ztd192c29jay92c29j
a19hZGRyLmMKPj4+IMKgwqDCoMKgIGluZGV4IDkwOWRlMjZjYjBlNy4uNzNiYjFkMmZhNTI2IDEw
MDY0NAo+Pj4gwqDCoMKgwqAgLS0tIGEvbmV0L3Ztd192c29jay92c29ja19hZGRyLmMKPj4+IMKg
wqDCoMKgICsrKyBiL25ldC92bXdfdnNvY2svdnNvY2tfYWRkci5jCj4+PiDCoMKgwqDCoCBAQCAt
MjIsNiArMjIsOCBAQCBFWFBPUlRfU1lNQk9MX0dQTCh2c29ja19hZGRyX2luaXQpOwo+Pj4KPj4+
IMKgwqDCoMKgwqAgaW50IHZzb2NrX2FkZHJfdmFsaWRhdGUoY29uc3Qgc3RydWN0IHNvY2thZGRy
X3ZtICphZGRyKQo+Pj4gwqDCoMKgwqDCoCB7Cj4+PiDCoMKgwqDCoCArwqDCoMKgwqDCoMKgIHVu
c2lnbmVkIHNob3J0IHN2bV92YWxpZF9mbGFncyA9IFZNQUREUl9GTEFHX1RPX0hPU1Q7Cj4+PiDC
oMKgwqDCoCArCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFhZGRyKQo+Pj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVGQVVMVDsKPj4+
Cj4+PiDCoMKgwqDCoCBAQCAtMzEsNiArMzMsOSBAQCBpbnQgdnNvY2tfYWRkcl92YWxpZGF0ZShj
b25zdCBzdHJ1Y3QgCj4+PiBzb2NrYWRkcl92bSAqYWRkcikKPj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAoYWRkci0+c3ZtX3plcm9bMF0gIT0gMCkKPj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+Cj4+IFN0cmljdGx5IHNw
ZWFraW5nIHRoaXMgY2hlY2sgc2hvdWxkIGJlIHN1cGVyc2VkZWQgYnkgdGhlIGNoZWNrIGJlbG93
Cj4+IChBS0EgcmVtb3ZlZCkuIFdlIHVzZWQgdG8gY2hlY2sgc3ZtX3plcm9bMF0sIHdpdGggdGhl
IG5ldyBmaWVsZCBhZGRlZAo+PiB0aGlzIG5vdyBjaGVja3Mgc3ZtX3plcm9bMl0uIE9sZCBhcHBs
aWNhdGlvbnMgbWF5IGhhdmUgbm90IGluaXRpYWxpemVkCj4+IHN2bV96ZXJvWzJdICh3ZSdyZSB0
YWxraW5nIGFib3V0IGJpbmFyeSBjb21wYXRpYmlsaXR5IGhlcmUsIGFwcHMgYnVpbHQKPj4gd2l0
aCBvbGQgaGVhZGVycykuCj4+Cj4+PiDCoMKgwqDCoCArwqDCoMKgwqDCoMKgIGlmIChhZGRyLT5z
dm1fZmxhZ3MgJiB+c3ZtX3ZhbGlkX2ZsYWdzKQo+Pj4gwqDCoMKgwqAgK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+Cj4+IFRoZSBmbGFncyBzaG91bGQgYWxz
byBwcm9iYWJseSBiZSBvbmUgYnl0ZSAod2UgY2FuIGRlZmluZSBhICJtb3JlCj4+IGZsYWdzIiBm
bGFnIHRvIHVubG9jayBmdXJ0aGVyIGJ5dGVzKSAtIG90aGVyd2lzZSBvbiBiaWcgZW5kaWFuIHRo
ZQo+PiBuZXcgZmxhZyB3aWxsIGZhbGwgaW50byBzdm1femVyb1sxXSBzbyB0aGUgdjMgaW1wcm92
ZW1lbnRzIGFyZSBtb290Cj4+IGZvciBiaWcgZW5kaWFuLCByaWdodD8KPgo+IFJpZ2h0LCBJIGFz
c3VtZWQgdGhlIGVudGlyZSBzdm1femVyb1tdIHdhcyB6ZXJvZWQgb3V0LCBidXQgd2UgY2FuJ3Qg
YmUKPiBzdXJlLgo+Cj4gU28sIEkgYWdyZWUgdG8gY2hhbmdlIHRoZSBzdm1fZmxhZ3MgdG8gMSBi
eXRlIChfX3U4KSwgYW5kIHJlbW92ZSB0aGUKPiBzdXBlcnNlZGVkIGNoZWNrIHRoYXQgeW91IHBv
aW50ZWQgb3V0Lgo+IFdpdGggdGhlc2UgY2hhbmdlcyB3ZSBzaG91bGQgYmUgZnVsbHkgYmluYXJ5
IGNvbXBhdGliaWxpdHkuCj4KCkhlcmUgd2UgZ28sIHNlbnQgb3V0IHY0OgoKaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGttbC8yMDIwMTIxNDE2MTEyMi4zNzcxNy0xLWFuZHJhcHJzQGFtYXpvbi5j
b20vCgpUaGFuayB5b3UgYm90aC4KCkFuZHJhCgo+Pgo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHJldHVybiAwOwo+Pj4gwqDCoMKgwqDCoCB9Cj4+PiDCoMKgwqDCoMKgIEVYUE9SVF9TWU1C
T0xfR1BMKHZzb2NrX2FkZHJfdmFsaWRhdGUpOwo+Pgo+CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQg
Q2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIg
U3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlh
LiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAw
NS4K

