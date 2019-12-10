Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2421190CE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfLJThB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:37:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfLJThB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:37:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B710E147F764C;
        Tue, 10 Dec 2019 11:37:00 -0800 (PST)
Date:   Tue, 10 Dec 2019 11:37:00 -0800 (PST)
Message-Id: <20191210.113700.2038253518329326443.davem@davemloft.net>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 10/11] net: make socket read/write_iter() honor
 IOCB_NOWAIT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191210155742.5844-11-axboe@kernel.dk>
References: <20191210155742.5844-1-axboe@kernel.dk>
        <20191210155742.5844-11-axboe@kernel.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 11:37:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 10 Dec 2019 08:57:41 -0700

> The socket read/write helpers only look at the file O_NONBLOCK. not
> the iocb IOCB_NOWAIT flag. This breaks users like preadv2/pwritev2
> and io_uring that rely on not having the file itself marked nonblocking,
> but rather the iocb itself.
> 
> Cc: David Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

I guess this should be OK:

Acked-by: David S. Miller <davem@davemloft.net>
