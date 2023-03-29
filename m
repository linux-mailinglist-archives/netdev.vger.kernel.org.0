Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865D56CD80C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjC2LCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2LCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8861BC6
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:02:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38C6F60C5B
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BE4C433D2;
        Wed, 29 Mar 2023 11:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680087768;
        bh=SzMnZMEIZXDrvhjme+WED+cf8vKrn55d+BsCld4CNqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XEDbRc5iEQFJJLYrPqz8+HnOctWqNfddSIpJBOmkcYr0jNsdx2zatzhy9HRiKkP1U
         MhTozlrHORNZGcqrkT8WoS+BQsrKXsFQwNqSo8Cu4SV/TXUPPsmRo7WV0UEm1gRz4P
         cSWIVFGMWX0Yf1TF/iAK5mxqe4vjU87bO5U/VG2eNH8sCEGco5UpUiBRjiTQC0Ii53
         mw9UVIcTjrZ1wE/2DmZUTSHAoRIviB+MJvSW7VZIktrUSHsbZIZce53FDikwDfM12O
         SQsibwt2yI0SSFWIrBiNkPfSmU3Fs7d8jqzIZrnOFwfXp7quEYQQazDblzHbh4usym
         8hQyGQVgfqaVg==
Date:   Wed, 29 Mar 2023 14:02:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net,
        maxime.chevallier@bootlin.com, pabeni@redhat.com
Subject: Re: [PATCH v3 3/3] net: mvpp2: parser fix PPPoE
Message-ID: <20230329110243.GL831478@unreal>
References: <20230325164105.uehseyxftzbdbppr@Svens-MacBookPro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325164105.uehseyxftzbdbppr@Svens-MacBookPro.local>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 05:41:05PM +0100, Sven Auhagen wrote:
> In PPPoE add all IPv4 header option length to the parser
> and adjust the L3 and L4 offset accordingly.
> Currently the L4 match does not work with PPPoE and
> all packets are matched as L3 IP4 OPT.
> 
> Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
> 
> Change from v2:
> 	* Formal fixes
> 
> Change from v1:
> 	* Added the fixes tag

Please add target [PATCH net ...] to the subject the patch.

Thanks
