Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD61C5E6838
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 18:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiIVQPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 12:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiIVQOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 12:14:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C76CF85A3
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 09:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7D7C6366D
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9585DC433D6;
        Thu, 22 Sep 2022 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663863256;
        bh=7aEeTVAcnWyfCAA2R0DvbOsT6tpFeVPbVpbDbgx7X0o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GZY6Il4RrjeZkpSnOzrowADL7LSAmiC7MW1dY1q/zGyQM0POdvLDHqnOTnKLIWu8I
         V25SnfLGEQosvkwz0XS0tOCaF4o89M15U3sW+6bNm92vScAmvbJzeBoTmSLRdTli9Y
         zIPJc8FcgIhjIBIDxU2vQRNGsY8IBtyJqUgW8m58JijskP7SUt9NfLXx8JZr5HhF4N
         cFUgLCeH59ofCWz2sAT8c90KBb9wHf2qA+ARToLMNHvuV5VKpKaeTZfLThPJgGVsrn
         UJcqvs2KRLTqPV+0q8qO2/7zdqV0LYI6ymy+xpnpCwtyHkKMxdfiL0H8+SPuClwoj7
         xc+R5JHhn77nw==
Date:   Thu, 22 Sep 2022 09:14:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Subject: Re: driver uABI review list? (was: Re: [PATCH/RFC net-next 0/3]
 nfp: support VF multi-queues configuration)
Message-ID: <20220922091414.4086f747@kernel.org>
In-Reply-To: <YyyHg/lvzXHKNPe9@unreal>
References: <20220920151419.76050-1-simon.horman@corigine.com>
        <20220921063448.5b0dd32b@kernel.org>
        <YyyHg/lvzXHKNPe9@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 19:04:19 +0300 Leon Romanovsky wrote:
> > Would it be helpful for participation if we had a separate mailing 
> > list for discussing driver uAPI introduction which would hopefully 
> > be lower traffic?  
> 
> Please don't. It will cause to an opposite situation where UAPI
> discussions will be hidden from most people.

Oh, it'd just be an additional list, the patches would still need 
to CC netdev.

> IMHO, every net vendor should be registered to netdev mailing list
> and read, review and participate.

Alright, so we got two no votes so far.
