Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4BA21174B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgGBAmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgGBAmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:42:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79331C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 17:42:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2F4E14E50EBB;
        Wed,  1 Jul 2020 17:42:12 -0700 (PDT)
Date:   Wed, 01 Jul 2020 17:42:10 -0700 (PDT)
Message-Id: <20200701.174210.2302611981694101962.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com
Subject: Re: [net-next 00/12][pull request] Intel Wired LAN Driver Updates
 2020-07-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 17:42:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Wed,  1 Jul 2020 15:34:00 -0700

> This series contains updates to all Intel drivers, but a majority of the
> changes are to the i40e driver.
> 
> Jeff converts 'fall through' comments to the 'fallthrough;' keyword for
> all Intel drivers. Removed unnecessary delay in the ixgbe ethtool
> diagnostics test.
> 
> Arkadiusz implements Total Port Shutdown for i40e. This is the revised
> patch based on Jakub's feedback from an earlier submission of this
> patch, where additional code comments and description was needed to
> describe the functionality.
> 
> Wei Yongjun fixes return error code for iavf_init_get_resources().
> 
> Magnus optimizes XDP code in i40e; starting with AF_XDP zero-copy
> transmit completion path. Then by only executing a division when
> necessary in the napi_poll data path. Move the check for transmit ring
> full outside the send loop to increase performance.
> 
> Ciara add XDP ring statistics to i40e and the ability to dump these
> statistics and descriptors.
> 
> Tony fixes reporting iavf statistics.
> 
> Radoslaw adds support for 2.5 and 5 Gbps by implementing the newer ethtool
> ksettings API in ixgbe.
> 
> The following are changes since commit 2b04a66156159592156a97553057e8c36de2ee70:
>   Merge branch 'cxgb4-add-mirror-action-support-for-TC-MATCHALL'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Pulled, thanks Tony.
