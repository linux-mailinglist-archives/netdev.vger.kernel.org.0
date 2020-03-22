Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F6518E63A
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgCVDSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:18:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34440 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVDSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:18:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3082615AC4287;
        Sat, 21 Mar 2020 20:18:47 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:18:46 -0700 (PDT)
Message-Id: <20200321.201846.2033521113132339001.davem@davemloft.net>
To:     opendmb@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bcmgenet: always enable status blocks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584489936-26812-1-git-send-email-opendmb@gmail.com>
References: <1584489936-26812-1-git-send-email-opendmb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:18:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>
Date: Tue, 17 Mar 2020 17:05:36 -0700

> The hardware offloading of the NETIF_F_HW_CSUM and NETIF_F_RXCSUM
> features requires the use of Transmit Status Blocks before transmit
> frame data and Receive Status Blocks before receive frame data to
> carry the checksum information.
> 
> Unfortunately, these status blocks are currently only enabled when
> the NETIF_F_HW_CSUM feature is enabled. As a result NETIF_F_RXCSUM
> will not actually be offloaded to the hardware unless both it and
> NETIF_F_HW_CSUM are enabled. Fortunately, that is the default
> configuration.
> 
> This commit addresses this issue by always enabling the use of
> status blocks on both transmit and receive frames. Further, it
> replaces the use of a dedicated flag within the driver private
> data structure with direct use of the netdev features flags.
> 
> Fixes: 810155397890 ("net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Applied, thank you.
