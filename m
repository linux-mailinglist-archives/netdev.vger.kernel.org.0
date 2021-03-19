Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6D53424B4
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhCSSdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:33:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37636 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230264AbhCSSci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 14:32:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lNJvD-00BvQJ-Pz; Fri, 19 Mar 2021 19:32:31 +0100
Date:   Fri, 19 Mar 2021 19:32:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: ipa: activate some commented assertions
Message-ID: <YFTuP7NbUFPoPoCb@lunn.ch>
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-5-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319042923.1584593-5-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -212,7 +213,7 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
>  			BCR_HOLB_DROP_L2_IRQ_FMASK |
>  			BCR_DUAL_TX_FMASK;
>  
> -	/* assert(version != IPA_VERSION_4_5); */
> +	ipa_assert(NULL, version != IPA_VERSION_4_5);

Hi Alex

It is impossible to see just looking what the NULL means. And given
its the first parameter, it should be quite important. I find this API
pretty bad.

    Andrew
