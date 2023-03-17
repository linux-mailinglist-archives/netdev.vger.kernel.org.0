Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49916BF3B4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCQVRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCQVRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:17:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA076EB81;
        Fri, 17 Mar 2023 14:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90136B825C3;
        Fri, 17 Mar 2023 21:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D459FC433EF;
        Fri, 17 Mar 2023 21:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679087805;
        bh=0xRB0/LOH7T8o9AX3OGm7niAqlTJENsKh17kmo7SoSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZfXd5h8znXAT2LwpPuzZAn/d4+tw4kfRhLx9y1EgXLsWS9rpNO/GNR/r7pCnBF6n2
         Act+YOUBp3ms++uc+hPZlKfuhoTbChlTqqaJFg8aySHrvl4Ae0oIs0ThyZvSFgfZEF
         P+hhwgMPK1525c0jbXGs2usH77vChO59aLcjVh2Awdx/lNB7UGXVdEbC0YD8vHFoX1
         tYhLOQ/26ZDz7YOeiR5/WnswLpQrV0LpHgZhPt5Ywo59XaoGYxs6+0BR8CBkXiGvCU
         fiXG37RiEwgf0Az4+RkzeN72sTxTQCKevPzGWUyp6tSsKx4/c5eMvdlKYMAW7RxUvb
         Qr5rmvfxPV+Tg==
Date:   Fri, 17 Mar 2023 14:16:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PULL v2] Networking for v6.3-rc3
Message-ID: <20230317141643.0fd525a2@kernel.org>
In-Reply-To: <CAHk-=wjJxtMDPoFzuh8CfzcDbrKwvCYFXrvaEe6=e2syr7TwoQ@mail.gmail.com>
References: <20230317202922.2240017-1-kuba@kernel.org>
        <CAHk-=wjJxtMDPoFzuh8CfzcDbrKwvCYFXrvaEe6=e2syr7TwoQ@mail.gmail.com>
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

On Fri, 17 Mar 2023 13:35:59 -0700 Linus Torvalds wrote:
> > Here we go again..  
> 
> Well, this time you're missing the diffstat and shortlog....
> 
> Other than that it looks fine ;)
> 
> I've pulled it, because the diffstat I get is within the expected size
> (ie "slightly bigger than the v1 diffstat that was missing some
> stuff"), and the top commit matches what you claim it should be.
> 
> But a bit more care would have been appreciated.

Second time I do this, sorry. Scripting time..
