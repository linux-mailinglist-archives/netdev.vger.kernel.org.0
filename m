Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97086C03CB
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 19:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjCSSjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 14:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCSSja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 14:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121A113DF1
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 11:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED6E6114C
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 18:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CBCC433EF;
        Sun, 19 Mar 2023 18:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679251167;
        bh=JNzkZNxN4unZ8sK+KCc52A6wzXO9F9RA417yXwHrptU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sd/x/D0yLSaOWHHyDCIH2Cx8KIC6GHzL+05HSpIoJR7QkxFlREwoL/LeEh2RgUVP1
         gGAPUr89kBJkyVqIS0dVDxdaRn56s49k9EYkdkDwp+QN4p7vILR18CCB9gCQaD8AXR
         k04rHbbBCmqE+p/nVYt0X8iP1tHDVtnFgo64MVBluBj+sJmXX8DVYSPTT2vRA5vwRz
         zW2F5Kjecw6+grx7INPrp31ugQkRzRO/WKy2AkQDSOLphvL8yVDlx1h+jMlwjo6SPw
         +KxtJkLdD1w63XenRj6NN0RIvm6JGk5682H/BTJ21lMY3XO6JYh6LCoi+QTMcRDUrG
         SYYVVLv9ygEHQ==
Date:   Sun, 19 Mar 2023 11:39:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Liang He" <windhl@126.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ethernet: sun: add check for the mdesc_grab()
Message-ID: <20230319113926.2f19022f@kernel.org>
In-Reply-To: <2ddbb6b4.1453.186f9a2a1f0.Coremail.windhl@126.com>
References: <20230315060021.1741151-1-windhl@126.com>
        <20230317222944.64f66377@kernel.org>
        <2ddbb6b4.1453.186f9a2a1f0.Coremail.windhl@126.com>
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

On Sun, 19 Mar 2023 19:30:30 +0800 (CST) Liang He wrote:
> At 2023-03-18 13:29:44, "Jakub Kicinski" <kuba@kernel.org> wrote:
> >On Wed, 15 Mar 2023 14:00:21 +0800 Liang He wrote:  
> >>  	hp = mdesc_grab();
> >>  
> >> +	if (!hp)
> >> +		return -ENODEV;  
> >
> >no empty line between the function call and error check, please  
> 
> Hi, Jakub,
> 
> Thanks very much for your review and reply.
> 
> While I have already prepared the new version patch,  my last patch
> has been Reviewed-by Piotr Raczynski and applied to netdev/net.git
> by David S.Miller.

You're right, I missed that.

> So should I send the new patch again? 

No need, we can't replace it now so let's leave it be.
