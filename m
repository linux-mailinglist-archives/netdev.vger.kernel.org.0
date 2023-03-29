Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78456CF211
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjC2SVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2SVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:21:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D447749D5;
        Wed, 29 Mar 2023 11:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B08061D6F;
        Wed, 29 Mar 2023 18:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A421C433D2;
        Wed, 29 Mar 2023 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680114102;
        bh=9PtUOZiKZ8i7ysVO6JVy+v53+cNNGqvHMWdAAkjxnd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PqY8z812HDa1h/OBeBoEL6Nt+26vtPX5jfEhOzhyO6toxGjqfSJrgdC+Gz9UUDpD2
         weTdI7vEu3GlrMcVv5/Ump/76LTDNUTQ3UVPFVPpUfb1Em45usn7msRCf3iVq9BS48
         aEsSTBUSDm2kLW8sRshOat8tr73NpiBixXZ14mbg3pj85TJ+yUP7vojpxczeO8aKeS
         6QkFvd8Ht8h8CTjOgJexbCcCRkt7UxzP3ZAEldKrAVTstlcrOOIhD71qbnsYIXrI7g
         se5fKq5Lu65RUAH3+pCZa4Pcvqp0fhygef6IL/6Zw1+f3mEb/JU/NhJrr7uAAmZKOT
         1s4BhWkMcyEUw==
Date:   Wed, 29 Mar 2023 21:21:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Veerasenareddy Burru <vburru@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] octeon_ep: unlock the correct lock on error path
Message-ID: <20230329182138.GX831478@unreal>
References: <251aa2a2-913e-4868-aac9-0a90fc3eeeda@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <251aa2a2-913e-4868-aac9-0a90fc3eeeda@kili.mountain>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 09:51:37AM +0300, Dan Carpenter wrote:
> The h and the f letters are swapped so it unlocks the wrong lock.
> 
> Fixes: 577f0d1b1c5f ("octeon_ep: add separate mailbox command and response queues")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Thees vairable nmaes are terirble.  The huamn mnid deos not raed ervey
> lteter by istlef, but the wrod as a wlohe.
> 
> https://www.dictionary.com/e/typoglycemia/
> 
>  drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
