Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF074D35CA
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiCIQrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbiCIQqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:46:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BD01017CE;
        Wed,  9 Mar 2022 08:41:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0151CE1F9A;
        Wed,  9 Mar 2022 16:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A9CC340E8;
        Wed,  9 Mar 2022 16:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646844077;
        bh=xOPUR8kyT5h4mXcbguSKn9aiNBRKhddNfJVl1rQy3Vg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aDXk4FmZ3VLlaVY98dcaZ8yqn6OWfbS4aNnlOVznCs6WpL79lfiz06EiuBpiUQeFU
         SgilRZ17aLXtLHllnASrLruAXSP3Ig9deEIchWNp7DnYNCy81LLvvth0Telu4y426l
         uV9nMseH6t0rfH1dkO+M3cUZqI6tmEpvOoPifRJSVEYChYfOY/QHSz+EXiPeyU9BJY
         o+JXapLiJc8uoW+tsyf8ltqFWVOMGhiUdfYxNSfhcaSZ1V000aGWhQiw+4EktMyLqj
         uuBKW+5nYYy2TmwHIH989cLaPjnBrAhnbdzSTP4xukSZK4ls30CoeKVdwTGbqB3RmV
         AeweD7DRYd+yg==
Date:   Wed, 9 Mar 2022 08:41:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Fabio Estevam <festevam@gmail.com>, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, fntoth@gmail.com,
        martyn.welch@collabora.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, marex@denx.de,
        Fabio Estevam <festevam@denx.de>
Subject: Re: (EXT) [PATCH v2 net] smsc95xx: Ignore -ENODEV errors when
 device is unplugged
Message-ID: <20220309084115.05321305@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <12992128.uLZWGnKmhe@steina-w>
References: <20220305204720.2978554-1-festevam@gmail.com>
        <12992128.uLZWGnKmhe@steina-w>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 09 Mar 2022 15:02:21 +0100 Alexander Stein wrote:
> > Fixes: a049a30fc27c ("net: usb: Correct PHY handling of smsc95xx")
> > Signed-off-by: Fabio Estevam <festevam@denx.de>  
> 
> Oh BTW, is this queued for stable? Which versions? If 'Fixes: a049a30fc27c 
> ("net: usb: Correct PHY handling of smsc95xx")' is the indicator, it's not 
> enough. This errors also shows up on v5.15.27 and is fixed with this patch.

The stable machinery will most likely suck it in automatically.
The patch should reach Linus tomorrow evening if you want to ping 
Greg and make sure.
