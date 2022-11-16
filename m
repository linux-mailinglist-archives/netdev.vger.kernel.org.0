Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299B062B25C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 05:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiKPEcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 23:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKPEcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 23:32:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CDA14D35
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 20:32:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DBFE618F5
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 04:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683BDC433C1;
        Wed, 16 Nov 2022 04:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668573126;
        bh=9EaAk9UU/LEa9ZcANhz8NX+T3x0yd1l3KBfVsh2Y/0o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b0FzGSlyaOhMW+DwH897SVliQ2U1mCxESe0LY7kr+5nmeNY2ROJDc6ppJwqjWcOW6
         JCeIxic0nvlAMZKF2K5hOcXK2DQBIgzWqQypfvDfrpceDX4Rigrv1bYf7tpaCH+zn5
         T85ocCpmoqjt4fBuahEyiYNyJKU75GBsk0qVv3CW9hmnfMq/+ypDobbtoEpgfxl6Cj
         /WRenR7cncm0NYLpXwgLtt8LDiB9fFwOSlzj1c3jnRSLGAwCiur99RuMmyuSbeJFSP
         DfjidzdtlMjEnMnmBTGswDP39285N2TFmz9o8YRUWBBfcb5+s5oIq6c4mBWp1AA2cC
         jcf8wwNfkmUyg==
Date:   Tue, 15 Nov 2022 20:32:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peter Kosyh <pkosyh@yandex.ru>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] net/mlx4: Check retval of mlx4_bitmap_init
Message-ID: <20221115203205.0c55ceee@kernel.org>
In-Reply-To: <20221115095356.157451-1-pkosyh@yandex.ru>
References: <20221115095356.157451-1-pkosyh@yandex.ru>
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

On Tue, 15 Nov 2022 12:53:56 +0300 Peter Kosyh wrote:
> If mlx4_bitmap_init fails, mlx4_bitmap_alloc_range will dereference
> the NULL pointer (bitmap->table).
> 
> Make sure, that mlx4_bitmap_alloc_range called in no error case.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>

Please repost with an appropriate Fixes: tag and [PATCH net] in the
subject. Please keep Tariq's review tag.
