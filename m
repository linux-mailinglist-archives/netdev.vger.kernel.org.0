Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829BD180BCE
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgCJWnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:43:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgCJWni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:43:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E4FF914C1A0AD;
        Tue, 10 Mar 2020 15:43:37 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:43:37 -0700 (PDT)
Message-Id: <20200310.154337.147777768423868296.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2] flow_offload: use flow_action_for_each in
 flow_action_mixed_hw_stats_types_check()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310101157.5567-1-jiri@resnulli.us>
References: <20200310101157.5567-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 15:43:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue, 10 Mar 2020 11:11:57 +0100

> Instead of manually iterating over entries, use flow_action_for_each
> helper. Move the helper and wrap it to fit to 80 cols on the way.
> 
> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
> ---
> v1->v2:
> - removed action_entry init in loop

Applied, thank you.
