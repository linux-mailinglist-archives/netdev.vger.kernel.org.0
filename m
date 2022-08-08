Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2791758CFE8
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244521AbiHHVup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244070AbiHHVuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:50:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E289FDC;
        Mon,  8 Aug 2022 14:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69F8960EEF;
        Mon,  8 Aug 2022 21:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BC2C433C1;
        Mon,  8 Aug 2022 21:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659995435;
        bh=QuUn35nY1VgewqJjnpKLBQZRbUUzlr2ZiZSsdxavDAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vD5yaCkKJ/F1FLrw3z9hFx3YIyoijYHCzFp2c4xA5yPYUSjrAtrB7oa1b0LJhhhGD
         fyJ9XcYeYbkS+99ePqGe1V4SOaiC/tKdLS21q2O7BMUX7E/igRKtMFezwNjS1h6amG
         AIbNHXf1TmohIxUBLl97Zf2dyTlPrg1njGwUpaEP0O9tg6pRxak6LhJaNWID2tvx0g
         XAOtkILcDf+2yfI7SXO1hlKjFJBXN2xCJgXNxUE7GSIFkEHyZm3ZriaG2+ZZoCDSDm
         0u9fyPGVLcZViykMCNRfM7559lxhtEjGVjoPX8Tk2JFcb7HmfD+hMDUDYOQbN80MVv
         +XGhvqZTEX7rA==
Date:   Mon, 8 Aug 2022 14:50:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth 2022-08-05
Message-ID: <20220808145034.63fc918e@kernel.org>
In-Reply-To: <CABBYNZKmuUpmUChz+tixFCOE_pUeaJq0Sbqkvjy54zd9H=GB4A@mail.gmail.com>
References: <20220805232834.4024091-1-luiz.dentz@gmail.com>
        <20220805174724.12fcb86a@kernel.org>
        <CABBYNZLPkVHJRtGkfV8eugAgLoSxK+jf_-UwhSoL2n=9J9TFcw@mail.gmail.com>
        <20220808143011.7136f07a@kernel.org>
        <CABBYNZKmuUpmUChz+tixFCOE_pUeaJq0Sbqkvjy54zd9H=GB4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Aug 2022 14:36:16 -0700 Luiz Augusto von Dentz wrote:
> > > Still rebasing, I thought that didn't make any difference as long as
> > > the patches apply.  
> >
> > Long term the non-rebasing model is probably better since it'd be great
> > for the bluetooth tree to be included in linux-next.  
> 
> You mean that bluetooth-next would be pulled directly into linux-next
> rather than net-next?

No, no. linux-next is just an integration tree, it doesn't take PRs.
Some more info:

https://www.kernel.org/doc/html/latest/process/howto.html#linux-next-integration-testing-tree

It's mostly for checking for conflicts and automated testing.
All the compilation bots run on it.

> > Since you haven't started using that model, tho, would you mind
> > repairing the Fixes tags in this PR? :)  
> 
> Let me fix them.

Thanks!
