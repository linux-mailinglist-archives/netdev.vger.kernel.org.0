Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD7A59B153
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 04:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbiHUCdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 22:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236221AbiHUCdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 22:33:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFB8272B;
        Sat, 20 Aug 2022 19:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 361D3B80B3C;
        Sun, 21 Aug 2022 02:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86332C433D6;
        Sun, 21 Aug 2022 02:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661049198;
        bh=SZHKvSTbh3CjmkFza0jZrnuho9MKcS9bxWgVK4foylQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CPWN8+r0vxZDDBEgbyIVXkxW9G3JN685TvRWU0nfedlOjW6Dl7UptSma+0gkrNEEw
         DjQApbvgsoERng8S9L1SDSRajH6IPj+JMAzfTzhPGfR2L2zp1KlSaT82qXItqbxLgW
         WBPayXK1zmHqdmkl+dQI7VOihuMOI7yoVfZ8rZyCScDO2VrEh1IUZO20EQTUKS190M
         7k0yXueSZHVlw2wooAHdk3e3LLnUhUWk5tquYqOO82mm4fHrZ/OYf86L3AazPUIzcR
         4lc8ODpQAlcvs8bAyTQ4Lb82fqAjq3lskEt8RN8eA37OOhVazlmN5j7fIqR6/jH9RW
         bk5r/MzCm73DQ==
Date:   Sun, 21 Aug 2022 10:33:11 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: Re: [PATCH V4 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Message-ID: <20220821023311.GI149610@dragon>
References: <20220726143853.23709-1-wei.fang@nxp.com>
 <20220726143853.23709-4-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726143853.23709-4-wei.fang@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 12:38:53AM +1000, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Enable the fec on i.MX8ULP EVK board.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>

Applied, thanks!
