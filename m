Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5A56AD012
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjCFVUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCFVUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:20:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3E3273B
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BBD560BC9
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 21:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48B2C433EF;
        Mon,  6 Mar 2023 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678137614;
        bh=b4VKEhW9/IGup+pnnU0dDWI563SCS1WgDNgy3yOLOiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=deld26o+WSCK9czLDPVuKcHGG6kfFDUcJQRWdm5G8zwmEQgReZea8p5KJeLlI1iau
         Sk9ksyFh5jtnl6SLnSFY18RmP4ltJ5Q6fBgVJm5VHRbRKsw4AeNGf9/97B4ATTHaQy
         xECsJakdLzyc6/0BYrP1gVVyDFOI4ODeK7Vsf4p+wvxaOomo2hZiGcn0aYj9tALMIA
         7IGRToMKVlAEX9MwiBqrYt72bcqku5lGYX4eKN/B2xJgal+CCjNzbsXNZ4cAceDOVR
         vuWR2Ybxe4L437qLdB2zW++wZBb1P4yYUMtWH5GdxAk21Jc7xnDqIwhplARZYpDsTx
         5riMoXMhLjULw==
Date:   Mon, 6 Mar 2023 13:20:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [net-next] ptp_ocp: add force_irq to xilinx_spi configuration
Message-ID: <20230306132013.6b05411e@kernel.org>
In-Reply-To: <2c9e80b1-3afc-9b78-755b-222da349212f@linux.dev>
References: <20230306155726.4035925-1-vadfed@meta.com>
        <20230306124952.1b86d165@kernel.org>
        <2c9e80b1-3afc-9b78-755b-222da349212f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Mar 2023 21:10:40 +0000 Vadim Fedorenko wrote:
> On 06.03.2023 20:49, Jakub Kicinski wrote:
> > On Mon, 6 Mar 2023 07:57:26 -0800 Vadim Fedorenko wrote:  
> >> Flashing firmware via devlink flash was failing on PTP OCP devices
> >> because it is using Quad SPI mode, but the driver was not properly
> >> behaving. With force_irq flag landed it now can be fixed.
> >>
> >> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>  
> > 
> > Give it until Friday, the patch needs to be in the networking trees
> > (our PR cadence during the merge window is less regular than outside
> > it).  
> 
> Looks like "1dd46599f83a spi: xilinx: add force_irq for QSPI mode" is in net and 
> net-next trees already? Or which patch are you talking about?

Hm, you're right. Any idea why both kbuild bot and our own CI think
this doesn't build, then?
