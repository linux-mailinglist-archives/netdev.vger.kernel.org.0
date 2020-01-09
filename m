Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB63F135C29
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731914AbgAIPDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:03:31 -0500
Received: from mout.gmx.net ([212.227.17.21]:36029 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbgAIPDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 10:03:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578582206;
        bh=BYSwQo9OeOTJJYOfjIqj0N8dQo/5jQ+jLdUqVu6Jn+M=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=bWtZP/hff/QNrt/2FIquy11UIjPn61H1HP2PywgGsne17m2LuSb14+KrzUFWWAQ1m
         ivhcf7N9Pc0zB85wThIUFHLjc+548aMOkNx8uKaQx8mX1Iup8Ijea6QxdcbL5RfKnf
         hzA4DzuYG3HdbteYCiy62MmZ6aThaUbdAxeKANJk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([31.29.59.61]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MkHQX-1jZfim1rSL-00kk6e; Thu, 09
 Jan 2020 16:03:25 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc:     netdev@vger.kernel.org
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
Date:   Thu, 9 Jan 2020 15:03:24 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200109144106.GA24459@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: base64
Content-Language: en-GB
X-Provags-ID: V03:K1:DjkX+xO1S7ZkylrIxJn599zgAPn2/q8aQMiejGsMa3BJRNNC534
 9HvQZKqGr9PZF+c/Ni/0PWkrqqCljkWEFfPEmlkBrUxakHBaSmhLaJDtw4jR3+i98h9N81A
 nqg5A7UZQkUeuWdL4L7P2cjNklAz9UbtOu/BOXFWv61dFrgJJB54z6emNf4Q1bpXjpNskcr
 /UCfi29RvnzZhH4Dobyuw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ipqOSXO2its=:ds3+M3v0RiGq745xhEPFOe
 2VmRTbzlEIuaoNXDcYmDrUMTSysAyjtivVwWE4t3egsppDFEbtyNYmjALqE8w4ywRdjJEozjz
 SceKJCVtk3UP8AqXBVxQBhWV0ugxdn4gp5mPQ/T+9/RsAA1yhnJqUAiygVQehTJGrE9Smu0aI
 eqpy8POLBDTnE6twob5DYmtk7gV19XcKLj6jZvY6O/vZDAN5/3swxTDpTD1O6i99QFSGfX3Y2
 9dw1esCnQQFPuOFm2UFAHLf7VYaZdUahW8sElDpHd6LWqGzCOHTGsLo2P75LWLvTminoLeePm
 hIraXsenzNP3E/oFgjIrBdmJXpnczXDeWR+qrPMnYi10c8sTXAjSdHdW/EqvFJF9PdHf0ibDB
 ACaVD+Tyliom3Czkr5/B/nw/7LyF1xYCAluV8cvHN7YpfcQdqBM+fEqKip5kpLe1ifIi/LlPf
 2yyg+r0lfvFNMk9PirbnA62QFlyHGp80iGY5Y6sfTPNzKw/l3oJfyBgkLZzmgBQvwKvBIk+1G
 qERYXGdnz4Gfr8kHucgJXyQ1+DCZ9aN00cOKk1tUH2wKYuQ0EO3vtaau0aEiUJLfXnNc0m0gc
 8Olbpg6uNXmZkMV474VlTGt+nVB4kwnw/VujJwD8+V8ah75CfDNzNiiaFJzELkrFI+XJAX3Wn
 /f/cAMKO5loilgDU4CeUIKATX3Zr103MTDBKOSsmY3L6MSBNey5pXzOX+8I5qRK1rD6W3rpY3
 F9lKYoYNyAm9tC5fQCUHWFbFzOuJ561MmhifkVotbaMxlsm+L7xlesobtabvdVZ9Y5UwGS1mU
 cNhHg6N0G/bg+uT3D9rqtHJzxZGyHmWh3xRSn6MtH+5sWVWFjg6hbXsA1/U99TncimhobDybY
 gOUwhR3cfj/HFIDJxMgblWI0iwoSIXIEaPXMgfADcMjSJk11SOLnbWFjXLaILZ+siJwg2jMr2
 2DVoEPcZsvQLL2Lo5QuHO9vtxyjjeLOXVwbqocOXDQbs2ao5XgCFBe04zpzLmtarN4TqfKDBK
 weDglT60sfpVxGIqk1AdVNTQfjFwIRLdLLq5wOsF5wuZj1DfAvD/WMyABgC23PX7/Rm8vvqG9
 u/WKsnRHNZG9Il4gy6hTi2nNpQpOEZu13Pb48M6vXNXT7uh3l4mzyXmcyNX1UlPPUXyFM87kS
 rWW89ZYJAs9WBReOns7uw+e4lw2Ub5U6I4uhC//mF6So1Qg5XqdkAKBhNSQqS6088MQPIpNMy
 V2cVGvAaA+F5TbR1qrGE7VjyS9M5wE8nFpl5ZKg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDkvMDEvMjAyMCAxNDo0MSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IE9uIFRodSwgSmFu
IDA5LCAyMDIwIGF0IDAxOjQ3OjMxUE0gKzAwMDAsING90onhtqzhuLPihKAgd3JvdGU6DQo+
PiBPbiBub2RlIHdpdGggNC4xOS45MyBhbmQgYSBTRlAgbW9kdWxlIChzcGVjcyBhdCB0aGUg
Ym90dG9tKSB0aGUgZm9sbG93aW5nIGlzDQo+PiBpbnRlcm1pdHRlbnRseSBvYnNlcnZlZDoN
Cj4gUGxlYXNlIG1ha2Ugc3VyZSBSdXNzZWxsIEtpbmcgaXMgaW4gQ2M6IGZvciBTRlAgaXNz
dWVzLg0KPg0KPiBUaGUgc3RhdGUgbWFjaGluZSBoYXMgYmVlbiByZXdvcmtlZCByZWNlbnRs
eS4gUGxlYXNlIGNvdWxkIHlvdSB0cnkNCj4gbmV0LW5leHQsIG9yIDUuNS1yYzUuDQo+DQo+
IFRoYW5rcw0KPiAJQW5kcmV3DQpVbmZvcnR1bmF0ZWx5IHRlc3RpbmcgdGhvc2UgYnJhbmNo
ZXMgaXMgbm90IGZlYXNpYmxlIHNpbmNlIHRoZSByb3V0ZXIgDQooc2VlIGFyY2hpdGVjdHVy
ZSBiZWxvdykgdGhhdCBob3N0IHRoZSBTRlAgbW9kdWxlIGRlcGxveXMgdGhlIE9wZW5XcnQg
DQpkb3duc3RyZWFtIGRpc3RybyB3aXRoIExUUyBrZXJuZWxzIC0gaW4gdGhlaXIgTWFzdGVy
IGRldmVsb3BtZW50IGJyYW5jaCANCjQuMTkuOTMgYmVpbmcgdGhlIG1vc3QgcmVjZW50IG9u
IG9mZmVyLg0KDQpDb3VsZCB0aGUgcmV3b3JrZWQgc3RhdGUgbWFjaGluZSBjb2RlIGNvbW1p
dHMgYmUgZGVwbG95ZWQgYXMgcGF0Y2hlcyANCndpdGggNC4xOSBrZXJuZWwsIGFuZCBpZiBz
byB3aGljaCBjb21taXRzIHdvdWxkIHRoYXQgYmU/DQpPciwgaWYgbm90IHdpbGwgdGhvc2Ug
Y29tbWl0cyBldmVudHVhbGx5IHJpZGUgdGhlIHRyYWlucyB0byB0aGUgTFRTIA0KYnJhbmNo
ZXMgYW5kIHdoYXQgd291bGQgYmUgdGhlIGV4cGVjdGVkIHRpbWUgZnJhbWUgZm9yIHN1Y2gg
dXBsaWZ0Pw0KDQpUaGUgcHJvYmxlbSBpcyB3aXRoIHRob3NlIGZhaWxpbmcgc3RhdGUgbWFj
aGluZSBjaGVja3MgaXMgYW4gDQppbmNvbnZlbmllbnQgZGlzcnVwdGlvbiBpbiB0aGUgbm9k
ZSdzIFdBTiBjb25uZWN0aXZpdHksIG9mdGVuIG5lZWRpbmcgdG8gDQpyZWJvb3QgdGhlIG5v
ZGUgdG8gZ2V0IHRoZSBjb25uZWN0aXZpdHkgcmVpbnN0YXRlZC4NCg0KTm90IHN1cmUgd2hl
dGhlciBwZXJ0aW5lbnQgYXQgYWxsIChha2EgYmVpbmcgY2x1ZWxlc3MpIGJ1dCBub3RpY2Vk
IHRoYXQgDQpmb3IgYmlnIGVuZGlhbiBzeXN0ZW1zIGEgY2hlY2sgZm9yIGFuIGludmVydGVk
IExPUyBTaWduYWwgaXMgaW1wbGVtZW50ZWQgDQpidXQgbm90IGZvciBsaXR0bGUgZW5kaWFu
IHN5c3RlbXMuDQoNCl9fXw0KQXJjaGl0ZWN0dXJlOsKgwqDCoMKgwqDCoMKgIGFybXY3bA0K
Qnl0ZSBPcmRlcjrCoMKgwqDCoMKgwqDCoMKgwqAgTGl0dGxlIEVuZGlhbg0KQ1BVKHMpOsKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDINCk9uLWxpbmUgQ1BVKHMpIGxpc3Q6IDAsMQ0K
VGhyZWFkKHMpIHBlciBjb3JlOsKgIDENCkNvcmUocykgcGVyIHNvY2tldDrCoCAyDQpTb2Nr
ZXQocyk6wqDCoMKgwqDCoMKgwqDCoMKgwqAgMQ0KVmVuZG9yIElEOsKgwqDCoMKgwqDCoMKg
wqDCoMKgIEFSTQ0KTW9kZWw6wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxDQpNb2Rl
bCBuYW1lOsKgwqDCoMKgwqDCoMKgwqDCoCBDb3J0ZXgtQTkNClN0ZXBwaW5nOsKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcjRwMQ0KQm9nb01JUFM6wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAx
NjAwLjAwDQpGbGFnczrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGhhbGYgdGh1bWIg
ZmFzdG11bHQgdmZwIGVkc3AgbmVvbiB2ZnB2MyB0bHMgdmZwZDMyDQo=
