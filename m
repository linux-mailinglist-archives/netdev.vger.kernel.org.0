Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8797059A537
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350296AbiHSSGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349841AbiHSSGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:06:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AAE5F990
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82BB461893
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 17:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0B5C433C1;
        Fri, 19 Aug 2022 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660931637;
        bh=yOh9N5MFHoQrepwBUPCrQDYkKUaLh7fK8DX7TwHbQ6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CsxAbKYj0fsY1w8eTo/0gncH4gzFkUFQbXCcik2+JWYVD+xysn8/JwH57jlTwMRBZ
         aDVlJxmo5dqpqhF22ZsdlJXpzmZKpHeKeP+mzbDCRLw7Ova+nmMUfXcOGo384mkpbd
         cPx+MYchhGIhIzF4J+UFHBM3gMhdnnqnWy/Qc0yNPQlrWhe0xy+fc4wl8KUlIzDiGK
         7bFfcTj4IBc+te9u/bBN68I/xwYigrsPbTLISrFpHj73NCjkN6J0T59NT/gSNl2/xz
         SQwKxOscY84ORvPD5YKf34qR9F9KD15sUNRDiM7wSuwrVC5l5Doi3AIfPCx3D8/IPv
         Bv5NWWcXw27LQ==
Date:   Fri, 19 Aug 2022 10:53:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220819105356.100003d5@kernel.org>
In-Reply-To: <Yv+z0nBW60SBFAmZ@nvidia.com>
References: <cover.1660639789.git.leonro@nvidia.com>
        <20220816195408.56eec0ed@kernel.org>
        <Yvx6+qLPWWfCmDVG@unreal>
        <20220817111052.0ddf40b0@kernel.org>
        <Yv3M/T5K/f35R5UM@unreal>
        <20220818193449.35c79b63@kernel.org>
        <Yv8lGtYIz4z043aI@unreal>
        <20220819084707.7ed64b72@kernel.org>
        <Yv+z0nBW60SBFAmZ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 13:01:22 -0300 Jason Gunthorpe wrote:
> Regardless, RDMA doesn't really intersect with this netdev work for
> XFRM beyond the usual ways that RDMA IP traffic can be captured by or
> run parallel to netdev.
> 
> A significant use case here is for switchdev modes where the switch
> will subject traffic from a switch port to ESP, not unlike it already
> does with vlan, vxlan, etc and other already fully offloaded switching
> transforms.

Yup, that's what I thought you'd say. Can't argue with that use case 
if Steffen is satisfied with the technical aspects.
