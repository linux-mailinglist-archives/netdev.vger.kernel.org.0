Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2533D130AA4
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 00:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgAEXFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 18:05:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgAEXFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 18:05:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 998751570D619;
        Sun,  5 Jan 2020 15:05:00 -0800 (PST)
Date:   Sun, 05 Jan 2020 15:05:00 -0800 (PST)
Message-Id: <20200105.150500.172694135797427206.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, linux@armlinux.org.uk,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v4 net-next 0/9] Convert Felix DSA switch to PHYLINK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200105.145620.1374612953471751229.davem@davemloft.net>
References: <20200103200127.6331-1-olteanv@gmail.com>
        <20200105.145620.1374612953471751229.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 15:05:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogU3VuLCAwNSBK
YW4gMjAyMCAxNDo1NjoyMCAtMDgwMCAoUFNUKQ0KDQo+IEZyb206IFZsYWRpbWlyIE9sdGVhbiA8
b2x0ZWFudkBnbWFpbC5jb20+DQo+IERhdGU6IEZyaSwgIDMgSmFuIDIwMjAgMjI6MDE6MTggKzAy
MDANCj4gDQo+PiBVbmxpa2UgbW9zdCBvdGhlciBjb252ZXJzaW9ucywgdGhpcyBvbmUgaXMgbm90
IGJ5IGZhciBhIHRyaXZpYWwgb25lLCBhbmQgc2hvdWxkDQo+PiBiZSBzZWVuIGFzICJMYXllcnNj
YXBlIFBDUyBtZWV0cyBQSFlMSU5LIi4gQWN0dWFsbHksIHRoZSBQQ1MgZG9lc24ndA0KPj4gbmVl
ZCBhIGxvdCBvZiBoYW5kLWhvbGRpbmcgYW5kIG1vc3Qgb2Ygb3VyIG90aGVyIGRldmljZXMgJ2p1
c3Qgd29yaycNCj4+ICh0aGlzIG9uZSBpbmNsdWRlZCkgd2l0aG91dCBhbnkgc29ydCBvZiBvcGVy
YXRpbmcgc3lzdGVtIGF3YXJlbmVzcywganVzdA0KPj4gYW4gaW5pdGlhbGl6YXRpb24gcHJvY2Vk
dXJlIGRvbmUgdHlwaWNhbGx5IGluIHRoZSBib290bG9hZGVyLg0KPj4gT3VyIGlzc3VlcyBzdGFy
dCB3aGVuIHRoZSBQQ1Mgc3RvcHMgZnJvbSAianVzdCB3b3JraW5nIiwgYW5kIHRoYXQgaXMNCj4+
IHdoZXJlIFBIWUxJTksgY29tZXMgaW4gaGFuZHkuDQo+PiANCj4+IFRoZSBQQ1MgaXMgbm90IHNw
ZWNpZmljIHRvIHRoZSBWaXRlc3NlIC8gTWljcm9zZW1pIC8gTWljcm9jaGlwIHN3aXRjaGluZyBj
b3JlDQo+PiBhdCBhbGwuIFZhcmlhdGlvbnMgb2YgdGhpcyBTZXJEZXMvUENTIGRlc2lnbiBjYW4g
YWxzbyBiZSBmb3VuZCBvbiBEUEFBMSBhbmQNCj4+IERQQUEyIGhhcmR3YXJlLg0KPj4gDQo+PiBU
aGUgbWFpbiBpZGVhIG9mIHRoZSBhYnN0cmFjdGlvbiBwcm92aWRlZCBpcyB0aGF0IHRoZSBQQ1Mg
bG9va3Mgc28gbXVjaCBsaWtlIGENCj4+IFBIWSBkZXZpY2UsIHRoYXQgd2UgbW9kZWwgaXQgYXMg
YW4gYWN0dWFsIFBIWSBkZXZpY2UgYW5kIHJ1biB0aGUgZ2VuZXJpYyBQSFkNCj4+IGZ1bmN0aW9u
cyBvbiBpdCwgd2hlcmUgYXBwcm9wcmlhdGUuDQo+ICAuLi4NCj4gDQo+IFNlcmllcyBhcHBsaWVk
LCBwbGVhc2UgYWRkcmVzcyBhbnkgZm9sbG93LXVwIGZlZWRiYWNrIHlvdSByZWNlaXZlLg0KDQpB
Y3R1YWxseSBJIHJldmVydGVkLCBwbGVhc2UgZml4IHRoaXMgd2FybmluZyBhbmQgcmVzdWJtaXQ6
DQoNCmRyaXZlcnMvbmV0L2RzYS9vY2Vsb3QvZmVsaXguYzogSW4gZnVuY3Rpb24goWZlbGl4X3Bo
eWxpbmtfbWFjX2NvbmZpZ6I6DQpkcml2ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4LmM6MjEwOjIy
OiB3YXJuaW5nOiB1bnVzZWQgdmFyaWFibGUgoW9jZWxvdF9wb3J0oiBbLVd1bnVzZWQtdmFyaWFi
bGVdDQogIHN0cnVjdCBvY2Vsb3RfcG9ydCAqb2NlbG90X3BvcnQgPSBvY2Vsb3QtPnBvcnRzW3Bv
cnRdOw0KICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+DQoNClRoYW5rIHlvdS4NCg==
