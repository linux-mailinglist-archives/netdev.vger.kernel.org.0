Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8B1612081
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 07:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJ2FUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 01:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJ2FUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 01:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362FA49B54
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 22:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B826460B97
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 05:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA58CC433C1;
        Sat, 29 Oct 2022 05:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667020809;
        bh=yc+cpXoafFiKuiCwUvDYmZhlurz8pOiMRPn9mvdc4R8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=buUVdrVdFvst/RxQ7fEpGaCU127u9rYi+T7Zo/9hRU4bbUisyKEoSZwlb2A7VeG7B
         QX8zyF7WxXaH5ngGv+nIrXG1IRwq889AZBwPJVY5ck9b90lFm0C8TrIWi2wgH2bnVL
         dKDEEowfFWxLoTFlUOgVekjlO1CIYRT3XdLC2bJiUGvzfZJkmPTVPr6f/7RhFROENx
         djjYwL+fRjZGRk1Q0WSrGs6uT/Lvo4I54bPs8ixye7L2Kpvds9DvJ/Ad9LJoU/IWoI
         7F+Y7XUXJll62Gsl12K0EnM2epNCDo7xoGu7JlkxRynQ0a+P8lkX9YddsZOGWEeB2w
         cCGV4dlh1hrSA==
Date:   Fri, 28 Oct 2022 22:20:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 4/5] net: dropreason: add
 SKB_DROP_REASON_FRAG_REASM_TIMEOUT
Message-ID: <20221028222007.3295e789@kernel.org>
In-Reply-To: <20221028133043.2312984-5-edumazet@google.com>
References: <20221028133043.2312984-1-edumazet@google.com>
        <20221028133043.2312984-5-edumazet@google.com>
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

On Fri, 28 Oct 2022 13:30:42 +0000 Eric Dumazet wrote:
> +	/** @FRAG_REASM_TIMEOUT: fragment reassembly timeout */
> +	SKB_DROP_REASON_FRAG_REASM_TIMEOUT,

I'm guessing the shortened version of the name in the comment
is intentional, but kdoc parsing is not on board :S
