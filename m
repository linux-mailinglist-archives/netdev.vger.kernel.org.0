Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD2C643C10
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 05:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLFEGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 23:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbiLFEGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 23:06:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD9322BC0
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 20:06:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F1D8CE1732
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39FFC433C1;
        Tue,  6 Dec 2022 04:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670299573;
        bh=9U3j7hSH4wqOdBO3aTet59xyKCFfbzxpZ7Q1SJSaPMc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uw/Ml6Du6NcyFZ9wa3qD0fzoQ56XWq4dO8JUPuipzqE2QdLRvXGMqVyI3v1wcgyrd
         c0Toj38+0QlYS+N2e/EJjjGti1F+mhnGcWkQUqbQOIhWPQwaBGzYEnXhNghu13hB8U
         DQxN9zMXXq1B0nKS/MTwrJfU9jvs+y0t1b5HdNRCsX4uXQbGZ26Sdxq+0dDQuwDrqo
         najZfHYLQ2OD+88dU/johwV+VquX6h6rpODWX3webeM4e60jQVWwgzaBBbVxnMbQrX
         hqCnSOsQyQRdIYvaVliV1vLpInlWmaLZnHcSsba1fcnS6HmFKLDZ+Y5/V9VkhQnRH4
         NEyZNiYx7FrOQ==
Date:   Mon, 5 Dec 2022 20:06:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     linux-mediatek@lists.infradead.org,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        sujuan.chen@mediatek.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: mtk_eth_soc: enable flow offload support
 fot MT7986 SoC
Message-ID: <20221205200611.6b488918@kernel.org>
In-Reply-To: <70E22A48-DEE2-403A-975F-AD7D418B78CA@public-files.de>
References: <fdcaacd827938e6a8c4aa1ac2c13e46d2c08c821.1670072898.git.lorenzo@kernel.org>
        <70E22A48-DEE2-403A-975F-AD7D418B78CA@public-files.de>
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

On Sat, 03 Dec 2022 16:38:15 +0100 Frank Wunderlich wrote:
> thanks for the Patch, i only noticed a typo in Subject (s/fot/for/).
> regards Frank

The message from the bot does not reflect that but FWIW
 - fixed when applying.
