Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAFD62D83B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbiKQKjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiKQKjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:39:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6151D8F
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:39:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7353862184
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 10:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CA1C433C1;
        Thu, 17 Nov 2022 10:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668681563;
        bh=/E/Tubw6BE1suhVQUT1+QTHSE+hJ2/kNnDO2Pd5swzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CgeMPYYXVOY+Dn2cS2gSVlCSx3URc4RCPsSePXJxWzkUHwjQaWUH0bRcQJusVwqTT
         3hRrgaucrrDIQs3uYX3SAm/Mu7MrtoApL+6FpyPfQ9pfx6vgRbuCS6mXxX0JGnAUlS
         21h/gkPceR32K430epKsw44Y4DLcV2rPvuBVC4pb3wKJ1zYZDbKCsEufu5awTyPqE1
         867QP80u3VuzWETP+sSVnna2FTB2fyzoPOAbHt3nQS63U808yQZ44hV9b+gdjl/7UM
         2lN/kqJ56nVigEpoygAa0hIT9YQFOhPBjprYvU/ME4yj2DhapftVHWYHELh3ww6Rzw
         arS/lnDAAOlVg==
Date:   Thu, 17 Nov 2022 12:39:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Peter Kosyh <pkosyh@yandex.ru>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH net v2] net/mlx4: Check retval of mlx4_bitmap_init
Message-ID: <Y3YPV4csGxEJ6uSl@unreal>
References: <20221116100806.226699-1-pkosyh@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116100806.226699-1-pkosyh@yandex.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 01:08:06PM +0300, Peter Kosyh wrote:
> If mlx4_bitmap_init fails, mlx4_bitmap_alloc_range will dereference
> the NULL pointer (bitmap->table).
> 
> Make sure, that mlx4_bitmap_alloc_range called in no error case.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: d57febe1a478 ("net/mlx4: Add A0 hybrid steering")
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Please don't add blank lines between tags and your Signed-off-by should
be last.

Thanks
