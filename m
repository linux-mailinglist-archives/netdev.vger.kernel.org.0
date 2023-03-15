Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71026BA887
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 07:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjCOG66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 02:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjCOG66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 02:58:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC19206A2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 23:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09F14B81BBD
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BD8C433EF;
        Wed, 15 Mar 2023 06:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678863534;
        bh=sDNQgULNBJuK7kjsSav55LyD6kZ7YY8q+Owhl08CmIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f0QiBJXZnY8LH9jtkCS5yz8RmposuwN8KdFwQKx2kwMySYeO7ICzx16pWgmh+KX8q
         3fkDtUAm2CRQvjN2C/3oFkHREwTOMcdEi8lnw320/g5Ah9Y5WwYon4GJ1+RqmTAN75
         nmF0fjCQ7t+NalUyxZI24Z1qYU9Q3lZM70ySIQMioAYG0cMY2nAhpuR0LkKrhYfXxs
         JEFQzTa37LD2z4f4hr7U5MQUMM2tLczKoUkYDrCiz79aMY8PaTfC5ovvcZtnYtbZEF
         TW1YjJkEeZnhp1GEznNH7iT6RBxP2PsG9h6+tY93QCh8nZx/Kz6PAvlHta6J6TP4zk
         qoJbPf4yESz6Q==
Date:   Tue, 14 Mar 2023 23:58:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: Re: [PATCH 1/3] net: mvpp2: classifier flow remove tagged
Message-ID: <20230314235853.4dfb1cb6@kernel.org>
In-Reply-To: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
References: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
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

On Sat, 11 Mar 2023 08:09:48 +0100 Sven Auhagen wrote:
> The classifier attribute MVPP22_CLS_HEK_TAGGED
> has no effect in the definition and is filtered out by default.

filtered out in the code somewhere? 

> Even if it is applied to the classifier, it would discard double
> or tripple tagged vlans.

So the MVPP22_CLS_HEK_TAGGED change is a nop?

> Also add missing IP Fragmentation Flag.

What's the impact of this change? Seems like it should be a separate
patch.
