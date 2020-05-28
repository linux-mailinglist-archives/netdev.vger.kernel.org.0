Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5851E70FA
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437869AbgE1X5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437753AbgE1X5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:57:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0D8C08C5C7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:30:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B79961296CF90;
        Thu, 28 May 2020 16:30:20 -0700 (PDT)
Date:   Thu, 28 May 2020 16:30:19 -0700 (PDT)
Message-Id: <20200528.163019.343545037180184967.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
Subject: Re: [PATCH V7 00/19] net: ks8851: Unify KS8851 SPI and MLL drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528222146.348805-1-marex@denx.de>
References: <20200528222146.348805-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 16:30:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Fri, 29 May 2020 00:21:27 +0200

> The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
> of silicon, except the former has an SPI interface, while the later has a
> parallel bus interface. Thus far, Linux has two separate drivers for each
> and they are diverging considerably.
> 
> This series unifies them into a single driver with small SPI and parallel
> bus specific parts. The approach here is to first separate out the SPI
> specific parts into a separate file, then add parallel bus accessors in
> another separate file and then finally remove the old parallel bus driver.
> The reason for replacing the old parallel bus driver is because the SPI
> bus driver is much higher quality.
> 
> Note that I dropped "net: ks8851: Drop define debug and pr_fmt()" for now,
> will send it separatelly later.

Series applied, thanks Marek.
