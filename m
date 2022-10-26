Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3288060DDB5
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiJZJGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJZJGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:06:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A4E9A9E2;
        Wed, 26 Oct 2022 02:06:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBA3E61DA3;
        Wed, 26 Oct 2022 09:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D56C433D6;
        Wed, 26 Oct 2022 09:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666775202;
        bh=OJvRuXCcGUbboEOk7Whw5rAuR91zEDRn4jEkqbi+aHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqCcQ7ZoY0p0kJ1iG46UxlBE3FBv69P0TzDoyjQ/57SMyKPqS1ilBFnMrACdBWnlM
         200Ib4YEGd8J6zY2p+qVgx2NFpMNBhhdxMQ62eA4tsalRG48tV/se8pDazphsLb3bp
         frZDMESa90mI+ETR0o3PthGeH+Y59aN9d1+j2pTgOfF3SV3+RC9v0DBtesaArdEfVW
         aBC247/J3rMkwu9+DrV9ceUwbKATQtansLvMT2F7LF03ic64keQ6TEQWeHnrFvy3es
         7mUzUOMIo5cmhKOLIY9pv4Q4iyKHv83LCJmST1Mb58EsJAVnqqeJX57inM1qOilafl
         uzVCjiasTtJcA==
Date:   Wed, 26 Oct 2022 12:06:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arnd@arndb.de,
        tsbogend@alpha.franken.de, mpe@ellerman.id.au, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, lukas.bulwahn@gmail.com,
        stephen@networkplumber.org, shayagr@amazon.com, mw@semihalf.com,
        petrm@nvidia.com, wsa+renesas@sang-engineering.com,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next] eth: fealnx: delete the driver for Myson MTD-800
Message-ID: <Y1j4nX3zvIXXx+ab@unreal>
References: <20221025184254.1717982-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025184254.1717982-1-kuba@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 11:42:54AM -0700, Jakub Kicinski wrote:
> The git history for this driver seems to be completely
> automated / tree wide changes. I can't find any boards
> or systems which would use this chip. Google search
> shows pictures of towel warmers and no networking products.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: tsbogend@alpha.franken.de
> CC: mpe@ellerman.id.au
> CC: npiggin@gmail.com
> CC: christophe.leroy@csgroup.eu
> CC: lukas.bulwahn@gmail.com
> CC: arnd@arndb.de
> CC: stephen@networkplumber.org
> CC: shayagr@amazon.com
> CC: leon@kernel.org
> CC: mw@semihalf.com
> CC: petrm@nvidia.com
> CC: wsa+renesas@sang-engineering.com
> CC: linux-mips@vger.kernel.org
> CC: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/mips/configs/mtx1_defconfig      |    1 -
>  arch/powerpc/configs/ppc6xx_defconfig |    1 -
>  drivers/net/ethernet/Kconfig          |   10 -
>  drivers/net/ethernet/Makefile         |    1 -
>  drivers/net/ethernet/fealnx.c         | 1953 -------------------------
>  5 files changed, 1966 deletions(-)
>  delete mode 100644 drivers/net/ethernet/fealnx.c

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
