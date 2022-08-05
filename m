Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B1658B244
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 00:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241779AbiHEWCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 18:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241795AbiHEWBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 18:01:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86A415FD5;
        Fri,  5 Aug 2022 14:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C334B828C1;
        Fri,  5 Aug 2022 21:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C0FC433D6;
        Fri,  5 Aug 2022 21:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659736707;
        bh=rxSonpH412uobYK9gmbLa6aHdWFS056tCCG6Cx8N1oo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YbIln0/1v+6tzHWKACYmnVKbhVonTo6Ay164PD4Z+/GO49WiKvm3bYJRCBFmjs81R
         RejmXdRdXy5a5oHdUa/95fPC836gc7AoYJ5sDwDwUhaTpX7w6yBzJaebqQ+rCxv/8K
         4FprN9Sse7JSAIizHHR4Rg39FrmkcfuVtsTolyl83D7MbOx2UxHdsOdyKKdJD3/gBA
         A0WvaSgCqR+hIpA+AbV8VlCGYPpfXCCSkC9k/rScnUx9kraRDVuPNkqgkW9PSx426E
         pO7JTDr13UYhWNk66u+vXuG2jeeiYSFf6QWfXduG4GIpaIK9US2+bmDQsP3xDglNJr
         Pxn76ILRaP3Ow==
Date:   Fri, 5 Aug 2022 14:58:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:CXGB4 ETHERNET DRIVER (CXGB4)" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 24/26] thermal/drivers/cxgb4: Use generic
 thermal_zone_get_trip() function
Message-ID: <20220805145826.4cea7828@kernel.org>
In-Reply-To: <82d5701e-9d22-cc4d-0d19-324147b64192@linaro.org>
References: <20220805145729.2491611-1-daniel.lezcano@linaro.org>
        <20220805145729.2491611-25-daniel.lezcano@linaro.org>
        <20220805131157.08f6a50f@kernel.org>
        <82d5701e-9d22-cc4d-0d19-324147b64192@linaro.org>
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

On Fri, 5 Aug 2022 23:48:02 +0200 Daniel Lezcano wrote:
> > Are you targeting 6.0 with these or should we pick it up for 6.1 via
> > netdev? I didn't see any notes on merging in the cover letter.  
> 
> Right, if it can go through the thermal tree, all the changes will be in 
> the same place, that will help

Would you be able to send them as a PR so we can also pull it in?
cxgb4 is not that active but why risk a conflict if we're starting
with a clean merge window slate. 

Either way:

Acked-by: Jakub Kicinski <kuba@kernel.org>
