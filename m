Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CC550C7F0
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 09:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiDWHPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 03:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbiDWHPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 03:15:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA955E1B;
        Sat, 23 Apr 2022 00:12:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95189B800C1;
        Sat, 23 Apr 2022 07:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DAEC385A0;
        Sat, 23 Apr 2022 07:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650697927;
        bh=Nj2EZzrHWfEvKNlc9vg6G7UO5bWs6p7TeqN3b9wh5XE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aQkj0o8otWg8mCoO0aFslm6iSU9quIdFdHPlBaET+4cGeAinuYsrIvJwHksKnA2wr
         hy931ni9WAUZSIJdoYQafd8H3e1rgOPQtlSy4yGQZsC6wzj9p+SxcJBpiDs5/yVtWU
         Y4a/HMM8NeliN/mPir633scE0S2zjhTrQeNRko+Tii1rkufSw+pI5DYHbt7WwOJK+X
         woDgXwLCnST5SoZguUiu2r4SyPFG1uXs+poj8C00GzPEiapjcaBTP4odJe8lZ1KW7f
         f2ViZnMQoP4SHl7e0o3/uKIPha+5BEKNsduZ4Qypa1JJCS70zxt9XHolveE7ZTVfXV
         o0jVWCmuy5bGg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wlcore: vendor_cmd: use pm_runtime_resume_and_get() instead of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220413093939.2538825-1-chi.minghao@zte.com.cn>
References: <20220413093939.2538825-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165069792370.11296.804168009468264707.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 07:12:05 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Patch applied to wireless-next.git, thanks.

d8e11976d8e8 wlcore: vendor_cmd: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220413093939.2538825-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

