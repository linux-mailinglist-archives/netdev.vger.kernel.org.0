Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2156CD385
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjC2Hpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjC2Hpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:45:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6849A1BF6
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 00:45:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20531B81CC0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469D5C433D2;
        Wed, 29 Mar 2023 07:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680075941;
        bh=VAZpVRXx6wDBRkcIVrNTuE/bd3j4sAOGdSFQtcnuqH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PxdbC+eAL6rNPumRjylPwE5v/KlOKemloVaAjfqd2FXGOrb8TE3YVYZ8IV1gQ0au8
         R99OSjpUa+bRK25oDiTN+NwHWe39ojLPccl8KkgPhl+bMHKTapM9w3N9ej+U/JZRyJ
         F/8SCykXwQOjLWAwxE85N94sGR3An/X0hzTYPmZULv13kvki6Yn9gBeAh53IQuk4DF
         zKJTYRVU4EgWlE9JA9xnwUinm5l2kOkf797CXCRyLYrE8Y7O2egVULODjJD/Za4A3e
         GWpeKtu2XIWFw2nsbNi9B670vhY1i7OXxUWqMpB4+hsBGJzMGEMoe9d7lLeFIwYewZ
         JRWV4C/A85/ig==
Date:   Wed, 29 Mar 2023 10:45:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dima Chumak <dchumak@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] devlink: Add port function attributes to
 enable/disable IPsec crypto and packet offloads
Message-ID: <20230329074537.GH831478@unreal>
References: <20230323111059.210634-1-dchumak@nvidia.com>
 <20230323100556.6130a7cd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323100556.6130a7cd@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 10:05:56AM -0700, Jakub Kicinski wrote:
> On Thu, 23 Mar 2023 13:10:55 +0200 Dima Chumak wrote:
> > Currently, mlx5 PCI VFs are disabled by default for IPsec functionality.
> > A user does not have the ability to enable IPsec support for a PCI VF
> > device.
> 
> Could Mellanox/nVidia figure out a why to get folks trained on posting
> patches correctly? IDK how to do that exactly but you have a rather
> large employee base, it may be most efficient if you handle that
> internally than the community teaching people one by one.

IDK why Dima postes like he posted, but we guide people and provide nice playground
to test submissions internally, but it is not enough. There are always nuances in
submission as rules constantly evolve.

> 
> Or perhaps there's something we can do to improve community docs?

People don't read them :)

> 
> Dima please read:
> 
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
> 
> And repost appropriately.
