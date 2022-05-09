Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B3C51F738
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbiEIIuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiEIIRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:17:53 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E651EF097
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 01:13:46 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b19so18257894wrh.11
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 01:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Quncaat1m9FyU6vsRVo8RGWqpYtJD3rrPH0rQwvy0UY=;
        b=cAbu9xmTl7xrSJn8AqOLiejFB+ZeuLSTB1oJ/xb4b8LWBKWldWplTMCXOqG+BjpsBk
         E7ZbLvRnmZOLP/NRSOTi406H7GgvOa+urRXJFpaOFM+/j0clE4+s+KA6E3ss1Qt5xL3m
         jW1wvrfuVziTrRyBS6BR+M+MF6QdCI/O48rZopmcHNdj0i5rUshZZ7IPrDVl18qf20bR
         fNGvGRi0lk0SdMtdxlQR4IhWfZTQF1xAeFvMaMtEv3jdtNA2gaBEEk/Vu3KxU4VpC0rg
         2Do8bZEr8tMwKvXs6ZwlMQ/CQG9BC3Govq4RER4K0BBuvagBfwoaXW/hUcKnu6zxqoPH
         L7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=Quncaat1m9FyU6vsRVo8RGWqpYtJD3rrPH0rQwvy0UY=;
        b=WvU2x3BoKuLXuRFrw+kH5RV139pbTKy1TMRJxalSMJUDC2sZBNZqmXJWUW1pHbvZLk
         zyJuzgq8VyuscVLAM6WUqsNyFCb3NQyOQDgKooFbvhptdUxZNZfExjRxZwblhXkkqdjr
         WTIhSyrLhG4gXS36+nPLjkHjRSSmopTshIU6NV8vsPGR2nAMHxpfC61NNhpE2PVmbKYe
         z31F82cdKJkTfKD+XnXEH7xT9x3QZOq15nIYS4CAHMfXK+2wW5OfBqH+UOYvAeEIdjb9
         kH84vBZIn8gGu5JrYgKRJSZSfP3pHEYi4nuWFea+30eJXOyZ5mxxF2j4svkEzlKtI4pS
         Mi/w==
X-Gm-Message-State: AOAM532XrP+BPxOdvqs1d6MkXTLYHoGzIPeY229gpbErkLJLd1usw86A
        crmgWc5r090FsQoIwAEQITXNfDgY5yU=
X-Google-Smtp-Source: ABdhPJx5pe38aFgHELtntw4KY9xDDxI+2cRGRnR7VeGHOAS5Ao8U0uwfXUk2M2982AVx5WKIr+Kh6w==
X-Received: by 2002:a5d:614c:0:b0:20a:e4cd:f7c2 with SMTP id y12-20020a5d614c000000b0020ae4cdf7c2mr12729165wrt.382.1652084018149;
        Mon, 09 May 2022 01:13:38 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id e17-20020a05600c4e5100b00394832af31csm9631227wmq.0.2022.05.09.01.13.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 May 2022 01:13:37 -0700 (PDT)
Date:   Mon, 9 May 2022 09:13:35 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edumazet@google.com, pabeni@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v3 00/13]: Move Siena into a separate
 subdirectory
Message-ID: <20220509081335.rn4sayedyts7xtyc@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
References: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
 <20220504204531.5294ed21@kernel.org>
 <20220505130024.rqsiwd6zrmjxsze6@gmail.com>
 <20220505092853.2ea45aec@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505092853.2ea45aec@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 09:28:53AM -0700, Jakub Kicinski wrote:
> On Thu, 5 May 2022 14:00:24 +0100 Martin Habets wrote:
> > > Still funky:
> > > 
> > > $ git pw series apply 638179
> > > Applying: sfc: Disable Siena support
> > > Using index info to reconstruct a base tree...
> > > M	drivers/net/ethernet/sfc/Kconfig
> > > M	drivers/net/ethernet/sfc/Makefile
> > > M	drivers/net/ethernet/sfc/efx.c
> > > M	drivers/net/ethernet/sfc/nic.h
> > > Falling back to patching base and 3-way merge...
> > > No changes -- Patch already applied.  
> > 
> > git is right, this got applied by Dave with commit
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0c38a5bd60eb
> > 
> > > Applying: sfc: Move Siena specific files
> > > Applying: sfc: Copy shared files needed for Siena (part 1)
> > > Applying: sfc: Copy shared files needed for Siena (part 2)
> > > Applying: sfc: Copy a subset of mcdi_pcol.h to siena
> > > Using index info to reconstruct a base tree...
> > > Falling back to patching base and 3-way merge...
> > > No changes -- Patch already applied.  
> > 
> > git is right, this got applied by Dave with commit
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=6b73f20ab6c401a1a7860f02734ab11bf748e69b
> > 
> > > Applying: sfc/siena: Remove build references to missing functionality
> > > Applying: sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
> > > Applying: sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
> > > Applying: sfc/siena: Rename peripheral functions to avoid conflicts with sfc
> > > Applying: sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
> > > Applying: sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
> > > Applying: sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
> > > Applying: sfc: Add a basic Siena module  
> > 
> > The other patches I don't see upstream.
> > There is also merge commit
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=39e85fe01127cfb1b4b59a08e5d81fed45ee5633
> > but that only covers the ones that got applied.
> > 
> > So my summary is that patch 1 and 5 are in, but the others are not.
> > Pretty confusing stuff. I wonder if the --find-copies-harder option is too
> > clever.
> > 
> > From what I can see net-next is not broken, other than Siena NICs being
> > disabled. Your git pw series apply seems correct.
> 
> Oh. Well. That I did not suspect. I ignored the confused pw-bot replies.
> 
> Would you prefer me to revert what's in the tree or send incremental
> patches?

I'll send an incremental series.

> Either way I'd prefer if you posted once more, if that's okay, so that
> the pw build bot can take a swing at the series. Looks like the patches
> were merged before the build bot got to them this time.

Will do.

Martin
