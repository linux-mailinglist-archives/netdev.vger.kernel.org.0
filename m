Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF8160EEC8
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJ0DnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJ0DnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:43:04 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CF314EC67;
        Wed, 26 Oct 2022 20:43:02 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ontmJ-006roG-VJ; Thu, 27 Oct 2022 11:42:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Oct 2022 11:42:36 +0800
Date:   Thu, 27 Oct 2022 11:42:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: [v3 PATCH] af_key: Fix send_acquire race with pfkey_register
Message-ID: <Y1n+LM57U3HUHMJa@gondor.apana.org.au>
References: <000000000000fd9a4005ebbeac67@google.com>
 <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
 <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com>
 <Y1YrVGP+5TP7V1/R@gondor.apana.org.au>
 <Y1Y8oN5xcIoMu+SH@hog>
 <Y1d8+FdfgtVCaTDS@gondor.apana.org.au>
 <Y1k4T/rgRz4rkvcl@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1k4T/rgRz4rkvcl@hog>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 03:38:23PM +0200, Sabrina Dubroca wrote:
>
> LGTM, thanks.
> 
> Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Thanks for the review and comments!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
