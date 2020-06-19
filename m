Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59D5200092
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgFSDOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgFSDOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:14:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E860C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:14:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20513120ED49A;
        Thu, 18 Jun 2020 20:14:00 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:13:59 -0700 (PDT)
Message-Id: <20200618.201359.1652911161395044541.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH net v2] net: core: reduce recursion limit value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616155205.8276-1-ap420073@gmail.com>
References: <20200616155205.8276-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:14:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Tue, 16 Jun 2020 15:52:05 +0000

> In the current code, ->ndo_start_xmit() can be executed recursively only
> 10 times because of stack memory.
> But, in the case of the vxlan, 10 recursion limit value results in
> a stack overflow.
> In the current code, the nested interface is limited by 8 depth.
> There is no critical reason that the recursion limitation value should
> be 10.
> So, it would be good to be the same value with the limitation value of
> nesting interface depth.
> 
> Test commands:
 ...
> Splat looks like:
 ...
> 
> Fixes: 11a766ce915f ("net: Increase xmit RECURSION_LIMIT to 10.")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thanks.
