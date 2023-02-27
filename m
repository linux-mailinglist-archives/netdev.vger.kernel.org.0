Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51C56A4D72
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjB0Vln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjB0Vlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:41:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42C01ACE5
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 13:41:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E8B8B80D9A
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 21:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C37C433D2;
        Mon, 27 Feb 2023 21:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677534099;
        bh=LR69F4Hi/J5dXxkwZ4fIti/juaKEdgpM8soLTJxmlPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=efd8TnJbrIiMP2wOrpQM1WLE7OtWVHCKdGACENQZOHatE/3ZVCpzt7oUtISj/ZTYl
         6fr/ucKSBQU/fBenvRnqaHN/SnoW7EeMTbr+gra6JYWxrsZsLySFtYdljnvKjf/Dwq
         N+QHwbXw7lJ7F5foSF3nuOFxQQWKSXSntFtRuTd58Ls98a2Z/UaxtZZcJpJuJ13jh0
         HCmFXbKDHid0ZuV6U0Bf8gZ3ePnNOvXnKa+ZBUCXgy2asbBK0pEJB4q2u8oM162XVo
         yq4diuIkOLiKy83b4imk54dJanHAN07nrjNSRJI2NluVABviPgRE5ve59lwX2Xfs20
         koEKCvpMgLsKw==
Date:   Mon, 27 Feb 2023 13:41:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, amir@vadai.me,
        dcaratti@redhat.com, willemb@google.com, ozsh@nvidia.com,
        paulb@nvidia.com
Subject: Re: [PATCH net 1/3] net/sched: act_pedit: fix action bind logic
Message-ID: <20230227134137.51079d41@kernel.org>
In-Reply-To: <20230227120420.152a9b32@kernel.org>
References: <20230224150058.149505-1-pctammela@mojatatu.com>
        <20230224150058.149505-2-pctammela@mojatatu.com>
        <Y/oIWNU5ryYmPPO1@corigine.com>
        <a15d21c6-8a88-6c9a-ca7e-77a31ecfbe28@mojatatu.com>
        <Y/o0BDsoepfkakiG@corigine.com>
        <20230227113641.574dd3bf@kernel.org>
        <CAM0EoMmx7As2RL4hnuH8ja_B7Dpx86DWL3JmPQKjB+2B+XYQww@mail.gmail.com>
        <20230227120420.152a9b32@kernel.org>
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

On Mon, 27 Feb 2023 12:04:20 -0800 Jakub Kicinski wrote:
> > > I'm with Simon - this is a long standing problem, and we weren't getting
> > > any user complaints about this. So I also prefer to route this via
> > > net-next, without the Fixes tags.    
> > 
> > At minimum the pedit is a fix.  
> 
> How come? What makes pedit different?
> It's kinda hard to parse from the diff and the commit messages
> look copy/pasted.

Ah, looks like DaveM already applied this (not v2), so the discussion
is moot.
