Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E231A5EDE0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfGCUth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:49:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfGCUtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:49:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 556FC144D4A87;
        Wed,  3 Jul 2019 13:49:36 -0700 (PDT)
Date:   Wed, 03 Jul 2019 13:49:35 -0700 (PDT)
Message-Id: <20190703.134935.540885263693556753.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Mellanox, mlx5 devlink versions query
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190703.134700.1755482990570068688.davem@davemloft.net>
References: <20190702235442.1925-1-saeedm@mellanox.com>
        <20190703.134700.1755482990570068688.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 13:49:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogV2VkLCAwMyBK
dWwgMjAxOSAxMzo0NzowMCAtMDcwMCAoUERUKQ0KDQo+IEZyb206IFNhZWVkIE1haGFtZWVkIDxz
YWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBUdWUsIDIgSnVsIDIwMTkgMjM6NTU6MDcgKzAw
MDANCj4gDQo+PiBUaGlzIGh1bWJsZSAyIHBhdGNoIHNlcmllcyBmcm9tIFNoYXkgYWRkcyB0aGUg
c3VwcG9ydCBmb3IgZGV2bGluayBmdw0KPj4gdmVyc2lvbnMgcXVlcnkgdG8gbWx4NSBkcml2ZXIu
DQo+PiANCj4+IEluIHRoZSBmaXJzdCBwYXRjaCB3ZSBpbXBsZW1lbnQgdGhlIG5lZWRlZCBmdyBj
b21tYW5kcyB0byBzdXBwb3J0IHRoaXMNCj4+IGZlYXR1cmUuDQo+PiBJbiB0aGUgMm5kIHBhdGNo
IHdlIGltcGxlbWVudCB0aGUgZGV2bGluayBjYWxsYmFja3MgdGhlbXNlbHZlcy4NCj4+IA0KPj4g
SSBhbSBub3Qgc2VuZGluZyB0aGlzIGFzIGEgcHVsbCByZXF1ZXN0IHNpbmNlIGkgYW0gbm90IHN1
cmUgd2hlbiBteSBuZXh0DQo+PiBwdWxsIHJlcXVlc3QgaXMgZ29pbmcgdG8gYmUgcmVhZHksIGFu
ZCB0aGVzZSB0d28gcGF0Y2hlcyBhcmUgc3RyYWlnaHQNCj4+IGZvcndhcmQgbmV0LW5leHQgcGF0
Y2hlcy4NCj4gDQo+IFNlcmllcyBhcHBsaWVkIHRvIG5ldC1uZXh0LCB0aGFua3MuDQoNClRoaXMg
ZG9lc24ndCBidWlsZCwgdGhlcmUgaXMgc29tZSBkZXBlbmRlbmN5Li4uDQoNCltkYXZlbUBsb2Nh
bGhvc3QgbmV0LW5leHRdJCBtYWtlIC1zIC1qMTQNCkluIGZpbGUgaW5jbHVkZWQgZnJvbSAuL2lu
Y2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaDo1MSwNCiAgICAgICAgICAgICAgICAgZnJvbSBkcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZncuYzozMzoNCmRyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mdy5jOiBJbiBmdW5jdGlvbiChbWx4NV9yZWdf
bWNxaV9xdWVyeaI6DQouL2luY2x1ZGUvbGludXgvbWx4NS9kZXZpY2UuaDo2ODozNjogZXJyb3I6
IGludmFsaWQgYXBwbGljYXRpb24gb2YgoXNpemVvZqIgdG8gaW5jb21wbGV0ZSB0eXBlIKF1bmlv
biBtbHg1X2lmY19tY3FpX3JlZ19kYXRhX2JpdHOiDQogI2RlZmluZSBNTFg1X1VOX1NaX0RXKHR5
cCkgKHNpemVvZih1bmlvbiBtbHg1X2lmY18jI3R5cCMjX2JpdHMpIC8gMzIpDQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fg0K
