Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130CE2D5111
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 03:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgLJCxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 21:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgLJCxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 21:53:13 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72663C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 18:52:33 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D69604D259C20;
        Wed,  9 Dec 2020 18:52:32 -0800 (PST)
Date:   Wed, 09 Dec 2020 18:52:32 -0800 (PST)
Message-Id: <20201209.185232.1729910094911369837.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [net-next v4 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-12-09
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
References: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 18:52:33 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Wed,  9 Dec 2020 13:13:03 -0800

> This series contains updates to ice driver only.
> 
> Bruce changes the allocation of ice_flow_prof_params from stack to heap to
> avoid excessive stack usage. Corrects a misleading comment and silences a
> sparse warning that is not a problem.
> 
> Paul allows for HW initialization to continue if PHY abilities cannot
> be obtained.
> 
> Jeb removes bypassing FW link override and reading Option ROM and
> netlist information for non-E810 devices as this is now available on
> other devices.
> 
> Nick removes vlan_ena field as this information can be gathered by
> checking num_vlan.
> 
> Jake combines format strings and debug prints to the same line.
> 
> Simon adds a space to fix string concatenation.
> 
> v4: Drop ACL patches. Change PHY abilities failure message from debug to
> warning.
> v3: Fix email address for DaveM and fix character in cover letter
> v2: Expand on commit message for patch 3 to show example usage/commands.
>     Reduce number of defensive checks being done.
> 
> The following are changes since commit afae3cc2da100ead3cd6ef4bb1fb8bc9d4b817c5:
>   net: atheros: simplify the return expression of atl2_phy_setup_autoneg_adv()
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Also pulled, thanks.
