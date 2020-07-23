Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D2D22A46C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbgGWBPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWBPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:15:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04DCC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:15:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D236126B59D0;
        Wed, 22 Jul 2020 17:58:55 -0700 (PDT)
Date:   Wed, 22 Jul 2020 18:15:40 -0700 (PDT)
Message-Id: <20200722.181540.1257169297433921619.davem@davemloft.net>
To:     mstarovoitov@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com, netdev@vger.kernel.org,
        epomozov@marvell.com
Subject: Re: [PATCH net] net: atlantic: fix PTP on AQC10X
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722190958.12645-1-mstarovoitov@marvell.com>
References: <20200722190958.12645-1-mstarovoitov@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:58:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>
Date: Wed, 22 Jul 2020 22:09:58 +0300

> From: Egor Pomozov <epomozov@marvell.com>
> 
> This patch fixes PTP on AQC10X.
> PTP support on AQC10X requires FW involvement and FW configures the
> TPS data arb mode itself.
> So we must make sure driver doesn't touch TPS data arb mode on AQC10x
> if PTP is enabled. Otherwise, there are no timestamps even though
> packets are flowing.
> 
> Fixes: 2deac71ac492a ("net: atlantic: QoS implementation: min_rate")
> Signed-off-by: Egor Pomozov <epomozov@marvell.com>
> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Applied, thank you.
