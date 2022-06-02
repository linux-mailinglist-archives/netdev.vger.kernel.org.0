Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDE853B121
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbiFBBDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiFBBDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:03:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26E525C1E2;
        Wed,  1 Jun 2022 18:03:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ACC8B81D9C;
        Thu,  2 Jun 2022 01:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EEAC385B8;
        Thu,  2 Jun 2022 01:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654131796;
        bh=wksuz7vaU/eT//E6IgpXwPJq8QtyuB6m7LjRu8m7SC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qha8JLVY2iWPYuve2RGON4YDTNKfH+xK8C0vhdhsGZaiuONp0bzbvfBe5GCdbr96F
         FGuk6sWryGYBGZf99Ktq+s6EtTg03fYEvi/u4jxdRf3VTPaCRmmYjmc1BsH8ZUqwyK
         Ja45OsmwNnZBNd2JfqE6UXscH0TQMV86b4Q7yYSJAfcxx0bfZuQ+K6vgmaa6c48FCR
         6X3LTLZUov3OoHFU+IVhOS23wHedUQvSLF0uRaj0CvzY0k4RgZ1yFGG7vryX0h2jtf
         d3BoKuabKLe67ngushbsRUKP+bQ4p2i5lNabIcWWhkPL1rVKHa6wHKZRkalyh/wDRE
         VX/sOmR+dtUhg==
Date:   Wed, 1 Jun 2022 18:03:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: stmmac: use dev_err_probe() for reporting mdio bus
 registration failure
Message-ID: <20220601180314.02e4d84e@kernel.org>
In-Reply-To: <20220601142226.1123110-1-linux@rasmusvillemoes.dk>
References: <20220601142226.1123110-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Jun 2022 16:22:26 +0200 Rasmus Villemoes wrote:
>  		if (ret < 0) {
> -			dev_err(priv->device,
> +			dev_err_probe(priv->device, ret,
>  				"%s: MDIO bus (id: %d) registration failed",
>  				__func__, priv->plat->bus_id);

Please adjust the indent of the continuation lines.

And fix the spelling checkpatch also points out.
