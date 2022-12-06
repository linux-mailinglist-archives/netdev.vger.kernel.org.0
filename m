Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6C3643E0C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiLFIF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiLFIF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:05:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777711A07B;
        Tue,  6 Dec 2022 00:05:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1D10615A5;
        Tue,  6 Dec 2022 08:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801B2C433C1;
        Tue,  6 Dec 2022 08:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670313924;
        bh=iU1nTlIIFsG8ZExX8X4Ya6XC5By7z1nDy14hkZt+HlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOkFwdZ9ZIcz3j3JA396Ocj7KcLySwy0uvUe0vny0Pbrw2dintYZnayHReK1EhVQi
         Pa8y7fcxDDBECOkCEY3j8aoNT7/YQ8K2nsdKCzMCYiJo0I9rBrTPLr7Pbzh7fQGkNm
         JxzWLkT/jo1gRaGKdZco+3/Ik4bou2vxG6PlfhjQwx9jOGjIB/qBIH31US0kZBpu02
         NRccyX7ouPX3bCi18DxAG5Gt3MiQBRHKIsIXzGwtvFr0iinYX5Vu7RSlICr9NI4Wjr
         hNfR2L5oVFmbd2ymCn799tjukAvqYSY5KYl/pRpYPrvtHX0itxybvgIpwvhaWw6Zwb
         a09pbej5VmOpA==
Date:   Tue, 6 Dec 2022 10:05:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     ye.xingchen@zte.com.cn
Cc:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, richardbgobert@gmail.com, iwienand@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: use sysfs_emit() to instead of
 scnprintf()
Message-ID: <Y473v/0z/YlTRzoT@unreal>
References: <202212051918564721658@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212051918564721658@zte.com.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 07:18:56PM +0800, ye.xingchen@zte.com.cn wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  net/ethernet/eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
