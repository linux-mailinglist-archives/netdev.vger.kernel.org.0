Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12ED45AC913
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 05:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiIEDZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 23:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiIEDZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 23:25:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D1813D37;
        Sun,  4 Sep 2022 20:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FC196100B;
        Mon,  5 Sep 2022 03:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD86C433D6;
        Mon,  5 Sep 2022 03:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662348296;
        bh=BqXz4ZG6IJlp/co8w+rlx5+RqBDVKQI9G5sRrtSGCfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XLr+fHUTDMK4qh5/gftAcaXH83GoNHt8YoGp+LL3V8b4SzUFniu5q7R0c1B+AAk13
         aTJ+5EwYyhUGDPQxhR8CI7VKkdTuBDhFiMjoIFNRectZ7BsASrCul+HgOPwvC0nilU
         f3yivX43sy4r70eoEgjw9qbIRZXR1h3YwzbLT/ZPc6Fs779B43QOYWTYaJrd55mc3l
         I7QrhujF/ULBPWO7EPIw4M8JAwBv0srWqLNJNH5xuPC+mTp1Uk/M3k/oXsgYRrm9l5
         2U+WWc5184ExXeofgzZ1YpPng2q0Zk0+ZnG18G2lJLEpxpej0WRrNv1jTt/osnulxC
         JXTDQVDg1nWfg==
Date:   Mon, 5 Sep 2022 11:24:50 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH v2 devicetree 0/3] NXP LS1028A DT changes for multiple
 switch CPU ports
Message-ID: <20220905032450.GH1728671@dragon>
References: <20220831160124.914453-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831160124.914453-1-olteanv@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 07:01:21PM +0300, Vladimir Oltean wrote:
> The Ethernet switch embedded within the NXP LS1028A has 2 Ethernet ports
> towards the host, for local packet termination. In current device trees,
> only the first port is enabled. Enabling the second port allows having a
> higher termination throughput.
> 
> Care has been taken that this change does not produce regressions when
> using updated device trees with old kernels that do not support multiple
> DSA CPU ports. The only difference for old kernels will be the
> appearance of a new net device (for &enetc_port3) which will not be very
> useful for much of anything.
> 
> Vladimir Oltean (3):
>   arm64: dts: ls1028a: move DSA CPU port property to the common SoC dtsi
>   arm64: dts: ls1028a: mark enetc port 3 as a DSA master too
>   arm64: dts: ls1028a: enable swp5 and eno3 for all boards

Applied all, thanks!
