Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91FED4DEA4A
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 20:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243507AbiCSTG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 15:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235662AbiCSTG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 15:06:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F64FD0D
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 12:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A0AB60BBC
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 19:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D74BC340EC;
        Sat, 19 Mar 2022 19:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647716735;
        bh=GjreBnVoIK5q17niaWxbWGQr3pJmqEAtWIC9uzMdSUM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mMdjsRNR61reG/AWstpwySFqTNytFBWKcoi+a2o/88lgRHdVSCQKChRmyS1W8caW7
         KTqsSqfqdYc3RAhz3hxJlMzE0jgGea6EOzKxyhGTZkr5N+U0Dmbo2+VmNpdmoSpyji
         lAs6GSlqo9wa2+0g+Wo+H+KwtyvzSBiKkzIWF/XRsfNNQRSIarP0WCP6W905nkgk3d
         lFvJmZfSttG+GNM8j4TytYblYS3bznRxY5OEWtYaX5bhv4510VfOtmCfyQL/4ybk3t
         6qBGq19G1AtMJmJ7y8n+ifV9LViIAHvXpEH6/H9BalvXQJjvQTKcSyIpMFWBqtuQ/v
         tWFbcegz1fxqw==
Date:   Sat, 19 Mar 2022 12:05:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: pull request (net): ipsec 2022-03-16
Message-ID: <20220319120534.3de1cfac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220319074911.GB4161825@gauss3.secunet.de>
References: <20220316121142.3142336-1-steffen.klassert@secunet.com>
        <20220316114438.11955749@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220319074911.GB4161825@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Mar 2022 08:49:11 +0100 Steffen Klassert wrote:
> On Wed, Mar 16, 2022 at 11:44:38AM -0700, Jakub Kicinski wrote:
> > One minor improvement to appease patchwork would be to add / keep the
> > [PATCH 0/n] prefix on the PR / cover letter when posting the patches
> > under it.  
> 
> I did that in the ipsec-next pull request, let me know if this is
> OK as I did it.

Yes, that one worked out perfectly. Thanks!

> > It seems that patchwork is hopeless in delineating the
> > patches and the PR if that's not there. For whatever reason it grouped
> > the PR and patch 2 as a series and patch 1 was left separate :S  
> 
> I guess this is why I get always two mails from patchwork-bot for
> each pull request. I already wondered why that happens :)

To be honest the pr handling in the patchwork-bot is not 100% accurate,
I wish it was responding to the pr / cover letter.  We'll get there :)
