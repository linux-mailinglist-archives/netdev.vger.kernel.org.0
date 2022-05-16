Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF75529027
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 22:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbiEPUeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349178AbiEPUcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:32:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E990A2126E;
        Mon, 16 May 2022 13:16:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C366B8160F;
        Mon, 16 May 2022 20:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A03C34100;
        Mon, 16 May 2022 20:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652732164;
        bh=ME96KX8IfX1svEsT1z2Dl5hSwjXyNb9P2yDf0uGA9FI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O0S4GRNM6WUisWnWefckQXgbR6PZD+pb7qWIyAS80cWIqtkYFGEqTiXoM0C8+PXTh
         F59z5FAtrV9TgdbPvFLCsthZn3BL0km6e8LY3p6X4TLCswVx6PREdHIRrqdmcYSa2R
         yqDF2uCaa+ZZOqqAS2ZdR88IVh2JT3zfq0shj29RnD9a7NFcF6ktABlDs93Sz8mXlF
         IoSDKLxBiYjc6dEr50+2tC5tDBvKh5RTGSGNvTGCFqHhapqxaRYK5chPgdTj0AX4uN
         4vm+E0+rjYccB934PBjZQv8twso3aZ9Wawv4JE4UEgONtBK0OOddQ6NTuw6abU0xbU
         iWV4JSCCOuZpA==
Date:   Mon, 16 May 2022 13:16:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        dinesh.sharma@intel.com, ilpo.jarvinen@linux.intel.com,
        moises.veleta@intel.com, sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next 0/2] net: skb: Remove skb_data_area_size()
Message-ID: <20220516131602.3dfddf42@kernel.org>
In-Reply-To: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
References: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 May 2022 10:33:58 -0700 Ricardo Martinez wrote:
> This patch series removes the skb_data_area_size() helper,
> replacing it in t7xx driver with the size used during skb allocation.
> 
> https://lore.kernel.org/netdev/CAHNKnsTmH-rGgWi3jtyC=ktM1DW2W1VJkYoTMJV2Z_Bt498bsg@mail.gmail.com/

Thanks for following up!
