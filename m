Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E99D607BED
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiJUQQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiJUQQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:16:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3AA1EEA0A
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 09:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F61ECE2B2B
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 16:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695A3C433C1;
        Fri, 21 Oct 2022 16:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666368979;
        bh=PhTVzvhDsbX8CVXgqzHXLC8WT3HlIoqmjyPdhVBnK84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tGGs45+5P4WWO6BscED/q2R/zfiKal4CAeLe1GGPQDDa8udTa8C5c1kvmpIajlK9i
         bBMRy4Q+4OWQq0AKd37XrvYLpmD4S76aqOiLkdbaTLKb3w/X/ILwy/dUIagUr1Wq9t
         /7V5vv/rKPB2Q5p90wPxtNGAoueYEygsfRDeP75dfCv2P1wkrYQu3DbocVzPzsdBM0
         oDx6a19TTCwku41lofZAtja3ae9fh3Wjw2feP1CpNWSnDSAscmSo/6SncRlDI/5eny
         OsMgTyoGSO5I7xXwpQPsPgxZRyi/P4w75GPmuHKpT+Hr1F2unNxCu2aEaKasFE1ZmP
         XxJqTZwwPMLTw==
Date:   Fri, 21 Oct 2022 09:16:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] net: sfp: get rid of DM7052 hack when
 enabling high power
Message-ID: <20221021091618.30c27249@kernel.org>
In-Reply-To: <Y1LAVAUSQJrmO+63@lunn.ch>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
        <E1ol98G-00EDT1-Q6@rmk-PC.armlinux.org.uk>
        <Y1LAVAUSQJrmO+63@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 17:52:52 +0200 Andrew Lunn wrote:
> On Wed, Oct 19, 2022 at 02:29:16PM +0100, Russell King (Oracle) wrote:
> > Since we no longer mis-detect high-power mode with the DM7052 module,
> > we no longer need the hack in sfp_module_enable_high_power(), and can
> > now switch this to use sfp_modify_u8().
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

FWIW there is a v2 of this, somewhat mis-subjected (pw-bot's
auto-Superseding logic missed it for example):
https://lore.kernel.org/all/E1oltef-00Fwwz-3t@rmk-PC.armlinux.org.uk/
