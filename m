Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD35559FA9
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 19:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiFXR0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 13:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiFXRZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 13:25:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9546981267;
        Fri, 24 Jun 2022 10:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21D4F61343;
        Fri, 24 Jun 2022 17:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E45C34114;
        Fri, 24 Jun 2022 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656091447;
        bh=w6ZJaZuEMggIsC/hmznPABbeiiiBjWaqRfYcfBN7soA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N1pckqbAofck2e8cPirh55uOBcDr6b/JVm1mBoZqNMvKn1FmRqq0xZUX1fkEaaUwe
         sTf+26nhZ8wQu9XnWM+iXQeXBTjZL727RcjISHiMfGCqFfAfExw1Rf8sYj065p7eBR
         nb0SKrAookQzanjENRR1/s1MVYaocYTzVaHhcRFFm+3tpCNnNmuFukqH5ae8h66ck1
         FjdacSuEHIx3RzchsFeo9PhdLFXdJg3lIwq8UVOCAA3ctQ9u6k+bZ6MHSkCxK1hAOF
         PlV3BY5OzgVDMlhJDoCTDuktrZG9khnFD8zwOKnoDissz564NaAaFhJgs4o/vx/r6w
         01NucDNYY91bw==
Date:   Fri, 24 Jun 2022 10:23:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next v1 1/1] net: asix: add optional flow control
 support
Message-ID: <20220624102358.3b1c0bac@kernel.org>
In-Reply-To: <20220624080337.GA14396@pengutronix.de>
References: <20220624080208.3143093-1-o.rempel@pengutronix.de>
        <20220624080337.GA14396@pengutronix.de>
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

On Fri, 24 Jun 2022 10:03:37 +0200 Oleksij Rempel wrote:
> On Fri, Jun 24, 2022 at 10:02:07AM +0200, Oleksij Rempel wrote:
> > Add optional flow control support with respect to the link partners
> > abilities.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>  
> 
> This is a net-next patch, depending on other net patch:
> https://lore.kernel.org/all/20220624075139.3139300-2-o.rempel@pengutronix.de/

Unfortunately you're gonna have to repost if there's a dependency.
We're a full week away from the fixes making it to net-next, so
too long to keep a patch sitting in pw with the current patch rate.
