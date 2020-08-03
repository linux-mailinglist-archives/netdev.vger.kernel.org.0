Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D2F23AFFF
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgHCWKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCWKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:10:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA6EC06174A;
        Mon,  3 Aug 2020 15:10:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95F0712771D66;
        Mon,  3 Aug 2020 14:53:53 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:10:38 -0700 (PDT)
Message-Id: <20200803.151038.440269686968773655.davem@davemloft.net>
To:     yepeilin.cs@gmail.com
Cc:     pshelar@ovn.org, kuba@kernel.org, dan.carpenter@oracle.com,
        arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] openvswitch: Prevent
 kernel-infoleak in ovs_ct_put_key()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731044838.213975-1-yepeilin.cs@gmail.com>
References: <20200731044838.213975-1-yepeilin.cs@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 14:53:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>
Date: Fri, 31 Jul 2020 00:48:38 -0400

> ovs_ct_put_key() is potentially copying uninitialized kernel stack memory
> into socket buffers, since the compiler may leave a 3-byte hole at the end
> of `struct ovs_key_ct_tuple_ipv4` and `struct ovs_key_ct_tuple_ipv6`. Fix
> it by initializing `orig` with memset().
> 
> Cc: stable@vger.kernel.org

Please don't CC: stable for networking fixes.

> Fixes: 9dd7f8907c37 ("openvswitch: Add original direction conntrack tuple to sw_flow_key.")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>

Applied and queued up for -stable, thank you.
