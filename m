Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D105F6C03DD
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 19:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCSSsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 14:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjCSSsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 14:48:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C9018178
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 11:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D8FEB80CAC
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 18:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E753C433EF;
        Sun, 19 Mar 2023 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679251697;
        bh=pY8OnU1Uah20CUusNeceHQ3Gstb/WclLTmjey5r2b4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KnGuuvRex+6prONsHc+RjUF2nsENWRc0olQb1xDDK+ooxIGKjc1Ojq9RJnkYvevuj
         ooN9jEw3OfxQfLCfBL+7S/1VhmK1TBiIh5iw0mvB5sg/KWnUVvlUoNzFx1K6hYJOF7
         0V9FcSW3xA9KX0XHu3MgyyHav/4VhW9eQVhWuQ2DMjwHsBDp4ufiREuWDiIW8rM1rm
         EytkpXwwLSimO6UDkedTjPE7lurSo2AlpIoRgkFEmYgec9JSgQ5pNPapyRkNncxp9z
         EdGObzTWEPsatIUpYDBxkKXjYuUVyUtrcpn7GIC5dcZsdXLSTFEtUHtSCOy63pay+6
         69mlucVoyjDsQ==
Date:   Sun, 19 Mar 2023 11:48:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH net 1/1] nfp: correct number of MSI vectors requests
 returned
Message-ID: <20230319114815.5bcba7bf@kernel.org>
In-Reply-To: <20230319111944.GA36557@unreal>
References: <20230315121733.27783-1-louis.peens@corigine.com>
        <20230316110943.GV36557@unreal>
        <20230316142710.3b79ed06@kernel.org>
        <20230319111944.GA36557@unreal>
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

On Sun, 19 Mar 2023 13:19:44 +0200 Leon Romanovsky wrote:
> On Thu, Mar 16, 2023 at 02:27:10PM -0700, Jakub Kicinski wrote:
> > On Thu, 16 Mar 2023 13:09:43 +0200 Leon Romanovsky wrote:  
> > > Please don't break lines. You have upto 80 chars per-line.  
> > 
> > 72 I think, git adds an indentation. Not that I personally care
> > about "not using full lines".  
> 
> I care about typography.

Typography of commit messages? Let's make sure the code is right.

We may have some fundamental disagreements about line length
and identifier name length, looking at mlx5 code :(
