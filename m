Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE16561FE0
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbiF3QCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbiF3QCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:02:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C063969B;
        Thu, 30 Jun 2022 09:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D56C61F2D;
        Thu, 30 Jun 2022 16:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8CCC34115;
        Thu, 30 Jun 2022 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656604942;
        bh=hwWzVmDS+Gn+ZGTxrGxGrVhSXn7V3fn4x4DATS7HEPE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hGlt1AE1GAEQ1udAHkqLsbPVLAANFrSQJyHnl1Gp6uB/WV7Z5/r7TECpRJ5VuY9EM
         ykFlKGuENWnEsf5ktVfrUo7aIqSihmvThn4Ybio+0yD2wpErYIiD5gpW1s+XnQh0lt
         zU7Tw8Lp0Hv75ZWDhud71GhnioD3rKUX5I8HZUBf1luOksx0n2LvAdNB6pI6A0y0Zc
         iATfNeWSgfc4o/hzJhng+A6mFsw9lLoDXFvt7O4QYrsAKw19ElxwOa1p51j8UgyqZE
         Mo1jogC/R7V8m8rHdpW3ba/q2Ag2tqoOwOcsRK8Sesr4PBDgVNvwcZ6BXQBGXue15q
         5R+4ngfQY/fpA==
Date:   Thu, 30 Jun 2022 09:02:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Daire McNamara" <daire.mcnamara@microchip.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v1 06/14] net: macb: add polarfire soc reset support
Message-ID: <20220630090220.7ee5c7a7@kernel.org>
In-Reply-To: <20220630080532.323731-7-conor.dooley@microchip.com>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
        <20220630080532.323731-7-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 09:05:25 +0100 Conor Dooley wrote:
> To date, the Microchip PolarFire SoC (MPFS) has been using the
> cdns,macb compatible, however the generic device does not have reset
> support. Add a new compatible & .data for MPFS to hook into the reset
> functionality added for zynqmp support (and make the zynqmp init
> function generic in the process).
> 
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>

Please repost 2 and 6 separately with [PATCH net-next] in the subject.
