Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EAB62530A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 06:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiKKFX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 00:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKKFX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 00:23:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220BF23E87
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:23:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEADCB81E60
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 05:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCB3C433D6;
        Fri, 11 Nov 2022 05:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668144233;
        bh=+G7FVbXL/2a/mjajrDEwt1xYcigFrw+tPKbiVH6rTVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q8+3InUXjWKHfSDF2abkOO5im/VKyp4v0dj3zjL/VE4CJ+dJ/wt92Gl40uaW4fydc
         fEKmE88Q1zYM0Ld7UCbAMWFV7xRDIFhWkbMP3jvgX2JtE5y0tJF8cABpvZsXPAbzdz
         m7BcrzPPv0wr5poTOOaD8cLtojkjpOogILiAxXrCHUxN2ddB07dCvJuQqDJEWYBCoS
         92ipggXD9fYJkrTvHMKvjNL+p+Hld0xEIA1OQ+fcm9VzcveFd109VZhBHEAygELNGF
         GphOqso/cFAXpRmkbZgnulsqdcAe1aJdJiNmDPXqGAJtAItl3ecMzGzo+CrIBdU29K
         7tgy8aRs8ec6A==
Date:   Thu, 10 Nov 2022 21:23:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 0/2] Handle alternate miss-completions
Message-ID: <20221110212352.7d7d5792@kernel.org>
In-Reply-To: <CAErkTsT8mXJqLGKc8M2Aoz9h6+h=5Zw2L9UGb4KS2Ynp22cqBA@mail.gmail.com>
References: <20221110172800.1228118-1-jeroendb@google.com>
        <CAErkTsT8mXJqLGKc8M2Aoz9h6+h=5Zw2L9UGb4KS2Ynp22cqBA@mail.gmail.com>
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

On Thu, 10 Nov 2022 14:39:39 -0800 Jeroen de Borst wrote:
> I should have prefixed these with 'gve:'. Let me know if I should resend them.

Yes, please.
