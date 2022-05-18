Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E214552B1CA
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 07:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiERFKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 01:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiERFKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 01:10:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934082DFB;
        Tue, 17 May 2022 22:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09124B81E68;
        Wed, 18 May 2022 05:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AD1C385A9;
        Wed, 18 May 2022 05:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652850647;
        bh=zLSUPhiMZkHcI2NBTIXoQ5eEv+4diNzEqoaYxrNP2p8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ExkNDaFYEJVADZBn0RIDYtfSpF7+BCYlUhclkwTg2tVyN5Qfke+g0VXRlWz2LAgIj
         RLyh3sgNLhMcDVe4iv/1P6zhDrtDP7LAKEqGxfJv8A+DawSK1pHOIrWxtSHhdN+SEh
         lshWxLML2s5ttHCyIIzcNhDvxJ8otkbhbibBdiCeXHqVJxLh6v0qMEL8UZJA2g4THD
         cBR1IZICuEYpUgSOF7WezLKmTxQIGrgbMLHjoz6NFq8OnQdzz9V4Nv8mXPlPkPdX84
         cj6MUwu6nh3PIuPE8QCD9aQ9Cv9odkiBRTFAgEBpXCtEfwQfhqWr2GIWWMlpRwgHsJ
         gP5rjt2EJRrag==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bernard Zhao <bernard@vivo.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhaojunkui2008@126.com
Subject: Re: [PATCH] mediatek/mt76: cleanup the code a bit
References: <20220517062913.473920-1-bernard@vivo.com>
Date:   Wed, 18 May 2022 08:10:41 +0300
In-Reply-To: <20220517062913.473920-1-bernard@vivo.com> (Bernard Zhao's
        message of "Mon, 16 May 2022 23:29:09 -0700")
Message-ID: <8735h74e9a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bernard Zhao <bernard@vivo.com> writes:

> Function mt76_register_debugfs just call mt76_register_debugfs_fops
> with NULL op parameter.
> This change is to cleanup the code a bit, elete the meaningless
> mt76_register_debugfs, and all call mt76_register_debugfs_fops.
>
> Signed-off-by: Bernard Zhao <bernard@vivo.com>

Please make the title more informative and don't use mediatek in the
title, for example something like this:

mt76: remove simple mt76_register_debugfs() function

More info:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
