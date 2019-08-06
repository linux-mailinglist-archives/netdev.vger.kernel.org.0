Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA3B83938
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfHFS7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:59:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48218 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfHFS7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:59:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A50A61550C5D1;
        Tue,  6 Aug 2019 11:59:34 -0700 (PDT)
Date:   Tue, 06 Aug 2019 11:59:34 -0700 (PDT)
Message-Id: <20190806.115934.1807630426878001706.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        Tristram.Ha@microchip.com, vivien.didelot@gmail.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH 1/3] net: dsa: ksz: Remove dead code and fix warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806130609.29686-1-marex@denx.de>
References: <20190806130609.29686-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 11:59:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTWFyZWsgVmFzdXQgPG1hcmV4QGRlbnguZGU+DQpEYXRlOiBUdWUsICA2IEF1ZyAyMDE5
IDE1OjA2OjA3ICswMjAwDQoNCj4gUmVtb3ZlIGtzel9wb3J0X2NsZWFudXAoKSwgd2hpY2ggaXMg
dW51c2VkLiBBZGQgbWlzc2luZyBpbmNsdWRlDQo+ICJrc3pfY29tbW9uLmgiLCB3aGljaCBmaXhl
cyB0aGUgZm9sbG93aW5nIHdhcm5pbmcgd2hlbiBidWlsdCB3aXRoDQo+IG1ha2UgLi4uIFc9MQ0K
PiANCj4gZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmM6MjM6Njogd2Fybmlu
Zzogbm8gcHJldmlvdXMgcHJvdG90eXBlIGZvciChLi4uoiBbLVdtaXNzaW5nLXByb3RvdHlwZXNd
DQo+IA0KPiBOb3RlIHRoYXQgdGhlIG9yZGVyIG9mIHRoZSBoZWFkZXJzIGNhbm5vdCBiZSBzd2Fw
cGVkLCBhcyB0aGF0IHdvdWxkDQo+IHRyaWdnZXIgbWlzc2luZyBmb3J3YXJkIGRlY2xhcmF0aW9u
IGVycm9ycywgd2hpY2ggd291bGQgaW5kaWNhdGUgdGhlDQo+IHdheSBmb3J3YXJkIGlzIHRvIG1l
cmdlIHRoZSB0d28gaGVhZGVycyBpbnRvIG9uZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1hcmVr
IFZhc3V0IDxtYXJleEBkZW54LmRlPg0KDQpBcHBsaWVkLg0K
