Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E934BB0ED
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiBREwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:52:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiBREwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:52:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC39013FAB;
        Thu, 17 Feb 2022 20:52:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82AD5B82499;
        Fri, 18 Feb 2022 04:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36B7C340E9;
        Fri, 18 Feb 2022 04:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645159923;
        bh=uVJfEu+xW11wsO1oXDxEUy1ONTXTBEQ/j80dZ6m2VGM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ateDoHk2L90L0ImxhAfpFwST64FplrE+8OFDL57JFyTYPmS6C5RNZqjHNONH7efIE
         FKwHD0TmzKJd5cQgCXYsM6gg9DVk1k5Fk7A/BEr9JtjtHy3U7661PLg192gqs9fe40
         KzyL98R8tej6QN3yAR55F1XrZ/ythnF3NaBVQegOfecd4Et+OeYkKY4WYZc9G8ulR1
         RUMIfhB7K9k76VjNvWcnJDm0fxGrlFRbkG1flVydn2i09ahJ0tzlrOvThYKvl7RxJW
         8I7Ltc5mTL1Lqx+Nvdfj5mFfIv3q2woMftNKSnQJT3C8coJP8kpKYeH29EeCDLHOL9
         /Odiiu3/xkSkw==
Date:   Thu, 17 Feb 2022 20:52:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: prestera: flower: fix destroy tmpl in
 chain
Message-ID: <20220217205201.3909b634@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1645022624-2010-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1645022624-2010-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 16:43:44 +0200 Volodymyr Mytnyk wrote:
> Fixes: fa5d824ce5dd ("net: prestera: acl: add multi-chain support offload")
> 
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>

Ah, and please don't put empty lines between tags.
