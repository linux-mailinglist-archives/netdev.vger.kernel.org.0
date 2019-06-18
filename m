Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3808C4A768
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbfFRQqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:46:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49860 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730080AbfFRQqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:46:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BAC81506621A;
        Tue, 18 Jun 2019 09:46:01 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:46:00 -0700 (PDT)
Message-Id: <20190618.094600.427814233009639292.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v2 00/16] mlxsw: Improve IPv6 route insertion
 rate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 09:46:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 18 Jun 2019 18:12:42 +0300

> Unlike IPv4, an IPv6 multipath route in the kernel is composed from
> multiple sibling routes, each representing a single nexthop.
> 
> Therefore, an addition of a multipath route with N nexthops translates
> to N in-kernel notifications. This is inefficient for device drivers
> that need to program the route to the underlying device. Each time a new
> nexthop is appended, a new nexthop group needs to be constructed and the
> old one deleted.
> 
> This patchset improves the situation by sending a single notification
> for a multipath route addition / deletion instead of one per-nexthop.
> When adding thousands of multipath routes with 16 nexthops, I measured
> an improvement of about x10 in the insertion rate.
 ...

Series applied, thanks everyone.
