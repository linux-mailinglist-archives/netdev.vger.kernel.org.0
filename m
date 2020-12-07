Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCAE2D19F9
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgLGTq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:46:26 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:59620 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLGTq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:46:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607370385; x=1638906385;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=d6qO1HCsb2ZszMYHpduk4dlpxhgfd9b+MTURRLXFKKc=;
  b=h4y1fOI+B14STKMRlpD7dLMv5QoA06NkhSnc5R6YCsK8v0+aySpE48YF
   SVBpZQUDC9SfIr7SUsI/rnwJGC98AQHvP1V2Vfkc6FzM4cF7I8Fp9chMB
   z5etvbqV4/bDR5PYk8VYrubS6pYaEJdl9Qq0ElouDc/UQXZed5xPdP2u7
   w=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="901221316"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 07 Dec 2020 19:45:39 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id CA36CA1BF5;
        Mon,  7 Dec 2020 19:45:38 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.184) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 19:45:33 +0000
Subject: Re: [PATCH net-next v2 2/4] vm_sockets: Add VMADDR_FLAG_TO_HOST vsock
 flag
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
 <20201204170235.84387-3-andraprs@amazon.com>
 <20201207095935.um2aafhvoikwy5xr@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <96b93774-f4dc-54ed-364c-e57281921111@amazon.com>
