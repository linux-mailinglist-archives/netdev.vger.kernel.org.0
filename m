Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148286BC572
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCPFFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCPFFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:05:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609E026CC2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C8FBB81FC5
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5E9C433D2;
        Thu, 16 Mar 2023 05:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678943142;
        bh=FB7F9eB/QDKBWWJsCAH8XZlKLAYBUUvz355/bHmee0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ST7qE4DvD28Q3Cown7ITVBQ2K13g4/MHCII/ZI2NNlZSW+Z6+ACJeQUxnsZuWo1uF
         bmpBNQLeo3FG3zqhYnDtOJOE+CQccY9PbYpZMjcNR2Fyz2/JMzr4glgP9vvrKyogop
         XJ0CFUpWUeUbMKfg9X31F99qeNORk+5pGBUX0fLldgZjKURESMKYLOQEaplkHrXaun
         wUPGWshliyuOmf7zpLJA6FcAwet/s+TrzW177/b7jnd3fBMqXo1z8W9KslM9x2PZP2
         Zhs0XqDZLqeu0kXlrGHCoYHj4F9UvEU/pTMdQMsDm0rk9zJkk6vAgeZWuo+WK88ojj
         LNKvtBY1IzoFQ==
Date:   Wed, 15 Mar 2023 22:05:41 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: Re: [net-next 05/15] net/mlx5e: Correct SKB room check to use all
 room in the fifo
Message-ID: <ZBKjpTzP4tn0sYlq@x130>
References: <20230314054234.267365-1-saeed@kernel.org>
 <20230314054234.267365-6-saeed@kernel.org>
 <20230315215641.24119b38@kernel.org>
 <20230315215941.553de9af@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230315215941.553de9af@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Mar 21:59, Jakub Kicinski wrote:
>On Wed, 15 Mar 2023 21:56:41 -0700 Jakub Kicinski wrote:
>> On Mon, 13 Mar 2023 22:42:24 -0700 Saeed Mahameed wrote:
>> > Subject: [net-next 05/15] net/mlx5e: Correct SKB room check to use all room in the fifo
>>
>> net/mlx5e: utilize the entire fifo
>>
>> > From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>> >
>> > Previous check was comparing against the fifo mask. The mask is size of the
>> > fifo (power of two) minus one, so a less than or equal comparator should be
>> > used for checking if the fifo has room for the SKB.
>> >
>> > Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")
>>
>> no fixes tag
>>
>> I thought we've been over this.

Sorry it wasn't clear to me that it was about the Fixes tag, 
I thought the issue was with targeting the net branch.

>
>The rest looks fine, do you want me to apply from the list and fix up?

Yes that works, Thank you.


