Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B751B64AA
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgDWTnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWTnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:43:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762F4C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:43:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2864E1277C57A;
        Thu, 23 Apr 2020 12:43:40 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:43:39 -0700 (PDT)
Message-Id: <20200423.124339.503368247240713467.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, lrizzo@google.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/3] net: napi: addition of
 napi_defer_hard_irqs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422161329.56026-1-edumazet@google.com>
References: <20200422161329.56026-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:43:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 22 Apr 2020 09:13:26 -0700

> This patch series augments gro_glush_timeout feature with napi_defer_hard_irqs
> 
> As extensively described in first patch changelog, this can suppresss
> the chit-chat traffic between NIC and host to signal interrupts and re-arming
> them, since this can be an issue on high speed NIC with many queues.
> 
> The last patch in this series converts mlx4 TX completion to
> napi_complete_done(), to enable this new mechanism.

Series applied, thanks Eric.
