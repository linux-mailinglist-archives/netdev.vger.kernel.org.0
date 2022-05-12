Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F3E5257EF
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 00:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359269AbiELWo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 18:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244764AbiELWo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 18:44:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C95283A06
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 15:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBCBE61F5E
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 22:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64BEC385B8;
        Thu, 12 May 2022 22:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652395497;
        bh=SJ9KKf3X0A3qSjpOWGQ7rE4nBIiL22fmA+EBVYjNj04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=St1IJgkV3Y1Dpwd5vsBwhEx0BkN3WW1W+vGNpwSU6y7Ke0ljfr6iPX89tin00zOA1
         EZt1yV8Gr45NA76YwoNlqaoiXU9w3qBBBdwL6nvC4trW4+vVn8VARYhPQ4/KnnPKIs
         cIEdSn7jyJ9/N/H8tOuiH1XW/ShFihfQp1XPYxIQX9daWfGZBL710blulWv1mT/BQc
         bcy7N8RqiUHf8hi3M99YU2/WsLLVRJeR3k6euwBtKVH5NPEp+6NyTgF+3O0TSaQP7f
         s6eG4G3GSCopHsOMqWcM/Wm1VIJy602SWGnl+LcsZhP69PNSC1rdKbyEZ362njBlQg
         TDehYCKqaJTig==
Date:   Thu, 12 May 2022 15:44:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     alexandru.ardelean@analog.com, alvaro.karsz@solid-run.com,
        davem@davemloft.net, edumazet@google.com, josua@solid-run.com,
        krzysztof.kozlowski+dt@linaro.org, michael.hennerich@analog.com,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
Message-ID: <20220512154455.31515ead@kernel.org>
In-Reply-To: <bfe71846f940be3c410ae987569ddfbf@walle.cc>
References: <20220510133928.6a0710dd@kernel.org>
        <20220511125855.3708961-1-michael@walle.cc>
        <20220511091136.34dade9b@kernel.org>
        <c457047dd2af8fc0db69d815db981d61@walle.cc>
        <20220511124241.7880ef52@kernel.org>
        <bfe71846f940be3c410ae987569ddfbf@walle.cc>
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

On Thu, 12 May 2022 23:20:18 +0200 Michael Walle wrote:
> > It's pure speculation on my side. I don't even know if PHYs use
> > the recovered clock to clock its output towards the MAC or that's
> > a different clock domain.
> > 
> > My concern is that people will start to use DT to configure SyncE which
> > is entirely a runtime-controllable thing, and doesn't belong. Hence
> > my preference to hide the recovered vs free-running detail if we can
> > pick one that makes most sense for now.  
> 
> I see. That makes sense, but then wouldn't it make more sense to pick
> the (simple) free-running one? As for SyncE you'd need the recovered
> clock.

Sounds good.
