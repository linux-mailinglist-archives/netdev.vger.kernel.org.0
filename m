Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2416686384
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 11:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjBAKPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 05:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjBAKPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 05:15:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E952ED46;
        Wed,  1 Feb 2023 02:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57C6CB8212E;
        Wed,  1 Feb 2023 10:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD693C433EF;
        Wed,  1 Feb 2023 10:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675246551;
        bh=4F/4o9bF1W2DN0Tz9O4TNOCLMwNbDxBuiXPZyCpB0gs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X6igeg86uPp8w2LARhr1dVShiLvJlu602IgYEwsfwmNCqSbfImHEtymayqwOCwoCx
         mnoOXuiBB0Dgxhfw67E7Xd2XhQd//LHoTx0kcgSDKhels8D3aPm9fTGqgDlwBdau3R
         b6OpM6GQrYrZ2+JJ8pJ/gMVp/X0WbiX8xmSwifwyuBXiOxFKnV5Cs3lLTTrTsE5Pzy
         UB47pRjlwTtvIpiAflR9ODXgiHMs47Kbj+v+qAY2JsP0sgT3JvYJ+hKK+8DVa9ESXm
         2MnOO8w0ruL0fgWwVktbuVS57MXKrYW+FyL7P6w2PGUFCiiF8XLNGAGXoBxOBeoyd6
         P6xL6IwbYp+Tw==
Date:   Wed, 1 Feb 2023 10:15:43 +0000
From:   Lee Jones <lee@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        richardcochran@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com, pabeni@redhat.com,
        edumazet@google.com, davem@davemloft.net,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Subject: Re: [PATCH v5 net-next 00/13] add support for the the vsc7512
 internal copper phys
Message-ID: <Y9o7z0Ddbwus0M1R@google.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <167514242005.16180.6859220313239539967.git-patchwork-notify@kernel.org>
 <Y9jaDvtvzPxIrgFi@google.com>
 <20230131114538.43e68eb3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230131114538.43e68eb3@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Jan 2023, Jakub Kicinski wrote:

> On Tue, 31 Jan 2023 09:06:22 +0000 Lee Jones wrote:
> > Please don't do that.  The commits do not have proper Acked-by tags.
> > 
> > The plan is to merge these via MFD and send out a pull-request to an
> > immutable branch.  However, if you're prepared to convert all of the:
> > 
> >   Acked-for-MFD-by: Lee Jones <lee@kernel.org>
> > 
> > to
> > 
> >   Acked-by: Lee Jones <lee@kernel.org>
> 
> Sorry, I must have been blind yesterday because I definitely double
> checked this doesn't touch mfd code. And it does :/
> 
> The patches should not be sent for net-next if they are not supposed 
> to be applied directly. Or at the very least says something about
> merging in the cover letter!
> 
> > ... and send out a pull request to a succinct (only these patches) and
> > immutable branch then that is also an acceptable solution.
> > 
> > Please let me know what works best for you.
> 
> Sorry for messing up again. Stable branch would obviously had been best.
> Do we have to take action now, or can we just wait for the trees to
> converge during the merge window?

Russell explained to me (off-list) that the net-next branch is immutable
and the only way to fix this would be to revert the whole set.

Let's not go to that much trouble this time.

It does mean that I cannot take any more commits on the affected files,
but that shouldn't be a big deal seeing how far into the release cycle
we are.

No real harm done.

-- 
Lee Jones [李琼斯]
