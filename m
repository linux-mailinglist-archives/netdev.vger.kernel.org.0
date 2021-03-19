Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5011342487
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhCSSVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:21:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230206AbhCSSUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 14:20:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lNJjf-00BvJS-Md; Fri, 19 Mar 2021 19:20:35 +0100
Date:   Fri, 19 Mar 2021 19:20:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        kuba@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: ipa: introduce ipa_assert()
Message-ID: <YFTrc4wGyZ5142Es@lunn.ch>
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-4-elder@linaro.org>
 <YFQurZjWYaolHGvR@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFQurZjWYaolHGvR@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It will be much better for everyone if you don't obfuscate existing
> kernel primitives and don't hide constant vs. dynamic expressions.
> 
> So any random kernel developer will be able to change the code without
> investing too much time to understand this custom logic.
> 
> And constant expressions are checked with BUILD_BUG_ON().
> 
> If you still feel need to provide assertion like this, it should be done
> in general code.

+1

	Andrew
