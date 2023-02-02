Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3316885C2
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjBBRy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjBBRy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:54:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2191C6A714;
        Thu,  2 Feb 2023 09:54:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D6AC61C67;
        Thu,  2 Feb 2023 17:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A39FC433D2;
        Thu,  2 Feb 2023 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675360494;
        bh=BOF/mnvCtH7ZcWaoKQBInDDta2u7vCAD1PNqaquXBT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j6bRixwn/XkM7BET4mNUlKe0OinPz+os9HjEE/psnlY5vEqEMdi3FD74/TAZ2Mdxg
         8y5DrbGMFZENuyhFXeFtAOXiL7+0nGdMNjNJs1iP7Fqa0as/No6w/oEoBvQlfkx1uk
         FMYNSbD7COwYTVUuRKug5Jb2OOwD+7RE7vI7C+AuM+oMhfTq6wUkMKFlEkWZStF4hf
         KRnVTAo4HRftD5IQCo024oXv0L6rIuvmxNuYNSCqK1Eb4XJwOIR7soRQ52YoMlQZ9w
         NFWyzEah998X9Kov0yB7WvqEvLMCN6SBbT9acTup3OILL8f5yIw8UCTW/BUf37PPji
         6VktaISUtiCHw==
Date:   Thu, 2 Feb 2023 09:54:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230202095453.68f850bc@kernel.org>
In-Reply-To: <Y9v2ZW3mahPBXbvg@nvidia.com>
References: <20230126230815.224239-1-saeed@kernel.org>
        <Y9tqQ0RgUtDhiVsH@unreal>
        <20230202091312.578aeb03@kernel.org>
        <Y9vvcSHlR5PW7j6D@nvidia.com>
        <20230202092507.57698495@kernel.org>
        <Y9v2ZW3mahPBXbvg@nvidia.com>
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

On Thu, 2 Feb 2023 13:44:05 -0400 Jason Gunthorpe wrote:
> > You don't remember me trying to convince you to keep the RoCE stuff
> > away from our open source IPsec implementation?  
> 
> Huh? What does this:
> 
> https://lore.kernel.org/all/cover.1673960981.git.leon@kernel.org/
> 
> Have to do with IPsec?

Dunno. But I don't know what it has to do with the PR we're commenting
on either..
