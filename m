Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED55E545BE4
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243492AbiFJFws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242654AbiFJFwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:52:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C786F0;
        Thu,  9 Jun 2022 22:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B983EB830A8;
        Fri, 10 Jun 2022 05:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97ABC3411B;
        Fri, 10 Jun 2022 05:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654840357;
        bh=9zkxBIOVn1jqpEIn3oRNOtYHxAz8CrVcwvYLEOX+hUQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hdh7bWVg2Kn+IOmG8VDaHsYzXzO5C8DP99mi7sI/gyXTsydvAp7Rp1ScECqRxQFMR
         3jv4cwtrL13VLFj8F9i4WpZCMcqsE4jC/1lIMMQAi1Mm4ewszyg/CflVwHsmX99B/W
         2NxwXQruv3/CCnZYo2LoujCOhCGHUJ3P15x74TlXbn4VfbarmvG6ShTWuG8EXBGjUA
         egeV837WAYF588soBoZtSrFrJj5y6xlQe/AYip5rTPmqHITwGB4E3PLhDJAjRiNU8J
         VctdO0qOhBgUJ0ZaXiFeSTBuBu4We+xzTSPr0HlTk/lWs5wgcdeO6T8z5H8L07edNo
         KRFFZPln4bsvg==
Date:   Thu, 9 Jun 2022 22:52:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>
Subject: Re: [PATCH net-next v3 0/7] pcs-xpcs, stmmac: add 1000BASE-X AN for
 network switch
Message-ID: <20220609225235.4904ea56@kernel.org>
In-Reply-To: <20220610033610.114084-1-boon.leong.ong@intel.com>
References: <20220610033610.114084-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022 11:36:03 +0800 Ong Boon Leong wrote:
> Thanks Russell King [1] and Andrew Lunn [2] for v1 review and suggestion.
> Since then, I have worked on refactoring the implementation as follow:
> 
> My apology in sending v2 patch series that miss 1/7 patch, please ignore.

Please wait 24h before posting v3, as is documented to be our process:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#i-have-received-review-feedback-when-should-i-post-a-revised-version-of-the-patches

In the meantime try to build each patch with W=1 C=1 flags set and fix
the build errors and warnings you're introducing. 

Thanks!
