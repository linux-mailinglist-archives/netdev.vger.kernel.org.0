Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5DD58A06D
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbiHDSXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiHDSXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:23:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A27929CA3
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 11:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4412B82431
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 18:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E78CC433D7;
        Thu,  4 Aug 2022 18:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659637381;
        bh=MYlBXxOdub2yPRy1GuH/k7aldZfQBNU8DPpg12Cg1Bc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r3hZwMt73LPiBRcQYERlxzUA0QhAPymPstrT8iCR/I929hzF0+kdai/2NhkvNctCL
         o+RjYTsOqckdXDw8h7oNOfugRCH1kArIpGijzCh0+hhX2x4+Ua7eJOLCq89s6w2DTV
         8QtDWrF2M4QzfW7PBBZNbzlGR6Mo2/2Sfgjz1Rs02mwg2gTdYde8IkOQYSXKJvsSwC
         7v5Blap+geTiYou4rwVFfKijV0v4ofgg8clb58pXLAdOTG4KN1lqpJqcWjzg9Z6lbW
         ksKW98ugbMPoK1BG/b5JbBqBByj0+wl4+uZcmPCQqhm9HHxQKDkKXnhY6QSI0Zoy89
         QH8oCJgwF48tA==
Date:   Thu, 4 Aug 2022 11:23:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ingo Saitz <ingo@hannover.ccc.de>
Cc:     netdev@vger.kernel.org, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: Documentation fix
Message-ID: <20220804112300.3306b80b@kernel.org>
In-Reply-To: <Yutp1LUTDrpGprhL@pinguin.zoo>
References: <Yutp1LUTDrpGprhL@pinguin.zoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Aug 2022 08:40:20 +0200 Ingo Saitz wrote:
> Hi
> 
> The wangxun ethernet driver contains a confusing kernel config
> description: (in drivers/net/ethernet/wangxun/Kconfig)
> 
> ..."to skip all
>     the questions about Intel cards."
> 
> This clearly should read Wangxun, not Intel, I assume.

I have a feeling I pointed that out in review :S
Let me send a fix, thanks!
