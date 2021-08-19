Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A0A3F1FBB
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 20:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhHSSQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 14:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234586AbhHSSPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 14:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8E5860F5E;
        Thu, 19 Aug 2021 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629396918;
        bh=MH3KBUsP31Zg149sXGgA9d+b6FiXWMEHwNIc35rZFjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=law/IyVJO9snho3TQ1nA0RaNgWwP+/IY2F2x0iu5I3/o8pM4OIcd04z/bE1hNdVlP
         KjR0Irq3Xf6gOi3I1VEM/i2Tqa2d+W5MuAKKUqn9ZlhFhyZso4A1g6OQGDI4zx9Bgl
         VpExGK/axNjeFAMXIVJFuoPrg2T6v7PovhA/hztxW8VPZ3kH66hJUgFrIoIWzZgDjk
         LCDbr4Z4PpbqqPdeGOyyL1KGyvicfx62Ebpi+k+UxnwRUy4N6stVWUVOPIRovF1xIt
         84xPnT5JOrvoIQRp1UNSElVUPZ9qnmXNvspBjCG0W+MFlUYRjNh4AKb9FZq+u/zmFG
         X+APx0DVcCe4g==
Date:   Thu, 19 Aug 2021 11:15:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>,
        gushengxian <gushengxian@yulong.com>
Subject: Re: [PATCH net] Revert "flow_offload: action should not be NULL
 when it is referenced"
Message-ID: <20210819111516.5b7b7a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <75084a98-f274-9d28-db5f-61eb00492e2a@mojatatu.com>
References: <20210819105842.1315705-1-idosch@idosch.org>
        <75084a98-f274-9d28-db5f-61eb00492e2a@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 07:51:15 -0400 Jamal Hadi Salim wrote:
> On 2021-08-19 6:58 a.m., Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > This reverts commit 9ea3e52c5bc8bb4a084938dc1e3160643438927a.
> > 
> > Cited commit added a check to make sure 'action' is not NULL, but
> > 'action' is already dereferenced before the check, when calling
> > flow_offload_has_one_action().
> > 
> > Therefore, the check does not make any sense and results in a smatch
> > warning:
> > 
> > include/net/flow_offload.h:322 flow_action_mixed_hw_stats_check() warn:
> > variable dereferenced before check 'action' (see line 319)
> > 
> > Fix by reverting this commit.
> > 
> > Cc: gushengxian <gushengxian@yulong.com>
> > Fixes: 9ea3e52c5bc8 ("flow_offload: action should not be NULL when it is referenced")
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>  
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Applied, thanks!
