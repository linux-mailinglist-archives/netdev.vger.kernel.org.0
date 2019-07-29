Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC282792AD
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfG2R4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:56:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbfG2R4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:56:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F5521401D378;
        Mon, 29 Jul 2019 10:56:07 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:56:07 -0700 (PDT)
Message-Id: <20190729.105607.1103199149475798153.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com
Subject: Re: [PATCH net] net/mlx5e: Fix unnecessary flow_block_cb_is_busy
 call
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564239595-23786-1-git-send-email-wenxu@ucloud.cn>
References: <1564239595-23786-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 10:56:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Sat, 27 Jul 2019 22:59:55 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> When call flow_block_cb_is_busy. The indr_priv is guaranteed to
> NULL ptr. So there is no need to call flow_bock_cb_is_busy.
> 
> Fixes: 0d4fd02e7199 ("net: flow_offload: add flow_block_cb_is_busy() and use it")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

I need a review on this.
