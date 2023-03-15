Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33B96BA88B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjCOHAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjCOHAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:00:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C45279AC
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:00:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 659E9B81BFA
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2176C433D2;
        Wed, 15 Mar 2023 07:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678863604;
        bh=+vOJBF9wTwwFdeUG/zW9AyU/K1yQkhpnD7VfFnVnK/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XI5wy6i1Iph9tD3HsJmtPNuX8abIBqyYFqMx4/yoTbCgvuKneqxxfZKDHcd4W1oYF
         FzEXy/EVSs0Vgkts+AzZAiUzTBlWgFlVavJgfJUBl7E0hxHhWsW75fNcjQx0XK478m
         Blf0xuw4ubDFvUn8WbTWmwvFhZ6ko5aGcFRRVeNsX8qYmfpq03ptX1faNH4VdnJn4r
         VwAD08tSH9q8fKnxpI/qwQg+V8ahIaURr0h76XPbVkYvNUpfCPzCZ4KIfN+CxvhUSd
         IQpW36xdVcwYaUZKOTFcRiXRmYmC7zl0ixWqv1ME/8IKj++cDXVzNGP+4lC/fnIerF
         kJmcR1gfkPE/A==
Date:   Wed, 15 Mar 2023 00:00:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: Re: [PATCH 2/3] net: mvpp2: parser fix QinQ
Message-ID: <20230315000002.31da6864@kernel.org>
In-Reply-To: <20230311071005.enqji2btj35ewx53@Svens-MacBookPro.local>
References: <20230311071005.enqji2btj35ewx53@Svens-MacBookPro.local>
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

On Sat, 11 Mar 2023 08:10:05 +0100 Sven Auhagen wrote:
> The mvpp2 parser entry for QinQ has the inner and outer VLAN
> in the wrong order.
> Fix the problem by swapping them.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Can we get a Fixes tag for this change?
