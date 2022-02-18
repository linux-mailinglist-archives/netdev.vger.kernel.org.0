Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B734BB097
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiBRESw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:18:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiBRESv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:18:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F92E0A3E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 20:18:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93828B82555
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D815DC340E9;
        Fri, 18 Feb 2022 04:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645157912;
        bh=XCzYvmZRZh42QLcEvMA3LaL7CTlBJceGJR1CnNnnU98=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JDablLuidvfUkTFJmnSbSXbyCVm2m6bQXifnh0W8CYpuBGsdilzPbF/2YDNyXqKUv
         dmGnSwJHSQ7vvPNwAV+Gt6LL9hEvzNBd/D/mzTY0aHJG0nX+2jzG83ifJVGF2BLkg/
         To5BBEMMIAfT5vVC2DiSNNytEzYDi21874X/KxuLtelXk79pq7Fx1itfNaiKxueGMI
         JVlr3kCAWFHS1fJxoTh8LtSeWqQE66gGxLOCxD+EMy7P6ncHKpSK90Q+czB10MB3OB
         dPnyvH7lqTwBIJgWy4dcnHGLXFcxWUmLiWrLyBVtCPVoD2GsB/qbsNZp5xID69JVyN
         TQsYzafAHDZ2w==
Date:   Thu, 17 Feb 2022 20:18:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Casper Andersson <casper@casan.se>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sparx5: Support offloading of bridge port
 flooding flags
Message-ID: <20220217201830.51419e5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217144534.sqntzdjltzvxslqo@wse-c0155>
References: <20220217144534.sqntzdjltzvxslqo@wse-c0155>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 14:45:38 +0000 Casper Andersson wrote:

Can others see this patch? My email client apparently does not have
enough PGP support enabled. I'm worried I'm not the only one. That said
lore and patchwork seem to have gotten it just fine:

https://lore.kernel.org/all/20220217144534.sqntzdjltzvxslqo@wse-c0155/
https://patchwork.kernel.org/project/netdevbpf/patch/20220217144534.sqntzdjltzvxslqo@wse-c0155/
