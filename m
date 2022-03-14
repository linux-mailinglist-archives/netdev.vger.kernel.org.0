Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6633B4D900A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 00:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbiCNXIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 19:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiCNXIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 19:08:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238903A1BF;
        Mon, 14 Mar 2022 16:07:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nTtmZ-0004Xy-K4; Tue, 15 Mar 2022 00:07:19 +0100
Date:   Tue, 15 Mar 2022 00:07:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <20220314230719.GA16569@breakpoint.cc>
References: <20220312220315.64531-1-pablo@netfilter.org>
 <20220314155440.33149b87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314155440.33149b87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> Minor nit for the future - it'd still be useful to have Fixes tags even
> for reverts or current release fixes so that lowly backporters (myself
> included) do not have to dig into history to double confirm patches
> are not needed in the production kernels we maintain. Thanks!

Understood, will do so next time.

For the record, the tags would have been:

Fixes: 878aed8db324 ("netfilter: nat: force port remap to prevent shadowing well-known ports")
Fixes: 4a6fbdd801e8 ("netfilter: conntrack: tag conntracks picked up in local out hook")
Fixes: 12e4ecfa244b ("netfilter: nf_tables: add register tracking infrastructure")

... all were merged v5.17-rc1 onwards.
