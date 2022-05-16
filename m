Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1893E528C3A
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 19:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238445AbiEPRnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 13:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiEPRnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 13:43:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB05C3703A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 10:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 801CCB8125D
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 17:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941ADC385AA;
        Mon, 16 May 2022 17:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652723018;
        bh=8nrM/7S0Fm9n96gYf1ySGIDwGth7vhgch3fr5F/SOU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DQH1eOrZKpyLL5z4zU7c1C71U3XFbPjZHJ5M7BDQZgZCQmRvvzXrMMi/98m3VE0GA
         7JeKl4UtGJ3L5afpYuvI6cRQc3SGCa2RXGnh3NgAiX7NqzW5h4LbERg2AQSToLQO78
         pGpQxCGr3jNtf8riROnS6WpVCGEflwGxKq+2stk9099PvOcgeSrPV+NAmAPZ/rMl5C
         8S37LVJX4wAvu/q9CNcB5484eBjdbCXZIQeUrFPUKoIMJ/zLvd+8Z3tggnYgJZh47n
         ffvnUYp8lQC2DuJP1tgkDpxFb2LQO28t7WHCq2Suni711OvUaP6mvzwpTLUqJ0aiA+
         l/fs/jtpMDM4g==
Date:   Mon, 16 May 2022 10:43:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Josua Mayer <josua@solid-run.com>
Cc:     Michael Walle <michael@walle.cc>, alexandru.ardelean@analog.com,
        alvaro.karsz@solid-run.com, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        michael.hennerich@analog.com, netdev@vger.kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
Message-ID: <20220516104336.3a76579e@kernel.org>
In-Reply-To: <072a773c-2e42-1b82-9fe7-63c9a3dc9c7d@solid-run.com>
References: <20220510133928.6a0710dd@kernel.org>
        <20220511125855.3708961-1-michael@walle.cc>
        <20220511091136.34dade9b@kernel.org>
        <c457047dd2af8fc0db69d815db981d61@walle.cc>
        <20220511124241.7880ef52@kernel.org>
        <bfe71846f940be3c410ae987569ddfbf@walle.cc>
        <20220512154455.31515ead@kernel.org>
        <072a773c-2e42-1b82-9fe7-63c9a3dc9c7d@solid-run.com>
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

On Sun, 15 May 2022 10:16:47 +0300 Josua Mayer wrote:
> Am 13.05.22 um 01:44 schrieb Jakub Kicinski:
> > On Thu, 12 May 2022 23:20:18 +0200 Michael Walle wrote:  
> >>> It's pure speculation on my side. I don't even know if PHYs use
> >>> the recovered clock to clock its output towards the MAC or that's
> >>> a different clock domain.
> >>>
> >>> My concern is that people will start to use DT to configure SyncE which
> >>> is entirely a runtime-controllable thing, and doesn't belong.  
> Okay.
> However phy drivers do not seem to implement runtime control of those 
> clock output pins currently, so they are configured once in DT.

To me that means nobody needs the recovered clock.

> >>> Hence
> >>> my preference to hide the recovered vs free-running detail if we can
> >>> pick one that makes most sense for now.  
> I am not a fan of hiding information. The clock configuration register 
> clearly supports this distinction.

Unless you expose all registers as a direct API to the user you'll be
"hiding information". I don't think we are exposing all possible
registers for this PHY, the two bits in question are no different.

> Is this a political stance to say users may not "accidentally" enable 
> SyncE by patching DT?
> If so we should print a warning message when someone selects it?

Why would we add a feature and then print a warning? We can always add 
the support later, once we have a use case for it.

> >> I see. That makes sense, but then wouldn't it make more sense to pick
> >> the (simple) free-running one? As for SyncE you'd need the recovered
> >> clock.  
> > 
> > Sounds good.  
> 
> Yep, it seems recovered clock is only for SyncE - and only if there is a 
> master clock on the network. Sadly however documentation is sparse and I 
> do not know if the adi phys would fall back to using their internal 
> clock, or just refuse to operate at all.
