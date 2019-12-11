Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155AE11A06F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfLKBXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:23:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51028 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLKBXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:23:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B8E015037605;
        Tue, 10 Dec 2019 17:23:46 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:23:45 -0800 (PST)
Message-Id: <20191210.172345.1443717103734845249.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/14] Add support for SFP+ copper modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209151553.GP25745@shell.armlinux.org.uk>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 17:23:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4IGFkbWluIDxsaW51eEBhcm1saW51eC5vcmcu
dWs+DQpEYXRlOiBNb24sIDkgRGVjIDIwMTkgMTU6MTU6NTMgKzAwMDANCg0KPiBUaGlzIHNlcmll
cyBhZGRzIHN1cHBvcnQgZm9yIENvcHBlciBTRlArIG1vZHVsZXMgd2l0aCBDbGF1c2UgNDUgUEhZ
cy4NCj4gU3BlY2lmaWNhbGx5IHRoZSBwYXRjaGVzOg0KDQpUaGlzIHNlcmllcyBuZWVkcyBzb21l
IHdvcmsgYWN0dWFsbHk6DQoNCjEpIFBhdGNoICM2IGFkZHMgdGhlIGZvbGxvd2luZyB3YXJuaW5n
Og0KDQpkcml2ZXJzL25ldC9waHkvcGh5bGluay5jOiBJbiBmdW5jdGlvbiChcGh5bGlua19hdHRh
Y2hfcGh5ojoNCmRyaXZlcnMvbmV0L3BoeS9waHlsaW5rLmM6NzcwOjY6IHdhcm5pbmc6IHVudXNl
ZCB2YXJpYWJsZSChcmV0oiBbLVd1bnVzZWQtdmFyaWFibGVdDQoNCjIpIFBhdGNoICMxMSBhZGRz
IGEgcmVmZXJlbmNlIHRvIE1MX0FOX0lOQkFORCB3aGljaCBicmVha3MgdGhlIGJ1aWxkOg0KDQpk
cml2ZXJzL25ldC9waHkvcGh5bGluay5jOiBJbiBmdW5jdGlvbiChcGh5bGlua19zZnBfY29ubmVj
dF9waHmiOg0KZHJpdmVycy9uZXQvcGh5L3BoeWxpbmsuYzoxODU2OjMxOiBlcnJvcjogoU1MX0FO
X0lOQkFORKIgdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pOyBkaWQgeW91
IG1lYW4goU1MT19BTl9JTkJBTkSiPw0KICByZXQgPSBwaHlsaW5rX3NmcF9jb25maWcocGwsIE1M
X0FOX0lOQkFORCwgcGh5LT5zdXBwb3J0ZWQsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgXn5+fn5+fn5+fn5+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTUxPX0FOX0lO
QkFORA0KDQozKSBQYXRjaCAjMTIgcmVtb3ZlcyB0aGlzIGxpbmUuDQoNClBsZWFzZSBmaXggdGhl
IHdhcm5pbmcgYW5kIG1ha2UgdGhpcyBwYXRjaCBzZXJpZXMgcHJvcGVybHkgYmlzZWN0YWJsZS4N
Cg0KWW91IGhhdmUgYWxsIHRoZSBBQ0tzLCBzbyBvbmNlIHRoaXMgaXMgZml4ZWQgdXAgSSdsbCBh
cHBseSBpdC4NCg0KVGhhbmtzLg0K
