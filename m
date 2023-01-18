Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C58670FF2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 02:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjARBZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjARBZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:25:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A9D10D7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 17:25:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C4D6B8164A
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 01:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7722C433D2;
        Wed, 18 Jan 2023 01:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674005143;
        bh=iVB7UfksrOBUAKFafPB0kqhM4GlvklXG7Uk1Kva9XZo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jfpp17G27SI+qjqztEr6PhFgw43qJh+FPojU+zQTHvlHLbQ/75Pbu7498etB2HYRt
         0huqVviZnjszhFUa+d6Bg3CEVZpFQ6k2Eg+dXlhCpI1rmh4XO26BEazcReHAI7V3Rj
         JM8HE2rDIvED/dNoLgv3UZBk5oZjKZZxEeBp3eEOBChw4WnZLwzlR8plT6dO2Cl8dt
         OSkFHv3lgssmnGFPt3pw0kEXb6NuedYDjPzaCqKrH7DcJQeV0Sm1dkhogq/3aiJfyq
         Gf/l3yttOSisTJj4JB+nSI0uMkcjma0x64e24cnzBk7bpbd3LH3XPSdRldumTSaIPC
         meFHfYgBltHhw==
Date:   Tue, 17 Jan 2023 17:25:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geoff Levand <geoff@infradead.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 7/7] net/ps3_gelic: Fix DMA mapping problems
Message-ID: <20230117172542.5a05e37d@kernel.org>
In-Reply-To: <32670eab538e232957517b74f4a547b0315253f7.1673748018.git.geoff@infradead.org>
References: <cover.1673748018.git.geoff@infradead.org>
        <32670eab538e232957517b74f4a547b0315253f7.1673748018.git.geoff@infradead.org>
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

On Mon, 16 Jan 2023 21:05:57 +0000 Geoff Levand wrote:
> Fixes several DMA mapping problems with the PS3's gelic network driver:
> 
>  * Change from checking the return value of dma_map_single to using the
>    dma_mapping_error routine.
>  * Use the correct buffer length when mapping the RX skb.

These two should be separate patches in a series sent against the net
tree (meaning [PATCH net] and a Fixes tag in the commit message).

Then a week later (once the fixes have propagated into the net-next
tree) you can send the cleanups to net-next.

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

Before any of that tho - the emails must reach the mailing list.
No idea why your posting did not show up there :(
