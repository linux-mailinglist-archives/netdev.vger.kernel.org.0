Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20C420202E
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732654AbgFTDXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732641AbgFTDXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:23:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB68C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:23:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A70DD1278CEB8;
        Fri, 19 Jun 2020 20:23:17 -0700 (PDT)
Date:   Fri, 19 Jun 2020 20:23:17 -0700 (PDT)
Message-Id: <20200619.202317.2242703981963330658.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, willemb@google.com
Subject: Re: [PATCH net v2] selftests/net: report etf errors correctly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618164043.60618-1-willemdebruijn.kernel@gmail.com>
References: <20200618164043.60618-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 20:23:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 18 Jun 2020 12:40:43 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> The ETF qdisc can queue skbs that it could not pace on the errqueue.
> 
> Address a few issues in the selftest
> 
> - recv buffer size was too small, and incorrectly calculated
> - compared errno to ee_code instead of ee_errno
> - missed invalid request error type
> 
> v2:
>   - fix a few checkpatch --strict indentation warnings
> 
> Fixes: ea6a547669b3 ("selftests/net: make so_txtime more robust to timer variance")
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied, thanks Willem.
