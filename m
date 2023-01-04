Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1AD65CC04
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 03:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbjADCwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 21:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjADCwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 21:52:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A091740B
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 18:52:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEE8B614C9
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 02:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BAFC433EF;
        Wed,  4 Jan 2023 02:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672800737;
        bh=dLtbJvXABcOGHtIevOR2RbVentyTdadp3QYfAqcy0/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oy+7WCMynXUsDjlfhQDiLO+upsjj7xiGtHDqblVSeSUUkvdfb5LxRd8wPTrQ79ng8
         h4BUtMsd+DL3oi8oyRJWClNoZNqUCQpnHFF+bmWs8x5zYrrxAP2HQK9ZK7FqmGwlcy
         klR6MyX1SjeSlTeEam1gWRwhS3HUjGv8+HxEK2GdpgpgDGWUSteHdXwX8JTnmyV60U
         1Rsc4VQE8JpYiti2yY5/W/euieO2WLR795byiRyt6KIFtq3+7OefoYw6oO63UmjhZ4
         p2TI+gQ4LRZG0lZhUbV0P4ZBHyyrTdvl9foAQv/aMeYVN3TzzLUj++OmMtd+l/tP1+
         Dw4ObA8doVyxA==
Date:   Tue, 3 Jan 2023 18:52:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 10/10] netdevsim: register devlink instance
 before sub-objects
Message-ID: <20230103185216.378279d7@kernel.org>
In-Reply-To: <Y7P6kieBDjB/K/30@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-11-kuba@kernel.org>
        <Y7Ldciiq9wX+xUqM@nanopsycho>
        <20230102152546.1797b0e9@kernel.org>
        <Y7P6kieBDjB/K/30@nanopsycho>
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

On Tue, 3 Jan 2023 10:51:14 +0100 Jiri Pirko wrote:
> >> I wonder, why don't you squash patch 8 to this one and make 1 move, to
> >> the fina destination?  
> >
> >I found the squashed version a lot harder to review.  
> 
> I'm puzzled. Both patches move calls to devl_register/unregister().
> The first one moves it, the second one moves it a bit more. What's
> making the squashed patch hard to review?

Ah, I thought you meant patch 7, sorry.
This one matters less, I'll squash.
