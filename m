Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E30B2D7D3A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405659AbgLKRry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:47:54 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:52673 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405623AbgLKRrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:47:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607708834; x=1639244834;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=uwv8ALfTPluQvriix7JixDzU0bTqOriiEkFwz/OA4QM=;
  b=RTC5ixgh4/JoiCWrSa58KtLi0dBVaKesNrJBXvkx6W76+SoIvAC3SYWB
   aA4lYO8r1JXz2QsJhmuz/1Mr28sq/bkr5SdVX7TSwsnDRgOgUjjtdPzNg
   Crao3Pc+m57ceCOdHK6SLqW94YuCERBEl1zSMmEk3aKnchoGWH+QQeI4c
   o=;
X-IronPort-AV: E=Sophos;i="5.78,412,1599523200"; 
   d="scan'208";a="902357220"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 11 Dec 2020 17:46:26 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 59D19C067A;
        Fri, 11 Dec 2020 17:46:24 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.146) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Dec 2020 17:46:19 +0000
Subject: Re: [PATCH net-next v3 0/4] vsock: Add flags field in the vsock
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
References: <20201211103241.17751-1-andraprs@amazon.com>
 <20201211152413.iezrw6qswzhpfa3j@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <2a6711c7-e165-6358-8659-6cd49ec5788c@amazon.com>
