Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CB56544CD
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLVQGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiLVQGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:06:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CAE1E3EE;
        Thu, 22 Dec 2022 08:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B893B81AFD;
        Thu, 22 Dec 2022 16:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1247BC433D2;
        Thu, 22 Dec 2022 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671725168;
        bh=yH5TY+BXIUX/RtGMIoGIZ/+GUrwkUycltBr89jfW6OA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kZp+YfHMr6wiksQT7I204ywCiQ/ZCYyxBt3oQQsE3m4NctAR1KyfeXd0bD1pXcSMs
         +qOLhFqfhF1VMxRECQ+omYiuj12lydKmKyepy6hkw84uobOuYAErczthwW4KvD868i
         fO6IDDIe4DQ2bpC88iWDHPLw2PLxXqHOW2faAspKG6t2HH5cP/xkpKBiiS2+q3OCjA
         SSPebE58UWcvwt1XcCHG0953ukMg9GhZOCenSGxHct9S3DrE4UBuy7E2X+Zwtyq+eJ
         F7XBzh/oMP63MIPEL7MgurQhO8+kzUkoNTvLeo5HakCDdyHLVfKk2QsIMbpOIX6nMK
         U/WNxYG/bmNPQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [wireless,v2] wifi: wilc1000: fix potential memory leak in
 wilc_mac_xmit()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1668684964-48622-1-git-send-email-zhangchangzhong@huawei.com>
References: <1668684964-48622-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johnny Kim <johnny.kim@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Park <chris.park@atmel.com>,
        Rachel Kim <rachel.kim@atmel.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167172516319.8231.9400853979965474557.kvalo@kernel.org>
Date:   Thu, 22 Dec 2022 16:06:04 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> wrote:

> The wilc_mac_xmit() returns NETDEV_TX_OK without freeing skb, add
> dev_kfree_skb() to fix it. Compile tested only.
> 
> Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Patch applied to wireless-next.git, thanks.

deb962ec9e1c wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1668684964-48622-1-git-send-email-zhangchangzhong@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

