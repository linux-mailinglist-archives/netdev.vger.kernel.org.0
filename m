Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBF66B86EF
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCNAdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCNAdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:33:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAA24E5F2;
        Mon, 13 Mar 2023 17:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 05488CE12B6;
        Tue, 14 Mar 2023 00:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F35DC433EF;
        Tue, 14 Mar 2023 00:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678754012;
        bh=cH5ifKhaPTxmo5PLQqb/zyvosbof39I56R0h8FeXNC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MWHTgNVysvGjziEGiHAVw0H11Ss6i2K9/V0AHyBe0VrnjIpjvHLF8AuYrqC6sbeyJ
         gCNvV1voB/XNqllE7i4DZQDzE/J2tgOPkDLNBmS/uUls8on5U6a9Pt0BvTbEyfXpbq
         fh2Xgq3Y5sQzK3aYWrz2dGXEoSM+SFjT9Z/1/m5tSGhjc2cpaVQMAf5AKcKSK+hlbv
         MlMVXcjPLSveeB3ivGze5jPwwiI0XmuomPrWketrXPjHDezhEXrXZiAs3mhBKjTlzU
         OmPQgxldMpUWJG4RKTjyFJpVB0eACQG895WTA8yoqarRDNsOIUXsGDO1pw92rs6ViL
         bVuetgTiB+euw==
Date:   Mon, 13 Mar 2023 17:33:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v6 0/8] Add Ethernet driver for StarFive JH7110 SoC
Message-ID: <20230313173330.797bf8e7@kernel.org>
In-Reply-To: <20230313034645.5469-1-samin.guo@starfivetech.com>
References: <20230313034645.5469-1-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 11:46:37 +0800 Samin Guo wrote:
> This series adds ethernet support for the StarFive JH7110 RISC-V SoC.
> The series includes MAC driver. The MAC version is dwmac-5.20 (from
> Synopsys DesignWare). For more information and support, you can visit
> RVspace wiki[1].

I'm guessing the first 6 patches need to go via networking and patches
7 and 8 via riscv trees? Please repost those separately, otherwise
the series won't apply and relevant CIs can't run on it.
