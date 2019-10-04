Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC07CC5A5
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 00:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbfJDWKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 18:10:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJDWKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 18:10:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0787814A6FD41;
        Fri,  4 Oct 2019 15:10:37 -0700 (PDT)
Date:   Fri, 04 Oct 2019 15:10:37 -0700 (PDT)
Message-Id: <20191004.151037.207929699391829769.davem@davemloft.net>
To:     austindh.kim@gmail.com
Cc:     romieu@fr.zoreil.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/velocity: fix -Wunused-but-set-variable warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191004045203.GA124692@LGEARND20B15>
References: <20191004045203.GA124692@LGEARND20B15>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 15:10:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQXVzdGluIEtpbSA8YXVzdGluZGgua2ltQGdtYWlsLmNvbT4NCkRhdGU6IEZyaSwgNCBP
Y3QgMjAxOSAxMzo1MjowMyArMDkwMA0KDQo+ICdjdXJyX3N0YXR1cycgaXMgZGVjbGFyZWQgYXMg
dTMyLg0KPiBCdXQgdGhpcyB2YXJpYWJsZSBpcyBub3QgdXNlZCBhZnRlciBiZWxvdyBzdGF0ZW1l
bnQuDQo+ICAgIGN1cnJfc3RhdHVzID0gdnB0ci0+bWlpX3N0YXR1cyAmICh+VkVMT0NJVFlfTElO
S19GQUlMKTsNCj4gDQo+IFRoaXMgdmFyaWFibGUgY291bGQgYmUgZHJvcHBlZCB0byBtdXRlIGJl
bG93IHdhcm5pbmcgbWVzc2FnZToNCj4gDQo+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L3ZpYS92
aWEtdmVsb2NpdHkuYzo4Njg6NjoNCj4gICAgd2FybmluZzogdmFyaWFibGUgoWN1cnJfc3RhdHVz
oiBzZXQgYnV0IG5vdCB1c2VkIA0KPiAgICBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEF1c3RpbiBLaW0gPGF1c3RpbmRoLmtpbUBnbWFpbC5jb20+DQoN
ClBsZWFzZSBkb24ndCBtYWtlIHRoZXNlIGNoYW5nZXMgbGlrZSBhIHJvYm90Lg0KDQpBbHdheXMg
bG9vayBhdCB0aGUgc3Vycm91bmRpbmcgY29udGV4dCBhbmQgZXZlbiB0aGUgaGlzdG9yeSBvZiBo
b3cNCnRoaXMgcGllY2Ugb2YgY29kZSBnb3QgaGVyZSBieSB1c2luZyBnaXQgYmxhbWUgYW5kIG90
aGVyIHRvb2xzLg0KDQpUaGVyZSBpcyBhIGNvbW1lbnQgcmlnaHQgdW5kZXIgdGhpcyB2YXJpYWJs
ZSBhc3NpZ25tZW50IHJlZmVycmluZyB0bw0KdGhlIHZhcmlhYmxlLiAgU28gaWYgeW91IHJlbW92
ZSB0aGUgdmFyaWFibGUsIHlvdSBzaG91bGQgZG8gc29tZXRoaW5nDQp3aXRoIHRoZSBjb21tZW50
IGFzIHdlbGwuDQoNClRoYW5rIHlvdS4NCg==
