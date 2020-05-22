Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B672D1DF277
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbgEVWwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 18:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgEVWwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:52:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C201CC061A0E;
        Fri, 22 May 2020 15:52:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44D2212744669;
        Fri, 22 May 2020 15:52:21 -0700 (PDT)
Date:   Fri, 22 May 2020 15:52:20 -0700 (PDT)
Message-Id: <20200522.155220.1541483265983849619.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        jiri@resnulli.us, kuba@kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v4 net-next] net: flow_offload: simplify hw stats check
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0f0e052c-fa79-2ac7-8cec-98d4908845d0@solarflare.com>
References: <0f0e052c-fa79-2ac7-8cec-98d4908845d0@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 15:52:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Wed, 20 May 2020 19:18:10 +0100

> Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
>  drivers and __flow_action_hw_stats_check can use simple bitwise checks.
> 
> Pre-fill all actions with DONT_CARE in flow_rule_alloc(), rather than
>  relying on implicit semantics of zero from kzalloc, so that callers which
>  don't configure action stats themselves (i.e. netfilter) get the correct
>  behaviour by default.
> 
> Only the kernel's internal API semantics change; the TC uAPI is unaffected.
> 
> v4: move DONT_CARE setting to flow_rule_alloc() for robustness and simplicity.
> 
> v3: set DONT_CARE in nft and ct offload.
> 
> v2: rebased on net-next, removed RFC tags.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied, thanks Edward.
