Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34E713B7F5
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 03:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAOCrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 21:47:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51718 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgAOCrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 21:47:11 -0500
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 076D41580B4E9;
        Tue, 14 Jan 2020 18:47:01 -0800 (PST)
Date:   Tue, 14 Jan 2020 18:46:54 -0800 (PST)
Message-Id: <20200114.184654.254868360954041208.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org, kuba@kernel.org
Subject: Re: [PATCH v3 net-next] net: socionext: get rid of huge dma sync
 in netsec_alloc_rx_data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1fce975f9f77780b92b86dbaf1ca89ffe37255bb.1578993365.git.lorenzo@kernel.org>
References: <1fce975f9f77780b92b86dbaf1ca89ffe37255bb.1578993365.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 18:47:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue, 14 Jan 2020 10:24:19 +0100

> Socionext driver can run on dma coherent and non-coherent devices.
> Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> now the driver can let page_pool API to managed needed DMA sync
> 
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied, thanks.
