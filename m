Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B884A7633
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbiBBQuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 11:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiBBQuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 11:50:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572B0C061714;
        Wed,  2 Feb 2022 08:50:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCBDCB83070;
        Wed,  2 Feb 2022 16:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288B0C004E1;
        Wed,  2 Feb 2022 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643820605;
        bh=pxXu2ynzPoiOfEerDr52wzyi9BNpwwM+EF62flPgRfg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Khcvk7Q2Zs+Fezw3FoOrXz/TlTkaH1YJt6dBa5JIhvS6krK3EXFvl15SYY5mLEVno
         3Ap+XeIRQu7q+NdlVXkWjZclYxwiywfIXVDLrOjsFLGzdcltCmaLg+qZ+AojcEb1c/
         JzQzVwdABxi2cfeOfhIiYMiYj2aliqcishBLFK8qzfDAKvlPR46bWV4RXW4DCNP3tI
         vmHshDn2X30JLWf5iyJQNfhGfJZtEuLXQTBUFjVWDmSo9bP+f2nx4IZPlHcYZI6UNj
         jtwHZfLbOrphw3isJB7KaJ6Vif8zaelWksJ1yUxFeErmSKFj/S0piod2CDLDjG/r0o
         bLiSRYhQRH07g==
Date:   Wed, 2 Feb 2022 08:50:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <20220202085004.6bab2fe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220202122848.647635-4-bigeasy@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
        <20220202122848.647635-4-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Feb 2022 13:28:47 +0100 Sebastian Andrzej Siewior wrote:
> so they can be removed once they are no more users left.

Any plans for doing the cleanup? 
