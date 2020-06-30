Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB50C20FCCD
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgF3TfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgF3TfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:35:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C31C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:35:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 421321273AA1A;
        Tue, 30 Jun 2020 12:35:01 -0700 (PDT)
Date:   Tue, 30 Jun 2020 12:34:59 -0700 (PDT)
Message-Id: <20200630.123459.1290794918414333048.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 00/13][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-06-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
References: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 12:35:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 29 Jun 2020 18:27:35 -0700

> This series contains updates to only the igc driver.
> 
> Sasha added Energy Efficient Ethernet (EEE) support and Latency Tolerance
> Reporting (LTR) support for the igc driver. Added Low Power Idle (LPI)
> counters and cleaned up unused TCP segmentation counters. Removed
> igc_power_down_link() and call igc_power_down_phy_copper_base()
> directly. Removed unneeded copper media check. 
> 
> Andre cleaned up timestamping by removing un-supported features and
> duplicate code for i225. Fixed the timestamp check on the proper flag
> instead of the skb for pending transmit timestamps. Refactored
> igc_ptp_set_timestamp_mode() to simply the flow.
> 
> v2: Removed the log message in patch 1 as suggested by David Miller.
>     Note: The locking issue Jakub Kicinski saw in patch 5, currently
>     exists in the current net-next tree, so Andre will resolve the
>     locking issue in a follow-on patch.
> 
> The following are changes since commit b8483ecaf72ee9059dcca5de969781028a550f89:
>   liquidio: use list_empty_careful in lio_list_delete_head
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Pulled, thanks Jeff.
