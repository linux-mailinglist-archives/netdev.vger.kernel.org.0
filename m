Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600D36DBF51
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 11:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjDIJNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 05:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDIJNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 05:13:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70E244AB;
        Sun,  9 Apr 2023 02:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60A6460B5F;
        Sun,  9 Apr 2023 09:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A94DC433D2;
        Sun,  9 Apr 2023 09:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681031609;
        bh=qiuMPkw3LflwK95ikVfNn16/3uu/H26vk5XI8BHKlRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rx3MHStfumvhAv4NbwovpwS0pYuLkKIpWJoaktVQ71qgytwDN1EuS0YMLMkQE3dHR
         GBbTDJWHgCge/tHQPGqsODt3+gdKvx5R3xP7dri8/tybT8R5LP+VcfSSUgEKvBtBSm
         s1u7HJk6Qmmr+AfyGAj796y8tXTN/IGyuhQdhsSWUsY0y5+yhZrp29lMCydfxhBLgn
         k2SxJYWLuj9DVHzNjJGbwpeBNaEvnovyctovGZ8Kb3jB5pHkv8XSGrtL5fl1gXYsvt
         bJ1Yn93Y5gWrfpE9dIqd64d6XR6BDuzmQyI7HZYvR4kzcrqwI4YDadTFJjCW5td9wo
         eZ+Vebw08ku8w==
Date:   Sun, 9 Apr 2023 12:13:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gautam Dawar <gautam.dawar@amd.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v4 00/14] sfc: add vDPA support for EF100 devices
Message-ID: <20230409091325.GF14869@unreal>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 01:40:01PM +0530, Gautam Dawar wrote:
> Hi All,
> 
> This series adds the vdpa support for EF100 devices.
> For now, only a network class of vdpa device is supported and
> they can be created only on a VF. Each EF100 VF can have one
> of the three function personalities (EF100, vDPA & None) at
> any time with EF100 being the default. A VF's function personality
> is changed to vDPA while creating the vdpa device using vdpa tool.

Jakub,

I wonder if it is not different approach to something that other drivers
already do with devlink enable knobs (DEVLINK_PARAM_GENERIC_ID_ENABLE_*)
and auxiliary bus.

Thanks
