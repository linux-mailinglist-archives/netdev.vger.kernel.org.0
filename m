Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7FD266A45
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgIKVrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgIKVra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:47:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF46C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:47:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E29651366AF5F;
        Fri, 11 Sep 2020 14:30:42 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:47:29 -0700 (PDT)
Message-Id: <20200911.144729.232221128478351816.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] enetc: Fix mdio bus removal on PF probe bailout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1599819395-26206-1-git-send-email-claudiu.manoil@nxp.com>
References: <1599819395-26206-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 14:30:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Fri, 11 Sep 2020 13:16:35 +0300

> This is the correct resolution for the conflict from
> merging the "net" tree fix:
> commit 26cb7085c898 ("enetc: Remove the mdio bus on PF probe bailout")
> with the "net-next" new work:
> commit 07095c025ac2 ("net: enetc: Use DT protocol information to set up the ports")
> that moved mdio bus allocation to an ealier stage of
> the PF probing routine.
> 
> Fixes: a57066b1a019 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied, thanks for catching this.
