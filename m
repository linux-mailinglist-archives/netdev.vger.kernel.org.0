Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA006239E4
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbiKJClj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiKJCli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:41:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6082B13EAD;
        Wed,  9 Nov 2022 18:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DCEAB82058;
        Thu, 10 Nov 2022 02:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B112C433C1;
        Thu, 10 Nov 2022 02:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668048094;
        bh=1p1FGahK1HOijVh6a1eX7XoPkQd2gtxu+E9nYhhYEFg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MpW8YDj4xpkBW/tx6Ok4JLW/RTxnyiX6/+3oGK6dhfqwi1y/G2msw9dF8zKVocsg7
         q8qnmip0cy77N8xgh7CV56c1Oxofhsa0mx5LQTz726VCDQW5SzPwSoRtV7qtwneDsY
         SvHFnCW88nLBL/6tuQzlmeZx8XbWik4zUjEv/+O8RXJAgYuTkgYiWYUTtonSLSZDW4
         sSueeLDiXOKl2GcGFsXnXdEKncAGXTTeNuRHPzLx3mnRrA5isETRSSZdiz+Qi8z+2T
         sV1Ju6Wrr8VJszQmllywGXU4it2o5s7hMpEEA/p9U+84q35pmCqk2GeSICk1Aojv49
         plyJ8D3I7Pq7Q==
Date:   Wed, 9 Nov 2022 18:41:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tee.min.tan@intel.com,
        muhammad.husaini.zulkifli@intel.com, hong.aun.looi@intel.com
Subject: Re: [PATCH net-next v2] net: phy: marvell: add sleep time after
 enabling the loopback bit
Message-ID: <20221109184132.1e0cd0dd@kernel.org>
In-Reply-To: <20221108074005.28229-1-aminuddin.jamaluddin@intel.com>
References: <20221108074005.28229-1-aminuddin.jamaluddin@intel.com>
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

On Tue,  8 Nov 2022 15:40:05 +0800 Aminuddin Jamaluddin wrote:
> Subject: [PATCH net-next v2] net: phy: marvell: add sleep time after enabling the loopback bit

Looks like v1 was tagged for net, why switch to net-next?
It's either a fix or not, we don't do gray scales in netdev.

> Sleep time is added to ensure the phy to be ready after loopback
> bit was set. This to prevent the phy loopback test from failing.
> 
> ---
> V1: https://patchwork.kernel.org/project/netdevbpf/patch/20220825082238.11056-1-aminuddin.jamaluddin@intel.com/
> ---

git am will cut off at the first --- it finds, so the v1 link and all
the tags below we'll be lost when the patch is applied. Please move 
this section after the tags.

> Fixes: 020a45aff119 ("net: phy: marvell: add Marvell specific PHY loopback")
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Signed-off-by: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
