Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5521256C398
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbiGHWRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 18:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiGHWRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 18:17:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D2EA2E40
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 15:17:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AF7CB829A0
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 22:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CD5C341C0;
        Fri,  8 Jul 2022 22:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657318638;
        bh=mFWkGVYP29dWVlA/4xEcmxGedu2bxslf6EQbx+M+6Dg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mI1+LzQ8PJhAnm2FHJzjf9XnaJcGHghs0osjCc1pcr2vir77AsCvCTVhL86ZuVzQZ
         XRzRPOFq/jZiuzwjgkEBOl29ur6aEnSkNirq3kiiuks2su9wQTx5cnUmak6LDIk3hB
         ChZyLMcLasxkXKSpAWrUAT70HyruiX3dj7D6Tr8ZTFisok7lPC+YlfFpxhvC5EK8CD
         /kK1tVlRgmgOAB927u6HjVHAftSDiweH9bg0uOjr1Xpg0Z0o/0A7d0RvH94sRPzPUh
         Uwv4BWmvPL9fS+3/9lASw+l9txVUWC6M8qzvf5hL5rdSvd082CZJvcOXO37Vh9q5P6
         QJvII9CSNTeNw==
Date:   Fri, 8 Jul 2022 15:17:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next v3 0/3] net: devlink: devl_* cosmetic fixes
Message-ID: <20220708151717.4fe3487d@kernel.org>
In-Reply-To: <20220708074808.2191479-1-jiri@resnulli.us>
References: <20220708074808.2191479-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jul 2022 09:48:02 +0200 Jiri Pirko wrote:
> Hi. This patches just fixes some small cosmetic issues of devl_* related
> functions which I found on the way.

This version does not apply but lgtm:

Acked-by: Jakub Kicinski <kuba@kernel.org>
