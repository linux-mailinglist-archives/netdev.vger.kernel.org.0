Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950B163C4B2
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiK2QJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiK2QJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:09:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728FE2670
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:09:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 195BC617AE
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 16:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270B4C433D7;
        Tue, 29 Nov 2022 16:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669738164;
        bh=B3cSwV7akq0imKUOcq8q26OA8bQ4SiDePLRs1fpwRXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d8tyIadVg8GWgmstPAxrI/emNH4iGwjty9SMFOvSP69YRME6BQIZhApGAwGyVRbQb
         mw5J4jj7Uu8hIbu6J3hpqT05aXrbSh+ACGUB9x9PSzyia4RjkdzOxkABhWUtm9uNd7
         TxkzKk1FUf66iXqOA2TsJXUDuQEfqRX4CW6TYydDvDs5xiv+OMXsD9EwPyBJGeGj+R
         z4EtshBUmEpxBdhhwb8g5SK96Ny0jKiTygEyQdn97/1xe55I2FYl1ETUHf3zVsyVZR
         ytfwcEz/TXZ3TKQDjKz3hl0Q5qXReNBg0M9GE9xZLeReuVvzMnAzEud6UfN4NH7Mg3
         xRsf84mH5pgfQ==
Date:   Tue, 29 Nov 2022 08:09:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v4 net-next 0/8]: hsr: HSR send/recv fixes
Message-ID: <20221129080923.549d3542@kernel.org>
In-Reply-To: <Y4Wy8ix3uZs07RIw@linutronix.de>
References: <20221125165610.3802446-1-bigeasy@linutronix.de>
        <20221128192401.7e855eaf@kernel.org>
        <Y4Wy8ix3uZs07RIw@linutronix.de>
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

On Tue, 29 Nov 2022 08:21:22 +0100 Sebastian Andrzej Siewior wrote:
> As per commit
>    e8d5bb4dfaa72 ("MAINTAINERS: Orphan HSR network protocol")
> 
> that email bounces. So not added because that email
> (arvid.brodin@alten.se) won't reach him. Is there another one I missed?

I see, thanks, let me add the addr to my local email graveyard.
