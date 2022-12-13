Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F264764AE4F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 04:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbiLMDjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 22:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbiLMDjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 22:39:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD341B9CE;
        Mon, 12 Dec 2022 19:39:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AED3B810B0;
        Tue, 13 Dec 2022 03:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AD3C433EF;
        Tue, 13 Dec 2022 03:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670902739;
        bh=doPFZQdrpo0V0DFdxQ+yws2d0FfMACnoMY1CMs2HpS0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t20zNnEG6ozQvCuuceCAK5uTk4MBweKb8YsGpBoedtUtP0eGxOxnot6cVPQ6ZcL/U
         Ft6vG1pBpKeXEoMfJH/P6L0oMsc931hlMglPMgmMXcBBjLRWz6LgxVO3+FxyDAAF3e
         gblR2sjVOqsMPr0XM4tDfRJn8GTp3bG0KCQbbh4SIX0+g0w/GWD88WRC71Q/EGb9A4
         annKSnxiqjgfRdrgYK5PkBwIw3/DRiFcp4nhkYv30XCm2F8WYZ/4Cym3mf+NLM0V8c
         yqvGuGFJeJvbE5MVidyEqKykK2hcUqr1xjftAuc6WcJxCH1+INCO2HdV19YAT1EXGi
         dwKG8WyHXuBaw==
Date:   Mon, 12 Dec 2022 19:38:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jun Nie <jun.nie@linaro.org>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net_sched: ematch: reject invalid data
Message-ID: <20221212193857.3656ae96@kernel.org>
In-Reply-To: <20221213012023.673544-1-jun.nie@linaro.org>
References: <20221213012023.673544-1-jun.nie@linaro.org>
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

On Tue, 13 Dec 2022 09:20:23 +0800 Jun Nie wrote:
> Change-Id: Id2411e5ddcf3091ba3f37bddd722eac051bc9d57
> Reported-by: syzbot+963f7637dae8becc038f@syzkaller.appspotmail.com

Please repost with the following changes:
 - no gerrit change-id
 - [PATCH net] in the subject
 - Fixes tag added
