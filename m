Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674D82CC209
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbgLBQTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:19:21 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:49598 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730691AbgLBQTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:19:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606925960; x=1638461960;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UA/GV23Ara3zyMQ0u3USDM/10j9wKCrlivLcATUot3U=;
  b=EBygBne9uzSyp56C6UVsS1+Y7JQkMP83SyEnfaqu5mO9a0gJsgVnhJ1s
   yZN+iIxZUtKZX1NK/OjvDY/7SwWmJvr2WF2b9UmXKVG2e07l2bOC0tTyZ
   GVtuuT91LXYlykmDhq3X5Gkog7P90nnQcf/ipS+EsvzqhcxU/UPr2jb84
   8=;
X-IronPort-AV: E=Sophos;i="5.78,387,1599523200"; 
   d="scan'208";a="67213731"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 02 Dec 2020 16:18:33 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id AB120C1B3B;
        Wed,  2 Dec 2020 16:18:29 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.252) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Dec 2020 16:18:24 +0000
Subject: Re: [PATCH net-next v1 0/3] vsock: Add flag field in the vsock
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
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201202133754.2ek2wgutkujkvxaf@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <d5c55d2e-5dc3-96f2-2333-37e778c761ae@amazon.com>
Date:   Wed, 2 Dec 2020 18:18:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201202133754.2ek2wgutkujkvxaf@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.252]
X-ClientProxiedBy: EX13D04UWB004.ant.amazon.com (10.43.161.103) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwMi8xMi8yMDIwIDE1OjM3LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBIaSBB
bmRyYSwKPgo+IE9uIFR1ZSwgRGVjIDAxLCAyMDIwIGF0IDA1OjI1OjAyUE0gKzAyMDAsIEFuZHJh
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
YWluIHVzZSBjYXNlLAo+PiBhZGQgYSBmbGFnIGZpZWxkIGluIHRoZSB2c29jayBhZGRyZXNzIGRh
dGEgc3RydWN0dXJlLiBUaGUgCj4+ICJzdm1fcmVzZXJ2ZWQxIiBmaWVsZAo+PiBoYXMgYmVlbiBy
ZXB1cnBvc2VkIHRvIGJlIHRoZSBmbGFnIGZpZWxkLiBUaGUgdmFsdWUgb2YgdGhlIGZsYWcgd2ls
bCAKPj4gdGhlbiBiZQo+PiB0YWtlbiBpbnRvIGNvbnNpZGVyYXRpb24gd2hlbiB0aGUgdnNvY2sg
dHJhbnNwb3J0IGlzIGFzc2lnbmVkLgo+Pgo+PiBUaGlzIHdheSBjYW4gZGlzdGluZ3Vpc2ggYmV0
d2VlbiBuZXN0ZWQgVk1zIC8gbG9jYWwgY29tbXVuaWNhdGlvbiBhbmQgCj4+IHNpYmxpbmcKPj4g
Vk1zIHVzZSBjYXNlcy4gQW5kIGNhbiBhbHNvIHNldHVwIG9uZSBvciBtb3JlIHR5cGVzIG9mIGNv
bW11bmljYXRpb24gCj4+IGF0IHRoZSBzYW1lCj4+IHRpbWUuCj4+Cj4KPiBBbm90aGVyIHRoaW5n
IHdvcnRoIG1lbnRpb25pbmcgaXMgdGhhdCBmb3Igbm93IGl0IGlzIG5vdCBzdXBwb3J0ZWQgaW4K
PiB2aG9zdC12c29jaywgc2luY2Ugd2UgYXJlIGRpc2NhcmRpbmcgZXZlcnkgcGFja2V0IG5vdCBh
ZGRyZXNzZWQgdG8gdGhlCj4gaG9zdC4KClJpZ2h0LCB0aGFua3MgZm9yIHRoZSBmb2xsb3ctdXAu
Cgo+Cj4gV2hhdCB3ZSBzaG91bGQgZG8gd291bGQgYmU6Cj4gLSBhZGQgYSBuZXcgSU9DVEwgdG8g
dmhvc3QtdnNvY2sgdG8gZW5hYmxlIHNpYmxpbmcgY29tbXVuaWNhdGlvbiwgYnkKPiDCoCBkZWZh
dWx0IEknZCBsaWtlIHRvIGxlYXZlIGl0IGRpc2FibGVkCj4KPiAtIGFsbG93IHNpYmxpbmcgZm9y
d2FyZGluZyBvbmx5IGlmIGJvdGggZ3Vlc3RzIGhhdmUgc2libGluZwo+IMKgIGNvbW11bmljYXRp
b24gZW5hYmxlZCBhbmQgd2Ugc2hvdWxkIGltcGxlbWVudCBzb21lIGtpbmQgb2YgZmlsdGVyaW5n
Cj4gwqAgb3IgbmV0d29yayBuYW1lc3BhY2Ugc3VwcG9ydCB0byBhbGxvdyB0aGUgY29tbXVuaWNh
dGlvbiBvbmx5IGJldHdlZW4gYQo+IMKgIHN1YnNldCBvZiBWTXMKPgo+Cj4gRG8geW91IGhhdmUg
cGxhbnMgdG8gd29yayBvbiBpdD8KCk5vcGUsIG5vdCB5ZXQuIEJ1dCBJIGNhbiB0YWtlIHNvbWUg
dGltZSBpbiB0aGUgc2Vjb25kIHBhcnQgb2YgRGVjZW1iZXIgLyAKYmVnaW5uaW5nIG9mIEphbnVh
cnkgZm9yIHRoaXMuIEFuZCB3ZSBjYW4gY2F0Y2ggdXAgaW4gdGhlIG1lYW50aW1lIGlmIAp0aGVy
ZSBpcyBzb21ldGhpbmcgYmxvY2tpbmcgb3IgbW9yZSBjbGFyaWZpY2F0aW9ucyBhcmUgbmVlZGVk
IHRvIG1ha2UgaXQgCndvcmsuCgpUaGFua3MsCkFuZHJhCgo+Cj4KPiBPdGhlcndpc2UgSSBwdXQg
aXQgaW4gbXkgdG8tZG8gbGlzdCBhbmQgaG9wZSBJIGhhdmUgdGltZSB0byBkbyBpdCAobWF5YmUK
PiBuZXh0IG1vbnRoKS4KPgo+IFRoYW5rcywKPiBTdGVmYW5vCj4KCgoKCkFtYXpvbiBEZXZlbG9w
bWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBM
YXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJv
bWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYy
MS8yMDA1Lgo=

