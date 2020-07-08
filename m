Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE50219376
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGHWa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHWa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:30:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A54C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 15:30:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A56611277EC77;
        Wed,  8 Jul 2020 15:30:58 -0700 (PDT)
Date:   Wed, 08 Jul 2020 15:30:58 -0700 (PDT)
Message-Id: <20200708.153058.1978603732819640586.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        meirl@mellanox.com, ayal@mellanox.com
Subject: Re: [PATCH net-next V2 2/2] net/mlx5: Added support for 100Gbps
 per lane link modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707034233.41122-2-saeedm@mellanox.com>
References: <20200707034233.41122-1-saeedm@mellanox.com>
        <20200707034233.41122-2-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 15:30:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon,  6 Jul 2020 20:42:33 -0700

> From: Meir Lichtinger <meirl@mellanox.com>
> 
> This patch exposes new link modes using 100Gbps per lane, including 100G,
> 200G and 400G modes.
> 
> Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
> Reviewed-by: Aya Levin <ayal@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Applied.
