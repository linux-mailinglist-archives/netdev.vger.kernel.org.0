Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AA95E9C73
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiIZIuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbiIZIu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:50:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482E41B7BE;
        Mon, 26 Sep 2022 01:50:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ocjog-00037R-1a; Mon, 26 Sep 2022 10:50:18 +0200
Date:   Mon, 26 Sep 2022 10:50:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        tgraf@suug.ch, urezki@gmail.com, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Martin Zaharinov <micron10@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
Message-ID: <20220926085018.GA11304@breakpoint.cc>
References: <20220926083139.48069-1-fw@strlen.de>
 <YzFkt744uWI4y3Sv@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzFkt744uWI4y3Sv@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Sep 26, 2022 at 10:31:39AM +0200, Florian Westphal wrote:
> >
> > This patch is partial revert of
> > commit 93f976b5190d ("lib/rhashtable: simplify bucket_table_alloc()"),
> > to avoid kvmalloc for ATOMIC case.
> 
> This patch should just be reverted.  If kvzalloc fails we should
> definitely know about it.

No idea what you mean, I am no mind reader.  Please consider
fixing this yourself, I am done with this crap.
