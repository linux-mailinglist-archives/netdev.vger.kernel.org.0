Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8069E693EE2
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 08:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBMHV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 02:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjBMHVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 02:21:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5F81207D
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 23:21:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C9760EA7
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE50C4339B;
        Mon, 13 Feb 2023 07:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676272912;
        bh=YwQ5FxWJt5mxBDiZ6RrEpTG3lGsTHqH52M//RwztC1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=afNgWJZ0+bEJgy+jHBNJkwi4PD36ehMh3CJG95L0qYJYch4CCL5VqkHz7l0oqFNeN
         AI9U/xSWf9cBhM8y0gab0pJSReU3XCk6VwJd6gg6S7dH2CQnW3mEMcDuu8wXWF5AwT
         hjBnplJhwUn+2E94AinQ8G+UhmADQ0QfZ3wzDqqfJGPELz5GhJ99ybUSjG7pkg08xy
         2Qb/gOzsvwgC2eTpG4RM+ee2ZGPwMx68od69tsMsyKAtUlUlwb6MpBI1vXpTJVgqrc
         tkLGgg2gMpKMzWjFxLwGg3m6KkbLyRpxDBkmxG/S3kfI7NMegD9cV9fC1klBrXPbxE
         P9hx99vJpamOg==
Date:   Mon, 13 Feb 2023 09:21:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>
Subject: Re: [PATCH net-next] nfp: ethtool: supplement nfp link modes
 supported
Message-ID: <Y+nlDMU3Bmllbi8R@unreal>
References: <20230210095319.603867-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210095319.603867-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 10:53:19AM +0100, Simon Horman wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Add support for the following modes to the nfp driver:
> 
> 	NFP_MEDIA_10GBASE_LR
> 	NFP_MEDIA_25GBASE_LR
> 	NFP_MEDIA_25GBASE_ER
> 
> These modes are supported by the hardware and,
> support for them was recently added to firmware.
> 
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 12 ++++++++++++
>  drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h |  3 +++
>  2 files changed, 15 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
