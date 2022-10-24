Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D32609FC6
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 13:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJXLIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 07:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiJXLIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 07:08:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0203C224
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 04:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2516120C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88909C433D6;
        Mon, 24 Oct 2022 11:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666609700;
        bh=S6g/jZwsqvjn+/jF6IMhI5qEa664pnsVMr0MGuVqJMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gr+tCBUemGndrY4iaRQDT+IzwlrNGALNnX+ex38ExlFlybzPcjBrgg1rUx9XKDHN4
         yBJic2AwDyUvY4z/JQWfbm4niC7YoVjAQIWVLWB4XxSPDmD9Kpy7CCsgNg0qly+mjb
         MtJteSWerNCPWcaxRPx1X9aE05E73O98lWllveFLEyT3n9gm2HFpx7jz81yWfqFQqQ
         e8w+i5s0n2KXy79FWIDiRQCqRA91nbX4XymgeIYsuoGIiD9J62/NEyGPwUlrT8PGMT
         Iqs5f7Rh6hK8fK9/E+E/FxY1pkvS2WE1Z26u6ifMH2635dFXuMgG1oI2hqEJQhRmfy
         WuY/Lz32OheIQ==
Date:   Mon, 24 Oct 2022 12:08:16 +0100
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][V2 net 00/16] mlx5 fixes 2022-10-14
Message-ID: <20221024110816.anp6pxu2tjowizh7@sx1>
References: <20221024061220.81662-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221024061220.81662-1-saeed@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Oct 07:12, Saeed Mahameed wrote:
>From: Saeed Mahameed <saeedm@nvidia.com>
>
>This series provides bug fixes to mlx5 driver.
>Please pull and let me know if there is any problem.
>
>v1->v2:
>  add missing sign-off.
>

Please don't pull yet, I will submit V3 since one patch needs to be fixed.
Sorry about the clutter.

