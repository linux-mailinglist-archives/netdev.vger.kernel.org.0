Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C574EB7C2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241569AbiC3BYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241538AbiC3BYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:24:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78692498A4
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:22:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59B8E612BB
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5278EC2BBE4;
        Wed, 30 Mar 2022 01:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648603366;
        bh=qkbwxBx91eDVzMek4FIxYU6sCiDh7QR0YBT2U2UzKkI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RWghizTD0pdDJ9JCUVdA/SDGsC29RsM95DmM/hjAGi4+AaYuwLjh2svGwAIcCSDyl
         knrxkfVRZqHjlaeUb+R8bXPrCCfVXg5LD+Bs/9ZgPN9PhXZ6hboAfriJLmzWUbDbJc
         tAR3iM0ggyXK3OgZzyfytWHqiPa/oCZ57Gn1Ahk3+Acgh9BhV9OLUrxNpJbychaXge
         I14RJwh2iKaW4mZr6oTdH6eg3oyBdHC9dUekyZ/2jINHH3PnEEWrMsIh91+cmXdD1D
         i6b8r9Zj3FntEOgigdjgYjTyVofp14lHWsHON7YvgAnEUK7DhlNx1nHEaAZK99T6T/
         JhF8EXhf54GcA==
Date:   Tue, 29 Mar 2022 18:22:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jmaloy@redhat.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Subject: Re: [net-next] tipc: clarify meaning of 'inactive' field in struct
 tipc_subscription
Message-ID: <20220329182245.0127ccbc@kernel.org>
In-Reply-To: <20220329173218.1737499-1-jmaloy@redhat.com>
References: <20220329173218.1737499-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 13:32:18 -0400 jmaloy@redhat.com wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> struct tipc_subscription has a boolean field 'inactive' which purpose
> is not immediately obvious. When the subscription timer expires we are
> still in interrupt context, and cannot easily just delete the
> subscription. We therefore delay that action until the expiration
> event has reached the work queue context where it is being sent to the
> user. However, in the meantime other events may occur, which must be
> suppressed to avoid any unexpected behavior.
> 
> We now clarify this with renaming the field and adding a comment.
> 
> Signed-off-by: Jon Maloy <jmaloy@redhat.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.18
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.18-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
