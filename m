Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B156A6AD016
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjCFVWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCFVWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:22:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567E934009
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00876B810CF
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 21:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF34C433EF;
        Mon,  6 Mar 2023 21:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678137721;
        bh=sNUN6mv6OVkNAUvHC/bzRD0kzE4DwOJ57Mk1N3ODLL0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aJ8zXjAIOjF+oKiD9Dgra5oWalpktKCt/hsZqPleQdcGPufGq2zWlT0PM6teYOLY5
         u8pw5Si1RD4eAEsYD4YxCtHHlPO2jewgk2n5R4AH9rlbPitNY/Pk3NaNxFOoQGyO+l
         vtBuzRTSqlaZohE+ARmwCYHXqgmowxTrvHJ79PHTlig6kr/+kdmHmQL1IC3YqplkXb
         8HcHA5jaRg19QyKhABGjopSG/q0cKM/gBleZ+80U50mEKXYkq/iOc7e0uyA4BzGqe8
         cdGXfJicpdiAT6DxnMXdvbWarlB8dM+uLHjmHi7gOwLo6XuCPfJLT8YGcXYxIkH0Wa
         hGy7X/F4KEMDw==
Date:   Mon, 6 Mar 2023 13:22:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [net-next] ptp_ocp: add force_irq to xilinx_spi configuration
Message-ID: <20230306132200.15d2dbfb@kernel.org>
In-Reply-To: <20230306132013.6b05411e@kernel.org>
References: <20230306155726.4035925-1-vadfed@meta.com>
        <20230306124952.1b86d165@kernel.org>
        <2c9e80b1-3afc-9b78-755b-222da349212f@linux.dev>
        <20230306132013.6b05411e@kernel.org>
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

On Mon, 6 Mar 2023 13:20:13 -0800 Jakub Kicinski wrote:
> On Mon, 6 Mar 2023 21:10:40 +0000 Vadim Fedorenko wrote:
> > On 06.03.2023 20:49, Jakub Kicinski wrote:  
> > > Give it until Friday, the patch needs to be in the networking trees
> > > (our PR cadence during the merge window is less regular than outside
> > > it).    
> > 
> > Looks like "1dd46599f83a spi: xilinx: add force_irq for QSPI mode" is in net and 
> > net-next trees already? Or which patch are you talking about?  
> 
> Hm, you're right. Any idea why both kbuild bot and our own CI think
> this doesn't build, then?

Probably because they both use master :S

kernel test robot folks, could you please switch from master to main
as the base for networking patches?
