Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B646141EB
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 00:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiJaXlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 19:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJaXlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 19:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C032115706;
        Mon, 31 Oct 2022 16:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ECB9614EB;
        Mon, 31 Oct 2022 23:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5521CC433C1;
        Mon, 31 Oct 2022 23:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667259668;
        bh=fF5fmsmBw8x107hSFOrswTvOSdyCrOqAoWXWsPQMdPo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ilSMv0IFr0PfMeN4M5vMhFx1hzhAMS3cxTL1vZoDWg8eQbrE9xuy8gP4BSPcTuRTi
         TXv91lug6CSBp5uSBzXv2rsBZHmsLAZMIDjA/pu5AWgC5MJnuZYwCiS7ndZo6y62h6
         +nKOHmk8UJtjCpoBB9xKfZ+gTknkSo3i7y0gCR0eU+2AeNNeRWCAO1yyp8CDRLuDHb
         U2PJJojYml1Ti6ncDjR5qKrZ5rniRJoRL3LAftkF3kXT/Sr0wnl2dcgNeC6G44Bf+b
         yPftc/WrzItESqfyoprFZcvFxRy1mteAMeEh6gLD9/2SqMur9Yy79QXIP5qMVNKH/L
         M3dWyG3wMGiYQ==
Date:   Mon, 31 Oct 2022 16:41:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <Bryan.Whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next V4] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <20221031164107.1a2e8090@kernel.org>
In-Reply-To: <20221031065336.GB8441@raju-project-pc>
References: <20221018061425.3400-1-Raju.Lakkaraju@microchip.com>
        <20221019164344.52cf16dd@kernel.org>
        <20221031065336.GB8441@raju-project-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Oct 2022 12:23:36 +0530 Raju Lakkaraju wrote:
> > You can then read the values in a loop. And inside that loop you can
> > handle errors (perhaps avoiding the need for lan743x_sgmii_dump_read()
> > which seems rather unnecessary as lan743x_sgmii_read() already prints
> > errors).
> > 
> > FWIW I like Andrew's suggestion from v3 to use version as a bitfield, too.  
> 
> I will implement Andrew's suggestion in my next regdump function patch.
> Is it OK ?

SG, thanks!
