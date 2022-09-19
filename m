Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353AE5BD211
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiISQTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiISQTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:19:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B705C30F5B;
        Mon, 19 Sep 2022 09:19:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oaJUE-0000tt-O3; Mon, 19 Sep 2022 18:19:10 +0200
Date:   Mon, 19 Sep 2022 18:19:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf 0/2] netfilter: conntrack: fix the gc rescheduling
 delay
Message-ID: <20220919161910.GK1023@breakpoint.cc>
References: <20220916092941.39121-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916092941.39121-1-atenart@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Antoine Tenart <atenart@kernel.org> wrote:
> Antoine Tenart (2):
>   netfilter: conntrack: fix the gc rescheduling delay
>   netfilter: conntrack: revisit the gc initial rescheduling bias

Series:
Reviewed-by: Florian Westphal <fw@strlen.de>
