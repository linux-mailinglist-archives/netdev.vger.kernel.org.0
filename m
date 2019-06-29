Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8C45AD10
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfF2TaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:30:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39568 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfF2TaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:30:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17ED814C7E037;
        Sat, 29 Jun 2019 12:30:07 -0700 (PDT)
Date:   Sat, 29 Jun 2019 12:30:06 -0700 (PDT)
Message-Id: <20190629.123006.462312256730945029.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: remove not needed call to
 dma_sync_single_for_device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8377f1a6-787a-7eea-17be-0d70cb9911d3@gmail.com>
References: <8377f1a6-787a-7eea-17be-0d70cb9911d3@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 12:30:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 27 Jun 2019 23:19:09 +0200

> DMA_API_HOWTO.txt includes an example explaining when
> dma_sync_single_for_device() is not needed, and that example matches
> our use case. The buffer isn't changed by the CPU and direction is
> DMA_FROM_DEVICE, so we can remove the call to
> dma_sync_single_for_device().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
