Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0812961EB2B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 07:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiKGGr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 01:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKGGrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 01:47:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830597678;
        Sun,  6 Nov 2022 22:47:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5C0AB80D69;
        Mon,  7 Nov 2022 06:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F27EC433D6;
        Mon,  7 Nov 2022 06:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667803641;
        bh=yh5fyrFAwBEmJYeBF5zKMkqvl5MweZNAs/fAoyl42dA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VVsLhfUoUTyhoQT5p8/khyDGJr6vsXaFWsfsT5AUz+saXp0r6yYqsR6MESzx/BUoI
         27BtTLqomfJs88OrHY8DucTqsKXxDCftjZ0DyaxCk9BSyxLjR6T/HIGAoa69oAZ0JX
         MGv5QHvuy8f6BWSy4gYjGpH75jZtDgnOBRihyGUujsjmnpWtGnDmwgA8L/tmfTdMjd
         SRXNJTDUkIuYBGLqDAXZtNo/fPnkd9XcYM4JTtuuzO1sCvL7oeGOcZAyFhYBVGmrSf
         pqGEE+61VDC/wPjBaw/fE/Dn6sa2oYqhyhCc9A+vCUo+P24sJpOvI2nmzisyfrV0YO
         DHShJ1FX6s+8w==
Date:   Mon, 7 Nov 2022 08:47:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet: alteon: remove unused variable len
Message-ID: <Y2ip9AtkfjkMtEa3@unreal>
References: <20221104174215.242539-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104174215.242539-1-colin.i.king@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 05:42:15PM +0000, Colin Ian King wrote:
> Variable len is being used to accumulate the skb_frag_size but it
> is never used afterwards. The variable is redundant and can be
> removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/alteon/acenic.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

net patches should have target in their title "[PATCH net-next] ...".
It is applicable to all your net patches.

Thanks
