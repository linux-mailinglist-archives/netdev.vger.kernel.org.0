Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7F41665AB
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgBTSAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 13:00:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbgBTSAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 13:00:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 908F1104D1AAA;
        Thu, 20 Feb 2020 10:00:34 -0800 (PST)
Date:   Thu, 20 Feb 2020 10:00:32 -0800 (PST)
Message-Id: <20200220.100032.1712605490922863986.davem@davemloft.net>
To:     keescook@chromium.org
Cc:     kuba@kernel.org, glider@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: Distribute switch variables for
 initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220062304.68942-1-keescook@chromium.org>
References: <20200220062304.68942-1-keescook@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 10:00:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+DQpEYXRlOiBXZWQsIDE5IEZl
YiAyMDIwIDIyOjIzOjA0IC0wODAwDQoNCj4gVmFyaWFibGVzIGRlY2xhcmVkIGluIGEgc3dpdGNo
IHN0YXRlbWVudCBiZWZvcmUgYW55IGNhc2Ugc3RhdGVtZW50cw0KPiBjYW5ub3QgYmUgYXV0b21h
dGljYWxseSBpbml0aWFsaXplZCB3aXRoIGNvbXBpbGVyIGluc3RydW1lbnRhdGlvbiAoYXMNCj4g
dGhleSBhcmUgbm90IHBhcnQgb2YgYW55IGV4ZWN1dGlvbiBmbG93KS4gV2l0aCBHQ0MncyBwcm9w
b3NlZCBhdXRvbWF0aWMNCj4gc3RhY2sgdmFyaWFibGUgaW5pdGlhbGl6YXRpb24gZmVhdHVyZSwg
dGhpcyB0cmlnZ2VycyBhIHdhcm5pbmcgKGFuZCB0aGV5DQo+IGRvbid0IGdldCBpbml0aWFsaXpl
ZCkuIENsYW5nJ3MgYXV0b21hdGljIHN0YWNrIHZhcmlhYmxlIGluaXRpYWxpemF0aW9uDQo+ICh2
aWEgQ09ORklHX0lOSVRfU1RBQ0tfQUxMPXkpIGRvZXNuJ3QgdGhyb3cgYSB3YXJuaW5nLCBidXQg
aXQgYWxzbw0KPiBkb2Vzbid0IGluaXRpYWxpemUgc3VjaCB2YXJpYWJsZXNbMV0uIE5vdGUgdGhh
dCB0aGVzZSB3YXJuaW5ncyAob3Igc2lsZW50DQo+IHNraXBwaW5nKSBoYXBwZW4gYmVmb3JlIHRo
ZSBkZWFkLXN0b3JlIGVsaW1pbmF0aW9uIG9wdGltaXphdGlvbiBwaGFzZSwNCj4gc28gZXZlbiB3
aGVuIHRoZSBhdXRvbWF0aWMgaW5pdGlhbGl6YXRpb25zIGFyZSBsYXRlciBlbGlkZWQgaW4gZmF2
b3Igb2YNCj4gZGlyZWN0IGluaXRpYWxpemF0aW9ucywgdGhlIHdhcm5pbmdzIHJlbWFpbi4NCj4g
DQo+IFRvIGF2b2lkIHRoZXNlIHByb2JsZW1zLCBtb3ZlIHN1Y2ggdmFyaWFibGVzIGludG8gdGhl
ICJjYXNlIiB3aGVyZQ0KPiB0aGV5J3JlIHVzZWQgb3IgbGlmdCB0aGVtIHVwIGludG8gdGhlIG1h
aW4gZnVuY3Rpb24gYm9keS4NCj4gDQo+IG5ldC9jb3JlL3NrYnVmZi5jOiBJbiBmdW5jdGlvbiCh
c2tiX2NoZWNrc3VtX3NldHVwX2lwojoNCj4gbmV0L2NvcmUvc2tidWZmLmM6NDgwOTo3OiB3YXJu
aW5nOiBzdGF0ZW1lbnQgd2lsbCBuZXZlciBiZSBleGVjdXRlZCBbLVdzd2l0Y2gtdW5yZWFjaGFi
bGVdDQo+ICA0ODA5IHwgICBpbnQgZXJyOw0KPiAgICAgICB8ICAgICAgIF5+fg0KPiANCj4gWzFd
IGh0dHBzOi8vYnVncy5sbHZtLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9NDQ5MTYNCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IEtlZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPg0KDQpBcHBsaWVkLg0K
