Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40F0101097
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKSBTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:19:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52150 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfKSBTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:19:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 511C6150FAE61;
        Mon, 18 Nov 2019 17:19:07 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:19:06 -0800 (PST)
Message-Id: <20191118.171906.2293867240880950490.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com
Subject: Re: [PATCH net] net/mlx4_en: Fix wrong limitation for number of TX
 rings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118094104.9477-1-tariqt@mellanox.com>
References: <20191118094104.9477-1-tariqt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:19:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Mon, 18 Nov 2019 11:41:04 +0200

> XDP_TX rings should not be limited by max_num_tx_rings_p_up.
> To make sure total number of TX rings never exceed MAX_TX_RINGS,
> add similar check in mlx4_en_alloc_tx_queue_per_tc(), where
> a new value is assigned for num_up.
> 
> Fixes: 7e1dc5e926d5 ("net/mlx4_en: Limit the number of TX rings")
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Applied and queued up for -stable, thanks.
