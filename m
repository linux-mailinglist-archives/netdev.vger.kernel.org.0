Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D756C0AFD
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 08:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjCTHBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 03:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjCTHBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 03:01:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE58D1B2EE
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 00:01:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BAD9CE0FF4
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 07:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3111C433EF;
        Mon, 20 Mar 2023 07:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679295686;
        bh=9x3+bKDqfaDfh8bHRnPQzOpqDf9M3iMm+yD4xzOrf7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o0V52darTGmGO1h01f3fDTMsG1U4GNBuXelb3ygDIFBIoLfAgTL7S2wRgwJmiKkTe
         UbE9EQBCI7wBz15vRBDg0brVX0gi4JkBRHZEXw1peO+pKT/ySiz1x6Y+EIuUIpE5J0
         OUGZ9u/vJ2lndW3ku5v0mkYSCjdgHJkAeXBXClKh+DwcLRYD2yqHlBPfkSV0Xxe6Yj
         K1nrOy90ma9Pngt7E8V/AefrfMYs9UaD8tMuPrDgloGv9LJR1+BBb9PoXpAQ32A7uz
         Pj4ZnlOPqznoQGwfCN1EDwrhHsjS83uO1DSF8Dqs7g9nH1GdsWUR7YIKYHYvUFGyDb
         jgQPhLIgac2iw==
Date:   Mon, 20 Mar 2023 09:01:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH net 1/1] nfp: correct number of MSI vectors requests
 returned
Message-ID: <20230320070121.GG36557@unreal>
References: <20230315121733.27783-1-louis.peens@corigine.com>
 <20230316110943.GV36557@unreal>
 <20230316142710.3b79ed06@kernel.org>
 <20230319111944.GA36557@unreal>
 <20230319114815.5bcba7bf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319114815.5bcba7bf@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 11:48:15AM -0700, Jakub Kicinski wrote:
> On Sun, 19 Mar 2023 13:19:44 +0200 Leon Romanovsky wrote:
> > On Thu, Mar 16, 2023 at 02:27:10PM -0700, Jakub Kicinski wrote:
> > > On Thu, 16 Mar 2023 13:09:43 +0200 Leon Romanovsky wrote:  
> > > > Please don't break lines. You have upto 80 chars per-line.  
> > > 
> > > 72 I think, git adds an indentation. Not that I personally care
> > > about "not using full lines".  
> > 
> > I care about typography.
> 
> Typography of commit messages? 

Everything and commit messages too.

> Let's make sure the code is right.

I rarely give comments about "style" only. This specific comment
came together with attempt to make the code right.

> 
> We may have some fundamental disagreements about line length
> and identifier name length, looking at mlx5 code :(

I have very little influence on how mlx5_core/_en looks like.

Thanks
