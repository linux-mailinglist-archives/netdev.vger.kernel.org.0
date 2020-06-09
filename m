Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D3E1F3226
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 04:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgFICDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 22:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgFICDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 22:03:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0714FC08C5C2;
        Mon,  8 Jun 2020 19:03:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46B24128A2F8A;
        Mon,  8 Jun 2020 19:03:37 -0700 (PDT)
Date:   Mon, 08 Jun 2020 19:02:13 -0700 (PDT)
Message-Id: <20200608.190213.2930972358973149.davem@davemloft.net>
To:     poojatrivedi@gmail.com
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        mallesham.jatharkonda@oneconvergence.com, josh.tway@stackpath.com,
        pooja.trivedi@stackpath.com
Subject: Re: [PATCH net] net/tls(TLS_SW): Add selftest for 'chunked'
 sendfile test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1591372878-10314-1-git-send-email-pooja.trivedi@stackpath.com>
References: <1591372878-10314-1-git-send-email-pooja.trivedi@stackpath.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jun 2020 19:03:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pooja Trivedi <poojatrivedi@gmail.com>
Date: Fri,  5 Jun 2020 16:01:18 +0000

> This selftest tests for cases where sendfile's 'count'
> parameter is provided with a size greater than the intended
> file size.
> 
> Motivation: When sendfile is provided with 'count' parameter
> value that is greater than the size of the file, kTLS example
> fails to send the file correctly. Last chunk of the file is
> not sent, and the data integrity is compromised.
> The reason is that the last chunk has MSG_MORE flag set
> because of which it gets added to pending records, but is
> not pushed.
> Note that if user space were to send SSL_shutdown control
> message, pending records would get flushed and the issue
> would not happen. So a shutdown control message following
> sendfile can mask the issue.
> 
> Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
> Signed-off-by: Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
> Signed-off-by: Josh Tway <josh.tway@stackpath.com>

Applied, thank you.
