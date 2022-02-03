Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3474A7ECE
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbiBCFCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiBCFCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 00:02:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F48C061714;
        Wed,  2 Feb 2022 21:02:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D6126172F;
        Thu,  3 Feb 2022 05:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482F5C340E8;
        Thu,  3 Feb 2022 05:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643864569;
        bh=hZtw8q9Ky8oUcxWVNf0TNaZ+8gLjnD87p8CNwMecU4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NjUOV9tNw8woaqHr10JY6495xL//ic8tAu2TfN6SVMWn3yvd9jxQnCfgY8JAFq6zE
         /Eyo7WtQxphgDO0MYdtAb+hFRIOpXc38vUtmLk4ApFqyNdWFaGER/8kXAD59kUQvi1
         BPR/fzmVsx/rHZb5iDDmZZOEDR0dQeqcIAOboy0HezKrh33wAghZNT2gN9BsUDzNg8
         xHw9+8vjl1dIGUgNdRV6Qt537wA5ikM7XBru0aB01PEQe/M7b6hWkrmukAbozTNdm1
         GFyaFld7v5EVMgGfdHaIkqGf7VQeAq38y1wpb5am4KjmqcuA+jVFhMnFnccmyUjxDu
         eqO/ic/rRkXvw==
Date:   Wed, 2 Feb 2022 21:02:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, robh+dt@kernel.org,
        bjorn.andersson@linaro.org, agross@kernel.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: ipa: request IPA register values be
 retained
Message-ID: <20220202210248.6e3f92ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220201140412.467233-3-elder@linaro.org>
References: <20220201140412.467233-1-elder@linaro.org>
        <20220201140412.467233-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Feb 2022 08:04:12 -0600 Alex Elder wrote:
> Fixes: 2775cbc5afeb6 ("net: ipa: rename "ipa_clock.c"")

The Fixes tag should point at the place the code was introduced, 
even if it moved or otherwise the patch won't apply as far back.
