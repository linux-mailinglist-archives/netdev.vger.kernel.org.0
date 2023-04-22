Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01DB6EB743
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 06:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDVEIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 00:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjDVEII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 00:08:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24611FD5
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 21:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54F12600E1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 04:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54730C433D2;
        Sat, 22 Apr 2023 04:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682136486;
        bh=pzj3tEVCTmRgpSg8jIVG5bp96ShIywb2G0Y++0ChK0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TLhfpyS7h1BBR326iXKJ5CGhAuPCdnaHV8Sto6gKoE8s3t0H/50pSdq8oOQZ6a/St
         8bQDYOOGRAmjSLSC8RynCKUWYctEcIAb8OwwY//VVic65p+lH7qtVofMWeUni5v9EB
         cdG5xuGBG7kj5OXHu7X1ou5osWVtJpgpOQrG2qsabxGqH86zFS+TnOmWm47sYFBdhx
         HNCtb7ViCvzELSMZbrGxH8pVlnfs/ZX6fIarsTA5ueB1aH9ctxVmLn94mmvLmC3Tuv
         EmS8ziqqyRFSnoe7GjDVBh2sy06tOYJEGsz5a2SpRBNyN0wKk6gHogttXelOEf4WqK
         ZlFum7jzseCgA==
Date:   Fri, 21 Apr 2023 21:08:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v4 0/4] net/sched: cleanup parsing prints in
 htb and qfq
Message-ID: <20230421210805.42a66c21@kernel.org>
In-Reply-To: <20230421175344.299496-1-pctammela@mojatatu.com>
References: <20230421175344.299496-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 14:53:40 -0300 Pedro Tammela wrote:
> These two qdiscs are still using prints on dmesg to report parsing
> errors. Since the parsing code has access to extack, convert these error
> messages to extack.
> 
> QFQ also had the opportunity to remove some redundant code in the
> parameters parsing by transforming some attributes into parsing
> policies.

I haven't investigated in detail but doesn't seem to apply:

Applying: net/sched: sch_htb: use extack on errors messages
Applying: net/sched: sch_qfq: use extack on errors messages
Applying: net/sched: sch_qfq: refactor parsing of netlink parameters
error: patch failed: net/sched/sch_qfq.c:408
error: net/sched/sch_qfq.c: patch does not apply
Patch failed at 0003 net/sched: sch_qfq: refactor parsing of netlink parameters
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
fatal: It looks like 'git am' is in progress. Cannot rebase.

-- 
pw-bot: cr
