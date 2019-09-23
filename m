Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A03BB885
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388311AbfIWPvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:51:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42238 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732805AbfIWPvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 11:51:14 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8DC11425E47B;
        Mon, 23 Sep 2019 08:51:11 -0700 (PDT)
Date:   Mon, 23 Sep 2019 17:51:06 +0200 (CEST)
Message-Id: <20190923.175106.799482393811705736.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 0/7] mlx5 checksum fixes for 4.19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190923123917.16817-1-saeedm@mellanox.com>
References: <20190923123917.16817-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Sep 2019 08:51:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon, 23 Sep 2019 12:39:57 +0000

> This series includes some upstream patches aimed to fix multiple checksum
> issues with mlx5 driver in 4.19-stable kernels.
> 
> Since the patches didn't apply cleanly to 4.19 back when they were
> submitted for the first time around 5.1 kernel release to the netdev
> mailing list, i couldn't mark them for -stable 4.19, so now as the issue
> is being reported on 4.19 LTS kernels, I had to do the backporting and
> this submission myself.
>  
> This series required some dependency patches and some manual touches
> to apply some of them.
> 
> Please apply to 4.19-stable and let me know if there's any problem.
> I tested and the patches apply cleanly and work on top of: v4.19.75

FWIW, I'm fine with this.
