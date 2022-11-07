Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB0261EB54
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiKGHFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKGHFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:05:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AB4B85B
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1728EB80D15
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 07:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB55C433D6;
        Mon,  7 Nov 2022 07:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667804739;
        bh=xjog7QpDxwe+HrMszMja6hNPmLuBNUDvjdTqKUrRIO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ko46vq9hETPsyrIpx8sHJs0eV3ILxekIIri8T7RetgSwGk1x3RajOceXblg0vZQnS
         8TsIn7sUMnJMQ2nJs402GDMfAJ6xJ2BTXVTPTb6/rMRBnvEIS6Mp9QvlHYnaHKrOvr
         yw7Yl0mnC6/v9VAYpFnt7t06sNV5ChZK6wO6GXb+U9Btlk5rEl3P6KgEP2pn6pR8Wi
         jV6zgRMx8GDm4g5DzPkujZIFEUgAX4mhKIFXeaphQdapyPxxzUGWlXatQe47sRmMax
         vpPrZmgEpgleGEtEswwInvL4Us+s9NOwMVipLJiClRNP8VzGWV5LG/VExth/EQeeAm
         v58/AJty0BOIA==
Date:   Mon, 7 Nov 2022 09:05:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6][pull request] Intel Wired LAN Driver
 Updates 2022-11-04 (ixgbe, ixgbevf, igb)
Message-ID: <Y2iuP+0shDbYJmWU@unreal>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 01:54:08PM -0700, Tony Nguyen wrote:
> This series contains updates to ixgbe, ixgbevf, and igb drivers.

<...>

> Kees Cook (2):
>   igb: Do not free q_vector unless new one was allocated

Except this patch and wrong Tested-by tag.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
