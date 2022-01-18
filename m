Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA85492C18
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 18:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347118AbiARRP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 12:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347121AbiARRPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 12:15:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F35C061574;
        Tue, 18 Jan 2022 09:15:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9C57B8170A;
        Tue, 18 Jan 2022 17:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AABC340E0;
        Tue, 18 Jan 2022 17:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642526152;
        bh=JN6V4ugw7NK4GTjm0AAcpeChxTI+dmoqh1YbGTFrRZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iCL6YV2aonl9dnD61DfDf/6Bn736K8gKspoHwblgh/cJi3eca8uVN0ig4IUod5XAY
         s7wejLwp8ChN7rpUQuHvsKtHGJzQZ+luWWEMdeAsAKHSg8yj2sWv06VNWENP8YjwsZ
         xpAO8vym+6oe5E8rDxkfMm+Q/KmwGPU9pIMTXbu37tcyvKXUie3BYKjacxpyohWglH
         5atjL2t2yt1hyNqxIT80dtxBcdXskq84o7doWvXS2IAf8rf0EMxFln3O68YyIEj6c1
         8pIBr5ku5VW70Mr1SKXqvFIx4j/vLcMPtLqDcCq4J8EKFFgvMFwyNDji3aWsYhJNSk
         RhlXQOVmoO7/A==
Date:   Tue, 18 Jan 2022 09:15:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com, Minghao Chi <chi.minghao@zte.com.cn>
Cc:     Richard Cochran <richardcochran@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] drivers/net/phy/dp83640: remove unneeded val variable
Message-ID: <20220118091551.7aa44124@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118151904.GA31192@hoboy.vegasvil.org>
References: <20220118075438.925768-1-chi.minghao@zte.com.cn>
        <20220118151904.GA31192@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 07:19:04 -0800 Richard Cochran wrote:
> On Tue, Jan 18, 2022 at 07:54:38AM +0000, cgel.zte@gmail.com wrote:
> > From: Minghao Chi <chi.minghao@zte.com.cn>
> > 
> > Return value from phy_read() directly instead
> > of taking this in another redundant variable.  
> 
> NAK this is purely cosmetic and not clearly better WRT CodingStyle.
>  
> > Reported-by: Zeal Robot <zealci@zte.com.cn>  
> 
> Please make your robot less zealous or filter its results before
> posting.

Plus what does it mean that the bot has signed this off?

> > Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>

> This is the second time I told you.  It isn't wise to ignore feedback,
> and it is also rude.

Same, you don't reply to emails and keep making the same mistakes.

I asked you to realign the continuation lines in:
https://lore.kernel.org/all/20220112083942.391fd0d7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net/
And without replying you just posted:
https://lore.kernel.org/all/20220118075159.925542-1-chi.minghao@zte.com.cn/
