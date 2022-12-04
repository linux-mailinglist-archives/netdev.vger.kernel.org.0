Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C344641CE6
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 13:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiLDM3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 07:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDM3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 07:29:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B27201;
        Sun,  4 Dec 2022 04:29:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CAC760110;
        Sun,  4 Dec 2022 12:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0DBC433C1;
        Sun,  4 Dec 2022 12:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670156957;
        bh=Cd45dw6/fKlmTx5ULGNx6W47Kn4QFo/Ra8RmCHB0WkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H2dBtc4n8sAYJRidEY+DG8umS0NcxsWlxGIhAKevjyXSwbxeotVCndv7+sMI4gCzf
         cRjDnFK0kzpyhyJMZY8F5JLEoL6aMaOe9mUn9UCvp12tLYyNsSNyzm0yp91gQe8AHE
         e2Mw/aaxRKLjKK919Ex8qLsqLgIeKr+VcxT6p8AbAc4nOJ0zWrIktpT06EiPuFvKje
         YXTOEMPwcnL5nE4yGjPUULOUT68TVUOizpR31Km393FTKtR+BcwEYXj+tt3YRqCOOf
         LI3ypEIIAb878V0htcSi/SC6x/A94rTxnjFP0GjShO9brneSSCLrC3JLrK868u/Yy/
         qSZ4x4yxoc7YA==
Date:   Sun, 4 Dec 2022 14:29:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     ye.xingchen@zte.com.cn
Cc:     davem@davemloft.net, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, khalasa@piap.pl,
        shayagr@amazon.com, wsa+renesas@sang-engineering.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: use sysfs_emit() to instead of scnprintf()
Message-ID: <Y4ySkvSn+imvDy0d@unreal>
References: <202212021632208664419@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212021632208664419@zte.com.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 04:32:20PM +0800, ye.xingchen@zte.com.cn wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  drivers/net/ethernet/sfc/efx_common.c       | 2 +-
>  drivers/net/ethernet/sfc/siena/efx_common.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Please use [PATCH net-next] ... format in title.

Thanks
