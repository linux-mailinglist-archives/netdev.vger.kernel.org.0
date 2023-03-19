Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7E06C00C1
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 12:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjCSLTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 07:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCSLTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 07:19:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A24E17CDE;
        Sun, 19 Mar 2023 04:19:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96D9F60F88;
        Sun, 19 Mar 2023 11:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E71CC433D2;
        Sun, 19 Mar 2023 11:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679224789;
        bh=ePGWx0oixQWMUSTRCyJZJ/i2hN4i5/aIMx6iEI6OnuU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NAaqUMFAypY4IJaFrOgFyp72q8mTibKbQLPf0pq8O/xP+yFrxPiofhRA4o0RvgpgP
         HmffCTX9DNCtw5VrmphsYbSRZNcb2kNpmbqa0Rp8QlJJ2y9s6q1NrWGKgjY00gmVcu
         gXMDrdTq9YbctS5A5ZxN/iddHRhlbgz5Ox9WmUzV0/VjRbC/NYPzIk99YdxcS6m/e5
         RFns+ioxcDaEQHsyQC4qSvYJw/j88/kaj9Fu3G1zW6T8yZvUtsbtB3dkmtoHrBSftk
         wmX7J5psBN4v7+ujfOHkL5IYVPkPKgW+GiO6Uj+ELWoHaOyi2ImTVygVNS0ecrsUVI
         P07htf+/TrcGg==
Date:   Sun, 19 Mar 2023 13:19:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net 1/1] nfp: correct number of MSI vectors requests
 returned
Message-ID: <20230319111944.GA36557@unreal>
References: <20230315121733.27783-1-louis.peens@corigine.com>
 <20230316110943.GV36557@unreal>
 <20230316142710.3b79ed06@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316142710.3b79ed06@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 02:27:10PM -0700, Jakub Kicinski wrote:
> On Thu, 16 Mar 2023 13:09:43 +0200 Leon Romanovsky wrote:
> > On Wed, Mar 15, 2023 at 02:17:33PM +0200, Louis Peens wrote:
> > > From: Xiaoyu Li <xiaoyu.li@corigine.com>
> > > 
> > > Before the referenced commit, when we requested a
> > > certain number of interrupts, if we could not meet
> > > the requirements, the number of interrupts supported
> > > by the hardware would be returned. But after the
> > > referenced commit, if the hardware failed to meet
> > > the requirements, the error of invalid argument
> > > would be directly returned, which caused a regression
> > > in the nfp driver preventing probing to complete.  
> > 
> > Please don't break lines. You have upto 80 chars per-line.
> 
> 72 I think, git adds an indentation. Not that I personally care
> about "not using full lines".

I care about typography.

Thanks
