Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8381B686380
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 11:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjBAKPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 05:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjBAKPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 05:15:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C297F1715E;
        Wed,  1 Feb 2023 02:15:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67FEE6174A;
        Wed,  1 Feb 2023 10:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C66CC433D2;
        Wed,  1 Feb 2023 10:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675246509;
        bh=3H1Vt7lsldjTMei2cYUmca7iFFw9k/q03aPAF6dXSTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LOlTyt77K2qv1OXGOor95/hy5VsFLkDO40yysPQYxLFDtBDXnlkwI+o8VP7TfKCJE
         6Jb4YF/dDl36t2suA7NZRIABLE9Xtewzh11hI5M1dTE42I9BBkR5y5g4LF/mgw2M/r
         ySbUXUSUIOwY6rllbRKoEiLKwXGqy+80rgG/WpwhuyWiumL1u9LzNbCBatvruyZH+a
         5TlGojliEP2t+VVc3rNmhBzYMfZ6eSliS2XWRm/YDA/nv8AzTX8aMO5ytC+qnK8gUp
         fU34dgAM7D1EbOXaG8v4IiYqrydqKGH2+rRdV0qWA/VNwiWQ2v3U+5XFTsiYR8GaZ0
         gnK5+mlumxEyg==
Date:   Wed, 1 Feb 2023 12:15:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com
Subject: Re: [net-next PATCH v1] octeontx2-af: Removed unnecessary debug
 messages.
Message-ID: <Y9o7qdLUgdhEIuwC@unreal>
References: <20230201040301.1034843-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201040301.1034843-1-rkannoth@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 09:33:01AM +0530, Ratheesh Kannoth wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> NPC exact match feature is supported only on one silicon
> variant, removed debug messages which print that this
> feature is not available on all other silicon variants.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> ---
>  .../marvell/octeontx2/af/rvu_npc_hash.c        | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
