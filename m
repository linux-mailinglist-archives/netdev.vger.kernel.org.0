Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AD89B85C
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392995AbfHWV6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:58:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38386 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390607AbfHWV6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:58:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0441D1543BD33;
        Fri, 23 Aug 2019 14:58:36 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:58:36 -0700 (PDT)
Message-Id: <20190823.145836.762276041202736875.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, nhorman@tuxdriver.com, arnd@arndb.de,
        andrew@lunn.ch, ayal@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next] drop_monitor: Make timestamps y2038 safe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190823154721.9927-1-idosch@idosch.org>
References: <20190823154721.9927-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:58:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri, 23 Aug 2019 18:47:21 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Timestamps are currently communicated to user space as 'struct
> timespec', which is not considered y2038 safe since it uses a 32-bit
> signed value for seconds.
> 
> Fix this while the API is still not part of any official kernel release
> by using 64-bit nanoseconds timestamps instead.
> 
> Fixes: ca30707dee2b ("drop_monitor: Add packet alert mode")
> Fixes: 5e58109b1ea4 ("drop_monitor: Add support for packet alert mode for hardware drops")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied, thanks Ido.
