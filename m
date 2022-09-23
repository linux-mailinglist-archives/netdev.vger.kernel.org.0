Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE035E720F
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIWCpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiIWCpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:45:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845CEC8400;
        Thu, 22 Sep 2022 19:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44EDFB8121D;
        Fri, 23 Sep 2022 02:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C96C433C1;
        Fri, 23 Sep 2022 02:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663901146;
        bh=DVpEhkll466QsOtEVq9IpaSrEpmDqujHhiywA3pe3YU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PS+WhfuXSiw90HTDCc1yyTMOMk3o3V2CMGY+Pk20PyCgDxL/P1CDmlojyusNdG69y
         eubthREj+XIqQWrP8IZvS+4jTdfwlAAYc8qRWnMLmhatvLBBaLCzeHVAiUJ2Avv9lN
         08GNpmHUlgB2iCHdpoFtySalKZfhQlNZIpUcQxBadEGQ7U4Cup6+jrCHweMQ1CpAEF
         tTsj194UJDIrBh15z+VZGGooWKna5D4BkF1Nw81JY/msNBSP7pzPaksA+UoCCUMZuv
         pgDLVqEEvrc2HOsQvh0M0qmFWjh8r/qmhfX9amlReHxKzbZl1OYYGw4SMqJ/dbP3Gt
         OEh4aEFOOao3A==
Date:   Thu, 22 Sep 2022 19:45:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Junxiao Chang <junxiao.chang@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jimmyjs.chen@adlinktech.com, hong.aun.looi@intel.com
Subject: Re: [net] net: stmmac: power up/down serdes in stmmac_open/release
Message-ID: <20220922194543.5b9f75a0@kernel.org>
In-Reply-To: <20220923005014.955076-1-junxiao.chang@intel.com>
References: <20220923005014.955076-1-junxiao.chang@intel.com>
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

On Fri, 23 Sep 2022 08:50:13 +0800 Junxiao Chang wrote:
> -
> -		if (ret < 0)
> -			goto error_serdes_powerup;
> -	}

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:7322:1: warning: unused label 'error_serdes_powerup' [-Wunused-label]
error_serdes_powerup:
^~~~~~~~~~~~~~~~~~~~~
