Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804D667CA59
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 12:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbjAZL7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 06:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjAZL7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 06:59:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA7462263;
        Thu, 26 Jan 2023 03:59:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD0ECB81D46;
        Thu, 26 Jan 2023 11:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933E2C433EF;
        Thu, 26 Jan 2023 11:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674734353;
        bh=FWWJFpobRb0f4jIYDScBQjebG8oOkbQRtojwF6I9pto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a2CHSMRR2qblKs3tYBXdtEvUQJBaEygMtAq+M7kihcPvUWQxU8oUPtw1Otj9WfeqZ
         uZgHnPUVK5St+xvr745MrhUkrTJvT4iHkRptilHwwdxLB4kS0/4N722vlMYLexHdU6
         tfk6epiWVYWpgvkeNVRAz/lUCV3ZyHU60JahlxZ7/Z09J7tWXRIffCfORG4EZ7dvXw
         3dscl9880EDVCnSuMKWTpOpFrf66cSHHysl3tdLmoSV/HY/sxxAAL4NPln+Mdq6vHQ
         2GIsAEPwoIp2cT0qu4Ir6+Hj/ZPUtZQ7Eb9zntPalGvGhVFBDqse6ZEa58GkPaUV11
         Amg0SNp7su9Lw==
Date:   Thu, 26 Jan 2023 19:59:04 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Li Yang <leoyang.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: ls1046ardb: Use in-band-status for SFP module
Message-ID: <20230126115903.GK20713@T480>
References: <20230124174757.2956299-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124174757.2956299-1-sean.anderson@seco.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 12:47:57PM -0500, Sean Anderson wrote:
> net10 is connected to an SFP module. Unfortunately, the I2C lines are
> not connected due to an address conflict. Now that DPAA uses phylink, we
> can use in-band-status. This lets us determine whether the link is up or
> down instead of assuming it is up all the time. Also fix the phy mode
> while we're here.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Applied, thanks!
