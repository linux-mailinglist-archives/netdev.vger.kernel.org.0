Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B346E10CD
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDMPQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjDMPQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:16:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206011B7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1FC363F90
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 15:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9115C433D2;
        Thu, 13 Apr 2023 15:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681399012;
        bh=meLXTD4Ni7vQbzDIuzZQsy+c0Zr4oMsFvn2FDWppdCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=El0L7ma3NYsiap2+9Pd7j5e/MX9OkCpuyXhxAcWNb3bjKbLHu3c+3WU7eaBLygiLU
         WXoro64mIEfemxpdLbM0OAEJzMsBxV7qnQ3nmOzm3QulY1cT4Ul7GYubdcmh+I+vvQ
         5UlfOZ7atRM2SpjKEtDl/9+mAGe4EFnIA7LuLeF4ZR47+ly0AzYBxFhDKPwqmJF3W6
         yehhc7RvJqs8hiAtOM4Sre6Xmz2T+Pg4jXhCO+6CdOObar8b0lM1rRl9hJGm7OH+js
         WM0yUxFzNRunCnvr3SrGa194CZm9suxEGpfgdmS92IPUuaLdB3VmEF/nyv6k6coDIy
         eICQeC/j+w75g==
Date:   Thu, 13 Apr 2023 08:16:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v1 1/1] add support for Ethernet PSE and PD
 devices
Message-ID: <20230413081651.1e31333b@kernel.org>
In-Reply-To: <20230413-valium-retreat-c5e7f29ebab6-mkl@pengutronix.de>
References: <20230317093024.1051999-1-o.rempel@pengutronix.de>
        <20230413-valium-retreat-c5e7f29ebab6-mkl@pengutronix.de>
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

On Thu, 13 Apr 2023 11:31:24 +0200 Marc Kleine-Budde wrote:
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>  
> 
> Soft Ping. Can anyone take a look at this?

You should probably To: Michal if you want him to take a look.
Let me do it for you...
