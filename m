Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621661F7E4A
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 23:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgFLVFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 17:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLVFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 17:05:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AA7C03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 14:05:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8EA6127AF92E;
        Fri, 12 Jun 2020 14:05:48 -0700 (PDT)
Date:   Fri, 12 Jun 2020 14:05:46 -0700 (PDT)
Message-Id: <20200612.140546.1983874454111631141.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org
Subject: Re: [Patch net] genetlink: clean up family attributes allocations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200612071655.8009-1-xiyou.wangcong@gmail.com>
References: <20200612071655.8009-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jun 2020 14:05:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Fri, 12 Jun 2020 00:16:55 -0700

> genl_family_rcv_msg_attrs_parse() and genl_family_rcv_msg_attrs_free()
> take a boolean parameter to determine whether allocate/free the family
> attrs. This is unnecessary as we can just check family->parallel_ops.
> More importantly, callers would not need to worry about pairing these
> parameters correctly after this patch.
> 
> And this fixes a memory leak, as after commit c36f05559104
> ("genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()")
> we call genl_family_rcv_msg_attrs_parse() for both parallel and
> non-parallel cases.
> 
> Fixes: c36f05559104 ("genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thanks Cong.
