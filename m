Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72533699A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfFFBs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:48:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44090 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfFFBs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:48:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3831C144D4AB4;
        Wed,  5 Jun 2019 18:48:28 -0700 (PDT)
Date:   Wed, 05 Jun 2019 18:48:27 -0700 (PDT)
Message-Id: <20190605.184827.1552392791102735448.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without
 firmware
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 18:48:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUnVzc2VsbCBLaW5nIDxybWsra2VybmVsQGFybWxpbnV4Lm9yZy51az4NCkRhdGU6IFdl
ZCwgMDUgSnVuIDIwMTkgMTE6NDM6MTYgKzAxMDANCg0KPiArCSAgICAoc3RhdGUgPT0gUEhZX1VQ
IHx8IHN0YXRlID09IFBIWV9SRVNVTUlORykpIHsNCg0KZHJpdmVycy9uZXQvcGh5L21hcnZlbGwx
MGcuYzogSW4gZnVuY3Rpb24goW12MzMxMF9saW5rX2NoYW5nZV9ub3RpZnmiOg0KZHJpdmVycy9u
ZXQvcGh5L21hcnZlbGwxMGcuYzoyNjg6MzU6IGVycm9yOiChUEhZX1JFU1VNSU5HoiB1bmRlY2xh
cmVkIChmaXJzdCB1c2UgaW4gdGhpcyBmdW5jdGlvbik7IGRpZCB5b3UgbWVhbiChUlBNX1JFU1VN
SU5Hoj8NCiAgICAgIChzdGF0ZSA9PSBQSFlfVVAgfHwgc3RhdGUgPT0gUEhZX1JFU1VNSU5HKSkg
ew0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn4NCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUlBNX1JFU1VNSU5HDQpkcml2ZXJzL25ldC9w
aHkvbWFydmVsbDEwZy5jOjI2ODozNTogbm90ZTogZWFjaCB1bmRlY2xhcmVkIGlkZW50aWZpZXIg
aXMgcmVwb3J0ZWQgb25seSBvbmNlIGZvciBlYWNoIGZ1bmN0aW9uIGl0IGFwcGVhcnMgaW4NCkF0
IHRvcCBsZXZlbDoNCmRyaXZlcnMvbmV0L3BoeS9tYXJ2ZWxsMTBnLmM6MjYyOjEzOiB3YXJuaW5n
OiChbXYzMzEwX2xpbmtfY2hhbmdlX25vdGlmeaIgZGVmaW5lZCBidXQgbm90IHVzZWQgWy1XdW51
c2VkLWZ1bmN0aW9uXQ0KIHN0YXRpYyB2b2lkIG12MzMxMF9saW5rX2NoYW5nZV9ub3RpZnkoc3Ry
dWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCiAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+DQo=
