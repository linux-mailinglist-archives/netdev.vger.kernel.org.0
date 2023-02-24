Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEBC6A217F
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjBXSaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBXSaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0CB4C6F5
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB7666191D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD852C433D2;
        Fri, 24 Feb 2023 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677263415;
        bh=pHz0xUiwNCN0ujmgT+u9lTN6Xkv4cIkUSCh6qPfvGf0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jwLMVuSMAippbDGfVrW8BRmagtdDAG2Qepk7LzhETUHStMPrTGb81yVNtabt7UHsx
         GSy17SnJV3Mg5IepLIkWYXUVIlKQMeE3qAlj/e1QopCJo95+sPy7xXl3n3pPst5He2
         AhzDQ3lv5ZqMiz/ci6beYcPdI9gE6r39QhjpSwfmNeZOmKyFB10iVSyZImv3sbp814
         b11c9WuvpGC8rSAbEYH5UavTtF9/OdvABRwVnzs2XpGPBXvRxEpnHKMO5GPnC1zhVS
         TDyaOhKsO9Ix5n83c8DNdStzpvPkkC6qTLw6ra1NvVfagRZj36zJX8+jWfCgC/fK5M
         56RLhFHx96yeA==
Date:   Fri, 24 Feb 2023 10:30:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        stephen@networkplumber.org, dsahern@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] genl: print caps for all families
Message-ID: <20230224103013.4a770b99@kernel.org>
In-Reply-To: <CAM0EoMk1esVFzY5fsGLxqhTU=OsDqHSLuKEqiFLJFB_mCmeC7w@mail.gmail.com>
References: <20230224015234.1626025-1-kuba@kernel.org>
        <20230223175708.51e593f0@kernel.org>
        <0ae995dd47329e1422cb0e99b7960615c58d37fe.camel@sipsolutions.net>
        <CAM0EoMnfDhAXsZKY7UqwCxgeXGH1Q-pQdqSycMHw+MSRZSABVA@mail.gmail.com>
        <CAM0EoMm9NyE7nJZ4ktntNMUsCQkyEuVyR5f_E7TgiKNCo15a3A@mail.gmail.com>
        <20230224091055.1a63e08e@kernel.org>
        <CAM0EoMk1esVFzY5fsGLxqhTU=OsDqHSLuKEqiFLJFB_mCmeC7w@mail.gmail.com>
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

On Fri, 24 Feb 2023 12:46:26 -0500 Jamal Hadi Salim wrote:
> > Do you mean to always interpret the flags? FWIW I think that should
> > be fine, old kernels just don't set those flags so I'm not sure why
> > we're gating interpreting them with the version.  
> 
> I think it was leftover cruft from when the capabilities were being
> sent as attributes. Old kernels
> should work fine AFAIK.

Thanks, SG! 
I'll send v2 which removes the version checks completely later.
