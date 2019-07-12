Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99BB67687
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfGLW35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:29:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34272 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbfGLW34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:29:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 211D714E01C2C;
        Fri, 12 Jul 2019 15:29:56 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:29:55 -0700 (PDT)
Message-Id: <20190712.152955.99149572464673787.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, saeedm@mellanox.com
Subject: Re: [PATCH net-next] net/mlx5e: Provide cb_list pointer when
 setting up tc block on rep
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710182554.2988-1-vladbu@mellanox.com>
References: <20190710182554.2988-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:29:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Wed, 10 Jul 2019 21:25:54 +0300

> Recent refactoring of tc block offloads infrastructure introduced new
> flow_block_cb_setup_simple() method intended to be used as unified way for
> all drivers to register offload callbacks. However, commit that actually
> extended all users (drivers) with block cb list and provided it to
> flow_block infra missed mlx5 en_rep. This leads to following NULL-pointer
> dereference when creating Qdisc:
 ...
> Extend en_rep with new static mlx5e_rep_block_cb_list list and pass it to
> flow_block_cb_setup_simple() function instead of hardcoded NULL pointer.
> 
> Fixes: 955bcb6ea0df ("drivers: net: use flow block API")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied, thanks.
