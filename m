Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC71B0E5A
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731503AbfILL4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:56:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731283AbfILL4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:56:44 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8B63147F7621;
        Thu, 12 Sep 2019 04:56:42 -0700 (PDT)
Date:   Thu, 12 Sep 2019 13:56:40 +0200 (CEST)
Message-Id: <20190912.135640.688251444357964226.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] sctp: Fix the link time qualifier of
 'sctp_ctrlsock_exit()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
References: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 04:56:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Wed, 11 Sep 2019 18:02:39 +0200

> The '.exit' functions from 'pernet_operations' structure should be marked
> as __net_exit, not __net_init.
> 
> Fixes: 8e2d61e0aed2 ("sctp: fix race on protocol/netns initialization")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied and queued up for -stable.
