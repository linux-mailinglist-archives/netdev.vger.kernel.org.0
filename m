Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9318C6C6E63
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjCWRGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCWRGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:06:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F4C90
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF467CE2157
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 17:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08BBC433EF;
        Thu, 23 Mar 2023 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679591157;
        bh=xGWuJYEQeg9o4AB1nEtgj3arV7wWSdI4TeDvb0UXKOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IlrJnuwmuVhGP5PSkE1J/0yeKjKvHR3OBiqOymybW3cIFlU72XC0x+xfmMpxDdxei
         w2ukq1S8HHM1UtbT38r2u2HCkY512vFkKakzcRRG6jlaKUIZQoRz4wsQmgSJjNI3O4
         HLN5zJTvkXF2bPXARk8ZbI65pbYgosJxqHsbP+ejVTceWfTb1vYpvdl3pbSlAZTVo5
         0GzTgbuQ6f+S6QaCT1BJfLL+GLwLxiqnRH/iKyPJv/zUyW/tMVHdTSXx68vFRMW+qb
         s7NNPDOwrOSvMlrRtBOJVDsfkEm0srIX9CM0n4UcvHAlyQzDV5wVEM3p0nZUhRH+o7
         Va+MZk5keO4qg==
Date:   Thu, 23 Mar 2023 10:05:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dima Chumak <dchumak@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] devlink: Add port function attributes to
 enable/disable IPsec crypto and packet offloads
Message-ID: <20230323100556.6130a7cd@kernel.org>
In-Reply-To: <20230323111059.210634-1-dchumak@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 13:10:55 +0200 Dima Chumak wrote:
> Currently, mlx5 PCI VFs are disabled by default for IPsec functionality.
> A user does not have the ability to enable IPsec support for a PCI VF
> device.

Could Mellanox/nVidia figure out a why to get folks trained on posting
patches correctly? IDK how to do that exactly but you have a rather
large employee base, it may be most efficient if you handle that
internally than the community teaching people one by one.

Or perhaps there's something we can do to improve community docs?

Dima please read:

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

And repost appropriately.
