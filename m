Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2375715FF
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 11:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbiGLJoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 05:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiGLJor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 05:44:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE135AA742;
        Tue, 12 Jul 2022 02:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7882F61768;
        Tue, 12 Jul 2022 09:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034D0C341CE;
        Tue, 12 Jul 2022 09:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657619084;
        bh=HJVV8hXX5II2o8jaxx4kBpml75YDJf76DdzCbI/DI8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PAzXLXai9OffFoUCYP++XvyDEluh5YLJelM6/AZIriftppqi/2qDF+5PfMw+dAq72
         6BZSR8muT7UA/O3nSNJotzofVa8+Yw7qNFi1X9lDzvpVcG0bR+OgOEPLlYMg2tcI6V
         DQGxegRYp4B0p1Qw9v3fW3ByM/Dh/LRGvvqoNLXk=
Date:   Tue, 12 Jul 2022 11:44:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Binyi Han <dantengknight@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Coiby Xu <coiby.xu@gmail.com>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: qlge: Fix indentation issue under long for
 loop
Message-ID: <Ys1Chwsa6e9EjRNs@kroah.com>
References: <20220710210418.GA148412@cloud-MacBookPro>
 <YsvZuPkbwe8yX8oi@kroah.com>
 <93dc367b01cdfbb68e6edf7367d2f69adfb5d407.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93dc367b01cdfbb68e6edf7367d2f69adfb5d407.camel@perches.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 01:55:24PM -0700, Joe Perches wrote:
> On Mon, 2022-07-11 at 10:05 +0200, Greg Kroah-Hartman wrote:
> > On Sun, Jul 10, 2022 at 02:04:18PM -0700, Binyi Han wrote:
> > > Fix indentation issue to adhere to Linux kernel coding style,
> > > Issue found by checkpatch. Change the long for loop into 3 lines. And
> > > optimize by avoiding the multiplication.
> > > 
> > > Signed-off-by: Binyi Han <dantengknight@gmail.com>
> > > ---
> > > v2:
> > > 	- Change the long for loop into 3 lines.
> > > v3:
> > > 	- Align page_entries in the for loop to open parenthesis.
> > > 	- Optimize by avoiding the multiplication.
> > 
> > Please do not mix coding style fixes with "optimizations" or logical
> > changes.  This should be multiple patches.
> > 
> > Also, did you test this change on real hardware?  At first glance, it's
> > not obvious that the code is still doing the same thing, so "proof" of
> > that would be nice to have.
> 
> I read the code and suggested the optimization.  It's the same logic.
> 
> 

I appreciate the review, but it looks quite different from the original
so it should be 2 different patches, one for coding style changes, and
the second for the "optimization".

thanks,

greg k-h
