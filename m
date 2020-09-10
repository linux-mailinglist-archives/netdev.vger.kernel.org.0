Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0336C2654D8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgIJWJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgIJWJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:09:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7EBC061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 15:09:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27A82135AA2FE;
        Thu, 10 Sep 2020 14:53:01 -0700 (PDT)
Date:   Thu, 10 Sep 2020 15:09:47 -0700 (PDT)
Message-Id: <20200910.150947.1427737324391041749.davem@davemloft.net>
To:     petrm@nvidia.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, parav@nvidia.com,
        saeedm@nvidia.com, idosch@nvidia.com, jiri@nvidia.com
Subject: Re: [PATCH net] net: DCB: Validate DCB_ATTR_DCB_BUFFER argument
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e086a3597a33e16bcc57b97f81dcb2aa3ce48e31.1599739681.git.petrm@nvidia.com>
References: <e086a3597a33e16bcc57b97f81dcb2aa3ce48e31.1599739681.git.petrm@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 14:53:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>
Date: Thu, 10 Sep 2020 14:09:05 +0200

> The parameter passed via DCB_ATTR_DCB_BUFFER is a struct dcbnl_buffer. The
> field prio2buffer is an array of IEEE_8021Q_MAX_PRIORITIES bytes, where
> each value is a number of a buffer to direct that priority's traffic to.
> That value is however never validated to lie within the bounds set by
> DCBX_MAX_BUFFERS. The only driver that currently implements the callback is
> mlx5 (maintainers CCd), and that does not do any validation either, in
> particual allowing incorrect configuration if the prio2buffer value does
> not fit into 4 bits.
> 
> Instead of offloading the need to validate the buffer index to drivers, do
> it right there in core, and bounce the request if the value is too large.
> 
> CC: Parav Pandit <parav@nvidia.com>
> CC: Saeed Mahameed <saeedm@nvidia.com>
> Fixes: e549f6f9c098 ("net/dcb: Add dcbnl buffer attribute")
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Applied and queued up for -stable, thank you.
