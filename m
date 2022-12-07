Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C680D64580B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiLGKhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiLGKhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:37:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5CB2D1C3;
        Wed,  7 Dec 2022 02:37:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 060D0612B7;
        Wed,  7 Dec 2022 10:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC726C433D6;
        Wed,  7 Dec 2022 10:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670409439;
        bh=r4Ky0VEt4IYt4gEBJ+qBI3AQnvtdo/WFFF7dgMzFhug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sqfwCpBO6fkO/RGC8pNiSfmwT/JWpBq8bl02+gAakEJYTnKMSpW/P6+BqemNmwmNS
         GrvQJau3t6+FO9+1jYSlpIfHQgv7s6OqsKjSbDpw7rTECOFrBGeWcyeFO/6uinI01t
         OQi8BGR0DhnONgl4fefLQl66DnxcTb0qpv2BBU5YC4yNkRtt0bq2NNbIyGzqF9NPrT
         DtuFNbr4OYW+r0JiQmJgdSZ4qgVfTg3wYWR1XlLMqbgwrZR8yezoKdk81zJo+JkiUd
         DpYsexFHtVJEvvRffhADDfeID5uEV/cGS4aA4ro9W99uJ4gHiOGfh3+qiyJntLxWQx
         U/QS7CvdaY3ng==
Date:   Wed, 7 Dec 2022 12:37:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] xfrm: Fix spelling mistake "oflload" -> "offload"
Message-ID: <Y5Bs28CaQwXRLFB+@unreal>
References: <20221207092314.2279009-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207092314.2279009-1-colin.i.king@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 09:23:14AM +0000, Colin Ian King wrote:
> There is a spelling mistake in a NL_SET_ERR_MSG message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  net/xfrm/xfrm_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
