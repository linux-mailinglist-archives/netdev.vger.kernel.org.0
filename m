Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6CE477671
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbhLPP65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbhLPP65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 10:58:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC531C061574;
        Thu, 16 Dec 2021 07:58:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68326B8247B;
        Thu, 16 Dec 2021 15:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6326C36AE0;
        Thu, 16 Dec 2021 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639670334;
        bh=yjju0W3t13Dxgiw22aXO5ZrCo2gj5Ng17Z78/prb7d4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RQNUlTJoc9XcMOuZkd1CvWNyuU1KsobMcb/YnFjJJtQsmb4el9EUj7pgpLPnkc20Y
         kP+Ja+w2OnHCCwEKp/n6X5AZ7Cjm2GFE+D/nd7M3lkQLEsBVOVTsCI0ufUQtMgB44c
         2tSeKL6rbVhTSRqC/nWNzbQ6eyoHyj+JU+dMsGlA85shvNOBM1fdJ3nlFcBGmE90/t
         ceFEJe8+SFnyTCsLLRsBmv4hCgRfo/v3r8zV3MYPsIAlenpIOCB0kyP2Tddi7GPcdw
         ygSyM7Jmyd5Ce18ArUtoNxhSrRnBXaiBnyOF26u3A0Br93JjM9FGtR5L3HW2eKUd+s
         wpBz8T/CotBKQ==
Date:   Thu, 16 Dec 2021 07:58:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wenliang Wang <wangwenliang.1995@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_net: fix rx_drops stat for small pkts
Message-ID: <20211216075853.758c27a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211216031135.3182660-1-wangwenliang.1995@bytedance.com>
References: <20211216031135.3182660-1-wangwenliang.1995@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 11:11:35 +0800 Wenliang Wang wrote:
> We found the stat of rx drops for small pkts does not increment when
> build_skb fail, it's not coherent with other mode's rx drops stat.

Appears to had been applied to net, thanks!
