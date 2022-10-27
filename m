Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9160EED6
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiJ0D4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiJ0D4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:56:02 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB8B836F7;
        Wed, 26 Oct 2022 20:56:00 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ontz4-006ryM-E4; Thu, 27 Oct 2022 11:55:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Oct 2022 11:55:46 +0800
Date:   Thu, 27 Oct 2022 11:55:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: [v3 PATCH] af_key: Fix send_acquire race with pfkey_register
Message-ID: <Y1oBQjVr+pf82IUN@gondor.apana.org.au>
References: <000000000000fd9a4005ebbeac67@google.com>
 <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
 <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com>
 <Y1YrVGP+5TP7V1/R@gondor.apana.org.au>
 <Y1Y8oN5xcIoMu+SH@hog>
 <Y1d8+FdfgtVCaTDS@gondor.apana.org.au>
 <Y1k4T/rgRz4rkvcl@hog>
 <Y1n+LM57U3HUHMJa@gondor.apana.org.au>
 <CANn89iLVRq28iMzjKBovyDvytH1ssW_Tp0AjoUbv74dFg2wXWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLVRq28iMzjKBovyDvytH1ssW_Tp0AjoUbv74dFg2wXWQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 08:45:57PM -0700, Eric Dumazet wrote:
>
> SGTM, thanks for the fix.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks Eric!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
