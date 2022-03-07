Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F28B4D03DB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbiCGQSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 11:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244125AbiCGQSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:18:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC8248E53;
        Mon,  7 Mar 2022 08:17:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4267860C3E;
        Mon,  7 Mar 2022 16:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199FBC340EB;
        Mon,  7 Mar 2022 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646669826;
        bh=g7AkI7UmXjqtWe/0nY3r8R1FTcT6BYIuEgvHT7ed2UA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jS6bdkyhDdnlOXciwJ71UjeRz7uCXsBTwcyBL4m2+vLZ4ALa4/pak7K4FPM7Wq219
         lKJ1PnYnJxd53MhCWcP+teEm8/DLCWSx7H1oI0yMOWDo62iVT81CcVJ1EaU8c6aPI2
         VPUBC8hpzXR4POlmZbTWFnkFWCGWBcJIAsDqhphs=
Date:   Mon, 7 Mar 2022 17:17:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Hou Tao <houtao1@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
Message-ID: <YiYv/4EIrx4AV6wi@kroah.com>
References: <20220307091702.378509770@linuxfoundation.org>
 <CA+G9fYtXE1TvxtXZPw++ZkGAUZ4f1rD1tBkMsDb33jsm-C1OZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtXE1TvxtXZPw++ZkGAUZ4f1rD1tBkMsDb33jsm-C1OZw@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 06:30:18PM +0530, Naresh Kamboju wrote:
> drivers/gpu/drm/mediatek/mtk_dsi.c: In function 'mtk_dsi_host_attach':
> drivers/gpu/drm/mediatek/mtk_dsi.c:858:28: error: implicit declaration
> of function 'devm_drm_of_get_bridge'; did you mean
> 'devm_drm_panel_bridge_add'? [-Werror=implicit-function-declaration]
>   858 |         dsi->next_bridge = devm_drm_of_get_bridge(dev,
> dev->of_node, 0, 0);
>       |                            ^~~~~~~~~~~~~~~~~~~~~~
>       |                            devm_drm_panel_bridge_add
> drivers/gpu/drm/mediatek/mtk_dsi.c:858:26: warning: assignment to
> 'struct drm_bridge *' from 'int' makes pointer from integer without a
> cast [-Wint-conversion]
>   858 |         dsi->next_bridge = devm_drm_of_get_bridge(dev,
> dev->of_node, 0, 0);
>       |                          ^
> cc1: some warnings being treated as errors

Offending commit now dropped, thanks.


greg k-h
