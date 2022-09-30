Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342395F0263
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 03:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiI3BuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 21:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiI3BuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 21:50:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7FB760D2;
        Thu, 29 Sep 2022 18:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C83B362203;
        Fri, 30 Sep 2022 01:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D83C433D6;
        Fri, 30 Sep 2022 01:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664502601;
        bh=GLXUi5XMqb9SWFsCHSWdY5rauLl8NCQnmgT8/QW7ew4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qzPBI2b8OdPAPM1rPavgrFFu2C3uGkLTrjypl29DiDgI41ll/xIWpMnqHct8Z18+H
         +A2GnxzqismYXm7jKA3q7YN8Ypc5gsw73oAKuOrEeWzieWodb7SdxDrx/Ocv2Og7mI
         4ine0SqwKroX91BwdXxtDJq4F5pYJLnnnW0qbXDt+nQtmwlWWaQBlyHlex+/J/UfZy
         ZqMhv6XwBc70RQMnoKU2J5+IhVuDWeYpD87xAkg5yqRDVhqMP0+mCsnL/JdKdSYr3Z
         ZH1kufJJ2dmJhbIXPGTfbjdaTv+Rh/xclRAjsJHozB4nHJ1n5FVtZWEgBFBfuZKMwO
         7eVRNAMTEsVmQ==
Date:   Thu, 29 Sep 2022 18:49:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [resend PATCH v6 0/4]  Mediatek ethernet patches for mt8188
Message-ID: <20220929184959.2c1458c1@kernel.org>
In-Reply-To: <20220928092308.26019-1-jianguo.zhang@mediatek.com>
References: <20220928092308.26019-1-jianguo.zhang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 17:23:04 +0800 Jianguo Zhang wrote:
> Jianguo Zhang (4):
>   dt-bindings: net: mediatek-dwmac: add support for mt8188
>   dt-bindings: net: snps,dwmac: add new property snps,clk-csr
>   arm64: dts: mediatek: mt2712e: Update the name of property 'clk_csr'
>   net: stmmac: add a parse for new property 'snps,clk-csr'

Are we supposed to drop patch 3 when applying this to net-next?
Do I understand this correctly?
