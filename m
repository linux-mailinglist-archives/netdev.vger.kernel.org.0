Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A0C63B34D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbiK1UfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbiK1UfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:35:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8787D2AC61;
        Mon, 28 Nov 2022 12:35:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BC1F613C5;
        Mon, 28 Nov 2022 20:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ACDC433D6;
        Mon, 28 Nov 2022 20:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669667715;
        bh=z/BrWdXYwkpzumsBKB/YphpI+Jdg+E6KDqyGxyCMSWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MuM5AmXPVp4aFBpJbABb4tugWQMqjP+5T97nDHOPjpPZkDOSTTHJP7nRPBJqN9kBi
         0G+yN7B44aN9xwt6o6kHvODqXGHEFh+AppK1N3bfMBF+1pArIxmhLi5ruQGgLdDUov
         wDRQDY1UpNxmIUBYHjgxnVObf5aGLHGBIOB360sPLd9qSkAVurpCXo1v1nktXFElE/
         xHlmXjUlWj/Zun4lDcUX+aJszsgkOYjkSnbtfjg6PAzFPIy1MvTa+1UzYOccsDZnyh
         N03dV82Xi4R5bLdiQoLauwqUqkZqeuQsupdx2wNyswynF+BIHLSXHaiIRd43LjCWyl
         wGFYTNbP47N/w==
Date:   Mon, 28 Nov 2022 12:35:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sujuan Chen <sujuan.chen@mediatek.com>
Cc:     <netdev@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>,
        <linux-kernel@vger.kernel.org>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Evelyn Tsai" <evelyn.tsai@mediatek.com>,
        Bo Jiao <bo.jiao@mediatek.com>,
        linux-mediatek <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH,v2] net: ethernet: mtk_wed: add wcid overwritten support
 for wed v1
Message-ID: <20221128123514.44bc620c@kernel.org>
In-Reply-To: <36d6cf34361ba648ad307affb0371d94663c108d.1669259807.git.sujuan.chen@mediatek.com>
References: <36d6cf34361ba648ad307affb0371d94663c108d.1669259807.git.sujuan.chen@mediatek.com>
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

On Thu, 24 Nov 2022 11:18:14 +0800 Sujuan Chen wrote:
> All wed versions should enable the wcid overwritten feature,
> since the wcid size is controlled by the wlan driver.

This appears to have been applied to net-next:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a66d79ee0bd5140a64b72cde588f8c83a55a1eb9

Thanks!
