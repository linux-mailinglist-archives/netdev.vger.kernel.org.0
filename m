Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012CD596792
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbiHQCyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiHQCyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:54:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C01560515
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 19:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1FE261494
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE29C433D6;
        Wed, 17 Aug 2022 02:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660704850;
        bh=Bh1eQiixVgfpx0ka064Nhjzwo7IPu9Z0EGPqRHZcehc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cjuDY1OcuDF9JDWkBeOdD+KqW3P2c1UJUYVClRXUMy26Hc8gCt8qGgtyzODdcN0JH
         5N7VDyBLh1ioAIl2p24tikAWuNsRftX6e3HPZVLLEDmXPzAq2q+lF00E2+YJtZzmo8
         KWGQuPBEuKPqnj9b0UBrFoDUBjQXw/iPpvc0nbwouPgAnLyWWkHYljIFfXBg1iwVpp
         fOK+8It8yaF3ANs7RdRHi/sog+0jJ8zovcJCjLDqcz8/E1+XG+qgWDqouroZanLn9d
         Xnf9FYzBvRbXokNm/CuXQl1fMcpoWS4HJ3sJJ7vSM3kyLBDrUaouQ0PVS+91vhqpNr
         K6uq7etNaTWwQ==
Date:   Tue, 16 Aug 2022 19:54:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220816195408.56eec0ed@kernel.org>
In-Reply-To: <cover.1660639789.git.leonro@nvidia.com>
References: <cover.1660639789.git.leonro@nvidia.com>
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

On Tue, 16 Aug 2022 11:59:21 +0300 Leon Romanovsky wrote:
> The following series extends XFRM core code to handle new type of IPsec
> offload - full offload.
> 
> In this mode, the HW is going to be responsible for whole data path, so
> both policy and state should be offloaded.

This is making a precedent for full tunnel offload in netdev, right?
Could you indulge us with a more detailed description, motivation,
performance results, where the behavior of offload may differ (if at
all), what visibility users have, how SW and HW work together on the
datapath? Documentation would be great.
