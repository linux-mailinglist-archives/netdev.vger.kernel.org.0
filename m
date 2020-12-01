Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6D2CAAC3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgLASbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:31:43 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:31903 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgLASbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 13:31:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606847501; x=1638383501;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=3v0xYiwGFnepKakD1Kn38bWbXTSKtbR5exXVdyChygA=;
  b=RY9FpVtchk8PqP6Y9b4QlD1RQapL0jt5eGSDJrwUVTiOxxgofZVRSllM
   e0+74bz3d686MfEgD02GMM/b/TCc6ZlRlay1spQjTROM5PeAT221DqACV
   9xjPfmpbVfrL9lKtbpRwBGvSjFzWtJj91r+3NVJ3AWUgQJ1F87Q5/VNqL
   Q=;
X-IronPort-AV: E=Sophos;i="5.78,385,1599523200"; 
   d="scan'208";a="100889006"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 01 Dec 2020 18:02:46 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 2A9A8100F56;
        Tue,  1 Dec 2020 18:02:42 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.67) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 18:02:37 +0000
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
 <20201201162721.lbngjzofyk3bad5b@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <f9384701-9ac2-abb2-2082-820f9fc99904@amazon.com>
Date:   Tue, 1 Dec 2020 20:02:28 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201201162721.lbngjzofyk3bad5b@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.160.67]
X-ClientProxiedBy: EX13D22UWC002.ant.amazon.com (10.43.162.29) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwMS8xMi8yMDIwIDE4OjI3LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPgo+IEhp
IEFuZHJhLAo+Cj4gT24gVHVlLCBEZWMgMDEsIDIwMjAgYXQgMDU6MjU6MDJQTSArMDIwMCwgQW5k
cmEgUGFyYXNjaGl2IHdyb3RlOgo+PiB2c29jayBlbmFibGVzIGNvbW11bmljYXRpb24gYmV0d2Vl
biB2aXJ0dWFsIG1hY2hpbmVzIGFuZCB0aGUgaG9zdCAKPj4gdGhleSBhcmUKPj4gcnVubmluZyBv
bi4gTmVzdGVkIFZNcyBjYW4gYmUgc2V0dXAgdG8gdXNlIHZzb2NrIGNoYW5uZWxzLCBhcyB0aGUg
bXVsdGkKPj4gdHJhbnNwb3J0IHN1cHBvcnQgaGFzIGJlZW4gYXZhaWxhYmxlIGluIHRoZSBtYWlu
bGluZSBzaW5jZSB0aGUgdjUuNSAKPj4gTGludXgga2VybmVsCj4+IGhhcyBiZWVuIHJlbGVhc2Vk
Lgo+Pgo+PiBJbXBsaWNpdGx5LCBpZiBubyBob3N0LT5ndWVzdCB2c29jayB0cmFuc3BvcnQgaXMg
bG9hZGVkLCBhbGwgdGhlIAo+PiB2c29jayBwYWNrZXRzCj4+IGFyZSBmb3J3YXJkZWQgdG8gdGhl
IGhvc3QuIFRoaXMgYmVoYXZpb3IgY2FuIGJlIHVzZWQgdG8gc2V0dXAgCj4+IGNvbW11bmljYXRp
b24KPj4gY2hhbm5lbHMgYmV0d2VlbiBzaWJsaW5nIFZNcyB0aGF0IGFyZSBydW5uaW5nIG9uIHRo
ZSBzYW1lIGhvc3QuIE9uZSAKPj4gZXhhbXBsZSBjYW4KPj4gYmUgdGhlIHZzb2NrIGNoYW5uZWxz
IHRoYXQgY2FuIGJlIGVzdGFibGlzaGVkIHdpdGhpbiBBV1MgTml0cm8gRW5jbGF2ZXMKPj4gKHNl
ZSBEb2N1bWVudGF0aW9uL3ZpcnQvbmVfb3ZlcnZpZXcucnN0KS4KPj4KPj4gVG8gYmUgYWJsZSB0
byBleHBsaWNpdGx5IG1hcmsgYSBjb25uZWN0aW9uIGFzIGJlaW5nIHVzZWQgZm9yIGEgCj4+IGNl
cnRhaW4gdXNlIGNhc2UsCj4+IGFkZCBhIGZsYWcgZmllbGQgaW4gdGhlIHZzb2NrIGFkZHJlc3Mg
ZGF0YSBzdHJ1Y3R1cmUuIFRoZSAKPj4gInN2bV9yZXNlcnZlZDEiIGZpZWxkCj4+IGhhcyBiZWVu
IHJlcHVycG9zZWQgdG8gYmUgdGhlIGZsYWcgZmllbGQuIFRoZSB2YWx1ZSBvZiB0aGUgZmxhZyB3
aWxsIAo+PiB0aGVuIGJlCj4+IHRha2VuIGludG8gY29uc2lkZXJhdGlvbiB3aGVuIHRoZSB2c29j
ayB0cmFuc3BvcnQgaXMgYXNzaWduZWQuCj4+Cj4+IFRoaXMgd2F5IGNhbiBkaXN0aW5ndWlzaCBi
ZXR3ZWVuIG5lc3RlZCBWTXMgLyBsb2NhbCBjb21tdW5pY2F0aW9uIGFuZCAKPj4gc2libGluZwo+
PiBWTXMgdXNlIGNhc2VzLiBBbmQgY2FuIGFsc28gc2V0dXAgb25lIG9yIG1vcmUgdHlwZXMgb2Yg
Y29tbXVuaWNhdGlvbiAKPj4gYXQgdGhlIHNhbWUKPj4gdGltZS4KPgo+IFRoYW5rcyB0byB3b3Jr
IG9uIHRoaXMsIEkndmUgbGVmdCB5b3UgYSBmZXcgY29tbWVudHMsIGJ1dCBJIHRoaW5rIHRoaXMK
PiBpcyB0aGUgcmlnaHQgd2F5IHRvIHN1cHBvcnQgbmVzdGVkIGFuZCBzaWJsaW5nIGNvbW11bmlj
YXRpb24gdG9nZXRoZXIuCgpIaSBTdGVmYW5vLAoKVGhhbmtzIGFsc28gZm9yIHRha2luZyB0aW1l
IHRvIHJldmlldyBhbmQgYm90aCB5b3UgYW5kIFN0ZWZhbiBmb3IgCnNoYXJpbmcgYW4gb3ZlcnZp
ZXcgb2YgdGhpcyBwcm9wb3NlZCBvcHRpb24uCgpJJ20gZ29pbmcgdGhyb3VnaCB0aGUgY29tbWVu
dHMgYW5kIHdpbGwgc2VuZCBvdXQgdGhlIHYyIG9mIHRoZSBwYXRjaCAKc2VyaWVzIGFzIEkgaGF2
ZSB0aGUgY2hhbmdlcyBkb25lIGFuZCB2YWxpZGF0ZWQuCgpUaGFua3MsCkFuZHJhCgoKCkFtYXpv
biBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTog
MjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3
MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJl
ciBKMjIvMjYyMS8yMDA1Lgo=

