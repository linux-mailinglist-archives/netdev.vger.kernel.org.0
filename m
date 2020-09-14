Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65934269769
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgINVIb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Sep 2020 17:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgINVIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:08:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E715BC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:08:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6105A127DE89A;
        Mon, 14 Sep 2020 13:51:29 -0700 (PDT)
Date:   Mon, 14 Sep 2020 14:08:15 -0700 (PDT)
Message-Id: <20200914.140815.1542913610622375616.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [net-next v2 0/5][pull request] 40GbE Intel Wired LAN Driver
 Updates 2020-09-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200914173224.692707-1-anthony.l.nguyen@intel.com>
References: <20200914173224.692707-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:51:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Mon, 14 Sep 2020 10:32:19 -0700

> This series contains updates to i40e driver only.
> 
> Li RongQing removes binding affinity mask to a fixed CPU and sets
> prefetch of Rx buffer page to occur conditionally.
> 
> Björn provides AF_XDP performance improvements by not prefetching HW
> descriptors, using 16 byte descriptors, and moving buffer allocation
> out of Rx processing loop.
> 
> v2: Define prefetch_page_address in a common header for patch 2.
> Dropped, previous, patch 5 as it is being reworked to be more
> generalized.
> 
> The following are changes since commit e059c6f340f6fccadd3db9993f06d4cc51305804:
>   tulip: switch from 'pci_' to 'dma_' API
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Looks good, pulled, thanks Tony.
