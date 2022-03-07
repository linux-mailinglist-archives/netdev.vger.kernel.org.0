Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A884CFD39
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiCGLot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiCGLot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:44:49 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D072356C39;
        Mon,  7 Mar 2022 03:43:54 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nRBm4-0006DZ-WB; Mon, 07 Mar 2022 12:43:37 +0100
Date:   Mon, 7 Mar 2022 12:43:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        roopa@nvidia.com, razor@blackwall.org, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] netfilter: bridge: clean up some inconsistent indenting
Message-ID: <20220307114336.GA21350@breakpoint.cc>
References: <20220307004149.25171-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307004149.25171-1-jiapeng.chong@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:
> Eliminate the follow smatch warning:
> 
> net/bridge/netfilter/nf_conntrack_bridge.c:385 nf_ct_bridge_confirm()
> warn: inconsistent indenting.

Applied to nf-next, thanks.
