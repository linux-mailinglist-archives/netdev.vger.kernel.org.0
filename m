Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD66948CB5A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356291AbiALSzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356338AbiALSyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:54:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD245C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:54:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BD8161A4E
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 18:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCC8C36AEA;
        Wed, 12 Jan 2022 18:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642013670;
        bh=jTTr0A3W4N0cTN1OvFEKqDKW74mv/lKbfnEOWcwjPa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=otEa/4iXFFQapkRMnyKn7aRAbm539dphmfBGnKw0l+gJ2YxiAFrHZSnEuRW7Rc/+/
         3q5nsSeayKvItQDOwpcB3KRnsQlK77I+gBbne42YID9+8kP07J6eBOgP+soEjYCHbF
         5cGrOwNzudgU4o/b76oOas7zCb1mUXX7eo8RO18Pa4K8c5nITXYpUnNxfUeCSB05tG
         dUVcuNECKVpQEPYxfh3rb9G1u1TKEN/9mW5zO1RphY9nG2tXlMp9YWlISaoiZyGJEJ
         4KpUb74OaAD/MD8Z0y/jtXcrlsyAB2UWcR6UU84T7o9JSMnituOdO+a65yURhcgwvp
         8ckMPcCCWkNXw==
Date:   Wed, 12 Jan 2022 10:54:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, mail@david-bauer.net
Subject: Re: [PATCH net-next v3 0/3] at803x fiber/SFP support
Message-ID: <20220112105429.49748b75@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112174418.873691-1-robert.hancock@calian.com>
References: <20220112174418.873691-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 11:44:15 -0600 Robert Hancock wrote:
> Add support for 1000Base-X fiber modes to the at803x PHY driver, as
> well as support for connecting a downstream SFP cage.
> 
> Changes since v2:
> -fixed tabs/spaces issue in one patch
> 
> Changes since v1:
> -moved page selection to config_init so it is handled properly
> after suspend/resume
> -added explicit check for empty sfp_support bitmask

Please not that net-next is closed during the merge window, 
all the non-fixes will have to be reposted. Looks like patch 1
can be separated out of this series and reposted for net.


# Form letter - net-next is closed

We have already sent the networking pull request for 5.17
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.17-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
