Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BE16DF7D6
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDLN6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjDLN6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:58:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1633C10DE
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5F6162D35
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 13:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95B8C433D2;
        Wed, 12 Apr 2023 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681307910;
        bh=elXLYxadHS1MPrtFcK8VwvpfzOnZib9ro4lfhJzgPOQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eZKuch263LhvqAdcjcygH6+YeFOU8/6vdcMUUUBKXYlAkIvML+K6g1tz4uERaGo/j
         iOBjP0zoP1/1+jUzBa54yWVCU4Hmd3DoJXoYHSGOUrkiXVd+vTKvAHcZtwoYcXoObJ
         KdtoZp+Vq7FDZMxk4zvZ7ksTuM66/tXSYhjWjxuzgCk8+oZopd4BIpQeIEi8rSAHeq
         rRfRoQ5Fc6O55tTavUsyftNLfVgVP6OoXBA0aiqrxU8RJyrwf4t+PtG9dsMEMS06da
         8D0z/lhhgoSF/Ki63RmN8n5jvRqVJEi7jMQi86vRlb3UiXltNV/IqfmYQ3bG+zPvAN
         lu1RGjgihvc2A==
Date:   Wed, 12 Apr 2023 06:58:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing
 SKBs
Message-ID: <20230412065828.2490161d@kernel.org>
In-Reply-To: <CAKhg4tK74HRuZ8MgAG1t6oQ+CV4o6y3QLvuYOkWUPCZMHjUyxw@mail.gmail.com>
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
        <20230410172626.443a00ca@kernel.org>
        <CAKhg4tK74HRuZ8MgAG1t6oQ+CV4o6y3QLvuYOkWUPCZMHjUyxw@mail.gmail.com>
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

On Wed, 12 Apr 2023 15:27:13 +0800 Liang Chen wrote:
> Sure. I have addressed it and submitted the updated patch for your
> review as v3. Thank you for pointing it out.

I know, I don't understand why you have to send this note, I can see
the patch. And it's still in patchwork which as you know (as I trust
you read our process documentation) means it's going to be reviewed.
The judeo-christiano-muslim world is going thru its spring celebrations
so the reviews will be slower than usual. 

Please be patient.

And please don't top post.
