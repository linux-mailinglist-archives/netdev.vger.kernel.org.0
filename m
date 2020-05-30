Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4B21E8C8F
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgE3Abt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3Abt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 20:31:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7A6C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 17:31:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF3011287B53E;
        Fri, 29 May 2020 17:31:48 -0700 (PDT)
Date:   Fri, 29 May 2020 17:31:47 -0700 (PDT)
Message-Id: <20200529.173147.1268428540138119531.davem@davemloft.net>
To:     fw@strlen.de
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: tcp_init_buffer_space can be static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528220152.3999-1-fw@strlen.de>
References: <20200528220152.3999-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 17:31:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Fri, 29 May 2020 00:01:52 +0200

> As of commit 98fa6271cfcb
> ("tcp: refactor setting the initial congestion window") this is called
> only from tcp_input.c, so it can be static.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian.
