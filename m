Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59BB4CAE97
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbiCBTZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbiCBTZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:25:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2661156C25
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:24:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEE8CB820F9
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 19:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DDDC004E1;
        Wed,  2 Mar 2022 19:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646249062;
        bh=I59xCcRx5hWrVRepoNd9dbsGnXxwb8NWzK9I089RJR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DWM06sKYfCYndEmvAbuKCk85PC0S7nxJ85euc/Az4PXnzmmXb6AVl94XR406glKjZ
         mCeinmKgp0Xn9A9diJHfTCqgAgKx78IMv724+IYtW/nWYt3LIHjphqq//I70AGMIxN
         3ffakjC7pZY/kN5/GTO4Q9LBYRm46Tnk24VbzlGMhi2a1ScWhvdURzGgN4fPJRkm3f
         BKScnnM7y0Ai2EzCFDCT5ZQ7ohIwWRCcLEVcY9/SqAwTcRb+93UIav2CYoHhSRRTKa
         N0hRk3TIpYKZkqKrzKpMcosns7MsB8sF7l4ILIR+txnhZikDA57nHU8wuuM950LSYD
         aMxoAXp8EBMNA==
Date:   Wed, 2 Mar 2022 11:24:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [net-next v9 0/2] net: sched: allow user to select txqueue
Message-ID: <20220302112420.4bc0cd79@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220222112326.15070-1-xiangxia.m.yue@gmail.com>
References: <20220222112326.15070-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Feb 2022 19:23:24 +0800 xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Patch 1 allow user to select txqueue in clsact hook.
> Patch 2 support skbhash, classid, cpuid to select txqueue.

Jamal, you had feedback on the previous version, 
does this one look good?
