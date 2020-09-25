Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94581277E41
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 04:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIYCzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 22:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgIYCzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 22:55:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D87C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 19:55:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A50D7135F7B03;
        Thu, 24 Sep 2020 19:38:23 -0700 (PDT)
Date:   Thu, 24 Sep 2020 19:55:10 -0700 (PDT)
Message-Id: <20200924.195510.1074527369569503472.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net-next V2 00/15] mlx5 Connection Tracking in
 NIC mode 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923224824.67340-1-saeed@kernel.org>
References: <20200923224824.67340-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:38:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: saeed@kernel.org
Date: Wed, 23 Sep 2020 15:48:09 -0700

> This series adds the support for connection tracking in NIC mode,
> and attached to this series some trivial cleanup patches.
> v1->v2:
>  - Remove "fixup!" comment from commit message (Jakub)
>  - More information and use case description in the tag message
>    (Cover-letter) (Jakub)
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
