Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAD15EC54B
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiI0N74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbiI0N7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6AE17ACAA;
        Tue, 27 Sep 2022 06:59:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49554619B9;
        Tue, 27 Sep 2022 13:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497F1C433D6;
        Tue, 27 Sep 2022 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664287142;
        bh=EcYAydDYhSXdtABK016ocMCdu+DSYk983pLPbY+Kzfo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R9kE8PbPoSuq7k+c3zSG+G8UkE7aTcI0/2J1p8BayaXdrimg3UOqmGSKpbruyP/vl
         iAtLU3vVplT14A0RtmYhVDeS6lJm52fiAGLV0vEDTEzCXNdhgohngcBc7eSrNEoLdt
         EEBuD9Rpqnn4ytvmblEzU0LEbvopjBTzRzKFHGVDrRIW2R3i3GWRYZ/icPloRlRaxd
         idec0Gy31khvbAvWEQEW4cIWWVvOjTL67KC2UfOflGlmwY0wBLdtC2SqvIV8EukyZs
         RmJj0XThPc6t5H6WQOxc42aP0ZlgOUfYzZXSrFw0QNSW5MfWq2uzeDmaDlZ3lgugHR
         B9sfCESO8x/rA==
Date:   Tue, 27 Sep 2022 06:59:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shane Parslow <shaneparslow808@gmail.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
 mapping
Message-ID: <20220927065901.614ad81f@kernel.org>
In-Reply-To: <CALi=oTa_=kN=To=67kG71Za2UdbvA9e4S5+CbnZStBRAsJENew@mail.gmail.com>
References: <20220926040524.4017-1-shaneparslow808@gmail.com>
        <20220926131109.43d51e55@kernel.org>
        <CALi=oTY7Me6g1=jtnZig-MzS-TPOOMQ53ih-78QuF-K+Rs0rUw@mail.gmail.com>
        <20220926143711.39ba78e9@kernel.org>
        <CALi=oTa_=kN=To=67kG71Za2UdbvA9e4S5+CbnZStBRAsJENew@mail.gmail.com>
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

On Mon, 26 Sep 2022 15:21:09 -0700 Shane Parslow wrote:
> Got it, thanks. This fixes: 1f52d7b62285 ("net: wwan: iosm: Enable
> M.2 7360 WWAN card support"). Thank you for your patience.

Looks like Kumar has some questions, so let me drop the patch from 
the queue for now. Once the discussion is resolved please repost as
[PATCH net v2] and put the Fixes tag (on a single line) right above
your s-o-b, like this:


[1] https://github.com/xmm7360/reversing

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>


Thanks!
