Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0335A1BA63
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfEMPvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:51:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbfEMPvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 11:51:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9625514E11A09;
        Mon, 13 May 2019 08:51:07 -0700 (PDT)
Date:   Mon, 13 May 2019 08:51:04 -0700 (PDT)
Message-Id: <20190513.085104.1611937467438995000.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net v2] net: mvpp2: cls: Add missing NETIF_F_NTUPLE flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190513073033.15015-1-maxime.chevallier@bootlin.com>
References: <20190513073033.15015-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 08:51:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Mon, 13 May 2019 09:30:33 +0200

> Now that the mvpp2 driver supports classification offloading, we must
> add the NETIF_F_NTUPLE to the features list.
> 
> Since the current code doesn't allow disabling the feature, we don't set
> the flag in dev->hw_features.
> 
> Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V2: Rebased on latest -net, added Jakub's Ack, gave more details in the
>     commit log about not adding the flag in hw_features.

Applied, thanks.
