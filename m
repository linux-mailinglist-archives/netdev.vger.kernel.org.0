Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957D26E36E5
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 12:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjDPKCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 06:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjDPKCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 06:02:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D8A2D7F
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 03:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8152060BB8
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 10:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6057DC433EF;
        Sun, 16 Apr 2023 10:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681639329;
        bh=zMhEHEkVy532lUrJrWIDR6FTZS+hJYvyRYFi3OS5DK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ljjn40hY8uPaFkko50GzTravjSHu3iB8Uebqn771fCOaJJNeGyEp2vdaRtskZ9adB
         QWmAzbP16DWksw9MHU+EzI0FTVLN62K9RkyXSd5+5PiZt5ycycBaO2ZxClXRo8K4s5
         wAlKXgyw1rGSYfvv9msTcy5S0OW4F5dbsQOUkUs2CqqrUY5fWZ1HSIXKp7Io6an6NR
         +Stz7amoGMz4vzVV9Fwk+EhD/AzhDX+iwPd2Hnn7h1T96xRFD2XBAibyGFNByYu1GN
         /Q/YK16CTsPj4h1OexkX3FyW/OG/CusbneFBU8nwA6eNK0E4TuWna2UXwwVn5ZHaDW
         AAMm5A6t/SB4g==
Date:   Sun, 16 Apr 2023 13:02:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ice: document RDMA devlink parameters
Message-ID: <20230416100205.GA15386@unreal>
References: <20230414162614.571861-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414162614.571861-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 09:26:14AM -0700, Jacob Keller wrote:
> Commit e523af4ee560 ("net/ice: Add support for enable_iwarp and enable_roce
> devlink param") added support for the enable_roce and enable_iwarp
> parameters in the ice driver. It didn't document these parameters in the
> ice devlink documentation file. Add this documentation, including a note
> about the mutual exclusion between the two modes.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  Documentation/networking/devlink/ice.rst | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
