Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0601E188F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388355AbgEZAtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 20:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbgEZAtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 20:49:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CBDC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 17:49:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46AF512796418;
        Mon, 25 May 2020 17:49:52 -0700 (PDT)
Date:   Mon, 25 May 2020 17:49:51 -0700 (PDT)
Message-Id: <20200525.174951.2144256991021641644.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@mellanox.com,
        benjamin.lahaise@netronome.com, tom@herbertland.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        liels@mellanox.com, ronye@mellanox.com
Subject: Re: [PATCH net-next v2 0/2] flow_dissector, cls_flower: Add
 support for multiple MPLS Label Stack Entries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525.173818.1886112260004012915.davem@davemloft.net>
References: <cover.1590081480.git.gnault@redhat.com>
        <20200525.173818.1886112260004012915.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 17:49:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogTW9uLCAyNSBN
YXkgMjAyMCAxNzozODoxOCAtMDcwMCAoUERUKQ0KDQo+IFNlcmllcyBhcHBsaWVkLCB0aGFua3Mu
DQoNClJldmVydGVkLCB0aGlzIGRvZXNuJ3QgZXZlbiBidWlsZCB3aXRoIHRoZSBvbmUgb2YgdGhl
IG1vc3QgcG9wdWxhciBkcml2ZXJzDQppbiB0aGUgdHJlZSwgbWx4NS4NCg0KZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3RjX3R1bl9tcGxzb3VkcC5jOiBJbiBmdW5j
dGlvbiChcGFyc2VfdHVubmVsojoNCmRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbi90Y190dW5fbXBsc291ZHAuYzoxMDU6NTI6IGVycm9yOiChc3RydWN0IGZsb3dfZGlz
c2VjdG9yX2tleV9tcGxzoiBoYXMgbm8gbWVtYmVyIG5hbWVkIKFtcGxzX2xhYmVsog0KICAxMDUg
fCAgICBvdXRlcl9maXJzdF9tcGxzX292ZXJfdWRwLm1wbHNfbGFiZWwsIG1hdGNoLm1hc2stPm1w
bHNfbGFiZWwpOw0KICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBefg0KLi9pbmNsdWRlL2xpbnV4L21seDUvZGV2aWNlLmg6NzQ6MTE6IG5v
dGU6IGluIGRlZmluaXRpb24gb2YgbWFjcm8goU1MWDVfU0VUog0KICAgNzQgfCAgdTMyIF92ID0g
djsgXA0KICAgICAgfCAgICAgICAgICAgXg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuL3RjX3R1bl9tcGxzb3VkcC5jOjEwNzo1MTogZXJyb3I6IKFzdHJ1Y3QgZmxv
d19kaXNzZWN0b3Jfa2V5X21wbHOiIGhhcyBubyBtZW1iZXIgbmFtZWQgoW1wbHNfbGFiZWyiDQog
IDEwNyB8ICAgIG91dGVyX2ZpcnN0X21wbHNfb3Zlcl91ZHAubXBsc19sYWJlbCwgbWF0Y2gua2V5
LT5tcGxzX2xhYmVsKTsNCiAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBefg0KLi9pbmNsdWRlL2xpbnV4L21seDUvZGV2aWNlLmg6NzQ6MTE6
IG5vdGU6IGluIGRlZmluaXRpb24gb2YgbWFjcm8goU1MWDVfU0VUog0KICAgNzQgfCAgdTMyIF92
ID0gdjsgXA0KICAgICAgfCAgICAgICAgICAgXg0K
