Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FC1E93CD
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfJ2Xmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:42:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33018 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfJ2Xmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:42:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BECA514EBE2D4;
        Tue, 29 Oct 2019 16:42:49 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:42:49 -0700 (PDT)
Message-Id: <20191029.164249.1707480773387143512.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     epomozov@marvell.com, igor.russkikh@aquantia.com,
        sergey.samoilenko@aquantia.com, dmitry.bezrukov@aquantia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: aquantia: fix error handling in
 aq_ptp_poll
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028070447.GA3659@embeddedor>
References: <20191028070447.GA3659@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:42:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Mon, 28 Oct 2019 02:04:47 -0500

> Fix currenty ignored returned error by properly checking *err* after
> calling aq_nic->aq_hw_ops->hw_ring_hwts_rx_fill().
> 
> Addresses-Coverity-ID: 1487357 ("Unused value")
> Fixes: 04a1839950d9 ("net: aquantia: implement data PTP datapath")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
