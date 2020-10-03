Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F13D28206D
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 04:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJCCLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 22:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJCCLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 22:11:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC164C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 19:11:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 337A012638BA3;
        Fri,  2 Oct 2020 18:54:51 -0700 (PDT)
Date:   Fri, 02 Oct 2020 19:11:38 -0700 (PDT)
Message-Id: <20201002.191138.1022500168699346347.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v3 0/9] genetlink: support per-command policy
 dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002215000.1526096-1-kuba@kernel.org>
References: <20201002215000.1526096-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 18:54:51 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri,  2 Oct 2020 14:49:51 -0700

> The objective of this series is to dump ethtool policies
> to be able to tell which flags are supported by the kernel.
> Current release adds ETHTOOL_FLAG_STATS for dumping extra
> stats, but because of strict checking we need to make sure
> that the flag is actually supported before setting it in
> a request.
> 
> Ethtool policies are per command, and so far only dumping
> family policies was supported.
> 
> The series adds new set of "light" ops to genl families which
> don't have all the callbacks, and won't have the policy.
> Most of families are then moved to these ops. This gives
> us 4096B in savings on an allyesconfig build (not counting
> the growth that would have happened when policy is added):
> 
>      text       data       bss        dec       hex
> 244415581  227958581  78372980  550747142  20d3bc06
> 244415581  227962677  78372980  550751238  20d3cc06
> 
> Next 5 patches deal the dumping per-op policy.
 ...

Series applied, thanks Jakub.
