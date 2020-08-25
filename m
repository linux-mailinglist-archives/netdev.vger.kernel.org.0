Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA324251B03
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgHYOkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 10:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHYOkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 10:40:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC0CC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 07:40:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91123133F3221;
        Tue, 25 Aug 2020 07:23:32 -0700 (PDT)
Date:   Tue, 25 Aug 2020 07:40:15 -0700 (PDT)
Message-Id: <20200825.074015.165950235545895585.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH v1] net: phy: leds: Deduplicate link LED trigger
 registration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824170904.60832-1-andriy.shevchenko@linux.intel.com>
References: <20200824170904.60832-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 07:23:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5keSBTaGV2Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+
DQpEYXRlOiBNb24sIDI0IEF1ZyAyMDIwIDIwOjA5OjA0ICswMzAwDQoNCj4gUmVmYWN0b3IgcGh5
X2xlZF90cmlnZ2VyX3JlZ2lzdGVyKCkgYW5kIGRlZHVwbGljYXRlIGl0cyBmdW5jdGlvbmFsaXR5
DQo+IHdoZW4gcmVnaXN0ZXJpbmcgTEVEIHRyaWdnZXIgZm9yIGxpbmsuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNv
bT4NCg0KVGhpcyBkb2Vzbid0IGNvbXBpbGU6DQoNCiAgQ0MgW01dICBkcml2ZXJzL25ldC9waHkv
cGh5X2xlZF90cmlnZ2Vycy5vDQpkcml2ZXJzL25ldC9waHkvcGh5X2xlZF90cmlnZ2Vycy5jOiBJ
biBmdW5jdGlvbiChcGh5X2xlZF90cmlnZ2Vyc19yZWdpc3RlcqI6DQpkcml2ZXJzL25ldC9waHkv
cGh5X2xlZF90cmlnZ2Vycy5jOjEwMjozODogZXJyb3I6IHBhc3NpbmcgYXJndW1lbnQgMiBvZiCh
cGh5X2xlZF90cmlnZ2VyX3JlZ2lzdGVyoiBmcm9tIGluY29tcGF0aWJsZSBwb2ludGVyIHR5cGUg
Wy1XZXJyb3I9aW5jb21wYXRpYmxlLXBvaW50ZXItdHlwZXNdDQogIDEwMiB8ICBlcnIgPSBwaHlf
bGVkX3RyaWdnZXJfcmVnaXN0ZXIocGh5LCAmcGh5LT5sZWRfbGlua190cmlnZ2VyLCAwLCAibGlu
ayIpOw0KICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+
fn5+fn5+fn5+fn5+fn5+fg0KICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfA0KICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3Ry
dWN0IHBoeV9sZWRfdHJpZ2dlciAqKg0KZHJpdmVycy9uZXQvcGh5L3BoeV9sZWRfdHJpZ2dlcnMu
Yzo2ODozMzogbm90ZTogZXhwZWN0ZWQgoXN0cnVjdCBwaHlfbGVkX3RyaWdnZXIgKqIgYnV0IGFy
Z3VtZW50IGlzIG9mIHR5cGUgoXN0cnVjdCBwaHlfbGVkX3RyaWdnZXIgKiqiDQogICA2OCB8ICAg
ICAgICAgc3RydWN0IHBoeV9sZWRfdHJpZ2dlciAqcGx0LA0KICAgICAgfCAgICAgICAgIH5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fl5+fg0KDQo=
