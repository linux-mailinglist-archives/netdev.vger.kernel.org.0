Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025686B96A6
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCNNpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjCNNpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:45:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947DEB06FF
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D61E2B81981
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8413FC433EF;
        Tue, 14 Mar 2023 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678801303;
        bh=frVH5IoL6TyN/bNQeAfRiAcHPIkUJee+isIHpwYi7PA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LN8DfIC2EspZ1pVhPpWkpuf2d2qq3/y8oqDvJsgIjTNqPsQOXeHSQvB7TiX3867cb
         YyqUi5r8mhR2u3pxVEjEZtPAkiTn+8U8/tqIqnzGd6cQU9KKaD0rVGwx2k/mxZPRH0
         cNzBbChSUkd3ozbsYS+zhP+NEMus3hrXUpVwVUNG6/F9zzgMCeano2yqmHsddRCvrL
         1Xs7IK7YxIHO4A7Ic+hVr5IBKVFjskdo2+zupVebd4IEl00iPF9uyiSx03uk9LmgMX
         hAmw4XOya+FVXPQBHi8WQCogLakrxsw4m7Z2C2IiNK1DCk/JD2sLzQL5qSb2hrWXxG
         Rm7p6S2XSSHaw==
Date:   Tue, 14 Mar 2023 15:41:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: Re: [PATCH net-next 01/14] ice: re-order ice_mbx_reset_snapshot
 function
Message-ID: <20230314134138.GF36557@unreal>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
 <20230313182123.483057-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313182123.483057-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:21:10AM -0700, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> A future change is going to refactor the VF mailbox overflow detection
> logic, including modifying ice_mbx_reset_snapshot and its callers. To make
> this change easier to review, first move the ice_mbx_reset_snapshot
> function higher in the ice_vf_mbx.c file.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Marek Szlosek <marek.szlosek@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 48 ++++++++++-----------
>  1 file changed, 24 insertions(+), 24 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
