Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7A162A1A5
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 20:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKOTA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 14:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiKOTA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 14:00:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D69DF13
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 11:00:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71FFEB81A84
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 19:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B679C433D6;
        Tue, 15 Nov 2022 19:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668538854;
        bh=FgOaXekfEF9/C4VF8NgE7NQvk40ApEn4CoxMXD9hVag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mAivD5ATnolOJnjRY9YvO6szyAVHzlhv7Li8NAES49d+hPJpmM9b5749UVX/ROkPX
         sLhdv38J3+4Vf1gg2WijT3Ws7YSL4Iob9gomTaxk4D9n6cBoIfuxyAfkj9d1dc+ECt
         EbxxUnlOnw8aCaO0WvGxv6fQhC5zYfKuwolHnXMu+/5k+zEjLqNZHvWARIY5Z+FnMC
         UQXKa+JKZdwsJhlKRJoEk/PpyoaOl1k5kSix/jkIZ5ePm1zSW9E3GsD9BU8Kg+I3VS
         AxNPtWCU7qA7oit0rDTh3Dl5nlGftlLNi4WUYQyY9aySYRU/uMu0kf2CKl0tpcdkIM
         lO2sIue1EMbXw==
Date:   Tue, 15 Nov 2022 21:00:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <Y3Ph4Lnf2vV0Hx3U@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <Y3PV7HM5cDoZogCY@unreal>
 <20221115183020.GA704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115183020.GA704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 07:30:20PM +0100, Steffen Klassert wrote:
> On Tue, Nov 15, 2022 at 08:09:48PM +0200, Leon Romanovsky wrote:
> > On Wed, Nov 09, 2022 at 02:54:28PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Changelog:
> > > v7: As was discussed in IPsec workshop:
> > 
> > Steffen, can we please merge the series so we won't miss another kernel
> > release?
> 
> I'm already reviewing the patchset. But as I said at the
> IPsec workshop, there is no guarantee that it will make
> it during this release cycle.

Of course, there is no guarantee, but let's not skip it if it is ready.

Thanks
