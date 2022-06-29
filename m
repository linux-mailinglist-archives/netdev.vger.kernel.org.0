Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F7855F4CA
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiF2D6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiF2D6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:58:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CF6113A;
        Tue, 28 Jun 2022 20:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D79D5B81E03;
        Wed, 29 Jun 2022 03:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB26C341C8;
        Wed, 29 Jun 2022 03:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656475086;
        bh=xlGxS8eUt1OwTO8mhrcABYeSBWBaRvP4l//S4lU2bl4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hrDTwX6hYGWX/wgcmW07d4J74gC6BeBtRFns102uUolRM4RhY87XGIMtBDXnwSuZo
         zgikn6BHii6BDtqCWa0ZAt2uCIsUoUVUy5VcmPHP2qEWinJShYe25rpOQkjWM8Ta/f
         Bid2Cycq6yAiVf5ydN0IE5ySyzVO3by6Y8asE2RMkpC/sIPc1qdysigyK8Lshr6sNj
         vHlEA2nrTCPpzoKy8HGNgbVzca98fMuzeJIh5FhgYMdeIesIiYpfJqjbgutyJmy2KL
         enCqF25Nsy6URxQ0hBhdpCtauUDvSEd3QhMUlEkuBT5xwET31rK+vYjrJmP1ZbvrqH
         YZLBkpUxllcUg==
Date:   Tue, 28 Jun 2022 20:58:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH RFC 0/5] Add MTU change with stmmac interface
 running
Message-ID: <20220628205805.2e105b5a@kernel.org>
In-Reply-To: <20220628013342.13581-1-ansuelsmth@gmail.com>
References: <20220628013342.13581-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 03:33:37 +0200 Christian Marangi wrote:
> This series is to permit MTU change while the interface is running.
> Major rework are needed to permit to allocate a new dma conf based on
> the new MTU before applying it. This is to make sure there is enough
> space to allocate all the DMA queue before releasing the stmmac driver.

=F0=9F=91=8D Looks good.
