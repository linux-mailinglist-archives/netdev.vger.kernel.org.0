Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0652C4D35E6
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiCIQog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238777AbiCIQln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:41:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827C2192C88;
        Wed,  9 Mar 2022 08:35:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25855CE1C7B;
        Wed,  9 Mar 2022 16:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E970CC340EC;
        Wed,  9 Mar 2022 16:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843726;
        bh=CefiZB93OswAiBg52UlwczG7SfE7iT0HtvRLdyKEJg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q7H3Gpg2ZJ/IRHwtUfrVnNpZVyQD2YQx+eHVsiQUOwtZM+WZj3reodZWXl78bPMUK
         y8LMfA5w1DwTlpdCKcevwC0Bpxbuy/5v+zEuKvUrJLPf28hL+YAVXCASRzYLfa0BMD
         zihNfD/lY3UGybYuXeksIMJUg5Bsnd9dkQX9p2XExoSk7qFf9LrZGv3vdU5KuzAn+C
         /jwskjoEOner6DRvvXdOMVHls6mmmTo1JdrUNCLLKzhKQS0amVfH4tbFCUt2n9bjpf
         FeOFqOZxPICEnQKXP0zYV1d+KMPGMBx4bs2vBXTQXXhYZCjquraa2QsTZPVCggCMlt
         jO/x+9RDBtZvw==
Date:   Wed, 9 Mar 2022 08:35:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        aelior@marvell.com, palok@marvell.com, pkushwaha@marvell.com,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        it+netdev@molgen.mpg.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        regressions@lists.linux.dev
Subject: Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware 7.13.21.0
Message-ID: <20220309083524.76fa760e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <46f2d9d9-ae7f-b332-ddeb-b59802be2bab@molgen.mpg.de>
References: <20211217165552.746-1-manishc@marvell.com>
        <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
        <46f2d9d9-ae7f-b332-ddeb-b59802be2bab@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 17:18:30 +0100 Paul Menzel wrote:
> > This change was added to Linux in commit b7a49f73059f (bnx2x: Utilize 
> > firmware 7.13.21.0) [1] to Linux v5.17-rc1, and backported to the stable 
> > series, for example, Linux v5.10.95.

SMH, I must have missed this getting backported in the rush of merge
window backports :(

Yes, please revert.
