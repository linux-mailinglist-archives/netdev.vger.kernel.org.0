Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F0218A953
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCRXiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:38:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60988 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCRXiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:38:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7447415535455;
        Wed, 18 Mar 2020 16:38:17 -0700 (PDT)
Date:   Wed, 18 Mar 2020 16:38:16 -0700 (PDT)
Message-Id: <20200318.163816.1292858106592359997.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com
Subject: Re: [PATCH net] net/sched: act_ct: Fix leak of ct zone template on
 replace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584528633-20177-1-git-send-email-paulb@mellanox.com>
References: <1584528633-20177-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 16:38:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Wed, 18 Mar 2020 12:50:33 +0200

> Currently, on replace, the previous action instance params
> is swapped with a newly allocated params. The old params is
> only freed (via kfree_rcu), without releasing the allocated
> ct zone template related to it.
> 
> Call tcf_ct_params_free (via call_rcu) for the old params,
> so it will release it.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: Paul Blakey <paulb@mellanox.com>

Applied and queued up for -stable.
