Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094FA12FDF6
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgACUdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:33:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47132 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbgACUdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:33:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E9811569D361;
        Fri,  3 Jan 2020 12:33:07 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:33:06 -0800 (PST)
Message-Id: <20200103.123306.507399332831633367.davem@davemloft.net>
To:     yukuai3@huawei.com
Cc:     rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH] bna: remove set but not used variable 'pgoff'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103120437.46400-1-yukuai3@huawei.com>
References: <20200103120437.46400-1-yukuai3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:33:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogeXUga3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPg0KRGF0ZTogRnJpLCAzIEphbiAyMDIw
IDIwOjA0OjM3ICswODAwDQoNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvY2FkZS9ibmEvYmZh
X2lvYy5jOiBJbiBmdW5jdGlvbg0KPiChYmZhX2lvY19md3Zlcl9jbGVhcqI6DQo+IGRyaXZlcnMv
bmV0L2V0aGVybmV0L2Jyb2NhZGUvYm5hL2JmYV9pb2MuYzoxMTI3OjEzOiB3YXJuaW5nOiB2YXJp
YWJsZQ0KPiChcGdvZmaiIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFi
bGVdDQo+IA0KPiBJdCBpcyBuZXZlciB1c2VkLCBhbmQgc28gY2FuIGJlIHJlbW92ZWQuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiB5dSBrdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+DQoNCkFwcGxpZWQu
DQo=
