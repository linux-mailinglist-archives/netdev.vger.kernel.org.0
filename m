Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA4265E97B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjAELBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbjAELBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:01:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D991551F9;
        Thu,  5 Jan 2023 03:01:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8304E619BF;
        Thu,  5 Jan 2023 11:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25744C433D2;
        Thu,  5 Jan 2023 11:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672916482;
        bh=4AaEU+L5WfhDASHSgIolPkmwy4JpsfUnNhDjGO6Fd54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Omg4CCtXnbWbYLxpmbdTRmwO5mt0C70C2S2HaL2EujR2sF3ghhJfeqQwk26FL97Za
         WNDcLfl06o9qZorbL6HOHDHCyOUzArGQPtYE42IPqA6f7MDXcspRrvz/PndTz8crqt
         zNzWqImF16PqTIQfcFRzkRlUfB93KZTaWK2EXSaxP/2plWsmzh4Hkkgakd5Mlf0Zsg
         ztdUtiHc1CGj5uDqAbXd6qVHoBj4UOOj2RMD2RL2nFsZlvbnQIeKLdQv4ZJuKw+c8n
         QxQw9RKM8dRYLurrU0eF4sHvIc7Ei8bxNkRrrKSYy4mvRpzNFYEBKxESSZXwBZLO8r
         r7LghxaAYMu9g==
Date:   Thu, 5 Jan 2023 13:01:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 1/5] net/ethtool: add netlink interface for the
 PLCA RS
Message-ID: <Y7at/jgmELqA984u@unreal>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
 <76d0a77273e4b4e7c1d22a897c4af9109a8edc51.1672840325.git.piergiorgio.beruto@gmail.com>
 <Y7aQcgR4C9Lg/+yK@unreal>
 <Y7aquABWDDmPeRAV@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7aquABWDDmPeRAV@gvm01>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 11:47:20AM +0100, Piergiorgio Beruto wrote:
> Thanks Leon for your review.
> Please, see my comments below.

<...>

> > > +	ret = ethnl_ops_begin(dev);
> > > +	if (ret < 0)
> > > +		goto out;
> > 
> > I see that many places in the code used this ret > 0 check, but it looks
> > like the right check is if (ret).
> Thanks. I've fixed those, although I copied this code from similar files
> (like cable test). Maybe we should check these out as well?

I don't think that it is worth to invest time in that. The code works
the same with if (ret<0) and if(!ret).

Thanks

> > 
> > Thanks
> 
> Thanks!
> Piergiorgio
