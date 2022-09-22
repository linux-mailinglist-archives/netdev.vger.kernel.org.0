Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539045E6B84
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiIVTIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiIVTI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:08:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119C3FFA5B
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75A2363798
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 19:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEAFC433C1;
        Thu, 22 Sep 2022 19:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663873706;
        bh=cyYfmI5+8d1NFEnpneFi2gX0bDg/0oreLKIf4MJ/S0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rnl0Xvfqa15C0+RHVbkt5RCouL+yr+eY/VCp4I/74fe3SWH+K404o37ozE+sncLqi
         Iyx5d6wo0RlLBoW7hE0tte/ML/BTsiK96mwimMiKJHqe+4h4mtVl/vROXfSoGLbyIg
         pJ4k4lfAsQoRONQ4z3RO/JFHdJUSOhYbL8VCyit9BuD7CZGUaoYsqWQGWJqoqHo57n
         l7LNux3mJ+UNBQVfuDRXd3Av3CM3qgUK474AOL2OJBMgmAYtbcmdlcYcQuKgdfDDy3
         HmY6TYl0PWBy0BHJtMaBNTzsiTHz33GwPeUO+xtiSFEvC7d7MALO/EK31vQNoLnVf8
         /hqJaiG7f27vA==
Date:   Thu, 22 Sep 2022 22:08:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: driver uABI review list? (was: Re: [PATCH/RFC net-next 0/3] nfp:
 support VF multi-queues configuration)
Message-ID: <YyyyphcLn8UQse2F@unreal>
References: <20220920151419.76050-1-simon.horman@corigine.com>
 <20220921063448.5b0dd32b@kernel.org>
 <YyyHg/lvzXHKNPe9@unreal>
 <20220922091414.4086f747@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922091414.4086f747@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 09:14:14AM -0700, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 19:04:19 +0300 Leon Romanovsky wrote:
> > > Would it be helpful for participation if we had a separate mailing 
> > > list for discussing driver uAPI introduction which would hopefully 
> > > be lower traffic?  
> > 
> > Please don't. It will cause to an opposite situation where UAPI
> > discussions will be hidden from most people.
> 
> Oh, it'd just be an additional list, the patches would still need 
> to CC netdev.

First, there is already such ML: https://lore.kernel.org/linux-api/
Second, you disconnect discussion from actual patches and this can
cause to repeating of same arguments while reviewing patches.

> 
> > IMHO, every net vendor should be registered to netdev mailing list
> > and read, review and participate.
> 
> Alright, so we got two no votes so far.
