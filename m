Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798DE62A0D7
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiKOR6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiKOR6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:58:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A152F384;
        Tue, 15 Nov 2022 09:58:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9271EB81A59;
        Tue, 15 Nov 2022 17:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1333C433C1;
        Tue, 15 Nov 2022 17:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668535080;
        bh=r+VsSBM+QYb6w/Ek8eu6bcQf54b1Y5QWvU3cDpX9LNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hj7bWcXJRCksnAEVm6gl+AfPsPKZ6ZVs14dsP9fI7w/2ybEI3hWNKJD/gS4gHN3IU
         jWGDTVRj7pJWCej981ZPeSjwqr4U9eKrPeGao2c2Q+Fj0tW/5Wm6qbV/24AHy6Efpt
         ru0mS0An2jobJPXQzcyx2WtIZMCW+ToO4tAcubU6/dOT978kG61pOq6hSIWbcZjdbU
         l+ABBf96ki0vJwaYhm4Y3hKOK260YURrNSL30/sB8fhaNr0n6NlZeGnSqZ7BnpgYSs
         Sudr26d9vT83DSJW9vhFS+brcvuC9WKDpGvHnEufWgkVS7KZCaYIwUYxLkHsgGfEMl
         kZlUtPwhlvo2Q==
Date:   Tue, 15 Nov 2022 09:57:55 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev
Subject: Re: [PATCH v4 0/2] net: fec: add xdp and page pool statistics
Message-ID: <Y3PTI/ma2JexAGff@x130.lan>
References: <20221115155744.193789-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221115155744.193789-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 09:57, Shenwei Wang wrote:
> Changes in V4:
> - Using u64 to record the XDP statistics
> - Changing strncpy to strscpy
> - Remove the "PAGE_POOL_STATS" select per Alexander's feedback
> - Export the page_pool_stats definition in the page_pool.h
>

Reviewed-by: Saeed Mahameed <saeed@kernel.org>

