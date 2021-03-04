Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414A332DCA9
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbhCDWCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241278AbhCDWC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:02:27 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB858C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 14:01:46 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 2B39A4FE58911;
        Thu,  4 Mar 2021 14:01:45 -0800 (PST)
Date:   Thu, 04 Mar 2021 14:01:03 -0800 (PST)
Message-Id: <20210304.140103.225055189743873865.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver
 Updates 2021-03-04
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210304192017.1911095-1-anthony.l.nguyen@intel.com>
References: <20210304192017.1911095-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 04 Mar 2021 14:01:45 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Thu,  4 Mar 2021 11:20:15 -0800

> This series contains updates to ixgbe and ixgbevf drivers.
> 
> Antony Antony adds a check to fail for non transport mode SA with
> offload as this is not supported for ixgbe and ixgbevf.
> 
> Dinghao Liu fixes a memory leak on failure to program a perfect filter
> for ixgbe.
> 
> v2:
> - Dropped patch 1
> 
> The following are changes since commit a9ecb0cbf03746b17a7c13bd8e3464e6789f73e8:
>   rtnetlink: using dev_base_seq from target net
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

This is the same URL as your previous pull request so these changes went in via that pull.

Just FYI...
