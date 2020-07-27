Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A6122F9E7
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgG0UMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgG0UMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 16:12:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BA7C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 13:12:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84B8E1277F87D;
        Mon, 27 Jul 2020 12:56:01 -0700 (PDT)
Date:   Mon, 27 Jul 2020 13:12:45 -0700 (PDT)
Message-Id: <20200727.131245.392232588748520405.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [net-next v2 0/8][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-07-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727171338.3698640-1-anthony.l.nguyen@intel.com>
References: <20200727171338.3698640-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 12:56:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Mon, 27 Jul 2020 10:13:30 -0700

> This series contains updates to igc driver only.
> 
> Sasha cleans up double definitions, unneeded and non applicable
> registers, and removes unused fields in structs. Ensures the Receive
> Descriptor Minimum Threshold Count is cleared and fixes a static checker
> error.
> 
> v2: Remove fields from hw_stats in patches that removed their uses.
> Reworded patch descriptions for patches 1, 2, and 4.
> 
> The following are changes since commit a57066b1a01977a646145f4ce8dfb4538b08368a:
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Pulled, thank you.
