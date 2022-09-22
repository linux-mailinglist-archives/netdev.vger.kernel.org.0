Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5945E6805
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 18:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiIVQE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 12:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiIVQE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 12:04:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036FDFFA4B
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 09:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A40B7B8387F
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94078C433D6;
        Thu, 22 Sep 2022 16:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663862664;
        bh=/bmjj2iJ6GMmHdDel6beRwJ/kS93U0zoLw5a2wda94M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E1O74oaTGlB8g/TMGsuoh1kubNGFlCpBZ8zx+mSG4DTmkfS+R41d9qDDZkGEqD90q
         VqQG2mVDC/avu+412KgUS/BdNyS8wdwe/1jEYpoiWdb5Wd6dLb5fqJq7gOwtp0qTFx
         8o54GLS8DEZ62VhMRDzPfFt4j/NFmqOJy0ubelxBl+mN3Yylu9h7BWeMpqPP98hAwZ
         EEDxuMv3jKIfvN8mPENlIyZir9c+o1LhPDLJANmubrxmFzbEqcH+4SJC+Ve6gu+zM5
         bK+nAncLJmxrxPUPYuMwfGUcxvlqOgjzK5iEh/RJKsggukZXULdFkzcsAINpwnPO4Q
         GjX1mF1R6fLCA==
Date:   Thu, 22 Sep 2022 19:04:19 +0300
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
Message-ID: <YyyHg/lvzXHKNPe9@unreal>
References: <20220920151419.76050-1-simon.horman@corigine.com>
 <20220921063448.5b0dd32b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921063448.5b0dd32b@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 06:34:48AM -0700, Jakub Kicinski wrote:
> On Tue, 20 Sep 2022 16:14:16 +0100 Simon Horman wrote:
> > this short series adds the max_vf_queue generic devlink device parameter,
> > the intention of this is to allow configuration of the number of queues
> > associated with VFs, and facilitates having VFs with different queue
> > counts.

<...>

> Would it be helpful for participation if we had a separate mailing 
> list for discussing driver uAPI introduction which would hopefully 
> be lower traffic?

Please don't. It will cause to an opposite situation where UAPI
discussions will be hidden from most people. IMHO, every net vendor
should be registered to netdev mailing list and read, review and
participate.

Thanks
