Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E74F1894BC
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgCRECW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:02:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35458 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgCRECW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:02:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3ED71140F8B8E;
        Tue, 17 Mar 2020 21:02:21 -0700 (PDT)
Date:   Tue, 17 Mar 2020 21:02:20 -0700 (PDT)
Message-Id: <20200317.210220.1278270199388080239.davem@davemloft.net>
To:     opendmb@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: bcmgenet: revisit MAC reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584395096-41674-1-git-send-email-opendmb@gmail.com>
References: <1584395096-41674-1-git-send-email-opendmb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Mar 2020 21:02:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>
Date: Mon, 16 Mar 2020 14:44:54 -0700

> Commit 3a55402c9387 ("net: bcmgenet: use RGMII loopback for MAC 
> reset") was intended to resolve issues with reseting the UniMAC
> core within the GENET block by providing better control over the
> clocks used by the UniMAC core. Unfortunately, it is not
> compatible with all of the supported system configurations so an
> alternative method must be applied.
> 
> This commit set provides such an alternative. The first commit
> reverts the previous change and the second commit provides the
> alternative reset sequence that addresses the concerns observed
> with the previous implementation.
> 
> This replacement implementation should be applied to the stable
> branches wherever commit 3a55402c9387 ("net: bcmgenet: use RGMII 
> loopback for MAC reset") has been applied.
> 
> Unfortunately, reverting that commit may conflict with some
> restructuring changes introduced by commit 4f8d81b77e66 ("net: 
> bcmgenet: Refactor register access in bcmgenet_mii_config").
> The first commit in this set has been manually edited to
> resolve the conflict on net/master. I would be happy to help
> stable maintainers with resolving any such conflicts if they
> occur. However, I do not expect that commit to have been
> backported to stable branch so hopefully the revert can be
> applied cleanly.

Series applied and queued up for -stable, thank you.
