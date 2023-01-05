Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AEC65E44E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjAEEBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAEEBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:01:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D2D13FA7
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:01:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD5F360C95
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90B2C433EF;
        Thu,  5 Jan 2023 04:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891275;
        bh=XExX1h697othQ9HT4/5MF/Us2q0mgx5vMA/gytPjjQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gtuhHKht5f5odDc1J8VNkbNpPvr8hUzgy5pvJqPZAdhGXXGwVlY7gySkbgQ+UpApt
         s6hxWj2Tw388l9Km2IAlkCwmyTRyVRvtOVjbvo2DVs+ZuWWGvb/Ied24Lo9oleCQKf
         tr7fRbL5o65lab24CRXrcIlfhBDs2E74RifAb9hU+co0lwSr20Z7ips2KiUCZli6jH
         NyXGvD7m4HK3VbJiNIuxc1Qtfdbkf7sPsG946aPiO7wdIdrnUAQZRMi4abjmGkiFLA
         cvXDb1U+6iYS9QhdbOpBRXWmmMW7AcjWTpHupmwkYwDJybUG/Qus4S2Y9RN+vj62JG
         4q79u4OcaA0Sg==
Date:   Wed, 4 Jan 2023 20:01:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv3 net-next] sched: multicast sched extack messages
Message-ID: <20230104200113.08112895@kernel.org>
In-Reply-To: <20230104091608.1154183-1-liuhangbin@gmail.com>
References: <20230104091608.1154183-1-liuhangbin@gmail.com>
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

On Wed,  4 Jan 2023 17:16:08 +0800 Hangbin Liu wrote:
> In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> made cls could log verbose info for offloading failures, which helps
> improving Open vSwitch debuggability when using flower offloading.
> 
> It would also be helpful if userspace monitor tools, like "tc monitor",
> could log this kind of message, as it doesn't require vswitchd log level
> adjusment. Let's add a new function to report the extack message so the
> monitor program could receive the failures. e.g.

If you repost this ever again please make sure you include my tag:

Nacked-by: Jakub Kicinski <kuba@kernel.org>

I explained to you at least twice why this is a terrible idea,
and gave you multiple alternatives.
