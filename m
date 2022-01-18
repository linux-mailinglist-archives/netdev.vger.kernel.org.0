Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41977492CF6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 19:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347753AbiARSH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 13:07:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57574 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiARSHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 13:07:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC144B816B8
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490C3C340E0;
        Tue, 18 Jan 2022 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642529272;
        bh=1cFfxvXQQNknFgUnQNTHqk+HdTRdSfpYhS7yJqnMVsU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KYipwJaEiRuFh49XkWNgqHT5Dirahv8KyXJSW5plWZ9RMC9/+DulaiE+Y44QBBA7s
         doX6hAQsQ9Q/P26IlGiDWKCeWXBUr/V6j0IUq8bCCcLA/RriuTMzGzLO5CsGkoti4s
         hSd9t19PWovGequdPwSMlZFoELnAYTXKBrKsBUyBO7tpgFEpKylfqUG9MIcfK17Ywv
         o0likpx1CTjajRBigbFFvkkgyCn4NJ88EK6kV82gBjlqbUV2Am31XtjEdsWmG+O1p4
         dwG/JovGLVw7mzj7dwSTnqwek+1/Z/aEcPo7OsBkWhl7x6lTolQsqlkvzgR0aShjVZ
         Cxu4J2zx3CWdg==
Date:   Tue, 18 Jan 2022 10:07:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Port mirroring, v2 (RFC)
Message-ID: <20220118100751.542e0ad0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <6d25d602-399e-0a25-1410-0e958237db11@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
        <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
        <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org>
        <YeHhKDUNy8rU+xcG@lunn.ch>
        <6d25d602-399e-0a25-1410-0e958237db11@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 15:12:41 -0600 Alex Elder wrote:
> > I think i need to take a step back here. With my background, an AP is
> > an 802.11 Access Point.  
> 
> Again, terminology problems!  Sorry about that.
> 
> Yes, when I say "AP" I mean "Application Processor".  Some people
> might call it "APSS" for "Application Processor Subsystem."

And AP is where Linux runs, correct? Because there are also APs on NICs
(see ETH_RESET_AP) which are not the host...
