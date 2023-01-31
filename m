Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1006836C6
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjAaTpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjAaTpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:45:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76231521C3;
        Tue, 31 Jan 2023 11:45:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B41DB81EA0;
        Tue, 31 Jan 2023 19:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0782CC433EF;
        Tue, 31 Jan 2023 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675194340;
        bh=fQd/be/jrJ7UexUlINl30/PPUvSR4hvzzmgRPa4YWKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hKJv4KnspYTvjXQzECzMhHLu8c6nSxx6XylgVzKkOxbg8xaUoHb2XmFzZe7ZBYyka
         uUmTaHyBo8Kf20zsTX9MnfUbwyixt6hVxWizjWaNJtJY+TZmBt9NkNqy5vOFIWNWwH
         pzTZCYPR6NqHwTbkfUeFt9SUIz0Smv0HMulEAlUqr/ZhGm8K5s/ThHQXMY5cb9uZif
         HajPE0X3uNpWuh+gPEzD4UaUqm15tZrs3vO6Ybv7hDKa4Pt9+ltCqYG3P+lwwKqBL9
         /mPXDte9ranyAyUS85dEUnHPvKeR0b/kT5V9XRP4jFF7A2tkorspRl3PhgyGCIFyEn
         7a3xpv2vMSatw==
Date:   Tue, 31 Jan 2023 11:45:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee@kernel.org>
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
Message-ID: <20230131114538.43e68eb3@kernel.org>
In-Reply-To: <Y9jaDvtvzPxIrgFi@google.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
        <167514242005.16180.6859220313239539967.git-patchwork-notify@kernel.org>
        <Y9jaDvtvzPxIrgFi@google.com>
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

On Tue, 31 Jan 2023 09:06:22 +0000 Lee Jones wrote:
> Please don't do that.  The commits do not have proper Acked-by tags.
> 
> The plan is to merge these via MFD and send out a pull-request to an
> immutable branch.  However, if you're prepared to convert all of the:
> 
>   Acked-for-MFD-by: Lee Jones <lee@kernel.org>
> 
> to
> 
>   Acked-by: Lee Jones <lee@kernel.org>

Sorry, I must have been blind yesterday because I definitely double
checked this doesn't touch mfd code. And it does :/

The patches should not be sent for net-next if they are not supposed 
to be applied directly. Or at the very least says something about
merging in the cover letter!

> ... and send out a pull request to a succinct (only these patches) and
> immutable branch then that is also an acceptable solution.
> 
> Please let me know what works best for you.

Sorry for messing up again. Stable branch would obviously had been best.
Do we have to take action now, or can we just wait for the trees to
converge during the merge window?
