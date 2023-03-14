Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4606B6B96DE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjCNNxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjCNNxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:53:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F99CA42F0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0F8961753
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DD2C433D2;
        Tue, 14 Mar 2023 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678801811;
        bh=YyUX+jsHMMPFtQ/UEDF6Nver4I3rrxbsbyr9rDD2Yno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IWx/A/9p6oAr2jpmB1J0bOsOQOSrvpBHX/eBBqTer8OXEyLYGRHtdK70EhywvdoLo
         8LM9o+iOf/JW0eJuyJkGAntdhL/ik/OPrfYL+BDqUESUEzXnIildozVVwBkkpZOg5Y
         fhF7m/jBp1jZ3Rvf4ZsK7czceJGn/aUgqJ8g80ryanJITXKaIqB74Ac/+9hgUQL2XC
         XE5eiWm627UMVzweWfZ0i1PbZgJm5z9VpVlzAnBliH5VhBd0TGldHtU2OSkzPBgHUx
         RWC/rKARVCR2eETFSwvhIiV/PoRgzfKydO9cUglqRqP1guMhGaQu006Ef/QD2bwwZ/
         x4OF4J3P/bvuQ==
Date:   Tue, 14 Mar 2023 15:50:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: Re: [PATCH net-next 07/14] ice: initialize mailbox snapshot earlier
 in PF init
Message-ID: <20230314135007.GJ36557@unreal>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
 <20230313182123.483057-8-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313182123.483057-8-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:21:16AM -0700, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> Now that we no longer depend on the number of VFs being allocated, we can
> move the ice_mbx_init_snapshot function earlier. This will be required by
> Scalable IOV as we will not be calling ice_sriov_configure for Scalable
> VFs.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Marek Szlosek <marek.szlosek@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c   | 1 +
>  drivers/net/ethernet/intel/ice/ice_sriov.c  | 2 --
>  drivers/net/ethernet/intel/ice/ice_vf_mbx.h | 4 ++++
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
