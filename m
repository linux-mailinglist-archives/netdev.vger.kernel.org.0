Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6A964524D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiLGCxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLGCxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:53:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316D4554CC;
        Tue,  6 Dec 2022 18:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C01EC615A3;
        Wed,  7 Dec 2022 02:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95CAC433C1;
        Wed,  7 Dec 2022 02:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670381610;
        bh=tBMnuZW7dcg8GFGznaGwyHM7+cx2dyG08WXtXUsK3kg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cJabMUMPsVo8D38EkaQxk5sYxXjpYAzogMpqueQB65+HNL49Gh93yZ5WaqAE68ggk
         q5RzrozRRofeQR1lFRtrTx/GjmFkwDdVthl2IdQ2wpHWew+YrfhsqHYUHRRREFH/4P
         jww3QeTm0hyPOm3XC2PxsZGXg+if6K49hBafS3dcFto0YC9+30N/Hjx/lnm0+Sc6/U
         qfbC67HjvBYOOaP3Zq5pz6tyt0HxmlmdL7cgw7xCG65OAtUjA/VznIP6JaGHfr1fkM
         JliUfWL+JM8osei72zT8mvmgs4NIMq0sep7OalWs8nNfwGaQqfy+ylPpuqIVEJEiOJ
         hmRvzIU+5vhxQ==
Date:   Tue, 6 Dec 2022 18:53:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@ieee.org>
Cc:     ye.xingchen@zte.com.cn, davem@davemloft.net, elder@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipa: use sysfs_emit() to instead of scnprintf()
Message-ID: <20221206185329.092e37da@kernel.org>
In-Reply-To: <ff01f296-f3bb-4fdf-d57f-8dd14f1b61d2@ieee.org>
References: <202212021642142044742@zte.com.cn>
        <ff01f296-f3bb-4fdf-d57f-8dd14f1b61d2@ieee.org>
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

On Fri, 2 Dec 2022 16:20:16 -0600 Alex Elder wrote:
> On 12/2/22 2:42 AM, ye.xingchen@zte.com.cn wrote:
> > From: ye xingchen <ye.xingchen@zte.com.cn>
> > 
> > Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> > should only use sysfs_emit() or sysfs_emit_at() when formatting the
> > value to be returned to user space.  
> 
> The buffer passed is non-null and the existing code properly
> limits the buffer to PAGE_SIZE.
> 
> But... OK.
> 
> Reviewed-by: Alex Elder <elder@linaro.org>
> 

Thanks! 38db82e2940 in net-next.
