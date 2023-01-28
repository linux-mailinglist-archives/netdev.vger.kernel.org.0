Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A240467F52F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 07:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjA1GZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 01:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjA1GZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 01:25:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D12518DD;
        Fri, 27 Jan 2023 22:25:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CBFD60CBA;
        Sat, 28 Jan 2023 06:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1590FC433D2;
        Sat, 28 Jan 2023 06:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674887108;
        bh=Umq2aUXuK9lTmblhHQPleWfHoZUAvv9+MtmiHIjdEvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nj/BiMD0JZkGPM54uzRsSL3dXml8GVuoWpXqrscvjyHvwi7wttjKj53JcENQbZ89m
         kG7To/Jk8anW6FHlf/A8nAXFJqJdvFo3qsPC/qCX1gKwUEz2g/MQie8q197uAmMQ+O
         Ffaoeu3QxyxTmcjRj6PiFvRsp7XS1Fbi7B8eBWVCO/ITOjO9c9mm5lgzs2mgZ1ITMl
         wnixV8jY+OuzZgegfw5QHYWUry5sySlA7r96KA0CtWMJEtfNs+4D4hPgO7Fk2qYWlP
         KjG877t1n2Iwm27KqpgKHbLS/5A+7TWkI+0VtJ51TheLvw5vqEuD3Z4SlgEVhJlcqa
         3kPAhmU/UaTKQ==
Date:   Fri, 27 Jan 2023 22:25:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230127222507.29c9ffb2@kernel.org>
In-Reply-To: <1de50d67-1c1d-bf5e-5409-d0cc19aeda73@tessares.net>
References: <20230127123604.36bb3e99@canb.auug.org.au>
        <1de50d67-1c1d-bf5e-5409-d0cc19aeda73@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Jan 2023 11:39:41 +0100 Matthieu Baerts wrote:
> On 27/01/2023 02:36, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the net-next tree got a conflict in:
> > 
> >   drivers/net/ethernet/engleder/tsnep_main.c
> > 
> > between commit:
> > 
> >   3d53aaef4332 ("tsnep: Fix TX queue stop/wake for multiple queues")
> > 
> > from the net tree and commit:
> > 
> >   25faa6a4c5ca ("tsnep: Replace TX spin_lock with __netif_tx_lock")
> > 
> > from the net-next tree.  
> 
> Thank you for the proposed patch. I had the same conflict on my side
> with MPTCP when merging net-next with -net and your fix seems to do the
> job correctly!
> 
> Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>

BTW would it be possible to get these in form of rr-cache?
Or otherwise to import the resolution without fetching all objects 
from your trees?
