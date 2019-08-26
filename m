Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8FAF9D87B
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfHZVdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:33:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbfHZVdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:33:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DA4215111512;
        Mon, 26 Aug 2019 14:33:50 -0700 (PDT)
Date:   Mon, 26 Aug 2019 14:33:49 -0700 (PDT)
Message-Id: <20190826.143349.2301544714034406944.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve DMA handling in rtl_rx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <32c6566d-12c3-a01e-c8b0-f68c32949c2c@gmail.com>
References: <32c6566d-12c3-a01e-c8b0-f68c32949c2c@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Aug 2019 14:33:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 26 Aug 2019 22:52:36 +0200

> Move the call to dma_sync_single_for_cpu after calling napi_alloc_skb.
> This avoids calling dma_sync_single_for_cpu w/o handing control back
> to device if the memory allocation should fail.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
