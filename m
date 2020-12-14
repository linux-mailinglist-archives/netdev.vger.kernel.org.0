Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F193B2D9ED8
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 19:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440745AbgLNSV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 13:21:28 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:37305 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440740AbgLNSUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 13:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607970038; x=1639506038;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0gXIC5TLvr8nDFVWjndt9zeLxv6JrK73XGxQi4uxaro=;
  b=TbgVafjN4pwCi2EFj/Lq6+L+hTtS59aPzD2SHKNICQS697NOWy1MNlFe
   ZDSKcSuDGdUUCTyTkxWTaGvX3CeG9Zc5BReDYoUhLSygDT0AOzGQ/nfPF
   7AZBIdU8y1fTRjDAbeCdCzykvQvQd3aV8BEr8EzwAuga0mt37awCZ2Sg4
   0=;
X-IronPort-AV: E=Sophos;i="5.78,420,1599523200"; 
   d="scan'208";a="95885892"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 14 Dec 2020 18:19:51 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id CC84DA17E2;
        Mon, 14 Dec 2020 18:19:49 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.48) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 18:19:44 +0000
Subject: Re: [PATCH net-next v4 0/5] vsock: Add flags field in the vsock
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
References: <20201214161122.37717-1-andraprs@amazon.com>
 <20201214170904.wwirjp7ujxrast43@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b97f86d5-db06-7c6d-5c15-e7c65ea46371@amazon.com>
