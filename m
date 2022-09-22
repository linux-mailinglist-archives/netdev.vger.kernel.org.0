Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE605E6382
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiIVNYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiIVNYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:24:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA873EFF40
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:24:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C89AB8366B
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EEFC433C1;
        Thu, 22 Sep 2022 13:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663853047;
        bh=jzyPSqNcYqGdLDuR6/hNATyrVvUrfedOpX6sE1uAwbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A72mEVINqOgV+a6hG3AOmcB/1ttL32+nAG7pawozhUpBcck+DRypYiOgywJS1Qnvj
         wIGPJBGRS3bjC/vZ9SCLvKjgjVuxEbDCI+SVhRogFARumMRlnqXK5nlXzWvLy2RH74
         n/vcD2m+C4JbONMBjr0Xo7dHlLYNCT4KOQsGU4dQ/CjUciTEViaspF06jcVftlhkOA
         tgHhv3TDY7JiFWtPEK6Hqc0FX6t9cW7ffCZsEynhWR1kpZcRiHi0Jl2dE19g6vFqoJ
         G0+tPzaOIFFTmsOmykxMRRS3aApNo4z6srU3149F4SOsD1dAzNSY618RLY1ug+Svbu
         sOuUsBS8Scs1Q==
Date:   Thu, 22 Sep 2022 06:24:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <20220922062405.15837cfe@kernel.org>
In-Reply-To: <Yyu6w8Ovq2/aqzBc@lunn.ch>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
        <20220921113637.73a2f383@hermes.local>
        <20220921183827.gkmzula73qr4afwg@skbuf>
        <20220921154107.61399763@hermes.local>
        <Yyu6w8Ovq2/aqzBc@lunn.ch>
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

On Thu, 22 Sep 2022 03:30:43 +0200 Andrew Lunn wrote:
> Looking at these, none really fit the concept of what the master
> interface is.
> 
> slave is also used quite a lot within DSA, but we can probably use
> user in place of that, it is already somewhat used as a synonym within
> DSA terminology.
> 
> Do you have any more recommendations for something which pairs with
> user. 

cpu-ifc? via?
