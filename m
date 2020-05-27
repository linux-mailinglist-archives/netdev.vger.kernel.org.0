Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAA81E4CFA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbgE0SVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388748AbgE0SVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:21:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F01FC08C5C1;
        Wed, 27 May 2020 11:21:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 785B5128B1EFF;
        Wed, 27 May 2020 11:21:07 -0700 (PDT)
Date:   Wed, 27 May 2020 11:21:06 -0700 (PDT)
Message-Id: <20200527.112106.313537871064974902.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     georgezhang@vmware.com, acking@vmware.com, decui@microsoft.com,
        dtor@vmware.com, netdev@vger.kernel.org, jhansen@vmware.com,
        stefanha@redhat.com, linux-kernel@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] vsock: fix timeout in vsock_accept()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527075655.69889-1-sgarzare@redhat.com>
References: <20200527075655.69889-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:21:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 27 May 2020 09:56:55 +0200

> The accept(2) is an "input" socket interface, so we should use
> SO_RCVTIMEO instead of SO_SNDTIMEO to set the timeout.
> 
> So this patch replace sock_sndtimeo() with sock_rcvtimeo() to
> use the right timeout in the vsock_accept().
> 
> Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Applied and queued up for -stable, thank you.
