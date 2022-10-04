Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5398A5F4A60
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 22:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJDUg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 16:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiJDUg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 16:36:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432A26BD5F;
        Tue,  4 Oct 2022 13:36:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D263C61505;
        Tue,  4 Oct 2022 20:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A59C433D6;
        Tue,  4 Oct 2022 20:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664915772;
        bh=CpAULTDBl27s8/bpX6JYwROiwvQeL8qEIQiP8tA4nGM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DIFOEbyfQcTA3n5kqt5ZKpFDyNR+y9P/OSm8i+VGwBJsjvW1lmCwkmUyKcaPmVtxC
         7vMbSGZ0P2/y5OLXuAPTjYEnj0BAXUWCxybF7f13O0J3Xgj3NRW2bqzku0qduxXzmZ
         AgvP7wsrX9eerhFUqioSxADtAmqlgxsLdo+nd8ed2fXf/XSjrZz/j2srlkiAvkTNR6
         Bynl3De9DUP77dvNciAc1XBtBXAFGnvmR2M3YXGggRAY8yN51JBLM1TmIXVLIrDPDy
         VWW0bAAi17ySmZvgacRM6+T8QQMn9aZop2me8dQRfeTEaNux0ShaHTBrr2jXsynnIg
         TDIuR2+HHRXZg==
Date:   Tue, 4 Oct 2022 13:36:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Divya.Koppera@microchip.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net] net: phy: micrel: Fixes FIELD_GET assertion
Message-ID: <20221004133611.0f4de477@kernel.org>
In-Reply-To: <CO1PR11MB4771D917426DB1DCDB5B50D0E25A9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20221003063130.17782-1-Divya.Koppera@microchip.com>
        <20221003170845.1fec4353@kernel.org>
        <CO1PR11MB4771D917426DB1DCDB5B50D0E25A9@CO1PR11MB4771.namprd11.prod.outlook.com>
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

On Tue, 4 Oct 2022 06:28:44 +0000 Divya.Koppera@microchip.com wrote:
> > Does not apply cleanly to net, please rebase & resend.  
> 
> I generated patch on net-next, as it is fix I kept for net. When I
> tried to apply these changes on net, this is getting failed as this
> main patch(21b688dabecb6a) did not go in net. Shall I resend patch
> for net-next?

Maybe wait a day or two and rebase + resend in two day or so, we're
waiting to Linus to pull net-next after which point the trees will get
forwarded to the same point.
