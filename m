Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D7F57261B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiGLTly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbiGLTle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:41:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44E04F654;
        Tue, 12 Jul 2022 12:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADB18B81AF2;
        Tue, 12 Jul 2022 19:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EF9C3411C;
        Tue, 12 Jul 2022 19:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657653540;
        bh=pPDNX247TR5GC+wlQted2L7PrtEmzXRELQHL1i77OPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QGRqW3QTdbhpBVtYBFTVkuZCGGteSYIsa7Jjr9qjrZEUF/4SYZpytrmSsS6Qzzsvc
         V8d8zHAfUtJv/ClB0oRzWjgvrSFt5p5YNYL73FeZ1bhOq4O3QELD26zxKqNuD7gFfH
         9UjNHsL2zCxdGfWiM9LXwaIlnvxIeuWqklK/d8fY=
Date:   Tue, 12 Jul 2022 21:18:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH stable 4.14 v3] net: dsa: bcm_sf2: force pause link
 settings
Message-ID: <Ys3JIVVpKvEts/Am@kroah.com>
References: <20220708001405.1743251-1-f.fainelli@gmail.com>
 <20220708001405.1743251-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708001405.1743251-2-f.fainelli@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 05:14:05PM -0700, Florian Fainelli wrote:
> From: Doug Berger <opendmb@gmail.com>
> 
> commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream
> 
> The pause settings reported by the PHY should also be applied to the
> GMII port status override otherwise the switch will not generate pause
> frames towards the link partner despite the advertisement saying
> otherwise.
> 
> Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Changes in v3:
> 
> - gate the flow control enabling to links that are auto-negotiated and
>   in full duplex
> 

Are these versions better / ok now?

thanks,

greg k-h
