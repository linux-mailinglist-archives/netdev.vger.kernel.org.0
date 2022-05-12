Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680D3524198
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349702AbiELAhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbiELAhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:37:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAA2644F2;
        Wed, 11 May 2022 17:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7886A61E3E;
        Thu, 12 May 2022 00:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E9FC340EE;
        Thu, 12 May 2022 00:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652315853;
        bh=oPbcXmEhIS2MldYy8gY8a6AU2aLINvW3YTd9d/rCGLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NlsU+BCR8KDnQzLfc+DPWNhfx4oexFCV/eV/I1NdGNw8Z78Mmd9ykN4Q4V2ljJXuC
         tLDg0vZ95oB4v0cqH5N3jcfR3GXauNNrkzYHpTnut1dHCNt45wj1KGpBaeVuqGVuhu
         HTFzc1I8uKP+AgZXu5ZAhysK0qfF2TJFvoyXwvMbD8us0RrpjORuckzVEmgDNAnfmW
         6OKOAtO0cNLeePRUZacTtExhBG7GwQA2EoL/c6gwAVBn2MSWKFJ47kPNt+ZOAfkqqo
         8b4OmcXQjGYR6DnEsUsWKjlWmZgEWGWAa0l0rvz7oUcouO6lA6Fy1CqnzCnOTziJvk
         2D1JYnSFWV9Sw==
Date:   Wed, 11 May 2022 17:37:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v5 3/3] ptp: clockmatrix: miscellaneous cosmetic
 change
Message-ID: <20220511173732.7988807e@kernel.org>
In-Reply-To: <1652279114-25939-3-git-send-email-min.li.xe@renesas.com>
References: <1652279114-25939-1-git-send-email-min.li.xe@renesas.com>
        <1652279114-25939-3-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 10:25:14 -0400 Min Li wrote:
> suggested by Jakub Kicinski
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_clockmatrix.c | 69 +++++++++++++------------------------------
>  1 file changed, 20 insertions(+), 49 deletions(-)

Not what I meant. I guess you don't speak English so no point trying to
explain. Please resend v4 and we'll merge that. v5 is not better.
