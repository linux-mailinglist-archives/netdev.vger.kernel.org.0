Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE912FDF8
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgACUdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:33:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47150 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbgACUdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:33:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F8E41569D361;
        Fri,  3 Jan 2020 12:33:14 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:33:13 -0800 (PST)
Message-Id: <20200103.123313.205020922142036843.davem@davemloft.net>
To:     yukuai3@huawei.com
Cc:     netanel@amazon.com, saeedb@amazon.com, zorik@amazon.com,
        ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com, sameehj@amazon.com,
        akiyano@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        yi.zhang@huawei.com, zhengbin13@huawei.com
Subject: Re: [PATCH] net: ena: remove set but not used variable 'rx_ring'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103120701.47681-1-yukuai3@huawei.com>
References: <20200103120701.47681-1-yukuai3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:33:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogeXUga3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPg0KRGF0ZTogRnJpLCAzIEphbiAyMDIw
IDIwOjA3OjAxICswODAwDQoNCj4gRml4ZXMgZ2NjICctV3VudXNlZC1idXQtc2V0LXZhcmlhYmxl
JyB3YXJuaW5nOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0
ZGV2LmM6IEluIGZ1bmN0aW9uDQo+IKFlbmFfeGRwX3htaXRfYnVmZqI6DQo+IGRyaXZlcnMvbmV0
L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5jOjMxNjoxOTogd2FybmluZzoNCj4gdmFy
aWFibGUgoXJ4X3JpbmeiIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFi
bGVdDQo+IA0KPiBJdCBpcyBuZXZlciB1c2VkLCBhbmQgc28gY2FuIGJlIHJlbW92ZWQuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiB5dSBrdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+DQoNCkRvZXMgbm90
IGFwcGx5IHRvIG5ldC1uZXh0Lg0K
