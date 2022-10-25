Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F6460D742
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiJYWkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiJYWkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649816B8D3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 15:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B536A61BD4
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 22:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4C4C433D6;
        Tue, 25 Oct 2022 22:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666737605;
        bh=QsLmNQLK9hrQ+9w+DGymM2b2NqUKEtn19jUXECHyZNM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oby3UgqXWtt3rznL3m+4YgqhxRbxTKnQj69atceDrteKQp9/THJmL7oI2EcVnL/+p
         9Zgb3k4BQdD0N0XN9ECjCd0VZxB0zyq9SV7KXBl4wQMCwMBMGFrxMzRn4pvrvbPvLv
         xY4hvkOOHWED5HA69HutQ6Nmf1d2nPC801KrIAA0p+Xu0ZDDgF/UraynAYw5ZRa3R8
         UfusV25HfnGDGreiCBQC9FBs1Qvv4o9OdQn5V280ksllhvykew7wq8aUkfHCSisCkq
         KJwGUbiOCfe9igfUEElgcDfdYFry6s2cQ9MAnjtZybH0ft2p3iJWq5ApkAHp4Q+qMj
         Lfci2h0I73j/g==
Date:   Tue, 25 Oct 2022 15:40:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        hch@lst.de, kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com,
        smalin@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        borisp@nvidia.com, aurelien.aptel@gmail.com, malin1024@gmail.com
Subject: Re: [PATCH v7 02/23] iov_iter: DDP copy to iter/pages
Message-ID: <20221025154003.686cb8b1@kernel.org>
In-Reply-To: <20221025135958.6242-3-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-3-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 16:59:37 +0300 Aurelien Aptel wrote:
> Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
> Signed-off-by: Boris Pismenny <borisp@nvidia.com>
> Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
> Signed-off-by: Yoray Zack <yorayz@nvidia.com>
> Signed-off-by: Shai Malin <smalin@nvidia.com>
> Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>

Great stuff :) Please get someone who matters to ack this.

> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  lib/iov_iter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index c3ca28ca68a6..75470a4b8ab3 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -526,7 +526,7 @@ size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
>  		might_fault();
>  	iterate_and_advance(i, bytes, base, len, off,
>  		copyout(base, addr + off, len),
> -		memcpy(base, addr + off, len)
> +		(base != addr + off) && memcpy(base, addr + off, len)
