Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F60B4F452F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350689AbiDEUC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457633AbiDEQWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:22:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8823366FA4;
        Tue,  5 Apr 2022 09:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 242656181D;
        Tue,  5 Apr 2022 16:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7BDC385A0;
        Tue,  5 Apr 2022 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649175647;
        bh=HeFS7lEAWZqOwBk9QGxbfXzbnQohh/dOySuSdkYeJ2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YkK+L2CHvDG+MpJnr4NtEJT6GXQT49oMpvk9f3EO/SOMI8HOUBJZVYQxh1NfaN/KS
         dsL4dpf7Is/fDx7mz6qfLycZH/CsKvO1bQZYo8qlXPvBoBWv7smYddYteBzdB5O+La
         XRHXXPlKqPw0Uiqg7iII4sRmrs1gbzrPbB6TLAXio+2EOoZH/sZBg9LydmI0NXqFCX
         gmrAEZUmwj+imCb4oqkea27jm01Hven5RFZ6dLmKFLhoT5J9vjCWVdHArmmnfqYsPh
         UU9sGY8uEBDg4LfcyuNSItLPEvMaNsZ+iXw3vWFOvSFVyFc/e1eEpuU0CW5Q+9zMVB
         x2A++9nRvvV6w==
Date:   Tue, 5 Apr 2022 09:20:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
Message-ID: <20220405092046.465ff7e5@kernel.org>
In-Reply-To: <878rskrod1.fsf@kernel.org>
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
        <YhojjHGp4EfsTpnG@kroah.com>
        <87wnhhsr9m.fsf@kernel.org>
        <5830958.DvuYhMxLoT@pc-42>
        <878rslt975.fsf@tynnyri.adurom.net>
        <20220404232247.01cc6567@kernel.org>
        <20220404232930.05dd49cf@kernel.org>
        <878rskrod1.fsf@kernel.org>
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

On Tue, 05 Apr 2022 10:16:58 +0300 Kalle Valo wrote:
> Sure, that would technically work. But I just think it's cleaner to use
> -rc1 (or later) as the baseline for an immutable branch. If the baseline
> is an arbitrary commit somewhere within merge windows commits, it's more
> work for everyone to verify the branch is suitable.
> 
> Also in general I would also prefer to base -next trees to -rc1 or newer
> to make the bisect cleaner. The less we need to test kernels from the
> merge window (ie. commits after the final release and before -rc1) the
> better.
> 
> But this is just a small wish from me, I fully understand that it might
> be too much changes to your process. Wanted to point out this anyway.

Forwarded!
