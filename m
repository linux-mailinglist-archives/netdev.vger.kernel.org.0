Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBFE627680
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 08:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbiKNHkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 02:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbiKNHj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 02:39:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0328113
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 23:39:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E0C260EE7
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA1BC433B5;
        Mon, 14 Nov 2022 07:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668411597;
        bh=0wUhCIocQy0jsnJGBhfLCv8GPkIdrHinuEkcsdz5j8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kV8lMtx/Sbhp5OX1dwhSgnOQawBOJhuIsTzFyQPcwH3RUxoePH5fgyVvz0mPLvKlm
         Jsr2EKl+71z+Igb4sj3yK6OE22ep59qTCokO0doCZ3fd7mir7M353CS8khxqU2mYIV
         YVAlpYNmUsIJmd/L6fNjIsC6ZuI3WQj+NFZyzWUun7SHzehhkbK2PUXmwTs0M1CTum
         nF81RlDuJ5JuC56xkT1E5n83c7BT6J6JmxOEQHp/ICD3pAbz9GYT6o+RhF0agmSKz5
         8oyghF2WdBsnQMqJ5fYV7s9kwnosObHfx1VSBCQ8eFy5gsmv5iD5zPkll2J4mhQFQ6
         ocmATRg31pPsw==
Date:   Mon, 14 Nov 2022 09:39:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hao Lan <lanhao@huawei.com>
Cc:     lipeng321@huawei.com, shenjian15@huawei.com,
        linyunsheng@huawei.com, liuyonglong@huawei.com,
        chenhao418@huawei.com, wangjie125@huawei.com,
        huangguangbin2@huawei.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        xiaojiantao1@h-partners.com
Subject: Re: [PATCH net 2/3] net: hns3: fix return value check bug of rx
 copybreak
Message-ID: <Y3HwyOlO1FXhiPcS@unreal>
References: <20221112082118.57844-1-lanhao@huawei.com>
 <20221112082118.57844-3-lanhao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112082118.57844-3-lanhao@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 12, 2022 at 04:21:17PM +0800, Hao Lan wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> The refactoring of rx copybreak modifies the original return logic, which
> will make this feature unavailable. So this patch fixes the return logic of
> rx copybreak.
> 
> Fixes: e74a726da2c4 ("net: hns3: refactor hns3_nic_reuse_page()")
> Fixes: 99f6b5fb5f63 ("net: hns3: use bounce buffer when rx page can not be reused")
> 
> Signed-off-by: Jie Wang <wangjie125@huawei.com>

Please delete blank line between Fixes and SOBs, in all three patches.

Thanks
