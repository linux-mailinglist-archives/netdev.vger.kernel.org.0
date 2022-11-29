Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B5D63B8B4
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiK2DYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiK2DYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:24:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CD147333
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 19:24:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A386154C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E0BC433C1;
        Tue, 29 Nov 2022 03:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669692243;
        bh=vuNpbhrNpRtvmt5ZAIXv3lOZ7sLCuwYHCi+gotMyplA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P/BD+0Z5s5n5Q5S/77HtUPxCh4rqFQg7qPfd4TFZ63F8L5Jb0+Ul8nLaE/9HlI0W/
         XmXvj+7qU0qciVPfJ66VWvrgqgw1xjJBv7kiofAuXcy/aZoi3g59WqMjPRlyNIk7to
         /1SRc5bvddghJh0Up9JXYVmhRsV7AF9r7U+9kn0Nr6rhdVysmMT50hsBx4EaOV+JZ+
         wRdj29XPgab0FV3+uudPksc3kDKcnsRYWIARbjb8Jpj4JKvx1ie1yoHWopiDK5mWhm
         JFXmL4ijrVSa0IzvSTtw5qtWsogZhwmR5K5PyFF8jQW31gYZlaD81AOZXYndAm6TBx
         eLg6WoHjd3AaA==
Date:   Mon, 28 Nov 2022 19:24:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v4 net-next 0/8]: hsr: HSR send/recv fixes
Message-ID: <20221128192401.7e855eaf@kernel.org>
In-Reply-To: <20221125165610.3802446-1-bigeasy@linutronix.de>
References: <20221125165610.3802446-1-bigeasy@linutronix.de>
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

On Fri, 25 Nov 2022 17:56:02 +0100 Sebastian Andrzej Siewior wrote:
> I started playing with HSR and run into a problem. Tested latest
> upstream -rc and noticed more problems. Now it appears to work.
> For testing I have a small three node setup with iperf and ping. While
> iperf doesn't complain ping reports missing packets and duplicates.

Any reason Arvid is not CCed? please always when there's a Fixes tag,
the authors should be CCed.

Please run v5 thru checkpatch there are spelling errors it points out
(and maybe something more).
