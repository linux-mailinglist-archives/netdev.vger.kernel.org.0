Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77150628FF6
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 03:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiKOCe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 21:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbiKOCdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 21:33:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA293AB;
        Mon, 14 Nov 2022 18:33:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A1AEB811FF;
        Tue, 15 Nov 2022 02:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D485FC433D7;
        Tue, 15 Nov 2022 02:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668479605;
        bh=arWWnXNyckh53wt46pLNwjigmsa726WXb0yla1rWH2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lmr5It+r7k82nBnQZkLsFlM7R6e70zyPYUIJmSo+MeuBaTN3bKzWu7dtyVRJNyuN1
         au3kioDCZwEovI3EAR63XA2Dbyou73KD7gqWSb5yAyi3NdWWeXa3IipU3ov7IzNdHG
         GZnfEwkSjfBf47XnTP3qUgi4myRtrflpjqh0MyFHuHpoWKd7EIFT31UKPdIgAgwF66
         gYlSH0B+ArxQJoLWnzQMa0f3dSlpfKg1STajGi0MiuKbmewphezOe2TmtqAumEaoyW
         UVhrGFMEgzfnWQ0pnDXaIp6pedheKq6lwTn9h+sQK5r7Z16WI7fBbgoNmCsJ0xDpWX
         uQ7qec5DQpr0w==
Date:   Mon, 14 Nov 2022 18:33:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sundance: remove unused variable cnt
Message-ID: <20221114183323.54d81387@kernel.org>
In-Reply-To: <20221114170317.92817-1-colin.i.king@gmail.com>
References: <20221114170317.92817-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Nov 2022 17:03:17 +0000 Colin Ian King wrote:
> Variable cnt is just being incremented and it's never used
> anywhere else. The variable and the increment are redundant so
> remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Once you've noticed that I'm tossing all your networking changes from
patchwork - the reason is that you seem to have ignored completely 
one of my replies and also recent review comments from Leon. 
