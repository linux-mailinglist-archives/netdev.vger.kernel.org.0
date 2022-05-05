Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB1151C00D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378731AbiEENEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378709AbiEENEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:04:09 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5F024F24
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 06:00:28 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v12so5996602wrv.10
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 06:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O0YLc9lX6vqz67PRcUNuSAm1TXEStWB4MjyI8KO6PMQ=;
        b=Db9tyPsO4KL7A9m9/eGvniIMTnix6ga4sVjED7/YTp9nSB8abnRqvUSX9+LO2Mkyg3
         yowkUvpreISRxPeePikn5MRLaQQdG5wqyS0WFvgYg+uZvLBXeC5aHznN3EMk2NsKxrny
         ks8B2M7qQoWtChVtf9hsvdabNSWfqFghpmVukwRiosjVLaH++lwOiHCBXdkQkkd9rplS
         EyaNz6kxFKym13WNMWev3csHQp9P1yYPNf7E+9Tc+XmSSRqcDVbSKITJcvx7MU1PpCDK
         vaV01X7srGxgRVmI5Ttm9EisAa9xWypCQxOBpk7EQbvfYqrx9VxH5TbnT6x0gSM3Y5SH
         BMSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=O0YLc9lX6vqz67PRcUNuSAm1TXEStWB4MjyI8KO6PMQ=;
        b=cHI3VLFzlZvHne0eVxQV/P33gpKCWzo83MLrvGld+tNYVgv63me2RhzoMqarRCqqb0
         edi34edcyiO4II0bNNvXWGATOj67vvBNzHh87U0IYCyDM3HexYubec3kNYGJBjizbPBw
         Nkv6E4SkCohMkyPBZhF/qJoeogCm4+CQP5VuMGPieMLoVV+zy94ivg8QhOce/QxqfiB6
         zVraHrF5HLGgHyRTbd7YlgUB3rQmbtk/a1xvGPHc39UXW/D0hV/hbpgHB5MHqFWB/x3p
         mR8qthGEjQ9IWzgU+Xzymy+H+OIgcxHqiMvEe+PJrsdtSPEv2XTQmVvjimkMmDhU/Dvc
         x+Cw==
X-Gm-Message-State: AOAM531PLLjWAgsEjuvyUhsdjouIRo+2TkyqyQrFeq+MvL784BvPEpk2
        cSNhlhQ28cD7gqfn9my7YyoBGQAsY54=
X-Google-Smtp-Source: ABdhPJzpJj4HWmE7R25PUG6tDw7uR/0/x/CEOgHl+REHnc5fZXBpIznh39qC3hz4AWQYerZMSKNCqQ==
X-Received: by 2002:a5d:6b0d:0:b0:1f0:6497:b071 with SMTP id v13-20020a5d6b0d000000b001f06497b071mr20639352wrw.638.1651755627066;
        Thu, 05 May 2022 06:00:27 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id v1-20020a1cf701000000b003942a244ed6sm1492140wmh.27.2022.05.05.06.00.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 05 May 2022 06:00:26 -0700 (PDT)
Date:   Thu, 5 May 2022 14:00:24 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edumazet@google.com, pabeni@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v3 00/13]: Move Siena into a separate
 subdirectory
Message-ID: <20220505130024.rqsiwd6zrmjxsze6@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
References: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
 <20220504204531.5294ed21@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504204531.5294ed21@kernel.org>
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

On Wed, May 04, 2022 at 08:45:31PM -0700, Jakub Kicinski wrote:
> On Wed, 04 May 2022 08:49:41 +0100 Martin Habets wrote:
> > The Siena NICs (SFN5000 and SFN6000 series) went EOL in November 2021.
> > Most of these adapters have been remove from our test labs, and testing
> > has been reduced to a minimum.
> > 
> > This patch series creates a separate kernel module for the Siena architecture,
> > analogous to what was done for Falcon some years ago.
> > This reduces our maintenance for the sfc.ko module, and allows us to
> > enhance the EF10 and EF100 drivers without the risk of breaking Siena NICs.
> > 
> > After this series further enhancements are needed to differentiate the
> > new kernel module from sfc.ko, and the Siena code can be removed from sfc.ko.
> > Thes will be posted as a small follow-up series.
> > The Siena module is not built by default, but can be enabled
> > using Kconfig option SFC_SIENA. This will create module sfc-siena.ko.
> > 
> > 	Patches
> > 
> > Patch 1 disables the Siena code in the sfc.ko module.
> > Patches 2-6 establish the code base for the Siena driver.
> > Patches 7-12 ensure the allyesconfig build succeeds.
> > Patch 13 adds the basic Siena module.
> > 
> > I do not expect patch 2 through 5 to be reviewed, they are FYI only.
> > No checkpatch issues were resolved as part of these, but they
> > were fixed in the subsequent patches.
> 
> Still funky:
> 
> $ git pw series apply 638179
> Applying: sfc: Disable Siena support
> Using index info to reconstruct a base tree...
> M	drivers/net/ethernet/sfc/Kconfig
> M	drivers/net/ethernet/sfc/Makefile
> M	drivers/net/ethernet/sfc/efx.c
> M	drivers/net/ethernet/sfc/nic.h
> Falling back to patching base and 3-way merge...
> No changes -- Patch already applied.

git is right, this got applied by Dave with commit
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0c38a5bd60eb

> Applying: sfc: Move Siena specific files
> Applying: sfc: Copy shared files needed for Siena (part 1)
> Applying: sfc: Copy shared files needed for Siena (part 2)
> Applying: sfc: Copy a subset of mcdi_pcol.h to siena
> Using index info to reconstruct a base tree...
> Falling back to patching base and 3-way merge...
> No changes -- Patch already applied.

git is right, this got applied by Dave with commit
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=6b73f20ab6c401a1a7860f02734ab11bf748e69b

> Applying: sfc/siena: Remove build references to missing functionality
> Applying: sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
> Applying: sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
> Applying: sfc/siena: Rename peripheral functions to avoid conflicts with sfc
> Applying: sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
> Applying: sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
> Applying: sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
> Applying: sfc: Add a basic Siena module

The other patches I don't see upstream.
There is also merge commit
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=39e85fe01127cfb1b4b59a08e5d81fed45ee5633
but that only covers the ones that got applied.

So my summary is that patch 1 and 5 are in, but the others are not.
Pretty confusing stuff. I wonder if the --find-copies-harder option is too
clever.

From what I can see net-next is not broken, other than Siena NICs being
disabled. Your git pw series apply seems correct.

Martin
