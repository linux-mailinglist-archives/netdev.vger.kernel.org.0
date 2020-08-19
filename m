Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8009E24A9F9
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 01:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgHSXgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 19:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSXgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 19:36:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A78C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 16:36:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 917DA11D69C3B;
        Wed, 19 Aug 2020 16:19:25 -0700 (PDT)
Date:   Wed, 19 Aug 2020 16:36:10 -0700 (PDT)
Message-Id: <20200819.163610.793690736242734635.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com, luobin9@huawei.com,
        saeedm@mellanox.com, leon@kernel.org, idosch@mellanox.com,
        danieller@mellanox.com
Subject: Re: [net-next v3 1/4] devlink: check flash_update parameter
 support in net core
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819002821.2657515-2-jacob.e.keller@intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
        <20200819002821.2657515-2-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 16:19:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 18 Aug 2020 17:28:15 -0700

> @@ -991,6 +993,12 @@ enum devlink_trap_group_generic_id {
>  	}
>  
>  struct devlink_ops {
> +	/**
> +	 * @supported_flash_update_params:
> +	 * mask of parameters supported by the driver's .flash_update
> +	 * implemementation.
> +	 */
> +	u32 supported_flash_update_params;
>  	int (*reload_down)(struct devlink *devlink, bool netns_change,
>  			   struct netlink_ext_ack *extack);
>  	int (*reload_up)(struct devlink *devlink,

Jakub asked if this gave W=1 warnings.  Then you responded that you didn't
see any warnings with allmodconfig nor allyesconfig, but that isn't the
question Jakub asked.

Are you building with W=1 explicitly added to the build?

The issue is this kerneldoc might not be formatted correctly, and such
warnings won't be presented without doing a W=1 build.

Thank you.
