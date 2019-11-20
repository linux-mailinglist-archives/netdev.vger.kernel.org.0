Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFAB10452B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfKTUfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:35:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59670 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfKTUfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:35:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64A6014C1F425;
        Wed, 20 Nov 2019 12:34:59 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:34:58 -0800 (PST)
Message-Id: <20191120.123458.362712252409261377.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH v5 net-next 0/3] add DMA-sync-for-device capability to
 page_pool API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1574261017.git.lorenzo@kernel.org>
References: <cover.1574261017.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:34:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Wed, 20 Nov 2019 16:54:16 +0200

> Introduce the possibility to sync DMA memory for device in the page_pool API.
> This feature allows to sync proper DMA size and not always full buffer
> (dma_sync_single_for_device can be very costly).
> Please note DMA-sync-for-CPU is still device driver responsibility.
> Relying on page_pool DMA sync mvneta driver improves XDP_DROP pps of
> about 170Kpps:
> 
> - XDP_DROP DMA sync managed by mvneta driver:	~420Kpps
> - XDP_DROP DMA sync managed by page_pool API:	~585Kpps
> 
> Do not change naming convention for the moment since the changes will hit other
> drivers as well. I will address it in another series.
 ...

Series applied, thanks.
