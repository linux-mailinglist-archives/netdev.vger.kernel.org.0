Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC42591781
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 01:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiHLXHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 19:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHLXHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 19:07:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4CB9AFC1;
        Fri, 12 Aug 2022 16:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 578AAB82539;
        Fri, 12 Aug 2022 23:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C68C433D6;
        Fri, 12 Aug 2022 23:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660345656;
        bh=1NHpvQAAd0/G6lwCwj3qp7kV5/r5MOySOolTmSn3tw4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mPEJn5uYT+pYfbBGf6a0wiZGjkenOhswPMPf/iUoWVW+T86QDRmf3LamxdsxUvj1/
         mtT4ewSIyt9mgoJccOqX4O6n8SWVsjRMBoSvL6jqBdBZLTXAsRRDK/SkkM5KGYiI89
         rF5DQjHOT2dHI62Hj9jYL+B0JzWi+i1w/7cW3h2Jdue8s6mYrOxvUWoN1dU9eXz1zW
         n3t8K2yhXEWxcc1nBV+3/j44WLlxQuTxrW7Fj8wD1Q1OdVeYXIw/4vhyX5vS3RHVtG
         aY3ctNg/iX5kUbXbDcWr90z/1AnLbAYPIjoCMlnYM9TFw6u/Sxq3wlZdto6v/PhnZS
         2eu5e3vzO6iHw==
Date:   Fri, 12 Aug 2022 16:07:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 3/4] ynl: add a sample python library
Message-ID: <20220812160735.06325b7b@kernel.org>
In-Reply-To: <0e27c04a-f17c-7491-7482-46dc9a5dd151@gmail.com>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-4-kuba@kernel.org>
        <20220811180452.13f06623@hermes.local>
        <0e27c04a-f17c-7491-7482-46dc9a5dd151@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 16:42:53 +0100 Edward Cree wrote:
> > It would be great if python had standard module for netlink.
> > Then your code could just (re)use that.
> > Something like mnl but for python.  
> 
> There's pyroute2, that seemed alright when I used it for something
>  a few years back, and I think it has the pieces you need.
> https://pyroute2.org/

I saw that and assumed that its true to its name and only supports
RTNL :( I'll reach out to Peter the maintainer for his thoughts. 

This patch was meant as a sample, I kept trying to finish up the C
codegen for a week and it still didn't feel presentable enough for 
the RFC. In practice I'd rather leave writing the language specific 
libs to the experts.
