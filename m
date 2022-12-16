Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84A564F100
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 19:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiLPScb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 13:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiLPScZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 13:32:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03C076159
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 10:32:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C0F1621CD
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 18:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8EFC433EF;
        Fri, 16 Dec 2022 18:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671215537;
        bh=HZg+vaTr8m+VemSI4SHkS8h20pqbbrGm2s6WlOzxgRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sty3dvQZLhGcMDW5HsuVaKF2y0qDTASrEvqn0B3t0UHFoZrJPTW3dF1NR2tl+1vK5
         3i0L54E8ymcYlrTyjaMlr9/AO2ghsG6rvdZg6dBJDIlV6beOmDdGpoTim7qMdJCrqH
         D1M3COQ8D1uCLXMaSr6jtJOWbzNem+xFAbowIink32u5N+nctfOweIKLk1MU22G+9+
         QmH6RdsAeOuWuwlWGSQTQcRW/WU7VaMaxeKyLWOdC32xGIXBSuZesMkL1YytIbgg7G
         vAf0kx4ChNoiGFz5gi1TXJF5iQwwO65df7eMu4lh6alQvzY3tfdT+dk2/+DlKJPZrZ
         JI41Hly0nQqPA==
Date:   Fri, 16 Dec 2022 10:32:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated
 directory
Message-ID: <20221216103216.6a98725b@kernel.org>
In-Reply-To: <Y5w2EXhHyxxSxQCE@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
        <20221215020155.1619839-2-kuba@kernel.org>
        <Y5ruLxvHdlhhY+kU@nanopsycho>
        <20221215110925.6a9d0f4a@kernel.org>
        <Y5w2EXhHyxxSxQCE@nanopsycho>
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

On Fri, 16 Dec 2022 10:10:41 +0100 Jiri Pirko wrote:
> >> Hmm, as devlink is not really designed to be only networking thing,
> >> perhaps this is good opportunity to move out of net/ and change the
> >> config name to "CONFIG_DEVLINK" ?  
> >
> >Nothing against it, but don't think it belongs in this patch.
> >So I call scope creep.  
> 
> Yeah, but I mean, since you move it from /net/core to /net/, why not
> just move it to / ?

It still needs to depend on NET for sockets, right?
