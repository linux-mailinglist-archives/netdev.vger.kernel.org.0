Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8994C281F1C
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgJBXcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJBXcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 19:32:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDC2C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 16:32:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2EE3811E59B90;
        Fri,  2 Oct 2020 16:15:32 -0700 (PDT)
Date:   Fri, 02 Oct 2020 16:32:18 -0700 (PDT)
Message-Id: <20201002.163218.1662001971354458656.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH net-next v3 0/4] dpaa2-eth: add devlink parser error
 drop trap support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001151148.18720-1-ioana.ciornei@nxp.com>
References: <20201001151148.18720-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 16:15:32 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Thu,  1 Oct 2020 18:11:44 +0300

> This patch set adds support in the dpaa2-eth driver for a new group of
> devlink drop traps - PARSER_ERROR_DROPS.
> 
> The first patch adds a new generic trap group and associated traps,
> their definitions in devlink and their corresponding entries in the
> Documentation.
> 
> Because there might be more devices (besides DPAA2) which do not support
> changing the action independently on each trap, a nre devlink callback
> is introduced - .trap_group_action_set(). If this callback is populated,
> it will take precedence over .trap_action_set() when the user requests
> changing the action on all the traps in a group.
> 
> The next patches add basic linkage with devlink for the dpaa2-eth driver
> and support for the newly added PARSER_ERROR_DROPS. Nothing special
> here, just setting up the Rx error queue, interpreting the parse result,
> and then reporting any frame received on that queue to devlink.
 ...

Series applied, thanks.
