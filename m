Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CAE659491
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 05:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiL3EHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 23:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiL3EHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 23:07:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440F1A1A1;
        Thu, 29 Dec 2022 20:07:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5BE9B81A6D;
        Fri, 30 Dec 2022 04:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F9BC433EF;
        Fri, 30 Dec 2022 04:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672373257;
        bh=oHSUVgzZFT5eD1K23WLe22CTg2guTdfkql7F7NFCmps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aFdywRFiKVgawGQ5CEwjudYuMZlqN89LeoHR7omeKkB+lWgIb8Kqn9jRUP4By/Toj
         Qlic3m0dk84suoQjPPUubx2zMUp/E6imGDr4nda7lQrzBOWU46zJK85nFJtFLlDEC0
         pfAzCTnioWunpQbOBmODJDWuD5z9SYc9cDQo2dBNshigN9Pwmurj3+h3PPY+4YsYTk
         B8sTM5yKQ+P73Vx310dmZVcBSGcni3dW4BiSRbu9Br9ajzr8ULzV1hqudddrXfFMKL
         pTeGdM4J2qUOMgdcONIxsWnYzqQKdfL0ToxRiEwbXtxAJ9TrGoVm93i2yU0ZBWV9OZ
         8/UF2AKfZ93Yg==
Date:   Thu, 29 Dec 2022 20:07:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Wunderlich <frank-w@public-files.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 4/5] net: ethernet: mtk_eth_soc: drop generic
 vlan rx offload, only use DSA untagging
Message-ID: <20221229200736.008f5ad1@kernel.org>
In-Reply-To: <20221227140807.48413-4-nbd@nbd.name>
References: <20221227140807.48413-1-nbd@nbd.name>
        <20221227140807.48413-4-nbd@nbd.name>
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

On Tue, 27 Dec 2022 15:08:06 +0100 Felix Fietkau wrote:
> Through testing I found out that hardware vlan rx offload support seems to
> have some hardware issues. At least when using multiple MACs and when receiving
> tagged packets on the secondary MAC, the hardware can sometimes start to emit
> wrong tags on the first MAC as well.
> 
> In order to avoid such issues, drop the feature configuration and use the
> offload feature only for DSA hardware untagging on MT7621/MT7622 devices which
> only use one MAC.

Does not apply cleanly, could you rebase and repost?
