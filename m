Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6615D6A217D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjBXS3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBXS3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:29:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3098816333
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:29:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD96F618DF
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2AEC433EF;
        Fri, 24 Feb 2023 18:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677263377;
        bh=ud2huRGJfii1gzpFR9C+gkwzPFbnNDxRFZL2X3TCEQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NeZUXFzL45pVPuYVzFyEQvdsRwjpPTE75ghgb5XUWdFmx6WwZex/eYJG0GEvcvtFT
         WN0is1QV7KytDjuTyy3s/Z1fDbFxtFqjecChjD2rGo9+mXeglS4OsgUhv+9Y71e+8s
         8foEgVGVSdJauxSzlFVOsLhWNe6I/dm97NBiZ0nWrtgkD24jpPx1jjjntqtzXv9RHr
         w9yYjtDjO87x7sh2G7LT4Q9LtJCGLlmylAuuJuThLhE+6xEHaCLaNsAgPd3w4bmzGE
         mECnI6L84+mvpyPCDrynwG6Hvlc1V3UIKmD5fqgZ/jEczPdbXud4KC9v8qvgqQ0daL
         VKTQef387+AaA==
Date:   Fri, 24 Feb 2023 10:29:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>, dsahern@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] genl: print caps for all families
Message-ID: <20230224102935.591dbb43@kernel.org>
In-Reply-To: <CAM0EoM=Ugqtg_jg_kgWjA+eojcV7k+nZuyov8Qn2C7L7aPwSRQ@mail.gmail.com>
References: <20230224015234.1626025-1-kuba@kernel.org>
        <20230223192742.36fd977a@hermes.local>
        <20230224091146.39eae414@kernel.org>
        <CAM0EoM=Ugqtg_jg_kgWjA+eojcV7k+nZuyov8Qn2C7L7aPwSRQ@mail.gmail.com>
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

On Fri, 24 Feb 2023 12:47:02 -0500 Jamal Hadi Salim wrote:
> On Fri, Feb 24, 2023 at 12:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 23 Feb 2023 19:27:42 -0800 Stephen Hemminger wrote:  
> > > What about JSON support. Is genl not json ready yet?  
> >
> > All the genl code looks quite dated, no JSON anywhere in sight :(  
> 
> We'll take care of this...

I'm biased but at this point the time is probably better spent trying
to filling the gaps in ynl than add JSON to a CLI tool nobody knows
about... too harsh? :)
