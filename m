Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAD065FAFE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjAFFsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjAFFsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:48:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0335A4BD79
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 21:48:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6ABBB81B55
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE342C433EF;
        Fri,  6 Jan 2023 05:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672984114;
        bh=L+3BF+LXWNMABik/Z/cdjYUuUCVzx7tqmE2QU5cxraU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CyrBFssq+YSpOpdvECws2o3ZFdQy2fSqMkzJD/DDGjJ0nqpstfjdWFUURtKcFluZp
         w5D/FMj6s5JfOung+VptjPauoUbQ/nZWWRntqAICDO113BEb2PmhuWd9HM8pxU8qZ/
         hx+xW6547BHVel+Lm7X7l/yxObWWTIoJuA4N6Xmh6Snb4lZ4oBiDKtOcdD1hmwGM0F
         Z0eDZzhFZUNbOX0N6oaT2F+IIZDUZrExZdhxYE238Z5qPYPgYc2QBj6tL8IRCYOmIa
         g3WD9qEgH0O8il3utb8CRwHobHXxJ3hj41cts6U1v0D+JKzCGfWyRuhqphLwUagKmO
         RJ0qU3P9+xwJw==
Date:   Thu, 5 Jan 2023 21:48:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, kvalo@kernel.org
Subject: Re: [PATCH v2 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
Message-ID: <20230105214832.7a73d6ed@kernel.org>
In-Reply-To: <Y7a5XeLjTj1MNCDz@lore-desk>
References: <cover.1672840858.git.lorenzo@kernel.org>
        <3145529a2588bba0ded16fc3c1c93ae799024442.1672840859.git.lorenzo@kernel.org>
        <Y7WKcdWap3SrLAp3@unreal>
        <Y7WURTK70778grfD@lore-desk>
        <Y7aW3k4xZVfDb6oh@unreal>
        <Y7a5XeLjTj1MNCDz@lore-desk>
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

On Thu, 5 Jan 2023 12:49:49 +0100 Lorenzo Bianconi wrote:
> > > These callbacks are implemented in the mt76 driver. I have not added these
> > > patches to the series since mt76 patches usually go through Felix/Kalle's
> > > trees (anyway I am fine to add them to the series if they can go into net-next
> > > directly).  
> > 
> > Usually patches that use specific functionality are submitted together
> > with API changes.  
> 
> I would say it is better mt76 patches go through Felix/Kalle's tree in order to avoid
> conflicts.
> 
> @Felix, Kalle: any opinions?

FWIW as long as the implementation is in net-next before the merge
window I'm fine either way. But it would be good to see the
implementation, a co-posted RFC maybe?
