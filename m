Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2EA209943
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 07:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389749AbgFYFCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 01:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbgFYFCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 01:02:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC69C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 22:02:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C03471287510B;
        Wed, 24 Jun 2020 22:02:24 -0700 (PDT)
Date:   Wed, 24 Jun 2020 22:02:23 -0700 (PDT)
Message-Id: <20200624.220223.817974985870667481.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next V3 0/9] mlx5 updates 2020-06-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 22:02:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 23 Jun 2020 21:46:06 -0700

> Hi Dave, Jakub
> 
> This series adds misc updates and one small feature, Relaxed ordering, 
> to mlx5 driver.
> 
> v1->v2:
>  - Removed unnecessary Fixes Tags 
> 
> v2->v3:
>  - Drop "macro undefine" patch, it has no value
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Saeed, please toss patch #9 and resend this, it still need discussion.

I personally don't like using ethtool for this even for diagnostic
purposes.  Such controls belong in the PCI layer and associated sysfs
file or similar.

Thank you.
