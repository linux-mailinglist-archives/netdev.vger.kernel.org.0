Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CFF5E9E0A
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiIZJkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbiIZJkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 05:40:18 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D6A46D85;
        Mon, 26 Sep 2022 02:37:43 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ockYC-008REy-30; Mon, 26 Sep 2022 19:37:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Sep 2022 17:37:19 +0800
Date:   Mon, 26 Sep 2022 17:37:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, tgraf@suug.ch, urezki@gmail.com,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Martin Zaharinov <micron10@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
Message-ID: <YzFyz5FWn50rhLsH@gondor.apana.org.au>
References: <20220926083139.48069-1-fw@strlen.de>
 <YzFkt744uWI4y3Sv@gondor.apana.org.au>
 <20220926085018.GA11304@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926085018.GA11304@breakpoint.cc>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 10:50:18AM +0200, Florian Westphal wrote:
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Mon, Sep 26, 2022 at 10:31:39AM +0200, Florian Westphal wrote:
> > >
> > > This patch is partial revert of
> > > commit 93f976b5190d ("lib/rhashtable: simplify bucket_table_alloc()"),
> > > to avoid kvmalloc for ATOMIC case.
> > 
> > This patch should just be reverted.  If kvzalloc fails we should
> > definitely know about it.
> 
> No idea what you mean, I am no mind reader.  Please consider
> fixing this yourself, I am done with this crap.

I just meant that the patch quoted above should be completely
reverted instead of partially reverted.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
