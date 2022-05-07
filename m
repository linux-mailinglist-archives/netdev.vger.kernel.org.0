Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB6551E35A
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 03:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350570AbiEGB6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 21:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiEGB6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 21:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC2A61628
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 18:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D8FB60B2D
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 01:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C43DC385A6;
        Sat,  7 May 2022 01:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651888498;
        bh=k0Zl3/xCUKvfS8Inm0eFpxZj7sqNk5pFBa3y7VMp8uM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FVI2FQqM0ArVWq30X5J6ptMjM/6FFHFu6KoJXEHz5vOJljNCg5exXbYcT/tDNj9dm
         A3EVdUs8MD0FlEcivUVc3Nru9Jr7w94EILXnTD17fVLwNhhYr6xpOKUjv4HFwiIt/c
         fGXFc0biq69g4zTTAQXFjDZU29wlqVR4Emhnrs67Rc3lyGjOoW/qy2BH7J9fmE9dhv
         CRj9tysXYUfcMOLyuhm4hJwP4dxnTKlUhb1UsQpWr+NmRAomQZAPLQtwcZiOR461so
         axj3J/00JBmtmJvryzwz3o4u19wBI7GSBaoYkDPRBAxlolgHjVY5L9OJqzjIrv/OBS
         j/JtOnz6BlzYw==
Date:   Fri, 6 May 2022 18:54:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Message-ID: <20220506185457.69cfdbe3@kernel.org>
In-Reply-To: <20220506185405.527a79d4@kernel.org>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
        <20220506153048.3695721-13-eric.dumazet@gmail.com>
        <20220506153414.72f26ee3@kernel.org>
        <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
        <20220506185405.527a79d4@kernel.org>
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

On Fri, 6 May 2022 18:54:05 -0700 Jakub Kicinski wrote:
> Without our patches drivers/net/ethernet/mellanox/mlx5/core/ builds

s/our/your/
