Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA8632DBE
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiKUURW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiKUURV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:17:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEEA554C7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:17:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A77B261460
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAD8C433C1;
        Mon, 21 Nov 2022 20:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669061840;
        bh=r6WtE3P9Qeyg+2BlmAae9fNTgZ8N6P6ZGJW3768qQBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DfgdJSuqNkhzfig0xpFj+tn++NyNk+7xC0lS03ehtPH9/YNHDjtpEAWloQcRie1t2
         A3IxObpe0yNar09QU79C3e0SGbROkj353A98iwcsXMmki/kAFqrm3UJdyL9U3uCbr/
         ll8304IqSLkjgDAGGmD4fjVw+GQyEjlrE1WwDU7ObI2rxT0FvfJDagSmXiT4xMBw7B
         4vWwzwc03CXAlEXH0oxExF4HmDw7pjilX/Z+qkoEMBPC3gxA1mmnvbQdyDN2zWz1lU
         eqMoTpLM3DWWareaN9TRn9HlfOiU2xHbLkgxgES6wK82Iy408wYY2howsKKhXH6uTC
         XvBNckhA6Yemg==
Date:   Mon, 21 Nov 2022 12:17:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, sujuan.chen@mediatek.com,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 5/5] net: ethernet: mtk_wed: add reset to
 tx_ring_setup callback
Message-ID: <20221121121718.4cc2afe5@kernel.org>
In-Reply-To: <9c4dded2b7a35a8e44b255a74e776a703359797b.1669020847.git.lorenzo@kernel.org>
References: <cover.1669020847.git.lorenzo@kernel.org>
        <9c4dded2b7a35a8e44b255a74e776a703359797b.1669020847.git.lorenzo@kernel.org>
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

On Mon, 21 Nov 2022 09:59:25 +0100 Lorenzo Bianconi wrote:
> +#define mtk_wed_device_tx_ring_setup(_dev, _ring, _regs, _reset) \
> +	(_dev)->ops->tx_ring_setup(_dev, _ring, _regs, _reset)

FWIW I find the "op macros" quite painful when trying to read a driver
I'm not familiar with. stmmac does this, too. Just letting you know,
it is what it is.
