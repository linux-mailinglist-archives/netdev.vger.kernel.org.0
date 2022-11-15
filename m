Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B14629056
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbiKODDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237572AbiKODCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:02:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DA51D678;
        Mon, 14 Nov 2022 19:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B89D061512;
        Tue, 15 Nov 2022 03:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 162F4C433D7;
        Tue, 15 Nov 2022 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668481216;
        bh=7GwYrxfGLtv3EWezChxqb+EW1qTYQWOsMI1x0yOy/oM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C/bEiGywRVb82J2X3iohUPsoR5VFGT138fbFv/XrIkmjGs2ZRayyC7JCaEZlnMDLC
         3K1T4KRAtqdTekG0wTAN0zp3bcdRkrV8ZjK/kjng4ybddpNbjHoPEP2WxwojQToVph
         z+1XmL84ug3FedJjcKeQbug0BKPQAYWWUobPpx1QAaRDLYhqEAU4EXfIv/Yc1EKN2v
         1A1Kttu2USPTmA+F+Yp11L4ve0gbojWUX3E4K0INQ9t3agglnd0LrNSGiELzqxo0KM
         htIZ1DFY6o1h0R3UI8Zd4eE4x3fWvjqkQHLsUYIjAlB9d2pR4AFWb38IVzM9UmQrt5
         EGkwh/TLqp5Rw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA42FC395FE;
        Tue, 15 Nov 2022 03:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch 00/10] genirq/msi: Treewide cleanup of pointless linux/msi.h
 includes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166848121595.31359.929419753615501478.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 03:00:15 +0000
References: <20221113201935.776707081@linutronix.de>
In-Reply-To: <20221113201935.776707081@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, maz@kernel.org, lee@kernel.org,
        damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stuyoder@gmail.com,
        laurentiu.tudor@nxp.com, fenghua.yu@intel.com,
        dave.jiang@intel.com, vkoul@kernel.org, dmaengine@vger.kernel.org,
        ioana.ciornei@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        simon.horman@corigine.com, oss-drivers@corigine.com,
        Roy.Pledge@nxp.com, diana.craciun@oss.nxp.com,
        alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
        iommu@lists.linux.dev
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 13 Nov 2022 21:33:54 +0100 (CET) you wrote:
> While working on per device MSI domains I noticed that quite some files
> include linux/msi.h just because.
> 
> The top level comment in the header file clearly says:
> 
>   Regular device drivers have no business with any of these functions....
> 
> [...]

Here is the summary with links:
  - [06/10] net: dpaa2: Remove linux/msi.h includes
    https://git.kernel.org/netdev/net-next/c/515e5fb6a95e
  - [07/10] net: nfp: Remove linux/msi.h includes
    https://git.kernel.org/netdev/net-next/c/5fd66a0b3bb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


