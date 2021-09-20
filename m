Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4B1411462
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbhITM3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:29:55 -0400
Received: from out0.migadu.com ([94.23.1.103]:44819 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238078AbhITM3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:29:53 -0400
Date:   Mon, 20 Sep 2021 20:28:18 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1632140901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=j+ZOYvpSYWGun6+n61peyKcXmP4Xhe25A8WioqPIZts=;
        b=iNoy8r9u6HBJGVrOBMZsrf4WTkmosH9Gb3ZD3nqIkpFVWN1inprGN54vdG8gbZP/M+wdih
        rk8VtrwOtCBceOTV3+miGPaB7j9wdr21o+UOarnwqnxHXUhI32E28/xuVynNtpAEyPWYHS
        bEWYuGyKYZE77I51dhqn8y3U1oVqQHc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "yajun.deng@linux.dev" <yajun.deng@linux.dev>
To:     "Cong Wang" <xiyou.wangcong@gmail.com>
Cc:     kuba <kuba@kernel.org>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH net-next] net: socket: add the case sock_no_xxx support
References: <20210916122943.19849-1-yajun.deng@linux.dev>, 
        <20210917183311.2db5f332@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>, 
        <87275ec67ed69d077e0265bc01acd8a2@linux.dev>, 
        <CAM_iQpXcqpEFpnyX=wLQFTWJBjWiAMofighQkpnrV2a0Fh83AQ@mail.gmail.com>
X-Priority: 3
X-GUID: 5C0D9E54-6F82-4349-80B9-7DF832FCB95A
X-Has-Attach: no
MIME-Version: 1.0
Message-ID: <202109202028152977817@linux.dev>
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: base64
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTrCoENvbmcgV2FuZwpEYXRlOsKgMjAyMS0wOS0yMMKgMDc6NTIKVG86wqBZYWp1biBEZW5n
CkNDOsKgSmFrdWIgS2ljaW5za2k7IERhdmlkIE1pbGxlcjsgTGludXggS2VybmVsIE5ldHdvcmsg
RGV2ZWxvcGVyczsgTEtNTApTdWJqZWN0OsKgUmU6IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBzb2Nr
ZXQ6IGFkZCB0aGUgY2FzZSBzb2NrX25vX3h4eCBzdXBwb3J0Ck9uIFNhdCwgU2VwIDE4LCAyMDIx
IGF0IDU6MTEgQU0gPHlhanVuLmRlbmdAbGludXguZGV2PiB3cm90ZToKPgo+IFNlcHRlbWJlciAx
OCwgMjAyMSA5OjMzIEFNLCAiSmFrdWIgS2ljaW5za2kiIDxrdWJhQGtlcm5lbC5vcmc+IHdyb3Rl
Ogo+Cj4gPiBPbiBUaHUsIDE2IFNlcCAyMDIxIDIwOjI5OjQzICswODAwIFlhanVuIERlbmcgd3Jv
dGU6Cj4gPgo+ID4+IFRob3NlIHNvY2tfbm9fe21tYXAsIHNvY2tldHBhaXIsIGxpc3RlbiwgYWNj
ZXB0LCBjb25uZWN0LCBzaHV0ZG93biwKPiA+PiBzZW5kcGFnZX0gZnVuY3Rpb25zIGFyZSB1c2Vk
IG1hbnkgdGltZXMgaW4gc3RydWN0IHByb3RvX29wcywgYnV0IHRoZXkgYXJlCj4gPj4gbWVhbmlu
Z2xlc3MuIFNvIHdlIGNhbiBhZGQgdGhlbSBzdXBwb3J0IGluIHNvY2tldCBhbmQgZGVsZXRlIHRo
ZW0gaW4gc3RydWN0Cj4gPj4gcHJvdG9fb3BzLgo+ID4KPiA+IFNvIHRoZSByZWFzb24gdG8gZG8g
dGhpcyBpcy4uIHdoYXQgZXhhY3RseT8KPiA+Cj4gPiBSZW1vdmluZyBhIGNvdXBsZSBlbXB0eSBo
ZWxwZXJzICh3aGljaCBpcyBub3QgZXZlbiBwYXJ0IG9mIHRoaXMgcGF0Y2gpPwo+ID4KPiA+IEkn
bSBub3Qgc29sZCwgc29ycnkuCj4KPiBXaGVuIHdlIGRlZmluZSBhIHN0cnVjdCBwcm90b19vcHMg
eHh4LCB3ZSBvbmx5IG5lZWQgdG8gYXNzaWduIG1lYW5pbmdmdWwgbWVtYmVyIHZhcmlhYmxlcyB0
aGF0IHdlIG5lZWQuCj4gVGhvc2Uge21tYXAsIHNvY2tldHBhaXIsIGxpc3RlbiwgYWNjZXB0LCBj
b25uZWN0LCBzaHV0ZG93biwgc2VuZHBhZ2V9IG1lbWJlcnMgd2UgZG9uJ3QgbmVlZCBhc3NpZ24K
PiBpdCBpZiB3ZSBkb24ndCBuZWVkLiBXZSBqdXN0IG5lZWQgZG8gb25jZSBpbiBzb2NrZXQsIG5v
dCBpbiBldmVyeSBzdHJ1Y3QgcHJvdG9fb3BzLgo+Cj4gVGhlc2UgbWVtYmVycyBhcmUgYXNzaWdu
ZWQgbWVhbmluZ2xlc3MgdmFsdWVzIGZhciBtb3JlIG9mdGVuIHRoYW4gbWVhbmluZ2Z1bCBvbmVz
LCBzbyB0aGlzIHBhdGNoIEkgdXNlZCBsaWtlbHkoISFzb2NrLT5vcHMtPnh4eCkgZm9yIHRoaXMg
Y2FzZS4gVGhpcyBpcyB0aGUgcmVhc29uIHdoeSBJIHNlbmQgdGhpcyBwYXRjaC4KwqAKQnV0IHlv
dSBlbmQgdXAgYWRkaW5nIG1vcmUgY29kZToKwqAKMSBmaWxlIGNoYW5nZWQsIDU4IGluc2VydGlv
bnMoKyksIDEzIGRlbGV0aW9ucygtKSAKClllc++8jFRoaXMgd291bGQgYWRkIG1vcmUgY29kZSzC
oGJ1dCB0aGlzIGlzIGF0IHRoZSBjb3N0IG9mIHJlZHVjaW5nIG90aGVyIGNvZGVzLsKgQXQgdGhl
IHNhbWUgdGltZSwgdGhlIGNvZGUgd2lsbCBvbmx5IHJ1biDCoGxpa2VseSghc29jay0+b3BzLT54
eHgpIGluIG1vc3QgY2FzZXMuIMKgRG9u4oCZdCB5b3UgdGhpbmsgdGhhdCB0aGlzIGtpbmQgb2Yg
bWVhbmluZ2xlc3MgdGhpbmcgc2hvdWxkbuKAmXQgYmUgZG9uZSBieSBzb2NrZXQ/CsKgCkkgZG9u
J3Qgc2VlIHRoaXMgYXMgYSBnYWluIGZyb20gYW55IHBlcnNwZWN0aXZlLgrCoApUaGFua3Mu

