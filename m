Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17A56944BD
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjBMLlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjBMLlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:41:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD70BCC0E
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 03:41:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B36A60FA7
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 11:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1D2C433EF;
        Mon, 13 Feb 2023 11:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676288459;
        bh=1c6wVaIuQwFg1mN5/nAeS6kiBQCHi+yqDVl8G0L+190=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sz6Yj2dn7flfyH2cPkCPGNMCdSotv8qYLEYyzrFzKz+JkwMw9aVevy1QUEYLokM4x
         fRQ3cjsPeA9QgrptzbpOljuOykmgxvzy6XXyDZqXqaVta4L7X6YMyiax0smj0BAIrk
         asENbNTG0S8mTQ+jkh8rPUME9HpHEMA0k5FvrB6u9Qovb/lUOLIPKIibeSC2qjppeA
         sGaXkMGQu/eamBXkdSnVHu1y1WUATtKR+B5gl8EzsER/kHqwYV/sdw83xo6OG/IF3d
         MPvlfRlMxwg3W40Yrdxzf609pbrNx10Akcwnc6VUgC53tg3lEevBHZ0ekT0ljh48e+
         VUepE1QviVd/g==
Date:   Mon, 13 Feb 2023 13:40:55 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v2] net: wangxun: Add base ethtool ops
Message-ID: <Y+ohx72uaMxnkxLr@unreal>
References: <20230213095959.55773-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213095959.55773-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 05:59:59PM +0800, Mengyuan Lou wrote:
> Add base ethtool ops get_drvinfo for ngbe and txgbe.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
> Change log:
> v2:
> - Remove dot in the patch subject.
> - Remove MODULE_LICENSE() in wx_ethtool.c
> 
>  drivers/net/ethernet/wangxun/libwx/Makefile   |  2 +-
>  .../net/ethernet/wangxun/libwx/wx_ethtool.c   | 27 +++++++++++++++++++
>  .../net/ethernet/wangxun/libwx/wx_ethtool.h   |  9 +++++++
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |  1 +
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  5 ++++
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  3 +++
>  6 files changed, 46 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
>  create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.h
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
