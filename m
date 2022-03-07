Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1D74D0BFF
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 00:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbiCGXZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 18:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240882AbiCGXZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 18:25:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC3F4A3C5;
        Mon,  7 Mar 2022 15:24:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BA71B815E0;
        Mon,  7 Mar 2022 23:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4486C340E9;
        Mon,  7 Mar 2022 23:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646695460;
        bh=fH7+crhzHVjXuw/xcVCDWpv4m05xVMzXGm7dPbHMG9I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nRIOoY7Lwacua73TW+Bc2couJTiyYC/ZO1ei30mPJnGqugmX5AZJRO8BM7UuiiJzF
         7tt+YjlGpCkReYfSbBQjsAO8gpbXivrJREb/8fms8BTtkhXU1RuP3RFq3gRFS9LtCZ
         Oo5WzPg4DyrP8af0a9b8pMw8IxVsP5tE/Z9MTGgmhNjxx+5h+bo0oGI4WY5k5+nl6X
         1VjWfYWokIIFWlDKrE04BS6lSKeRVpAWygH0DnH1BRIznxJlZ1CCdxNjbHhmy/ZHAS
         4TNWk3Bzl29cNUiE3nOUpE+YLYuHISKcS3zGIo9taGEEbIr71KQBBRVDgn47xU8+S7
         bRF3S/WpTZa3g==
Date:   Mon, 7 Mar 2022 15:24:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
Message-ID: <20220307152418.6622230f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220308101903.68e0ba72@canb.auug.org.au>
References: <20220307072248.7435feed@canb.auug.org.au>
        <20220307150248.388314c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220308101903.68e0ba72@canb.auug.org.au>
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

On Tue, 8 Mar 2022 10:19:03 +1100 Stephen Rothwell wrote:
> > Would it be possible to add bluetooth trees to linux-next?
> > 
> > Marcel, Luiz, Johan, would it help?  
> 
> I already have
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git
> branch master
> 
> in linux-next.  Those commits appeared in the bluetooth and net-next
> trees on the same day (Monday) for me.

I see :/

Thanks for checking.