Date:   Mon, 14 Dec 2020 20:19:36 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201214170904.wwirjp7ujxrast43@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D36UWB003.ant.amazon.com (10.43.161.118) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAxNC8xMi8yMDIwIDE5OjA5LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBN
b24sIERlYyAxNCwgMjAyMCBhdCAwNjoxMToxN1BNICswMjAwLCBBbmRyYSBQYXJhc2NoaXYgd3Jv
dGU6Cj4+IHZzb2NrIGVuYWJsZXMgY29tbXVuaWNhdGlvbiBiZXR3ZWVuIHZpcnR1YWwgbWFjaGlu
ZXMgYW5kIHRoZSBob3N0IAo+PiB0aGV5IGFyZQo+PiBydW5uaW5nIG9uLiBOZXN0ZWQgVk1zIGNh
biBiZSBzZXR1cCB0byB1c2UgdnNvY2sgY2hhbm5lbHMsIGFzIHRoZSBtdWx0aQo+PiB0cmFuc3Bv
cnQgc3VwcG9ydCBoYXMgYmVlbiBhdmFpbGFibGUgaW4gdGhlIG1haW5saW5lIHNpbmNlIHRoZSB2
NS41IAo+PiBMaW51eCBrZXJuZWwKPj4gaGFzIGJlZW4gcmVsZWFzZWQuCj4+Cj4+IEltcGxpY2l0
bHksIGlmIG5vIGhvc3QtPmd1ZXN0IHZzb2NrIHRyYW5zcG9ydCBpcyBsb2FkZWQsIGFsbCB0aGUg
Cj4+IHZzb2NrIHBhY2tldHMKPj4gYXJlIGZvcndhcmRlZCB0byB0aGUgaG9zdC4gVGhpcyBiZWhh
dmlvciBjYW4gYmUgdXNlZCB0byBzZXR1cCAKPj4gY29tbXVuaWNhdGlvbgo+PiBjaGFubmVscyBi
ZXR3ZWVuIHNpYmxpbmcgVk1zIHRoYXQgYXJlIHJ1bm5pbmcgb24gdGhlIHNhbWUgaG9zdC4gT25l
IAo+PiBleGFtcGxlIGNhbgo+PiBiZSB0aGUgdnNvY2sgY2hhbm5lbHMgdGhhdCBjYW4gYmUgZXN0
YWJsaXNoZWQgd2l0aGluIEFXUyBOaXRybyBFbmNsYXZlcwo+PiAoc2VlIERvY3VtZW50YXRpb24v
dmlydC9uZV9vdmVydmlldy5yc3QpLgo+Pgo+PiBUbyBiZSBhYmxlIHRvIGV4cGxpY2l0bHkgbWFy
ayBhIGNvbm5lY3Rpb24gYXMgYmVpbmcgdXNlZCBmb3IgYSAKPj4gY2VydGFpbiB1c2UgY2FzZSwK
Pj4gYWRkIGEgZmxhZ3MgZmllbGQgaW4gdGhlIHZzb2NrIGFkZHJlc3MgZGF0YSBzdHJ1Y3R1cmUu
IFRoZSB2YWx1ZSBvZiAKPj4gdGhlIGZsYWdzCj4+IGZpZWxkIGlzIHRha2VuIGludG8gY29uc2lk
ZXJhdGlvbiB3aGVuIHRoZSB2c29jayB0cmFuc3BvcnQgaXMgCj4+IGFzc2lnbmVkLiBUaGlzIHdh
eQo+PiBjYW4gZGlzdGluZ3Vpc2ggYmV0d2VlbiBkaWZmZXJlbnQgdXNlIGNhc2VzLCBzdWNoIGFz
IG5lc3RlZCBWTXMgLyBsb2NhbAo+PiBjb21tdW5pY2F0aW9uIGFuZCBzaWJsaW5nIFZNcy4KPj4K
Pj4gVGhlIGZsYWdzIGZpZWxkIGNhbiBiZSBzZXQgaW4gdGhlIHVzZXIgc3BhY2UgYXBwbGljYXRp
b24gY29ubmVjdCAKPj4gbG9naWMuIE9uIHRoZQo+PiBsaXN0ZW4gcGF0aCwgdGhlIGZpZWxkIGNh
biBiZSBzZXQgaW4gdGhlIGtlcm5lbCBzcGFjZSBsb2dpYy4KPgo+IEkgcmV2aWV3ZWQgYW5kIHRl
c3RlZCBhbGwgdGhlIHBhdGNoZXMsIGdyZWF0IGpvYiEKPgoKVGhhbmtzIGZvciBjaGVja2luZyBp
dCBvdXQuCgpBbmRyYQoKPgo+Pgo+PiBUaGFuayB5b3UuCj4+Cj4+IEFuZHJhCj4+Cj4+IC0tLQo+
Pgo+PiBQYXRjaCBTZXJpZXMgQ2hhbmdlbG9nCj4+Cj4+IFRoZSBwYXRjaCBzZXJpZXMgaXMgYnVp
bHQgb24gdG9wIG9mIHY1LjEwLgo+Pgo+PiBHaXRIdWIgcmVwbyBicmFuY2ggZm9yIHRoZSBsYXRl
c3QgdmVyc2lvbiBvZiB0aGUgcGF0Y2ggc2VyaWVzOgo+Pgo+PiAqIGh0dHBzOi8vZ2l0aHViLmNv
bS9hbmRyYXBycy9saW51eC90cmVlL3Zzb2NrLWZsYWctc2libGluZy1jb21tLXY0Cj4+Cj4+IHYz
IC0+IHY0Cj4+Cj4+ICogUmViYXNlIG9uIHRvcCBvZiB2NS4xMC4KPj4gKiBBZGQgY2hlY2sgZm9y
IHN1cHBvcnRlZCBmbGFnIHZhbHVlcy4KPj4gKiBVcGRhdGUgdGhlICJzdm1fZmxhZ3MiIGZpZWxk
IHRvIGJlIDEgYnl0ZSBpbnN0ZWFkIG9mIDIgYnl0ZXMuCj4+ICogdjM6IAo+PiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9sa21sLzIwMjAxMjExMTAzMjQxLjE3NzUxLTEtYW5kcmFwcnNAYW1hem9u
LmNvbS8KPj4KPj4gdjIgLT4gdjMKPj4KPj4gKiBSZWJhc2Ugb24gdG9wIG9mIHY1LjEwLXJjNy4K
Pj4gKiBBZGQgInN2bV9mbGFncyIgYXMgYSBuZXcgZmllbGQsIG5vdCByZXVzaW5nICJzdm1fcmVz
ZXJ2ZWQxIi4KPj4gKiBVcGRhdGUgY29tbWVudHMgdG8gbWVudGlvbiB3aGVuIHRoZSAiVk1BRERS
X0ZMQUdfVE9fSE9TVCIgZmxhZyBpcyAKPj4gc2V0IGluIHRoZQo+PiDCoGNvbm5lY3QgYW5kIGxp
c3RlbiBwYXRocy4KPj4gKiBVcGRhdGUgYml0d2lzZSBjaGVjayBsb2dpYyB0byBub3QgY29tcGFy
ZSByZXN1bHQgdG8gdGhlIGZsYWcgdmFsdWUuCj4+ICogdjI6IAo+PiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9sa21sLzIwMjAxMjA0MTcwMjM1Ljg0Mzg3LTEtYW5kcmFwcnNAYW1hem9uLmNvbS8K
Pj4KPj4gdjEgLT4gdjIKPj4KPj4gKiBVcGRhdGUgdGhlIHZzb2NrIGZsYWcgbmFtaW5nIHRvICJW
TUFERFJfRkxBR19UT19IT1NUIi4KPj4gKiBVc2UgYml0d2lzZSBvcGVyYXRvcnMgdG8gc2V0dXAg
YW5kIGNoZWNrIHRoZSB2c29jayBmbGFnLgo+PiAqIFNldCB0aGUgdnNvY2sgZmxhZyBvbiB0aGUg
cmVjZWl2ZSBwYXRoIGluIHRoZSB2c29jayB0cmFuc3BvcnQgCj4+IGFzc2lnbm1lbnQKPj4gwqBs
b2dpYy4KPj4gKiBNZXJnZSB0aGUgY2hlY2tzIGZvciB0aGUgZzJoIHRyYW5zcG9ydCBhc3NpZ25t
ZW50IGluIG9uZSAiaWYiIGJsb2NrLgo+PiAqIHYxOiAKPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGttbC8yMDIwMTIwMTE1MjUwNS4xOTQ0NS0xLWFuZHJhcHJzQGFtYXpvbi5jb20vCj4+Cj4+
IC0tLQo+Pgo+PiBBbmRyYSBQYXJhc2NoaXYgKDUpOgo+PiDCoHZtX3NvY2tldHM6IEFkZCBmbGFn
cyBmaWVsZCBpbiB0aGUgdnNvY2sgYWRkcmVzcyBkYXRhIHN0cnVjdHVyZQo+PiDCoHZtX3NvY2tl
dHM6IEFkZCBWTUFERFJfRkxBR19UT19IT1NUIHZzb2NrIGZsYWcKPj4gwqB2c29ja19hZGRyOiBD
aGVjayBmb3Igc3VwcG9ydGVkIGZsYWcgdmFsdWVzCj4+IMKgYWZfdnNvY2s6IFNldCBWTUFERFJf
RkxBR19UT19IT1NUIGZsYWcgb24gdGhlIHJlY2VpdmUgcGF0aAo+PiDCoGFmX3Zzb2NrOiBBc3Np
Z24gdGhlIHZzb2NrIHRyYW5zcG9ydCBjb25zaWRlcmluZyB0aGUgdnNvY2sgYWRkcmVzcwo+PiDC
oMKgIGZsYWdzCj4+Cj4+IGluY2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmggfCAyNiArKysr
KysrKysrKysrKysrKysrKysrKysrLQo+PiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmPCoMKgwqDC
oMKgwqDCoCB8IDIxICsrKysrKysrKysrKysrKysrKystLQo+PiBuZXQvdm13X3Zzb2NrL3Zzb2Nr
X2FkZHIuY8KgwqDCoMKgwqAgfMKgIDQgKysrLQo+PiAzIGZpbGVzIGNoYW5nZWQsIDQ3IGluc2Vy
dGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4+Cj4+IC0tIAo+PiAyLjIwLjEgKEFwcGxlIEdpdC0x
MTcpCj4+Cj4+Cj4+Cj4+Cj4+IEFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMu
Ui5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiAKPj4gTGF6YXIgU3RyZWV0LCBVQkM1LCBm
bG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiAKPj4gUmVnaXN0ZXJl
ZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCj4+Cj4KCgoK
CkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9m
ZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291
bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9u
IG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