Date:   Fri, 11 Dec 2020 19:46:10 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201211152413.iezrw6qswzhpfa3j@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D24UWB001.ant.amazon.com (10.43.161.93) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAxMS8xMi8yMDIwIDE3OjI0LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBIaSBB
bmRyYSwKPgo+IE9uIEZyaSwgRGVjIDExLCAyMDIwIGF0IDEyOjMyOjM3UE0gKzAyMDAsIEFuZHJh
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
YXRhIHN0cnVjdHVyZS4gVGhlIHZhbHVlIG9mIAo+PiB0aGUgZmxhZ3MKPj4gZmllbGQgaXMgdGFr
ZW4gaW50byBjb25zaWRlcmF0aW9uIHdoZW4gdGhlIHZzb2NrIHRyYW5zcG9ydCBpcyAKPj4gYXNz
aWduZWQuIFRoaXMgd2F5Cj4+IGNhbiBkaXN0aW5ndWlzaCBiZXR3ZWVuIGRpZmZlcmVudCB1c2Ug
Y2FzZXMsIHN1Y2ggYXMgbmVzdGVkIFZNcyAvIGxvY2FsCj4+IGNvbW11bmljYXRpb24gYW5kIHNp
YmxpbmcgVk1zLgo+Pgo+PiBUaGUgZmxhZ3MgZmllbGQgY2FuIGJlIHNldCBpbiB0aGUgdXNlciBz
cGFjZSBhcHBsaWNhdGlvbiBjb25uZWN0IAo+PiBsb2dpYy4gT24gdGhlCj4+IGxpc3RlbiBwYXRo
LCB0aGUgZmllbGQgY2FuIGJlIHNldCBpbiB0aGUga2VybmVsIHNwYWNlIGxvZ2ljLgo+Pgo+Cj4g
SSByZXZpZXdlZCBhbGwgdGhlIHBhdGNoZXMgYW5kIHRoZXkgYXJlIGluIGEgZ29vZCBzaGFwZSEK
CkhpIFN0ZWZhbm8sCgpUaGFua3MgZm9yIHRoZSBvdmVyYWxsIHJldmlldyBhbmQgZm9yIHRoZSBy
ZWNvbmZpcm1hdGlvbiBvZiB0aGUgUmIgZm9yIAp0aGUgdnNvY2sgYWRkcmVzcyBkYXRhIHN0cnVj
dHVyZSBjaGFuZ2VzLgoKPgo+IE1heWJlIHRoZSBsYXN0IHRoaW5nIHRvIGFkZCBpcyBhIGZsYWdz
IGNoZWNrIGluIHRoZQo+IHZzb2NrX2FkZHJfdmFsaWRhdGUoKSwgdG8gYXZvaWQgdGhhdCBmbGFn
cyB0aGF0IHdlIGRvbid0IGtub3cgaG93IHRvCj4gaGFuZGxlIGFyZSBzcGVjaWZpZWQuCgpJIGNh
biBhZGQgdGhpcyB2YWxpZGF0aW9uIGFzIGEgbmV3IHBhdGNoIGluIHRoZSBzZXJpZXMsIG5leHQg
cmV2aXNpb24uCgpUaGFua3MsCkFuZHJhCgo+Cj4gRm9yIGV4YW1wbGUgaWYgaW4gdGhlIGZ1dHVy
ZSB3ZSBhZGQgbmV3IGZsYWdzIHRoYXQgdGhpcyB2ZXJzaW9uIG9mIHRoZQo+IGtlcm5lbCBpcyBu
b3QgYWJsZSB0byBzYXRpc2Z5LCB3ZSBzaG91bGQgcmV0dXJuIGFuIGVycm9yIHRvIHRoZQo+IGFw
cGxpY2F0aW9uLgo+Cj4gSSBtZWFuIHNvbWV0aGluZyBsaWtlIHRoaXM6Cj4KPiDCoMKgwqAgZGlm
ZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdnNvY2tfYWRkci5jIGIvbmV0L3Ztd192c29jay92c29j
a19hZGRyLmMKPiDCoMKgwqAgaW5kZXggOTA5ZGUyNmNiMGU3Li43M2JiMWQyZmE1MjYgMTAwNjQ0
Cj4gwqDCoMKgIC0tLSBhL25ldC92bXdfdnNvY2svdnNvY2tfYWRkci5jCj4gwqDCoMKgICsrKyBi
L25ldC92bXdfdnNvY2svdnNvY2tfYWRkci5jCj4gwqDCoMKgIEBAIC0yMiw2ICsyMiw4IEBAIEVY
UE9SVF9TWU1CT0xfR1BMKHZzb2NrX2FkZHJfaW5pdCk7Cj4KPiDCoMKgwqDCoCBpbnQgdnNvY2tf
YWRkcl92YWxpZGF0ZShjb25zdCBzdHJ1Y3Qgc29ja2FkZHJfdm0gKmFkZHIpCj4gwqDCoMKgwqAg
ewo+IMKgwqDCoCArwqDCoMKgwqDCoMKgIHVuc2lnbmVkIHNob3J0IHN2bV92YWxpZF9mbGFncyA9
IFZNQUREUl9GTEFHX1RPX0hPU1Q7Cj4gwqDCoMKgICsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGlmICghYWRkcikKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1
cm4gLUVGQVVMVDsKPgo+IMKgwqDCoCBAQCAtMzEsNiArMzMsOSBAQCBpbnQgdnNvY2tfYWRkcl92
YWxpZGF0ZShjb25zdCBzdHJ1Y3Qgc29ja2FkZHJfdm0gCj4gKmFkZHIpCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBpZiAoYWRkci0+c3ZtX3plcm9bMF0gIT0gMCkKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPgo+IMKgwqDCoCArwqDCoMKg
wqDCoMKgIGlmIChhZGRyLT5zdm1fZmxhZ3MgJiB+c3ZtX3ZhbGlkX2ZsYWdzKQo+IMKgwqDCoCAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiDCoMKgwqAgKwo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4gwqDCoMKgwqAgfQo+IMKgwqDCoMKg
IEVYUE9SVF9TWU1CT0xfR1BMKHZzb2NrX2FkZHJfdmFsaWRhdGUpOwo+Cj4KPiBUaGFua3MsCj4g
U3RlZmFubwo+Cj4+IFRoYW5rIHlvdS4KPj4KPj4gQW5kcmEKPj4KPj4gLS0tCj4+Cj4+IFBhdGNo
IFNlcmllcyBDaGFuZ2Vsb2cKPj4KPj4gVGhlIHBhdGNoIHNlcmllcyBpcyBidWlsdCBvbiB0b3Ag
b2YgdjUuMTAtcmM3Lgo+Pgo+PiBHaXRIdWIgcmVwbyBicmFuY2ggZm9yIHRoZSBsYXRlc3QgdmVy
c2lvbiBvZiB0aGUgcGF0Y2ggc2VyaWVzOgo+Pgo+PiAqIGh0dHBzOi8vZ2l0aHViLmNvbS9hbmRy
YXBycy9saW51eC90cmVlL3Zzb2NrLWZsYWctc2libGluZy1jb21tLXYzCj4+Cj4+IHYyIC0+IHYz
Cj4+Cj4+ICogUmViYXNlIG9uIHRvcCBvZiB2NS4xMC1yYzcuCj4+ICogQWRkICJzdm1fZmxhZ3Mi
IGFzIGEgbmV3IGZpZWxkLCBub3QgcmV1c2luZyAic3ZtX3Jlc2VydmVkMSIuCj4+ICogVXBkYXRl
IGNvbW1lbnRzIHRvIG1lbnRpb24gd2hlbiB0aGUgIlZNQUREUl9GTEFHX1RPX0hPU1QiIGZsYWcg
aXMgCj4+IHNldCBpbiB0aGUKPj4gwqBjb25uZWN0IGFuZCBsaXN0ZW4gcGF0aHMuCj4+ICogVXBk
YXRlIGJpdHdpc2UgY2hlY2sgbG9naWMgdG8gbm90IGNvbXBhcmUgcmVzdWx0IHRvIHRoZSBmbGFn
IHZhbHVlLgo+PiAqIHYyOiAKPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIwMTIw
NDE3MDIzNS44NDM4Ny0xLWFuZHJhcHJzQGFtYXpvbi5jb20vCj4+Cj4+IHYxIC0+IHYyCj4+Cj4+
ICogVXBkYXRlIHRoZSB2c29jayBmbGFnIG5hbWluZyB0byAiVk1BRERSX0ZMQUdfVE9fSE9TVCIu
Cj4+ICogVXNlIGJpdHdpc2Ugb3BlcmF0b3JzIHRvIHNldHVwIGFuZCBjaGVjayB0aGUgdnNvY2sg
ZmxhZy4KPj4gKiBTZXQgdGhlIHZzb2NrIGZsYWcgb24gdGhlIHJlY2VpdmUgcGF0aCBpbiB0aGUg
dnNvY2sgdHJhbnNwb3J0IAo+PiBhc3NpZ25tZW50Cj4+IMKgbG9naWMuCj4+ICogTWVyZ2UgdGhl
IGNoZWNrcyBmb3IgdGhlIGcyaCB0cmFuc3BvcnQgYXNzaWdubWVudCBpbiBvbmUgImlmIiBibG9j
ay4KPj4gKiB2MTogCj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMDEyMDExNTI1
MDUuMTk0NDUtMS1hbmRyYXByc0BhbWF6b24uY29tLwo+Pgo+PiAtLS0KPj4KPj4gQW5kcmEgUGFy
YXNjaGl2ICg0KToKPj4gwqB2bV9zb2NrZXRzOiBBZGQgZmxhZ3MgZmllbGQgaW4gdGhlIHZzb2Nr
IGFkZHJlc3MgZGF0YSBzdHJ1Y3R1cmUKPj4gwqB2bV9zb2NrZXRzOiBBZGQgVk1BRERSX0ZMQUdf
VE9fSE9TVCB2c29jayBmbGFnCj4+IMKgYWZfdnNvY2s6IFNldCBWTUFERFJfRkxBR19UT19IT1NU
IGZsYWcgb24gdGhlIHJlY2VpdmUgcGF0aAo+PiDCoGFmX3Zzb2NrOiBBc3NpZ24gdGhlIHZzb2Nr
IHRyYW5zcG9ydCBjb25zaWRlcmluZyB0aGUgdnNvY2sgYWRkcmVzcwo+PiDCoMKgIGZsYWdzCj4+
Cj4+IGluY2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmggfCAyNSArKysrKysrKysrKysrKysr
KysrKysrKystCj4+IG5ldC92bXdfdnNvY2svYWZfdnNvY2suY8KgwqDCoMKgwqDCoMKgIHwgMjEg
KysrKysrKysrKysrKysrKysrKy0tCj4+IDIgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKPj4KPj4gLS0gCj4+IDIuMjAuMSAoQXBwbGUgR2l0LTExNykKPj4K
Pj4KPj4KPj4KPj4gQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJl
Z2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIAo+PiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIs
IElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIAo+PiBSZWdpc3RlcmVkIGluIFJv
bWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4KPj4KPgoKCgoKQW1hem9u
IERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAy
N0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcw
MDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVy
IEoyMi8yNjIxLzIwMDUuCg==

