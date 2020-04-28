Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CC51BCDD3
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgD1U6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726344AbgD1U6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:58:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638FCC03C1AC;
        Tue, 28 Apr 2020 13:58:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C32C0120F52B8;
        Tue, 28 Apr 2020 13:58:31 -0700 (PDT)
Date:   Tue, 28 Apr 2020 13:58:30 -0700 (PDT)
Message-Id: <20200428.135830.274833516409783023.davem@davemloft.net>
To:     gshan@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        shan.gavin@gmail.com
Subject: Re: [PATCH v2] net/ena: Fix build warning in ena_xdp_set()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428044945.123511-1-gshan@redhat.com>
References: <20200428044945.123511-1-gshan@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 13:58:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR2F2aW4gU2hhbiA8Z3NoYW5AcmVkaGF0LmNvbT4NCkRhdGU6IFR1ZSwgMjggQXByIDIw
MjAgMTQ6NDk6NDUgKzEwMDANCg0KPiBUaGlzIGZpeGVzIHRoZSBmb2xsb3dpbmcgYnVpbGQgd2Fy
bmluZyBpbiBlbmFfeGRwX3NldCgpLCB3aGljaCBpcw0KPiBvYnNlcnZlZCBvbiBhYXJjaDY0IHdp
dGggNjRLQiBwYWdlIHNpemUuDQo+IA0KPiAgICBJbiBmaWxlIGluY2x1ZGVkIGZyb20gLi9pbmNs
dWRlL25ldC9pbmV0X3NvY2suaDoxOSwNCj4gICAgICAgZnJvbSAuL2luY2x1ZGUvbmV0L2lwLmg6
MjcsDQo+ICAgICAgIGZyb20gZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0
ZGV2LmM6NDY6DQo+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRl
di5jOiBJbiBmdW5jdGlvbiAgICAgICAgIFwNCj4gICAgoWVuYV94ZHBfc2V0ojogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiAgICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9uZXRkZXYuYzo1NTc6Njogd2FybmluZzogICAg
ICBcDQo+ICAgIGZvcm1hdCChJWx1oiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFwNCj4gICAgZXhwZWN0cyBhcmd1bWVudCBvZiB0eXBlIKFsb25n
IHVuc2lnbmVkIGludKIsIGJ1dCBhcmd1bWVudCA0ICAgICAgXA0KPiAgICBoYXMgdHlwZSChaW50
oiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+
ICAgIFstV2Zvcm1hdD1dICJGYWlsZWQgdG8gc2V0IHhkcCBwcm9ncmFtLCB0aGUgY3VycmVudCBN
VFUgKCVkKSBpcyAgIFwNCj4gICAgbGFyZ2VyIHRoYW4gdGhlIG1heGltdW0gYWxsb3dlZCBNVFUg
KCVsdSkgd2hpbGUgeGRwIGlzIG9uIiwNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEdhdmluIFNoYW4g
PGdzaGFuQHJlZGhhdC5jb20+DQo+IC0tLQ0KPiB2MjogTWFrZSBFTkFfUEFHRV9TSVpFIHRvIGJl
ICJ1bnNpZ25lZCBsb25nIiBhbmQgdmVyaWZ5IG9uIGFhcmNoNjQNCj4gICAgIHdpdGggNEtCIG9y
IDY0S0IgcGFnZSBzaXplIGNvbmZpZ3VyYXRpb24NCg0KQXBwbGllZCwgdGhhbmsgeW91Lg0K
