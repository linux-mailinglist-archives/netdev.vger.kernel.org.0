Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E6A696FF2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjBNVlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjBNVlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:41:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA81329163
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:41:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80B4EB81F1E
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 21:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F15C433EF;
        Tue, 14 Feb 2023 21:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676410862;
        bh=oxW+1LxV5dwO3NkD7s8lzN7VictIbAu7L3snHUjnfLg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EONztt2XfdoH22UfUyU1bEkPGs/uCqa61ic1Z8Pdn8MJaCBY8EtcP/YZU5PpCRTMX
         lbq67N7YxRF73ZXgkPR+es5IUB9BztW83JmUs4rsOYQtdB8GBawP7P6ycjMds+1IUL
         uXljUevxh2ZxwaMuLwy1uw1WFPhe5g2a6twvUPnT++EnVCDRxDXOyOuaAjO+Zc9+QM
         RuRyQmNAN8m/zZ2NrlYCpNDaTeXhNic7KEHctIdltve61nnYvhIBbWA4OxrLRZOSEV
         cwQWTG7k9oQdVlzJZHBx6+z0zlHJ6HkOKqpTQLbmPQ3XP2rB3Fknv03i/6iXYNjdCo
         8woK/FaOPeUIQ==
Date:   Tue, 14 Feb 2023 13:41:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and
 classifiers
Message-ID: <20230214134101.702e9cdf@kernel.org>
In-Reply-To: <20230214134013.0ad390dd@kernel.org>
References: <20230214134915.199004-1-jhs@mojatatu.com>
        <Y+uZ5LLX8HugO/5+@nanopsycho>
        <20230214134013.0ad390dd@kernel.org>
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

On Tue, 14 Feb 2023 13:40:13 -0800 Jakub Kicinski wrote:
> > I think we have to let the UAPI there to rot in order not to break
> > compilation of apps that use those (no relation to iproute2).  
> 
> Yeah, I was hoping there's no other users but this is the first match
> on GitHub:
> 
> https://github.com/t2mune/nield/blob/0c0848d1d1e6c006185465ee96aeb5a13a1589e6/src/tcmsg_qdisc_dsmark.c
> 
> :(

I mean that in the context of deleting the uAPI, not the support, 
to be clear.
