Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0485F18C6A0
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgCTEna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:43:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46932 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgCTEna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:43:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DD841590E027;
        Thu, 19 Mar 2020 21:43:30 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:43:29 -0700 (PDT)
Message-Id: <20200319.214329.1659736613337215790.davem@davemloft.net>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring: make sure accept honor rlimit nofile
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320022216.20993-3-axboe@kernel.dk>
References: <20200320022216.20993-1-axboe@kernel.dk>
        <20200320022216.20993-3-axboe@kernel.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:43:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 19 Mar 2020 20:22:16 -0600

> Just like commit 21ec2da35ce3, this fixes the fact that
> IORING_OP_ACCEPT ends up using get_unused_fd_flags(), which checks
> current->signal->rlim[] for limits.
> 
> Add an extra argument to __sys_accept4_file() that allows us to pass
> in the proper nofile limit, and grab it at request prep time.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: David S. Miller <davem@davemloft.net>
