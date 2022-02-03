Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A6A4A7ED8
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbiBCFGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiBCFGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 00:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31488C061714;
        Wed,  2 Feb 2022 21:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBDD1B832B4;
        Thu,  3 Feb 2022 05:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BF6C340E8;
        Thu,  3 Feb 2022 05:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643864800;
        bh=MhborinkrgbHuL2kYhOyZnXcwLbzW4P5OGYVMOSscSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bStjN1VdJqBCOF4Z4J2NsniGgYJnutzPG351VPCCkKZrRQlEgxWIowi01rzGgTGLS
         nw2fXTz15f9iSKWtJhOSewFkdId31vwiapdZYc3IAlbrlfzYHl5BlWnFtob0WshyXY
         uGyLa1hfbO7Co6FGCEvOjTtL0ZfEP+Xrv/cc+KD6SXNc8m7CbejJHwLfWeJAzaHOSc
         WjOQO0JWnI1nYrXU8JfwAZhe5Uc2reaqNSN9EkNebkOSD1h0RiEu+pePKGrqTqNrBt
         l5NV7cyRSIChi9JDJEKG+d43XCJLe8LPotE+pOqp5VYrrYC2FCQorLNKucqFMFZf1M
         rHFR3u6dC6zxQ==
Date:   Wed, 2 Feb 2022 21:06:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, robh+dt@kernel.org,
        davem@davemloft.net, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: qcom: add IPA qcom,qmp property
Message-ID: <20220202210638.07b83d41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220201140723.467431-1-elder@linaro.org>
References: <20220201140723.467431-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Feb 2022 08:07:23 -0600 Alex Elder wrote:
> At least three platforms require the "qcom,qmp" property to be
> specified, so the IPA driver can request register retention across
> power collapse.  Update DTS files accordingly.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> 
> Dave, Jakub, please let Bjorn take this through the Qualcomm tree.

I don't know much about DT but the patch defining the property is
targeting net - will it not cause validation errors? Or Bjorn knows 
to wait for the fixes to propagate? Or it doesn't matter? :)
