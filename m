Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494314DBD0A
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354401AbiCQCds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345141AbiCQCdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:33:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D9E1FA55;
        Wed, 16 Mar 2022 19:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74C54B81DD5;
        Thu, 17 Mar 2022 02:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9699C340E9;
        Thu, 17 Mar 2022 02:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484350;
        bh=y9kA9fR+nB2fSNtZoY6laFEBg+/BJtd2Tcb6EeiZPW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PZXKCiFS23ahgZk4PCEs30fuMEJ9Z9V61W7ZJbUwLyenN3Xr8p45YdS7Aet5w9qpw
         GBOQdQPfVvuOMS+5yxd1Nz1xcmJ/986oRyCOeZ2JhZqnkFWS+t8AEE9lZ/SDty2BUW
         z738Y1fOfKq5KqXVegVGX+jDqN3h8E2mJFww5CEUPBr5CtHs7iSpVK3ymaffNEzs6b
         HcisQ2oBCwJKO6qQSlAoTEMBzl+7zgXDlbISLhZzN7j3ASZwYfc2EIeT3LjSvzoPpp
         tN8y/HvpXrGPqE+1LB+KEnkw9xqXxvgS+FtE9kuGSRahIQnJqlaAAOb5dlK3gkZhZ5
         66aJBILjF4lKA==
Date:   Wed, 16 Mar 2022 19:32:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH V2] net: mv643xx_eth: undo some opreations in
 mv643xx_eth_probe
Message-ID: <20220316193228.4966348c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316012444.2126070-1-chi.minghao@zte.com.cn>
References: <20220316012444.2126070-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 01:24:44 +0000 cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Cannot directly return platform_get_irq return irq, there
> are operations that need to be undone.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>

Pretty sure I reported this :/ Fixes tag would be nice as well.
Let me fix those two issues and apply. 
Inhale, exhale.

> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
