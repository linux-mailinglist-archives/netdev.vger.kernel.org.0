Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172A66B192B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCICZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCICZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:25:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879FABE5CF
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 18:25:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8211B619F3
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 02:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B378C433D2;
        Thu,  9 Mar 2023 02:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678328724;
        bh=52RlaBwr/I7UR/P8LyGBEdlckRATaR041hekgpmniQI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OdADgQGVgaEWtowViN4KytbNDqZCcpDVWRO660hmJS9qiGZLIClsZvE27NFaElceS
         VUYKXsNOCJ3YVWnc2hOcgj3l9+oGg1VcapRhom4O3f1mS71AJ4cE7VNVUjBnIlRkEf
         ifB3EQAosk/c0zL2JOvd5p45dZozM7VXF8JzWVfq59KGtjhoJVBGe+8bF+JMDtiWNx
         srfQoGcxsgfURskC6uFCP6f1Q7QFanKjHscaU2f4erF1jQpSjsBUEUAIKr4bhgphJD
         cwxmHwKIyE6x0x8BG8Foa7v2n78ylI+7gMM0xF7QGj1V+tvWF81Mea3xiA8zZS+/G8
         ybOCKsr1TybGA==
Date:   Wed, 8 Mar 2023 18:25:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [net-next] ptp_ocp: add force_irq to xilinx_spi configuration
Message-ID: <20230308182523.42c00e3b@kernel.org>
In-Reply-To: <520eb192-8b56-dde1-1b37-494a0d4d14b6@linux.dev>
References: <20230306155726.4035925-1-vadfed@meta.com>
        <20230306124952.1b86d165@kernel.org>
        <2c9e80b1-3afc-9b78-755b-222da349212f@linux.dev>
        <20230306132013.6b05411e@kernel.org>
        <20230306132200.15d2dbfb@kernel.org>
        <520eb192-8b56-dde1-1b37-494a0d4d14b6@linux.dev>
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

On Wed, 8 Mar 2023 19:01:22 +0000 Vadim Fedorenko wrote:
> On 06/03/2023 21:22, Jakub Kicinski wrote:
> > On Mon, 6 Mar 2023 13:20:13 -0800 Jakub Kicinski wrote:  
> >> Hm, you're right. Any idea why both kbuild bot and our own CI think
> >> this doesn't build, then?  
> > 
> > Probably because they both use master :S
> > 
> > kernel test robot folks, could you please switch from master to main
> > as the base for networking patches?  
> 
> Should I re-send it? It's marked as Deffered and is not going forward...

Yes, please, not sure why it's Deferred so let's do a resend.
