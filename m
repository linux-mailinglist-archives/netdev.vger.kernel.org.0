Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28A7637516
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKXJZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiKXJZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:25:49 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6AF11605A;
        Thu, 24 Nov 2022 01:25:47 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oy8UK-000Muy-51; Thu, 24 Nov 2022 17:25:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Nov 2022 17:25:44 +0800
Date:   Thu, 24 Nov 2022 17:25:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     tgraf@suug.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH v2] lib/test_rhashtable: Remove set but unused variable
 'insert_retries'
Message-ID: <Y384mIpMqUbwlR+i@gondor.apana.org.au>
References: <20221123093702.32219-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123093702.32219-1-jiapeng.chong@linux.alibaba.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 05:37:02PM +0800, Jiapeng Chong wrote:
> Variable 'insert_retries' is not effectively used in the function, so
> delete it.
> 
> lib/test_rhashtable.c:437:18: warning: variable 'insert_retries' set but not used.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3242
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> Changes in v2:
>   -The condition for modifying err is less than 0.
> 
>  lib/test_rhashtable.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
