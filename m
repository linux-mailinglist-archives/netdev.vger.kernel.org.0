Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3628251C51F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381455AbiEEQci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiEEQch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:32:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAC826579
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5246B82DBE
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106DDC385A4;
        Thu,  5 May 2022 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651768135;
        bh=w4rmtmfzqZzuD40CTx/UCbodYCe644jl91QyfdMZNAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JZaQhWE4WyS8d+1Xkh+ZE9m9WRptG4bnGzq5ImWaCqcHuBut66h29scvKPptZi6GS
         Fg7j0I4WHwQj4FYfJfHxKfqgkVhYVLEZMRnPCst+MLv/OiH1n8Efmylpn3pFHqj09u
         16HwIJEszGrCTMLxbNLF/H3X3N8lLpm8fWSJkUi3WvuBglRqVClXEhk5g236UUdgBA
         8jt/h1M3IGHNs7i1ai3IjZ+UvvPelQRsoe6IpBIAlERNjjqJ/LVVga7CqxwmLxapO7
         u5xhbrqKVD9I4SFLXV2eIqvhEzcA4hlxEhL+tqF5nO9gb13TEp5dojgDtLhhlBMQl9
         PY6Z8HMwNNlBQ==
Date:   Thu, 5 May 2022 09:28:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     edumazet@google.com, pabeni@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v3 00/13]: Move Siena into a separate
 subdirectory
Message-ID: <20220505092853.2ea45aec@kernel.org>
In-Reply-To: <20220505130024.rqsiwd6zrmjxsze6@gmail.com>
References: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
        <20220504204531.5294ed21@kernel.org>
        <20220505130024.rqsiwd6zrmjxsze6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 14:00:24 +0100 Martin Habets wrote:
> > Still funky:
> > 
> > $ git pw series apply 638179
> > Applying: sfc: Disable Siena support
> > Using index info to reconstruct a base tree...
> > M	drivers/net/ethernet/sfc/Kconfig
> > M	drivers/net/ethernet/sfc/Makefile
> > M	drivers/net/ethernet/sfc/efx.c
> > M	drivers/net/ethernet/sfc/nic.h
> > Falling back to patching base and 3-way merge...
> > No changes -- Patch already applied.  
> 
> git is right, this got applied by Dave with commit
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0c38a5bd60eb
> 
> > Applying: sfc: Move Siena specific files
> > Applying: sfc: Copy shared files needed for Siena (part 1)
> > Applying: sfc: Copy shared files needed for Siena (part 2)
> > Applying: sfc: Copy a subset of mcdi_pcol.h to siena
> > Using index info to reconstruct a base tree...
> > Falling back to patching base and 3-way merge...
> > No changes -- Patch already applied.  
> 
> git is right, this got applied by Dave with commit
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=6b73f20ab6c401a1a7860f02734ab11bf748e69b
> 
> > Applying: sfc/siena: Remove build references to missing functionality
> > Applying: sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
> > Applying: sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
> > Applying: sfc/siena: Rename peripheral functions to avoid conflicts with sfc
> > Applying: sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
> > Applying: sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
> > Applying: sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
> > Applying: sfc: Add a basic Siena module  
> 
> The other patches I don't see upstream.
> There is also merge commit
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=39e85fe01127cfb1b4b59a08e5d81fed45ee5633
> but that only covers the ones that got applied.
> 
> So my summary is that patch 1 and 5 are in, but the others are not.
> Pretty confusing stuff. I wonder if the --find-copies-harder option is too
> clever.
> 
> From what I can see net-next is not broken, other than Siena NICs being
> disabled. Your git pw series apply seems correct.

Oh. Well. That I did not suspect. I ignored the confused pw-bot replies.

Would you prefer me to revert what's in the tree or send incremental
patches?

Either way I'd prefer if you posted once more, if that's okay, so that
the pw build bot can take a swing at the series. Looks like the patches
were merged before the build bot got to them this time.
