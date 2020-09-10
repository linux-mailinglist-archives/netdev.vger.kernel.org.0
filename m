Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E46264F5D
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgIJTkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgIJTkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:40:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7F5C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:40:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E27412A30024;
        Thu, 10 Sep 2020 12:23:52 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:40:38 -0700 (PDT)
Message-Id: <20200910.124038.234817921157003779.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        kuba@kernel.org, thomas.petazzoni@bootlin.com, brouer@redhat.com,
        echaudro@redhat.com
Subject: Re: [PATCH net-next] net: mvneta: rely on MVNETA_MAX_RX_BUF_SIZE
 for pkt split in mvneta_swbm_rx_frame()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7b417a96a147d88ffdabc8e906d26d5adf39170d.1599588966.git.lorenzo@kernel.org>
References: <7b417a96a147d88ffdabc8e906d26d5adf39170d.1599588966.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:23:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue,  8 Sep 2020 20:23:31 +0200

> In order to easily change the rx buffer size, rely on
> MVNETA_MAX_RX_BUF_SIZE instead of PAGE_SIZE in mvneta_swbm_rx_frame
> routine for rx buffer split. Currently this is not an issue since we set
> MVNETA_MAX_RX_BUF_SIZE to PAGE_SIZE - MVNETA_SKB_PAD but it is a good to
> have to configure a different rx buffer size.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied, thanks.
