Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70281EC50D
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgFBWdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgFBWdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:33:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64391C08C5C0;
        Tue,  2 Jun 2020 15:33:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9910B1277CEB0;
        Tue,  2 Jun 2020 15:33:06 -0700 (PDT)
Date:   Tue, 02 Jun 2020 15:33:05 -0700 (PDT)
Message-Id: <20200602.153305.1816058302721883296.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@mellanox.com,
        clang-built-linux@googlegroups.com, linux-rdma@vger.kernel.org,
        natechancellor@gmail.com, netdev@vger.kernel.org,
        saeedm@mellanox.com, vuhuong@mellanox.com
Subject: Re: [PATCH net] net/mlx5: Don't fail driver on failure to create
 debugfs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200602122837.161519-1-leon@kernel.org>
References: <20200602122837.161519-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 15:33:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saeed, please pick this up.
