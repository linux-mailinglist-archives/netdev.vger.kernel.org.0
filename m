Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56160121FB8
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfLQA1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:27:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfLQA1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:27:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 164E11557482B;
        Mon, 16 Dec 2019 16:27:38 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:27:37 -0800 (PST)
Message-Id: <20191216.162737.869655021908615488.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        mirq-linux@rere.qmqm.pl, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        emamd001@umn.edu
Subject: Re: [PATCH] net: gemini: Fix memory leak in gmac_setup_txqs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191215011045.15453-1-navid.emamdoost@gmail.com>
References: <20191215011045.15453-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:27:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Sat, 14 Dec 2019 19:10:44 -0600

> In the implementation of gmac_setup_txqs() the allocated desc_ring is
> leaked if TX queue base is not aligned. Release it via
> dma_free_coherent.
> 
> Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Applied and queued up for -stable, thanks.
