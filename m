Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E56623322
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 20:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiKITFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 14:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiKITFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 14:05:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EAA1EEEA;
        Wed,  9 Nov 2022 11:05:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0825B81F74;
        Wed,  9 Nov 2022 19:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3B2C433D6;
        Wed,  9 Nov 2022 19:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668020740;
        bh=lQfrGf0TkswjXbAouqlpnUWIy9VgiBcukwnGHhn7JpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lpxBtp3zvmBYqfi22BFPCfAt2bUiFwC6prDsyQ2ROGmEQMBYatsPXtcWXjHWqBE4O
         Q7M1sJ7fbpRnovPPU2bK0g35j1XidJK8Ph6YtcLaNB2aH62xfainrAwQ4YuPvBByJe
         8BuVkLGYO4KrTIzgJFSgOrsNAmH6qepDsOV1kLloBzTvHrgBufz8iOiKyFDiU3sY6D
         RciWY9+vWdlNkr1zXn48MQ4OTzbvUKeYXb9iv01B0ToM1x+4zsXlTpbLVHz0VDtfpl
         R0qyI10tqLIZyGTAe+JT0sIwEJ6nTWcJjy3ZWQOTnvQfGaHl55Y7U+5CmcgVmxJS1u
         f885YNiZnANFQ==
Date:   Wed, 9 Nov 2022 11:05:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, devicetree@vger.kernel.org,
        robh+dt@kernel.org, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com, kvalo@kernel.org
Subject: Re: [PATCH v4 net-next 0/8] introduce WED RX support to MT7986 SoC
Message-ID: <20221109110538.431355ba@kernel.org>
In-Reply-To: <Y2vBTBUw47sshA+E@localhost.localdomain>
References: <cover.1667687249.git.lorenzo@kernel.org>
        <Y2vBTBUw47sshA+E@localhost.localdomain>
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

On Wed, 9 Nov 2022 16:03:40 +0100 Lorenzo Bianconi wrote:
> I noticed today the series state is 'Awaiting Upstream'. I am wondering if
> this series is expected to go through a different tree, e.g. wireless one
> (adding Kalle in cc). In this particular case the series changes only
> the mtk ethernet driver and mt76 is built since we modify a common include (but
> there are no changes in mt76). My personal opinion is this series is suited to
> go through net-next tree but I would be fine even if it goes through Kalle's
> one. Any opinions?

Works either way, we'll see what Kalle says.
Let me bring it back to Under review in the meantime.

While I have you - no acks for the bindings yet? On previous versions?
