Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A155F1B8296
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgDXX4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDXX4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:56:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0DDC09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 16:56:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EE8314F63C1A;
        Fri, 24 Apr 2020 16:56:40 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:56:39 -0700 (PDT)
Message-Id: <20200424.165639.2278485607513679445.davem@davemloft.net>
To:     zhengbin13@huawei.com
Cc:     mlxsw@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH -next] net/mlxfw: Remove unneeded semicolon
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424090015.90790-1-zhengbin13@huawei.com>
References: <20200424090015.90790-1-zhengbin13@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:56:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>
Date: Fri, 24 Apr 2020 17:00:15 +0800

> Fixes coccicheck warning:
> 
> drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c:79:2-3: Unneeded semicolon
> drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c:162:2-3: Unneeded semicolon
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Applied, thanks.
