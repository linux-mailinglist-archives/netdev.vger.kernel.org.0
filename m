Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533D557EA97
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 02:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiGWATb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 20:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiGWAT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 20:19:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB447755B;
        Fri, 22 Jul 2022 17:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FBF1B82BA3;
        Sat, 23 Jul 2022 00:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43253C341C6;
        Sat, 23 Jul 2022 00:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658535566;
        bh=KvFV11I5q8AnPteHYUyDnYb/2IqrotGqRnOmO+VMtxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l6iWB++2gH0wCI5DY4+ZTzyk4CutzXYmBLcU/LQ2HlfKAIcjX9pqLYIv3h9VQ2hnN
         bneAr41ztB2anL7HanCZpn28bOtJadzfPeGXdI1x/xWbjbiDDvUJylTQKHr+CV3aiP
         iPrlYdmcaGoJxVWIgRx9EKw04qonAGBgaa3k81DmgIAmWA2gL0e8/BtLgskweT7+pd
         bVdjXOHgb/Jpg6tq+Y2zHtyFbfigD9HuYq+/Gf9KaXXaoR3kntzAVA4wWmW/UXulrB
         Yzfb69AKuPvdzF7Kyc9YekPk9B2bVOhWx/OP0OpfHj5Hf43EB/8fKNPIkqjc+1DvlH
         Ks7HY8gWUHMHA==
Date:   Fri, 22 Jul 2022 17:19:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth-next 2022-07-22
Message-ID: <20220722171919.04493224@kernel.org>
In-Reply-To: <CABBYNZLj2z_81p=q0iSxEBgVW_L3dw8UKGwQKOEDj9fgDLYJ0g@mail.gmail.com>
References: <20220722205400.847019-1-luiz.dentz@gmail.com>
        <20220722165510.191fad93@kernel.org>
        <CABBYNZLj2z_81p=q0iSxEBgVW_L3dw8UKGwQKOEDj9fgDLYJ0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 17:09:33 -0700 Luiz Augusto von Dentz wrote:
> > I see two new sparse warnings (for a follow up):
> >
> > net/bluetooth/hci_event.c:3789:26: warning: cast to restricted __le16
> > net/bluetooth/hci_event.c:3791:26: warning: cast to restricted __le16  
> 
> Crap, let me fix them.

Do you mean i should hold off with pushing or you'll follow up?

> > Two bad Fixes tags:
> >
> > Commit: 68253f3cd715 ("Bluetooth: hci_sync: Fix resuming scan after suspend resume")
> >         Fixes tag: Fixes: 3b42055388c30 (Bluetooth: hci_sync: Fix attempting to suspend with
> >         Has these problem(s):
> >                 - Subject has leading but no trailing parentheses
> > Commit: 9111786492f1 ("Bluetooth: fix an error code in hci_register_dev()")
> >         Fixes tag: Fixes: d6bb2a91f95b ("Bluetooth: Unregister suspend with userchannel")
> >         Has these problem(s):
> >                 - Target SHA1 does not exist
> >
> > And a whole bunch of patches committed by you but signed off by Marcel.
> > Last time we tried to fix that it ended up making things worse.
> > So I guess it is what it is :) Pulling...  
> 
> Yep, that happens when I rebase on top of net-next so I would have to
> redo all the Signed-off-by lines if the patches were originally
> applied by Marcel, at least I don't know of any option to keep the
> original committer while rebasing?

I think the most common way is to avoid rebasing. Do you rebase to get
rid of revised patches or such?
