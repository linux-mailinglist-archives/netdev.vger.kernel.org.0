Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEFC3452A6
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 23:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhCVW5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 18:57:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41724 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230055AbhCVW5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 18:57:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOTTc-00CTuT-8k; Mon, 22 Mar 2021 23:56:48 +0100
Date:   Mon, 22 Mar 2021 23:56:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
Message-ID: <YFkgsHfldCNkaLSB@lunn.ch>
References: <20210320141729.1956732-1-elder@linaro.org>
 <20210320141729.1956732-3-elder@linaro.org>
 <YFcCAr19ZXJ9vFQ5@unreal>
 <dd4619e2-f96a-122f-2cf6-ec19445c6a5c@linaro.org>
 <YFdO6UnWsm4DAkwc@unreal>
 <7bc3e7d7-d32f-1454-eecc-661b5dc61aeb@linaro.org>
 <YFg7yHUeYvQZt+/Z@unreal>
 <f152c274-6fe0-37a1-3723-330b7bfe249a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f152c274-6fe0-37a1-3723-330b7bfe249a@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The solution is to create a user space tool inside the
> drivers/net/ipa directory that will link with the kernel
> source files and will perform all the basic one-time checks
> I want to make.

Hi Alex

Have you found any other driver doing this?  Where do they keep there
code?

Could this be a selftest, put somewhere in tools/testing/selftests.

Or can this be a test kernel module. Eg. we have crypt/testmsg.c which
runs a number of tests on the crypto subsystem,
./kernel/time/test_udelay.c which runs times on udelay.

Rather than inventing something new, please follow other examples
already in the kernel.

       Andrew 
