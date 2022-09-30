Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EED45F10BE
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiI3RZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiI3RZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:25:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E0AC7456;
        Fri, 30 Sep 2022 10:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 584EAB827A1;
        Fri, 30 Sep 2022 17:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F03C433C1;
        Fri, 30 Sep 2022 17:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664558734;
        bh=jGBn7lFjT1+xotlntygQv1Y69bjqIxYoFJN3FL+K2hY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U0yDEUHy7zkTyC0v7vwXq7Yp7o7kKvEiXwmkz6C9vUHcC0nbdQD+0kc38Gc3SBfNC
         /53O89FiGEODMAmd5FNa0kDi+UBWTkrEVOeLjeDQiOkYTMvCvPOpdmFIvxwwrxcKej
         qGGhl2AjMCokOA/ec6SrB8N1en8/G0CjZIbCi5CHcgoxMq4KBM3zWegULcOd1qDo8m
         m3Bb5+qEInZiRiolhDAuCDaiO+MWzwEEGYy9HfUt/O4AweifCJqs6w+1uIfiQJ5k6w
         AqBcG/l5uM+vMlEt+88OgTHdu3bY9a0k45HJ66P6869CMytzO1zqPVki9+fprXz5Dz
         Py5Nh03Hnb6eQ==
Date:   Fri, 30 Sep 2022 10:25:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Hacker <hackerzheng666@gmail.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, netdev@vger.kernel.org,
        wellslutw@gmail.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, alex000young@gmail.com,
        security@kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH] eth: sp7021: fix use after free bug in
 spl2sw_nvmem_get_mac_address
Message-ID: <20220930102533.03e21808@kernel.org>
In-Reply-To: <CAJedcCx5F1tFV0h75kQyQ+Gce-ZC4WagycCSbrjMtsYNM85bZg@mail.gmail.com>
References: <20220930040310.2221344-1-zyytlz.wz@163.com>
        <20220930084847.2d0b4f4a@kernel.org>
        <CAJedcCx5F1tFV0h75kQyQ+Gce-ZC4WagycCSbrjMtsYNM85bZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Oct 2022 01:23:52 +0800 Zheng Hacker wrote:
> > Is there reporter and author the same person with different email
> > addresses or two people?
> >  
> 
> Hi Jakub,
> Yes, its the same person from different email count.

Please repost without the Reported-by tag, then.
It's implied that you found the problem yourself
if there is no Reported-by tag.

Please remove the empty line between the Fixes
tag and you Signed-off-by tag.
