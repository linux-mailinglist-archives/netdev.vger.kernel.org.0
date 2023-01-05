Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D407365EBBD
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbjAENCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbjAENBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:01:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB005B17D;
        Thu,  5 Jan 2023 05:01:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C114B81ADD;
        Thu,  5 Jan 2023 13:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76597C433D2;
        Thu,  5 Jan 2023 13:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672923704;
        bh=D+P1416zC83o6ONjBzuZK93GoGpMJCp5lUzX1gzDVCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j8CSJ9Qt2cAsFYxZDzw4v+2j6WRcH2fHX4DJTgFbnA4yKrfG2uhyVD4ph6xKiPp3v
         zbTMiXY7xhTFv4jc1AVpxFpnmrpAavyXaaDKqQJ+D9sfp4jgnL4BiwPBKrcetwlYqR
         H9ZpZNQt8nmTPIXqfrHx6kXnBh1ECY2XM1dAn7TZ8pS4jMpxnb2TeOyBKoG4cUJAd3
         uI5q4bV9v/7ygKWToR9metRWC9o5LI7HrMMa55j32Ww9S3XZacFU2/FxM39bqeRf1s
         gpWrav6J/MH3eDReycDfhi6AwcnZlOBNwqSj4ETQnLnfTmRAUVIa35scuhchDpvdKU
         9efsejJHtM0Qw==
Date:   Thu, 5 Jan 2023 15:01:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wifi: rtw89: Add missing check for alloc_workqueue
Message-ID: <Y7bKM1xca+Gmd7uw@unreal>
References: <20230104142901.1611-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104142901.1611-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 10:29:01PM +0800, Jiasheng Jiang wrote:
> Add check for the return value of alloc_workqueue since it may return
> NULL pointer.
> Moreover, add destroy_workqueue when rtw89_load_firmware fails.
> 
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
> CHangelog:
> 
> v1 -> v2:
> 
> 1. Add destroy_workqueue when rtw89_load_firmware fails.
> ---
>  drivers/net/wireless/realtek/rtw89/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
