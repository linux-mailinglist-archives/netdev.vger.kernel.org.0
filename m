Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3650B49E5FA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiA0PZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbiA0PZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:25:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6994DC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 07:25:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 089B261515
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 15:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E596C340EE;
        Thu, 27 Jan 2022 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643297091;
        bh=qHS5Q/7BvjSxIXfvvLIY/w0v7GlftAEtzug+DigJOco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ubxMz7Mj2dLveK/g4f3Gx5KhDB6rxgdZEL2GTBRCtaIq6NocGaZrni+odQzDhSd4X
         7b9XuXc6DUx0KlQVyXDh5uIK6e8v0Y6DmHNopx+BU2if8vt/otG5P9eybUoY1hsPVH
         ae/Y/xIq1E60F48hPB/nQ+4jtQG9KddVG8wFkSrPYdC2LtAtiaVU7x6eSfdvD0D+Rh
         5DULtu60EqyqpOMpJL/xXxMlFLTMGpwHNo3yLF51IcG4NCmny3xJtc/+d2MhmUvklb
         c/hrdeWNzzBWNMbBQjAwKEg5pleXUY+NZqEANvCYvm718VzqHLUPOuPFHLCl2LvgaX
         Uy+hzG24Iuypw==
Date:   Thu, 27 Jan 2022 07:24:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net PATCH 0/9] Fixes for CN10K and CN9xxx platforms
Message-ID: <20220127072450.00143146@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZuqE3z27wq58a=xdRbjEXLfufN7mkVxANgnSqB0EEFnd3Q@mail.gmail.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
        <CALHRZuqE3z27wq58a=xdRbjEXLfufN7mkVxANgnSqB0EEFnd3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 19:02:30 +0530 sundeep subbaraya wrote:
> Hi David and Jakub,
> 
> Any comments on this patchset ?

This appears to be merged to netdev/net as commit 03c82e80ec28 ("Merge
branch 'octeontx2-af-fixes'"), and should be on its way up downstream 
to Linus. Sorry for the lack of notification the patchwork bot must
have had a hiccup.
