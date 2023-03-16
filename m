Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C499B6BC584
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjCPFN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPFN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BB07D87
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8080761CDB
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898FFC433EF;
        Thu, 16 Mar 2023 05:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678943634;
        bh=QTqYTlriQp6ASLZs/PvLuY8kh/kOUIDaTwHJOczPz84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ReEUwVzBOGANsnfj5z0ztfXgA5EXVWVs/nIgJAJxuN4+BFNoivJcI8yqBTYBqJ2m+
         2fiMRTpkzYeH3G7mouKDzU7CX+M7sMumZ7HBOpn5rRHQsUA00yLy8rOTBv7mbOFBBP
         9l94kNCa8ekrzcSCpBzGryle1uQ9n/Sfk9XVl8rudHGiYzbwrkkg7gE/FgZ5ylQzBR
         RxQIubVXScSQjaBuKhxmTYlOgAplFHp2z7P4mk3o5bm8mA/8egkdI0kkzdC7slkQ1M
         bfN2rtrO67HiH+qAmtnkxAtUPpgs08yrKakC/JzYUIX/XZqFp8L33H4tV+EqqT9N56
         7WXchpACYR/4Q==
Date:   Wed, 15 Mar 2023 22:13:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: Re: [net-next 05/15] net/mlx5e: Correct SKB room check to use all
 room in the fifo
Message-ID: <20230315221353.30d25540@kernel.org>
In-Reply-To: <ZBKjpTzP4tn0sYlq@x130>
References: <20230314054234.267365-1-saeed@kernel.org>
        <20230314054234.267365-6-saeed@kernel.org>
        <20230315215641.24119b38@kernel.org>
        <20230315215941.553de9af@kernel.org>
        <ZBKjpTzP4tn0sYlq@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 22:05:41 -0700 Saeed Mahameed wrote:
> >> no fixes tag
> >>
> >> I thought we've been over this.  
> 
> Sorry it wasn't clear to me that it was about the Fixes tag, 
> I thought the issue was with targeting the net branch.

Mostly about it getting into stable, the process is a bit 
unpredictable.

> >The rest looks fine, do you want me to apply from the list and fix up?  
> 
> Yes that works, Thank you.

Will do.

