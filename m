Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2822A67C942
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbjAZK4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236817AbjAZK4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:56:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940816A333
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:56:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FB526179F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DECAC433EF;
        Thu, 26 Jan 2023 10:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674730564;
        bh=PR85RUfvGcW1btdH03eIIBbiG2IHdWz/4PPuWIQkHIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZCiaDQzsfWlLkkvA57e0xanMN+NC9VFwp0myQNpFif277mQUfEGEcArUoLQdUtIgn
         qnE2yOFwACK6ztykMn+zHyRWDShhg/vagSYeKA2xspwSC+N9RTjsnzSIPS6KcnJlMm
         wcmmnQglv3U33liGlvqvhJ0vSI5qQPDRNNI7W4IZas87Eiw/XoLRCJyaiU5YAsuDMU
         7VnLxdUZQdSDvRbp18WHU/pw0cKWR6VJiDK3031HdcsX03OfwmVGzItk9vFGs8Cv/r
         fqVAXRzYTGe94sSZZnu7Yuj4xJjuifEtdp5VRLBtV4BfNRuOFpWWV99gxa7LYCQCV9
         pBsOlxw1WJ+Wg==
Date:   Thu, 26 Jan 2023 12:56:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Sasha Neftin <sasha.neftin@intel.com>,
        netdev@vger.kernel.org, Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 3/3] igc: Clean up and optimize watchdog task
Message-ID: <Y9JcQOcpMN+n4NH3@unreal>
References: <20230125212702.4030240-1-anthony.l.nguyen@intel.com>
 <20230125212702.4030240-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125212702.4030240-4-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 01:27:02PM -0800, Tony Nguyen wrote:
> From: Sasha Neftin <sasha.neftin@intel.com>
> 
> i225/i226 parts used only one media type copper. The copper media type is
> not replaceable. Clean up the code accordingly, and remove the obsolete
> media replacement and reset options.
> 
> Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc.h      |  2 --
>  drivers/net/ethernet/intel/igc/igc_main.c | 17 -----------------
>  2 files changed, 19 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
