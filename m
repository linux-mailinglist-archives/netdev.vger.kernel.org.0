Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D864C65FACB
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 05:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjAFE67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 23:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjAFE66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 23:58:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA73625DC;
        Thu,  5 Jan 2023 20:58:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74AA4B81BFF;
        Fri,  6 Jan 2023 04:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEDDC433EF;
        Fri,  6 Jan 2023 04:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672981135;
        bh=8sHGkyA2scdB7whz74zay7o5uIH26hS4CiJFHb+a7xI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KyM3m+bYUNtm7WWoBfNdLUfR0iAxcGTNmly5MtGLfIEXH6tHS0RcDyUPzgloFhHS4
         I5Bobtqnb7DDikiNcMpFK4wTSdKjRYPc5V/pQS7BMm6X+Ksx/onhoTnYmXR0wcdqNg
         ravEfFPKvazQhXA4E0xht8eu0X7aW4COSklR+nSGP4WPW8ep1RzGxhacw+cx+EqA5p
         x2m4dVYT0Hclx0Cy5z5QfI/rDntZhuW1oSzdiYDIxSWpryOjCcRYESlpRXM06Off0K
         vpYS1H8foMGrmxTd+kEnKugBezD0DYt1BTe+DZ4yJ0hzsUMBisKgMKfTTRmFIdStM0
         n4aD0tk5BFRLA==
Date:   Thu, 5 Jan 2023 20:58:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <macpaul.lin@mediatek.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] arm64: dts: mt8195: Add Ethernet controller
Message-ID: <20230105205853.7d86342b@kernel.org>
In-Reply-To: <20230105010712.10116-1-biao.huang@mediatek.com>
References: <20230105010712.10116-1-biao.huang@mediatek.com>
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

On Thu, 5 Jan 2023 09:07:10 +0800 Biao Huang wrote:
> Changes in v8:
> 1. add reviewed-by as Andrew's comments.

You don't have to repost just to include review/ack tags.
They are automatically gathered by our patch application tooling
when we apply patches to the tree.

I will take patch 1 to the networking tree, I _think_ patch 2 is
supposed to go via Matthias?
