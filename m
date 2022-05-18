Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D446252AFC1
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiERBQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiERBQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:16:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6865813E88
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 18:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0318A615E2
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 01:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF65C385B8;
        Wed, 18 May 2022 01:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652836595;
        bh=+t1S8IQHCcjw/ZcbWBixC910R7/eAfjNaG9qWhRpfqk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DFaPA0Ugd07R0zIN8Y6pRI+AOM5Andhq/xQB2PfnPvhA3AbZEs7pVZjH6prSua/dn
         M3i03bt0hykvvTM6jwrXZu1hDL7WutVyncxTgPjkMDeYBsBmjqTpxYWjYXrxIKu5Y5
         uNLmdMkqpSaeMXtTjLdnLe8AhbDQTcwgMGDbLI0suPAaYbsPrP8kNUDnOFS20b6s/9
         AbngLjhwNQI784/N6MVzYsy+asRwmgvd1k4Y/D6eD0WXUmgemNsgbq3UQagCRkfU54
         b4TZd/aoCGeSUkGa/2bLd1jNRf8M5RMdGM9s9jphQyepedmh1f7g8UYtOQvMlNn31A
         7NeD4BOYMvUvg==
Date:   Tue, 17 May 2022 18:16:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com
Subject: Re: [PATCH v5 0/3] adin: add support for clock output
Message-ID: <20220517181633.7498dcc7@kernel.org>
In-Reply-To: <20220517085143.3749-1-josua@solid-run.com>
References: <20220517085143.3749-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 11:51:36 +0300 Josua Mayer wrote:
> This patch series adds support for configuring the two clock outputs of adin
> 1200 and 1300 PHYs. Certain network controllers require an external reference
> clock which can be provided by the PHY.
> 
> One of the replies to v1 was asking why the common clock framework isn't used.
> Currently no PHY driver has implemented providing a clock to the network
> controller. Instead they rely on vendor extensions to make the appropriate
> configuration. For example ar8035 uses qca,clk-out-frequency - this patchset
> aimed to replicate the same functionality.
> 
> Finally the 125MHz free-running clock is enabled in the device-tree for
> SolidRun i.MX6 SoMs, to support revisions 1.9 and later, where the original phy
> has been replaced with an adin 1300.
> To avoid introducing new warning messages during boot for SoMs before rev 1.9,
> the status field of the new phy node is disabled by default, and will be
> enabled by U-Boot on demand.
> 
> Changes since v4:
> - removed recovered clock options

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
