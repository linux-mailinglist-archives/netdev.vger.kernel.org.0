Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4BE6672CC
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 14:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbjALNBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 08:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbjALNAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 08:00:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6542157900;
        Thu, 12 Jan 2023 04:58:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7392D60AC6;
        Thu, 12 Jan 2023 12:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECCEC433EF;
        Thu, 12 Jan 2023 12:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673528293;
        bh=D3nneqHedZvyKHPM/6g/ukFvUrU8cEN4MzJmLMER4WQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EKgIOzeDfF66LR9/+ePXrH9jj5zH5Qu+kEYGRgxRaK5znqZKlNXVepAK/pD/bhnym
         RFGBt0mLv9t6Rrpq9B5CxPXif0hrp+Yj4EX4KT0NyinNAKskgM1FKBzjblv1Lx5jjC
         pqPhBKes99TzMlyJJZXBkwt17NITK7BCihKt4hwA=
Date:   Thu, 12 Jan 2023 13:58:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 0/1] mt76: move mt76_init_tx_queue in common code
Message-ID: <Y8AD4jdyOpqrPT9a@kroah.com>
References: <20230112115850.9208-1-n.zhandarovich@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112115850.9208-1-n.zhandarovich@fintech.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 03:58:49AM -0800, Nikita Zhandarovich wrote:
> Svace has identified unchecked return value of mt7615_init_tx_queue
> function in 5.10 branch, even though it makes sense to track it
> instead. This issue is fixed in upstream version by Lorenzo's patch.
> 
> The same patch can be cleanly applied to the 5.10 branch.

I do not understand, what issue/bug does this fix?  And how can you
trigger it?  And why only worry about the 5.10.y kernel branch?

thanks,

greg k-h
