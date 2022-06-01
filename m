Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C4C53AE47
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 22:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiFAUmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 16:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiFAUmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 16:42:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE33F1D5030;
        Wed,  1 Jun 2022 13:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 296806167C;
        Wed,  1 Jun 2022 19:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38913C385A5;
        Wed,  1 Jun 2022 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654111579;
        bh=kjzuy5OLcjNnr7n1+E35W4+dixKa9+A7A847BOlSHXQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=My9EOlOPXw6b1JIbY5dKxbfR4SKtNunO75fcat7yYSD2rPvReQ/OHt/WbAHOi4OiE
         Jx7AEOsPKjE0VbDYtDvqCJr9saTAsCzjkDHFku5pQCBrvoQR0FcngJsHS89EYo1MlG
         LYGG2hroi0tRrrLp5JAAxM2875plaZrnilWzm7piLsCi+e8IXBQ5m86+EEqVEuzgTc
         ErfwqXxF+cIYudObD1Xqyp7W+78doqYtwqG4NXqQwnwgyIpForpKygIw6P9btdwlzd
         qypamayShc3ATF0zx35OZfWhV+GoFZthqvSvscQMxGpIXIsI+gT3YvSiUzxy4EpDXh
         3gkt8rNruVcjQ==
Date:   Wed, 1 Jun 2022 12:26:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: Re: [PATCH] MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to
 TLS support removal
Message-ID: <20220601122618.78b93038@kernel.org>
In-Reply-To: <YperBiCh1rkKDmSR@unreal>
References: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
        <Ypc85O47YoNzUTr5@unreal>
        <20220601103032.28d14fc4@kicinski-fedora-PC1C0HJN>
        <YperBiCh1rkKDmSR@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jun 2022 21:08:06 +0300 Leon Romanovsky wrote:
> On Wed, Jun 01, 2022 at 10:30:39AM -0700, Jakub Kicinski wrote:
> > > Thanks, we will submit it once net-next will be open.  
> > 
> > It should go via net FWIW.  
> 
> I'm slightly confused here.
> 
> According to net policy, the patches that goes there should have Fixes
> line, but Fixes lines are added for bugs [1].
> 
> This forgotten line in MAINTAINERS doesn't cause to any harm to
> users/developers.

Fair, maybe I worded it too strongly. I should have said something like
"FWIW it's okay for MAINTAINERS updates to go via net".

Documentation/ patches and MAINTAINERS are special, they can go into
net without a Fixes tag so that changes to get_maintainer output and
https://www.kernel.org/doc/html/latest/ propagate quickly.

> So when should I put Fixes line in netdev?
> 
> [1] https://lore.kernel.org/netdev/20211208070842.0ace6747@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

