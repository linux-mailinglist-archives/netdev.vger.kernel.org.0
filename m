Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C13F5E9C2E
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiIZIhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbiIZIho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:37:44 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510F736848;
        Mon, 26 Sep 2022 01:37:38 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ocjc0-008PUF-0b; Mon, 26 Sep 2022 18:37:13 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Sep 2022 16:37:11 +0800
Date:   Mon, 26 Sep 2022 16:37:11 +0800
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
Message-ID: <YzFkt744uWI4y3Sv@gondor.apana.org.au>
References: <20220926083139.48069-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926083139.48069-1-fw@strlen.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 10:31:39AM +0200, Florian Westphal wrote:
>
> This patch is partial revert of
> commit 93f976b5190d ("lib/rhashtable: simplify bucket_table_alloc()"),
> to avoid kvmalloc for ATOMIC case.

This patch should just be reverted.  If kvzalloc fails we should
definitely know about it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
