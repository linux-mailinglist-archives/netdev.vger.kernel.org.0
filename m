Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE36413B7FB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 03:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAOCuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 21:50:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgAOCuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 21:50:24 -0500
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A7611580B504;
        Tue, 14 Jan 2020 18:50:12 -0800 (PST)
Date:   Tue, 14 Jan 2020 18:50:07 -0800 (PST)
Message-Id: <20200114.185007.555439625894308968.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org, kuba@kernel.org
Subject: Re: [PATCH net] net: mvneta: fix dma sync size in mvneta_run_xdp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c73de2bf79cc3d2f6d4f8c8864ff6a64198db2c8.1578996931.git.lorenzo@kernel.org>
References: <c73de2bf79cc3d2f6d4f8c8864ff6a64198db2c8.1578996931.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 18:50:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue, 14 Jan 2020 11:21:16 +0100

> Page pool API will start syncing (if requested) starting from
> page->dma_addr + pool->p.offset. Fix dma sync length in
> mvneta_run_xdp since we do not need to account xdp headroom
> 
> Fixes: 07e13edbb6a6 ("net: mvneta: get rid of huge dma sync in mvneta_rx_refill")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied, thanks.
