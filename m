Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B186B96D8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjCNNwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjCNNvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:51:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC86DA0B3C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FCD7B8197E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A29C433EF;
        Tue, 14 Mar 2023 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678801730;
        bh=g/MW7ho0Z6EA41ZdxjXmYeBeOwF39pSWPbXYeHXztNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ckGZa+HiuHpuykecdKkqCePUHQe4nkGsFpZHHAEQh2w3hPh5vCEtyH94REfSApOs2
         cnOIK8nTcMexx6rCWhSD6CN5bq+YSRvA+Ozecad99ivGjDfKsfGJ71nbnYMi7FTpC1
         mXjQeq1IqsxQEUPR1xtyThCmvXCmZrsaGllZuQ+dXt2Tv6R4X2XRtqdNm9s74SQLx9
         kHYKMYe1iZCbCPdbP6VlLx5vMpZwctHqw5K0YNqzjoqouISmd1tY7UQ2Zw8NG5J1dx
         d7462G4FmJIvDDsRTWrWLkmZvTF6jSVAHOoaZKRGO+8pG6DP0F6u0q22vIy3C5A9LN
         n2GOmDO/kJSaQ==
Date:   Tue, 14 Mar 2023 15:48:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: Re: [PATCH net-next 05/14] ice: remove ice_mbx_deinit_snapshot
Message-ID: <20230314134845.GI36557@unreal>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
 <20230313182123.483057-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313182123.483057-6-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:21:14AM -0700, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The ice_mbx_deinit_snapshot function's only remaining job is to clear the
> previous snapshot data. This snapshot data is initialized when SR-IOV adds
> VFs, so it is not necessary to clear this data when removing VFs. Since no
> allocation occurs we no longer need to free anything and we can safely
> remove this function.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Marek Szlosek <marek.szlosek@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_sriov.c  |  5 +----
>  drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 14 --------------
>  drivers/net/ethernet/intel/ice/ice_vf_mbx.h |  1 -
>  3 files changed, 1 insertion(+), 19 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
