Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22229623B4B
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 06:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiKJFdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 00:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiKJFdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 00:33:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028AB388B;
        Wed,  9 Nov 2022 21:33:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 883A3B82059;
        Thu, 10 Nov 2022 05:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BF1C433C1;
        Thu, 10 Nov 2022 05:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668058404;
        bh=3hgeLAwk4esWTSqgIqITFPv1E5o+nyLyDn8nF6HntFg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=J3vyFZcGmUSmoPWg4MkblFRaowrBTOzFakon/JqxJNc9bJNnJEtzb3ECSLPAKE9GG
         vjIQP4LOLr2bkl7H9THJ4r0nujREzedt5zUtAiBxF72y56XOuTnZcc1e/11J3iuQLL
         7he6aGjR3eCQkpXAHoqtgIcACPgCcNFqrCzSvVwCRrSZRKJ7XG0xJ6EFTgsl1fiYp9
         kaY2SNbH97tdC7WIONUifYIS9Oly+7WT57ShdG8HzU1PLPR9tfPekngVy0W8LVdQr4
         m//kDz1UfVuAtoPqkDHmuoC5ipeU2nmTllseYiLEplWxYeZ6NqSyPFX/ndkRUF3f/e
         vMfT99DxG3u8A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, devicetree@vger.kernel.org,
        robh+dt@kernel.org, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com
Subject: Re: [PATCH v4 net-next 0/8] introduce WED RX support to MT7986 SoC
References: <cover.1667687249.git.lorenzo@kernel.org>
        <Y2vBTBUw47sshA+E@localhost.localdomain>
        <20221109110538.431355ba@kernel.org>
Date:   Thu, 10 Nov 2022 07:33:18 +0200
In-Reply-To: <20221109110538.431355ba@kernel.org> (Jakub Kicinski's message of
        "Wed, 9 Nov 2022 11:05:38 -0800")
Message-ID: <874jv7tlup.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 9 Nov 2022 16:03:40 +0100 Lorenzo Bianconi wrote:
>> I noticed today the series state is 'Awaiting Upstream'. I am wondering if
>> this series is expected to go through a different tree, e.g. wireless one
>> (adding Kalle in cc). In this particular case the series changes only
>> the mtk ethernet driver and mt76 is built since we modify a common include (but
>> there are no changes in mt76). My personal opinion is this series is suited to
>> go through net-next tree but I would be fine even if it goes through Kalle's
>> one. Any opinions?
>
> Works either way, we'll see what Kalle says.

I would prefer if you can take these to net-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
