Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A7320B947
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgFZTWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgFZTWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 15:22:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7A8C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 12:22:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B29C7120F19CB;
        Fri, 26 Jun 2020 12:22:50 -0700 (PDT)
Date:   Fri, 26 Jun 2020 12:22:49 -0700 (PDT)
Message-Id: <20200626.122249.2231192220693532473.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v3 0/8][pull request] 40GbE Intel Wired LAN Driver
 Updates 2020-06-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626062850.1649538-1-jeffrey.t.kirsher@intel.com>
References: <20200626062850.1649538-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 12:22:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 25 Jun 2020 23:28:42 -0700

> This series contains updates to i40e driver and removes the individual
> driver versions from all of the Intel wired LAN drivers.
> 
> Shiraz moves the client header so that it can easily be shared between
> the i40e LAN driver and i40iw RDMA driver.
> 
> Jesse cleans up the unused defines, since they are just dead weight.
> 
> Alek reduces the unreasonably long wait time for a PF reset after reboot
> by using jiffies to limit the maximum wait time for the PF reset to
> succeed.  Added additional logging to let the user know when the driver
> transitions into recovery mode.  Adds new device support for our 5 Gbps
> NICs.
> 
> Todd adds a check to see if MFS is set after warm reboot and notifies
> the user when MFS is set to anything lower than the default value.
> 
> Arkadiusz fixes a possible race condition, where were holding a
> spin-lock while in atomic context.
> 
> v2: removed code comments that were no longer applicable in patch 2 of
>     the series.  Also removed 'inline' from patch 4 and patch 8 of the
>     series.  Also re-arranged code to be able to remove the forward
>     function declarations.  Dropped patch 9 of the series, while the
>     author works on cleaning up the commit message.
> v3: Updated patch 8 description to answer Jakub's questions
> 
> The following are changes since commit 6d29302652587001038c8f5ac0e0c7fa6592bbbc:
>   Merge tag 'mlx5-updates-2020-06-23' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Pulled, thanks Jeff.
