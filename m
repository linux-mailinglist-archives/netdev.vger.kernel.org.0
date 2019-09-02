Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4421DA5C8D
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 21:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfIBTKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 15:10:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfIBTKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 15:10:14 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E50715404E58;
        Mon,  2 Sep 2019 12:10:13 -0700 (PDT)
Date:   Mon, 02 Sep 2019 12:10:12 -0700 (PDT)
Message-Id: <20190902.121012.1434735697208917415.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, valex@mellanox.com, erezsh@mellanox.com,
        maorg@mellanox.com, markb@mellanox.com
Subject: Re: [net-next 01/18] net/mlx5: Add flow steering actions to fs_cmd
 shim layer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190902072213.7683-2-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
        <20190902072213.7683-2-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Sep 2019 12:10:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon, 2 Sep 2019 07:22:52 +0000

> +	maction->flow_action_raw.pkt_reformat =
> +		mlx5_packet_reformat_alloc(dev->mdev, prm_prt, len,
> +					   in, namespace);
> +	if (IS_ERR(maction->flow_action_raw.pkt_reformat))
>  		return ret;

Don't you have to initialize 'ret' to the pointer error here?

This transformation doesn't look correct.
