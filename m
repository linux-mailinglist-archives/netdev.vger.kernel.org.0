Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312A64C2EFA
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiBXPIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiBXPIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:08:50 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8391768EE;
        Thu, 24 Feb 2022 07:08:20 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nNFj0-0004yq-2G; Thu, 24 Feb 2022 16:08:10 +0100
Date:   Thu, 24 Feb 2022 16:08:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: fix error code in
 nf_tables_updobj()
Message-ID: <20220224150810.GF28705@breakpoint.cc>
References: <20220224150130.GA6856@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224150130.GA6856@kili>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Set the error code to -ENOMEM instead of leaving it uninitialized.
> 
> Fixes: 33170d18fd2c ("netfilter: nf_tables: fix memory leak during stateful obj update")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Correct, but this commit no longer exists, it was replaced by
dad3bdeef45f81a6e90204bcc85360bb76eccec7,
"netfilter: nf_tables: fix memory leak during stateful obj update"

... which sets err to -ENOMEM.
