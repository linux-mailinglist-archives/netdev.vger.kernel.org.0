Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA34026505E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgIJUO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgIJUKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:10:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7F5C0613ED
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:09:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D088F133ED912;
        Thu, 10 Sep 2020 12:53:03 -0700 (PDT)
Date:   Thu, 10 Sep 2020 13:09:50 -0700 (PDT)
Message-Id: <20200910.130950.423681956437768223.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        kuba@kernel.org, thomas.petazzoni@bootlin.com, brouer@redhat.com,
        echaudro@redhat.com
Subject: Re: [PATCH net-next] net: mventa: drop mvneta_stats from
 mvneta_swbm_rx_frame signature
From:   David Miller <davem@davemloft.net>
In-Reply-To: <24f6f0436b4c574b3c2ab83503ba4004078d6dbe.1599685320.git.lorenzo@kernel.org>
References: <24f6f0436b4c574b3c2ab83503ba4004078d6dbe.1599685320.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:53:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Wed,  9 Sep 2020 23:05:23 +0200

> Remove mvneta_stats from mvneta_swbm_rx_frame signature since now stats
> are accounted in mvneta_run_xdp routine
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied, thanks.
