Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE94228C10
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgGUWir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgGUWir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:38:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB80C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 15:38:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1618911E45904;
        Tue, 21 Jul 2020 15:22:02 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:38:46 -0700 (PDT)
Message-Id: <20200721.153846.1520844098240618013.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/6] Add adaptive interrupt coalescing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:22:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Tue, 21 Jul 2020 10:55:16 +0300

> Apart from some related cleanup patches, this set
> introduces in a straightforward way the support needed
> to enable and configure interrupt coalescing for ENETC.
> 
> Patch 5 introduces the support needed for configuring the
> interrupt coalescing parameters and for switching between
> moderated (int. coalescing) and per-packet interrupt modes.
> When interrupt coalescing is enabled the Rx/Tx time
> thresholds are configurable, packet thresholds are fixed.
> To make this work reliably, patch 5 uses the traffic
> pause procedure introduced in patch 2.
> 
> Patch 6 adds DIM (Dynamic Interrupt Moderation) to implement
> adaptive coalescing based on time thresholds, for the Rx 'channel'.
> On the Tx side a default optimal value is used instead, optimized for
> TCP traffic over 1G and 2.5G links.  This default 'optimal' value can
> be overridden anytime via 'ethtool -C tx-usecs'.
> 
> netperf -t TCP_MAERTS measurements show a significant CPU load
> reduction correlated w/ reduced interrupt rates. For the
> measurement results refer to the comments in patch 6.
> 
> v2: Replaced Tx DIM with predefined optimal value, giving
> better results. This was also suggested by Jakub (cc).
> Switched order of patches 4 and 5, for better grouping.
> 
> v3: minor cleanup/improvements

Series applied, thank you.
