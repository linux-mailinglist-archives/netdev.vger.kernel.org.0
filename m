Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DCE643AC5
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiLFBdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiLFBd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:33:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BADD1A836
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 17:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4C37B815D1
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253F9C433C1;
        Tue,  6 Dec 2022 01:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670290405;
        bh=FOSFp6ww9p5br2tXOtrpRtu5gzVprXj7AyWZt8zMlWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jvEWDl4gSsGsU0ROG0Tr5uOkzmm+dWdTE6cW4wIc5EmuVpbHxJOM2Q1wj+Ieqther
         MVG/rotr8BbDJNjr/lD/ou27bLl6mGbF4hZ8QdmJzKF7NZmHRHSyXEIwEEindjtff/
         rU0U1of5dQhEQG1xr7lJHpk3IxH4TscpFLuaRH6p41bjSb+zd12yuPy0CqQ7M3nDjX
         FoufkUYqIRV1DNWmOGkIpdIBn+Du0GU7jTs2vLnDn7PebqEwjhNKiK4cjCwSUMjZ+h
         j1vbyTgxBdXqIza/vo4pyCBGDXelkC9EghiGBmXfYaX+2riq0SIhoJuDM/h8LG+NDu
         rYHohroVvcVkw==
Date:   Mon, 5 Dec 2022 17:33:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v7] ethtool: add netlink based get rss support
Message-ID: <20221205173324.072b21da@kernel.org>
In-Reply-To: <Y42hg4MsATH/07ED@unreal>
References: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
        <Y4yPwR2vBSepDNE+@unreal>
        <20221204153850.42640ac2@kernel.org>
        <Y42hg4MsATH/07ED@unreal>
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

On Mon, 5 Dec 2022 09:45:07 +0200 Leon Romanovsky wrote:
> > Conversion to netlink stands on its own.  
> 
> It doesn't answer on my question. The answer is "we do, just because we
> can" is nice but doesn't remove my worries that such "future" extension
> will work with real future feature.

By that logic we should have not merged 90% of netlink ethtool patches,
and I don't think we have had any major backward compat problems.

> From my experience, many UAPI designs without real use case in hand
> will require adaptions and won't work out-of-box.

Which is why this patch has been cut down to the bare minimum.
See the reviews for previous 6 versions.

> IMHO, it is the same sin as premature optimization.

Your feedback has been registered.
