Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F74F1D1FDF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403772AbgEMUMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390841AbgEMUMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:12:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A48AC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 13:12:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14D4E127F93EB;
        Wed, 13 May 2020 13:12:12 -0700 (PDT)
Date:   Wed, 13 May 2020 13:12:11 -0700 (PDT)
Message-Id: <20200513.131211.726414267223514414.davem@davemloft.net>
To:     hch@lst.de
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] ipv6: set msg_control_is_user in
 do_ipv6_getsockopt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513193641.2703043-1-hch@lst.de>
References: <20200513193641.2703043-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 13:12:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 21:36:41 +0200

> While do_ipv6_getsockopt does not call the high-level recvmsg helper,
> the msghdr eventually ends up being passed to put_cmsg anyway, and thus
> needs msg_control_is_user set to the proper value.
> 
> Fixes: 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for ->msg_control")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Applied, thanks.
