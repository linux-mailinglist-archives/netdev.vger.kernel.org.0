Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792193F7519
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240790AbhHYMdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:33:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51274 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbhHYMdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:33:40 -0400
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 0DD1A4D0F1970;
        Wed, 25 Aug 2021 05:32:52 -0700 (PDT)
Date:   Wed, 25 Aug 2021 13:32:47 +0100 (BST)
Message-Id: <20210825.133247.1847208011519477744.davem@davemloft.net>
To:     asml.silence@gmail.com
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org, josh@joshtriplett.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, metze@samba.org
Subject: Re: [PATCH v4 1/4] net: add accept helper not installing fd
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c57b9e8e818d93683a3d24f8ca50ca038d1da8c4.1629888991.git.asml.silence@gmail.com>
References: <cover.1629888991.git.asml.silence@gmail.com>
        <c57b9e8e818d93683a3d24f8ca50ca038d1da8c4.1629888991.git.asml.silence@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 25 Aug 2021 05:32:54 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 25 Aug 2021 12:25:44 +0100

> Introduce and reuse a helper that acts similarly to __sys_accept4_file()
> but returns struct file instead of installing file descriptor. Will be
> used by io_uring.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: David S. Miller <davem@davemloft.net>
