Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D91E93A1
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfJ2Xa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:30:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32930 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfJ2Xaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:30:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA01714EBDE8D;
        Tue, 29 Oct 2019 16:30:54 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:30:54 -0700 (PDT)
Message-Id: <20191029.163054.513288593325892115.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, eranbe@mellanox.com,
        jackm@dev.mellanox.co.il
Subject: Re: [PATCH net] net/mlx4_core: Dynamically set guaranteed amount
 of counters per VF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191027143915.5232-1-tariqt@mellanox.com>
References: <20191027143915.5232-1-tariqt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:30:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Sun, 27 Oct 2019 16:39:15 +0200

> From: Eran Ben Elisha <eranbe@mellanox.com>
> 
> Prior to this patch, the amount of counters guaranteed per VF in the
> resource tracker was MLX4_VF_COUNTERS_PER_PORT * MLX4_MAX_PORTS. It was
> set regardless if the VF was single or dual port.
> This caused several VFs to have no guaranteed counters although the
> system could satisfy their request.
> 
> The fix is to dynamically guarantee counters, based on each VF
> specification.
> 
> Fixes: 9de92c60beaa ("net/mlx4_core: Adjust counter grant policy in the resource tracker")
> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Applied, thanks Tariq.
