Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83C7250C23
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 01:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgHXXM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 19:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXXM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 19:12:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F775C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 16:12:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A2271291A210;
        Mon, 24 Aug 2020 15:56:09 -0700 (PDT)
Date:   Mon, 24 Aug 2020 16:12:54 -0700 (PDT)
Message-Id: <20200824.161254.2126365846760565009.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     kuba@kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCH] net: Get rid of consume_skb when tracing is off
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200821222329.GA2633@gondor.apana.org.au>
References: <20200821222329.GA2633@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 15:56:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 22 Aug 2020 08:23:29 +1000

> The function consume_skb is only meaningful when tracing is enabled.
> This patch makes it conditional on CONFIG_TRACEPOINTS.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Fair enough, applied, thanks.
