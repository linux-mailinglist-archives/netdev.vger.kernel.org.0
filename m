Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983CF4AF39
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 02:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfFSA5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 20:57:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfFSA5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 20:57:34 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A53914B2A348;
        Tue, 18 Jun 2019 17:57:28 -0700 (PDT)
Date:   Tue, 18 Jun 2019 20:57:24 -0400 (EDT)
Message-Id: <20190618.205724.706287109559936732.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hns3: Add missing newline at end of file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617143836.5154-1-geert+renesas@glider.be>
References: <20190617143836.5154-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 17:57:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Mon, 17 Jun 2019 16:38:36 +0200

> "git diff" says:
> 
>     \ No newline at end of file
> 
> after modifying the file.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to net-next, thanks.
