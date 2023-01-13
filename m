Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1068066A375
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjAMTiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjAMTh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:37:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2058E8A22F
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 11:34:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD919B82184
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0478EC433D2;
        Fri, 13 Jan 2023 19:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673638450;
        bh=0/hA9gqARbpMRLZbrT922yvX4vSg45dKT2X/pYyclWg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hgjY9fBMWGfORaknueC8BDBtr6aj6S3/4GDSOKenukQjOOJRm7mvgekkQSg07RROm
         srFKzR70OHLKHM23kUDLdUHco06EzwAB7/8Ng5hPilVx0DGZx1NV1IH2jAMx0b1wXo
         DJ7cmeUvAN+lGelq6Pmv9toNAGkXPl+g0xb+Pl3Wow8wgaMiMYemSUjD65/nydSWNe
         A799hAhklDP7iqEv0C9EXsCLaSUzfeakGfZeGWus3biDbCKthgIjF0c3GkKfUMHF8k
         ks+ELdZpe3SYocd2ma/vksozmOwTK9DASHVLXJhkvwoArUNih5xidcmaA4RP8jb4EJ
         hg1rYICzOfnXg==
Date:   Fri, 13 Jan 2023 11:34:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] u64_stat: Remove the obsolete fetch_irq()
 variants.
Message-ID: <20230113113409.6af61346@kernel.org>
In-Reply-To: <20230110160738.974085-1-bigeasy@linutronix.de>
References: <20230110160738.974085-1-bigeasy@linutronix.de>
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

On Tue, 10 Jan 2023 17:07:38 +0100 Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> There are no more users of the obsolete interface
> u64_stats_fetch_begin_irq() and u64_stats_fetch_retry_irq().
> 
> Remove the obsolete API.
> 
> [bigeasy: Split out the bits from a larger patch].
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Applied, thanks!
