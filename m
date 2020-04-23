Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58931B52CD
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgDWC6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWC6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:58:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3F8C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:58:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A40CC127B3908;
        Wed, 22 Apr 2020 19:58:22 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:58:22 -0700 (PDT)
Message-Id: <20200422.195822.3861758699741605.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv4: Update fib_select_default to handle nexthop
 objects
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422214020.72107-1-dsahern@kernel.org>
References: <20200422214020.72107-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:58:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 22 Apr 2020 15:40:20 -0600

> From: David Ahern <dsahern@gmail.com>
> 
> A user reported [0] hitting the WARN_ON in fib_info_nh:
 ...
> The WARN_ON is triggered in fib_select_default which is invoked when
> there are multiple default routes. Update the function to use
> fib_info_nhc and convert the nexthop checks to use fib_nh_common.
> 
> Add test case that covers the affected code path.
> 
> [0] https://github.com/FRRouting/frr/issues/6089
> 
> Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable, thanks.
