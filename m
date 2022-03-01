Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3DC4C7F35
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 01:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiCAAcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 19:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCAAcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 19:32:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC50764C;
        Mon, 28 Feb 2022 16:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 763A3B816C6;
        Tue,  1 Mar 2022 00:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBEFC340EE;
        Tue,  1 Mar 2022 00:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646094678;
        bh=Euw391qM8LjbXBajM9+tTp5fY6LR/jx5+DgRym+rV0M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p+4LNoQZC6RWYH3OJoYXk04Ws5oCuxGDBow3ww7Lg8UgeVyn04Dry3JlhtBcIP1CG
         rExyYNeQAtacbJc/Z1I+0hUDZGOvYOd12LYJSl1lfO3/CgV91/GLt4vctQZDoUT9P3
         Of6ocsTiYRIKiUoR7jFFKwjyWT8cuCRFbHruUsCTYfe7tXhEywgA9lW4Fnu+sEHLEm
         eHzOJaLR7mbXAOKp6TcbON09BdMo68dc+taCjVZ7+HaSEqB/Eh8Zt36M/re5MDI5Bd
         ZPuG3Uq+Ei0zQXXCO7vZ60X60LyDD8bqcasfs3w+6FEWpUPpiVGWMc8ZqpdkuqQWO/
         s5cNS3W1aw+dg==
Date:   Mon, 28 Feb 2022 16:31:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][for-next v2 00/17] mlx5-next 2022-22-02
Message-ID: <20220228163116.3eb49678@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220228224148.gwzbabatnedfrmu3@sx1>
References: <20220223233930.319301-1-saeed@kernel.org>
        <20220228224148.gwzbabatnedfrmu3@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 14:41:48 -0800 Saeed Mahameed wrote:
> On 23 Feb 15:39, Saeed Mahameed wrote:
> >From: Saeed Mahameed <saeedm@nvidia.com>
> >
> >Hi Dave, Jakub and Jason,
> >
> >v1->v2:
> > - Fix typo in the 1st patch's title
> >
> >The following PR includes updates to mlx5-next branch:
> 
> Dave, Jakub, I expecting this to be pulled into net-next, let me know if I
> did something wrong, I see the series is marked as "Awaiting upstream" in
> patchworks.

Indeed, pulled now, sorry for the wait!