Date:   Mon, 7 Dec 2020 21:45:28 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207095935.um2aafhvoikwy5xr@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.161.184]
X-ClientProxiedBy: EX13D45UWA002.ant.amazon.com (10.43.160.38) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwNy8xMi8yMDIwIDExOjU5LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBG
cmksIERlYyAwNCwgMjAyMCBhdCAwNzowMjozM1BNICswMjAwLCBBbmRyYSBQYXJhc2NoaXYgd3Jv
dGU6Cj4+IEFkZCBWTUFERFJfRkxBR19UT19IT1NUIHZzb2NrIGZsYWcgdGhhdCBpcyB1c2VkIHRv
IHNldHVwIGEgdnNvY2sKPj4gY29ubmVjdGlvbiB3aGVyZSBhbGwgdGhlIHBhY2tldHMgYXJlIGZv
cndhcmRlZCB0byB0aGUgaG9zdC4KPj4KPj4gVGhlbiwgdXNpbmcgdGhpcyB0eXBlIG9mIHZzb2Nr
IGNoYW5uZWwsIHZzb2NrIGNvbW11bmljYXRpb24gYmV0d2Vlbgo+PiBzaWJsaW5nIFZNcyBjYW4g
YmUgYnVpbHQgb24gdG9wIG9mIGl0Lgo+Pgo+PiBDaGFuZ2Vsb2cKPj4KPj4gdjEgLT4gdjIKPj4K
Pj4gKiBOZXcgcGF0Y2ggaW4gdjIsIGl0IHdhcyBzcGxpdCBmcm9tIHRoZSBmaXJzdCBwYXRjaCBp
biB0aGUgc2VyaWVzLgo+PiAqIFJlbW92ZSB0aGUgZGVmYXVsdCB2YWx1ZSBmb3IgdGhlIHZzb2Nr
IGZsYWdzIGZpZWxkLgo+PiAqIFVwZGF0ZSB0aGUgbmFtaW5nIGZvciB0aGUgdnNvY2sgZmxhZyB0
byAiVk1BRERSX0ZMQUdfVE9fSE9TVCIuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJhIFBhcmFz
Y2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4gLS0tCj4+IGluY2x1ZGUvdWFwaS9saW51eC92
bV9zb2NrZXRzLmggfCAxNSArKysrKysrKysrKysrKysKPj4gMSBmaWxlIGNoYW5nZWQsIDE1IGlu
c2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC92bV9zb2Nr
ZXRzLmggCj4+IGIvaW5jbHVkZS91YXBpL2xpbnV4L3ZtX3NvY2tldHMuaAo+PiBpbmRleCA0Njcz
NTM3NmE1N2E4Li43MmUxYTNkMDU2ODJkIDEwMDY0NAo+PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGlu
dXgvdm1fc29ja2V0cy5oCj4+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmgK
Pj4gQEAgLTExNCw2ICsxMTQsMjEgQEAKPj4KPj4gI2RlZmluZSBWTUFERFJfQ0lEX0hPU1QgMgo+
Pgo+PiArLyogVGhlIGN1cnJlbnQgZGVmYXVsdCB1c2UgY2FzZSBmb3IgdGhlIHZzb2NrIGNoYW5u
ZWwgaXMgdGhlIGZvbGxvd2luZzoKPj4gKyAqIGxvY2FsIHZzb2NrIGNvbW11bmljYXRpb24gYmV0
d2VlbiBndWVzdCBhbmQgaG9zdCBhbmQgbmVzdGVkIFZNcyAKPj4gc2V0dXAuCj4+ICsgKiBJbiBh
ZGRpdGlvbiB0byB0aGlzLCBpbXBsaWNpdGx5LCB0aGUgdnNvY2sgcGFja2V0cyBhcmUgZm9yd2Fy
ZGVkIAo+PiB0byB0aGUgaG9zdAo+PiArICogaWYgbm8gaG9zdC0+Z3Vlc3QgdnNvY2sgdHJhbnNw
b3J0IGlzIHNldC4KPj4gKyAqCj4+ICsgKiBTZXQgdGhpcyBmbGFnIHZhbHVlIGluIHRoZSBzb2Nr
YWRkcl92bSBjb3JyZXNwb25kaW5nIGZpZWxkIGlmIHRoZSAKPj4gdnNvY2sKPj4gKyAqIHBhY2tl
dHMgbmVlZCB0byBiZSBhbHdheXMgZm9yd2FyZGVkIHRvIHRoZSBob3N0LiBVc2luZyB0aGlzIAo+
PiBiZWhhdmlvciwKPj4gKyAqIHZzb2NrIGNvbW11bmljYXRpb24gYmV0d2VlbiBzaWJsaW5nIFZN
cyBjYW4gYmUgc2V0dXAuCj4KPiBNYXliZSB3ZSBjYW4gYWRkIGEgc2VudGVuY2Ugc2F5aW5nIHRo
YXQgdGhpcyBmbGFnIGlzIHNldCBvbiB0aGUgcmVtb3RlCj4gcGVlciBhZGRyZXNzIGZvciBhbiBp
bmNvbWluZyBjb25uZWN0aW9uIHdoZW4gaXQgaXMgcm91dGVkIGZyb20gdGhlIGhvc3QKPiAobG9j
YWwgQ0lEIGFuZCByZW1vdGUgQ0lEID4gVk1BRERSX0NJRF9IT1NUKS4KClN1cmUsIEkgY2FuIG1h
a2UgaXQgbW9yZSBjbGVhciB3aGVuIGl0IGlzIHNldCBlLmcuIGluIHVzZXIgc3BhY2UgCihjb25u
ZWN0IHBhdGgpIGFuZCBpbiBrZXJuZWwgc3BhY2UgKGxpc3RlbiBwYXRoKS4KClRoYW5rcywKQW5k
cmEKCj4KPj4gKyAqCj4+ICsgKiBUaGlzIHdheSBjYW4gZXhwbGljaXRseSBkaXN0aW5ndWlzaCBi
ZXR3ZWVuIHZzb2NrIGNoYW5uZWxzIAo+PiBjcmVhdGVkIGZvcgo+PiArICogZGlmZmVyZW50IHVz
ZSBjYXNlcywgc3VjaCBhcyBuZXN0ZWQgVk1zIChvciBsb2NhbCBjb21tdW5pY2F0aW9uIAo+PiBi
ZXR3ZWVuCj4+ICsgKiBndWVzdCBhbmQgaG9zdCkgYW5kIHNpYmxpbmcgVk1zLgo+PiArICovCj4+
ICsjZGVmaW5lIFZNQUREUl9GTEFHX1RPX0hPU1QgMHgwMDAxCj4+ICsKPj4gLyogSW52YWxpZCB2
U29ja2V0cyB2ZXJzaW9uLiAqLwo+Pgo+PiAjZGVmaW5lIFZNX1NPQ0tFVFNfSU5WQUxJRF9WRVJT
SU9OIC0xVQo+PiAtLSAKPj4gMi4yMC4xIChBcHBsZSBHaXQtMTE3KQo+Pgo+Pgo+Pgo+Pgo+PiBB
bWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZp
Y2U6IDI3QSBTZi4gCj4+IExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBD
b3VudHksIDcwMDA0NSwgUm9tYW5pYS4gCj4+IFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0
cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo+Pgo+CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQg
Q2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIg
U3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlh
LiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAw
NS4K

