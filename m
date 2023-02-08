Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C18868E918
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjBHHgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjBHHgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:36:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE5D360B2;
        Tue,  7 Feb 2023 23:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF88661523;
        Wed,  8 Feb 2023 07:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66E6C433EF;
        Wed,  8 Feb 2023 07:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675841785;
        bh=Ucw5pnrTuHtl6P2Jg5YunGWn1K0GXdRAziXy4dCG1I0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jsCkKQcQXW2y6im7a+SMhfIzRyp0DgNMWZQ4SfXG++8cGYs5vzq4ifrIq47u4CoNq
         2p0lrWgaX6s7tGnflLQJbtk+slsQxOHBQaFXZmPLwJyuR5jjo1NTe4cKSk2zzmvi7t
         f1cwjFnc4cgAi2N5IpM0BBW/BGScwglUns/5YRW0GdG+ytOz44lp3SrqP8FGbov05E
         Vk+k52bvn6QWYP7yPavGIxLiK/0MejqGBOczi8HrCvignIM9irdpheDvcBGwfSIRUn
         gIjLrL/eXQvcb4sbrjUEPqLCZ3NaDAh25oPb7LQULykxbWeU4Jm50STKIdHTm907J8
         ZztvSocRfyMlA==
Date:   Tue, 7 Feb 2023 23:36:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ronak Doshi <doshir@vmware.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Message-ID: <20230207233623.25c4822e@kernel.org>
In-Reply-To: <Y+NOaUHBQGxrYuf2@kroah.com>
References: <20230207192849.2732-1-doshir@vmware.com>
        <20230207221221.52de5c9a@kernel.org>
        <Y+NOaUHBQGxrYuf2@kroah.com>
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

On Wed, 8 Feb 2023 08:25:29 +0100 Greg KH wrote:
> > Does it mean it always fails, often fails or occasionally fails 
> > to provide the right hash?
> > 
> > Please add a Fixes tag so that the patch is automatically pulled 
> > into the stable releases.  
> 
> Fixes: is not the way to do this, you need a cc: stable in the
> signed-off-by area please as the documentation has stated for 16+ years :)

Ah, I have been caught! :] 
I may have started telling people "to put the Fixes tag on for stable"
because it seems most succinct and understandable.
I'll go back to saying "for the benefit of the backporters", or some
such, sorry..
