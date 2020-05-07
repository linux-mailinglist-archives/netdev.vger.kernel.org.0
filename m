Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1201C7F6E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgEGAxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgEGAxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:53:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92642C061A0F;
        Wed,  6 May 2020 17:53:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01E2B12783B7E;
        Wed,  6 May 2020 17:53:17 -0700 (PDT)
Date:   Wed, 06 May 2020 17:53:17 -0700 (PDT)
Message-Id: <20200506.175317.102621048517657840.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        m-karicheri2@ti.com
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw-nuss: fix irqs type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505163126.13942-1-grygorii.strashko@ti.com>
References: <20200505163126.13942-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:53:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Tue, 5 May 2020 19:31:26 +0300

> The K3 INTA driver, which is source TX/RX IRQs for CPSW NUSS, defines IRQs
> triggering type as EDGE by default, but triggering type for CPSW NUSS TX/RX
> IRQs has to be LEVEL as the EDGE triggering type may cause unnecessary IRQs
> triggering and NAPI scheduling for empty queues. It was discovered with
> RT-kernel.
> 
> Fix it by explicitly specifying CPSW NUSS TX/RX IRQ type as
> IRQF_TRIGGER_HIGH.
> 
> Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied, thanks.
