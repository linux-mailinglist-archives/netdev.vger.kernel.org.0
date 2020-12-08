Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1912D320F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbgLHSY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:24:28 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:25760 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730424AbgLHSY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607451867; x=1638987867;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=eYoKHhsuFogOJORm3zmz7AyHSCi/zgwQzoYHkuz2KUI=;
  b=R37+7srN2s0vL0+TCd+prVUC9lPcNV6cJVmeKDge80EM9LGF5KDqFP8T
   x4lbmQbxDvWHuoy3OWakYEPywEXEZ/2OWHctXOfZVkcxjwrqrmerWw4JY
   RG0TA4t2Lrf6n71maTb9whhyKzh+Bopqv6LnOk25DuqfoQUmZ7shvwfQP
   U=;
X-IronPort-AV: E=Sophos;i="5.78,403,1599523200"; 
   d="scan'208";a="94388883"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 08 Dec 2020 18:23:39 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id 0BAA6A18C1;
        Tue,  8 Dec 2020 18:23:38 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.184) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 18:23:33 +0000
Subject: Re: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the
 vsock address data structure
To:     Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201204170235.84387-2-andraprs@amazon.com>
 <20201207132908.130a5f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <73ff948f-f455-7205-bfaa-5b468b2528c2@amazon.com>
Date:   Tue, 8 Dec 2020 20:23:24 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207132908.130a5f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.184]
X-ClientProxiedBy: EX13D47UWC002.ant.amazon.com (10.43.162.83) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwNy8xMi8yMDIwIDIzOjI5LCBKYWt1YiBLaWNpbnNraSB3cm90ZToKPiBPbiBGcmksIDQg
RGVjIDIwMjAgMTk6MDI6MzIgKzAyMDAgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+PiBkaWZmIC0t
Z2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZtX3NvY2tldHMuaCBiL2luY2x1ZGUvdWFwaS9saW51
eC92bV9zb2NrZXRzLmgKPj4gaW5kZXggZmQwZWQ3MjIxNjQ1ZC4uNDY3MzUzNzZhNTdhOCAxMDA2
NDQKPj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZtX3NvY2tldHMuaAo+PiArKysgYi9pbmNs
dWRlL3VhcGkvbGludXgvdm1fc29ja2V0cy5oCj4+IEBAIC0xNDUsNyArMTQ1LDcgQEAKPj4KPj4g
ICBzdHJ1Y3Qgc29ja2FkZHJfdm0gewo+PiAgICAgICAgX19rZXJuZWxfc2FfZmFtaWx5X3Qgc3Zt
X2ZhbWlseTsKPj4gLSAgICAgdW5zaWduZWQgc2hvcnQgc3ZtX3Jlc2VydmVkMTsKPj4gKyAgICAg
dW5zaWduZWQgc2hvcnQgc3ZtX2ZsYWdzOwo+PiAgICAgICAgdW5zaWduZWQgaW50IHN2bV9wb3J0
Owo+PiAgICAgICAgdW5zaWduZWQgaW50IHN2bV9jaWQ7Cj4+ICAgICAgICB1bnNpZ25lZCBjaGFy
IHN2bV96ZXJvW3NpemVvZihzdHJ1Y3Qgc29ja2FkZHIpIC0KPiBTaW5jZSB0aGlzIGlzIGEgdUFQ
SSBoZWFkZXIgSSBnb3R0YSBhc2sgLSBhcmUgeW91IDEwMCUgc3VyZSB0aGF0IGl0J3MKPiBva2F5
IHRvIHJlbmFtZSB0aGlzIGZpZWxkPwo+Cj4gSSBkaWRuJ3QgZ3Jhc3AgZnJvbSBqdXN0IHJlYWRp
bmcgdGhlIHBhdGNoZXMgd2hldGhlciB0aGlzIGlzIGEgdUFQSSBvcgo+IGp1c3QgaW50ZXJuYWwg
a2VybmVsIGZsYWcsIHNlZW1zIGxpa2UgdGhlIGZvcm1lciBmcm9tIHRoZSByZWFkaW5nIG9mCj4g
dGhlIGNvbW1lbnQgaW4gcGF0Y2ggMi4gSW4gd2hpY2ggY2FzZSB3aGF0IGd1YXJhbnRlZXMgdGhh
dCBleGlzdGluZwo+IHVzZXJzIGRvbid0IHBhc3MgaW4gZ2FyYmFnZSBzaW5jZSB0aGUga2VybmVs
IGRvZXNuJ3QgY2hlY2sgaXQgd2FzIDA/CgpUaGF0J3MgYWx3YXlzIGdvb2QgdG8gZG91YmxlLWNo
ZWNrIHRoZSB1YXBpIGNoYW5nZXMgZG9uJ3QgYnJlYWsgLyBhc3N1bWUgCnNvbWV0aGluZywgdGhh
bmtzIGZvciBicmluZ2luZyB0aGlzIHVwLiA6KQoKU3VyZSwgbGV0J3MgZ28gdGhyb3VnaCB0aGUg
cG9zc2libGUgb3B0aW9ucyBzdGVwIGJ5IHN0ZXAuIExldCBtZSBrbm93IGlmIApJIGdldCBhbnl0
aGluZyB3cm9uZyBhbmQgaWYgSSBjYW4gaGVscCB3aXRoIGNsYXJpZmljYXRpb25zLgoKVGhlcmUg
aXMgdGhlICJzdm1fcmVzZXJ2ZWQxIiBmaWVsZCB0aGF0IGlzIG5vdCB1c2VkIGluIHRoZSBrZXJu
ZWwgCmNvZGViYXNlLiBJdCBpcyBzZXQgdG8gMCBvbiB0aGUgcmVjZWl2ZSAobGlzdGVuKSBwYXRo
IGFzIHBhcnQgb2YgdGhlIAp2c29jayBhZGRyZXNzIGluaXRpYWxpemF0aW9uIFsxXVsyXS4gVGhl
ICJzdm1fZmFtaWx5IiBhbmQgInN2bV96ZXJvIiAKZmllbGRzIGFyZSBjaGVja2VkIGFzIHBhcnQg
b2YgdGhlIGFkZHJlc3MgdmFsaWRhdGlvbiBbM10uCgpOb3csIHdpdGggdGhlIGN1cnJlbnQgY2hh
bmdlIHRvICJzdm1fZmxhZ3MiLCB0aGUgZmxvdyBpcyB0aGUgZm9sbG93aW5nOgoKKiBPbiB0aGUg
cmVjZWl2ZSAobGlzdGVuKSBwYXRoLCB0aGUgcmVtb3RlIGFkZHJlc3Mgc3RydWN0dXJlIGlzIApp
bml0aWFsaXplZCBhcyBwYXJ0IG9mIHRoZSB2c29jayBhZGRyZXNzIGluaXQgbG9naWMgWzJdLiBU
aGVuIHBhdGNoIDMvNCAKb2YgdGhpcyBzZXJpZXMgc2V0cyB0aGUgIlZNQUREUl9GTEFHX1RPX0hP
U1QiIGZsYWcgZ2l2ZW4gYSBzZXQgb2YgCmNvbmRpdGlvbnMgKGxvY2FsIGFuZCByZW1vdGUgQ0lE
ID4gVk1BRERSX0NJRF9IT1NUKS4KCiogT24gdGhlIGNvbm5lY3QgcGF0aCwgdGhlIHVzZXJzcGFj
ZSBsb2dpYyBjYW4gc2V0IHRoZSAic3ZtX2ZsYWdzIiAKZmllbGQuIEl0IGNhbiBiZSBzZXQgdG8g
MCBvciAxIChWTUFERFJfRkxBR19UT19IT1NUKTsgb3IgYW55IG90aGVyIHZhbHVlIApncmVhdGVy
IHRoYW4gMS4gSWYgdGhlICJWTUFERFJfRkxBR19UT19IT1NUIiBmbGFnIGlzIHNldCwgYWxsIHRo
ZSB2c29jayAKcGFja2V0cyBhcmUgdGhlbiBmb3J3YXJkZWQgdG8gdGhlIGhvc3QuCgoqIFdoZW4g
dGhlIHZzb2NrIHRyYW5zcG9ydCBpcyBhc3NpZ25lZCwgdGhlICJzdm1fZmxhZ3MiIGZpZWxkIGlz
IApjaGVja2VkLCBhbmQgaWYgaXQgaGFzIHRoZSAiVk1BRERSX0ZMQUdfVE9fSE9TVCIgZmxhZyBz
ZXQsIGl0IGdvZXMgb24gCndpdGggYSBndWVzdC0+aG9zdCB0cmFuc3BvcnQgKHBhdGNoIDQvNCBv
ZiB0aGlzIHNlcmllcykuIE90aGVyd2lzZSwgCm90aGVyIHNwZWNpZmljIGZsYWcgdmFsdWUgaXMg
bm90IGN1cnJlbnRseSB1c2VkLgoKR2l2ZW4gYWxsIHRoZXNlIHBvaW50cywgdGhlIHF1ZXN0aW9u
IHJlbWFpbnMgd2hhdCBoYXBwZW5zIGlmIHRoZSAKInN2bV9mbGFncyIgZmllbGQgaXMgc2V0IG9u
IHRoZSBjb25uZWN0IHBhdGggdG8gYSB2YWx1ZSBoaWdoZXIgdGhhbiAxIAoobWF5YmUgYSBib2d1
cyBvbmUsIG5vdCBpbnRlbmRlZCBzbykuIEFuZCBpdCBpbmNsdWRlcyB0aGUgCiJWTUFERFJfRkxB
R19UT19IT1NUIiB2YWx1ZSAodGhlIHNpbmdsZSBmbGFnIHNldCBhbmQgc3BlY2lmaWNhbGx5IHVz
ZWQgCmZvciBub3csIGJ1dCB3ZSBzaG91bGQgYWxzbyBhY2NvdW50IGZvciBhbnkgZnVydGhlciBw
b3NzaWJsZSBmbGFncykuIEluIAp0aGlzIGNhc2UsIGFsbCB0aGUgdnNvY2sgcGFja2V0cyB3b3Vs
ZCBiZSBmb3J3YXJkZWQgdG8gdGhlIGhvc3QgYW5kIAptYXliZSBub3QgaW50ZW5kZWQgc28sIGhh
dmluZyBhIGJvZ3VzIHZhbHVlIGZvciB0aGUgZmxhZ3MgZmllbGQuIElzIHRoaXMgCnBvc3NpYmxl
IGNhc2Ugd2hhdCB5b3UgYXJlIHJlZmVycmluZyB0bz8KClRoYW5rcywKQW5kcmEKClsxXSBodHRw
czovL21hbjcub3JnL2xpbnV4L21hbi1wYWdlcy9tYW43L3Zzb2NrLjcuaHRtbApbMl0gCmh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4
LmdpdC90cmVlL25ldC92bXdfdnNvY2svdnNvY2tfYWRkci5jI24xNApbM10gCmh0dHBzOi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90
cmVlL25ldC92bXdfdnNvY2svdnNvY2tfYWRkci5jI24yMwoKCgpBbWF6b24gRGV2ZWxvcG1lbnQg
Q2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIg
U3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlh
LiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAw
NS4K

