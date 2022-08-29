Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A6B5A4C00
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiH2Mf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiH2Mfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:35:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEBF72EDD
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72C8C6113E
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 12:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FE6C433C1;
        Mon, 29 Aug 2022 12:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661775524;
        bh=8rgL+Gyhi/dvXx6tyId7k/0lsOPBUanu+XWFHRQQD3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecCiNdfRpc2ADtVCRe+YBvsFKtzwRoHhwB0F96tN112fDdCHAunhZHGGwvzmHcGz6
         86JPz5Y08319lmEubrMXF3u9bGV2O6U67K7eb+jPVZvSMD0rNLKvsdQSn/zkuYGI39
         limlGXOxQrVEzFiglfLa1IMw+xlBxSsauFeXjSg9CL5oCaKVK8/Sdu5E2KzLGwet2s
         QUL845IQ2Z6FW+o7dyxGyYMS7ZCcWMDaXweKosuwMnOZ4qnnUn3TZa0mhblf1K+Ewq
         T0RKDvtfuRLWTfKidyOOQZI1Lb5RB4spS1h8FtnMQgAOc7mCmWJWDs+KgabaQ7F2XB
         zlmDO2uQtKFUQ==
Date:   Mon, 29 Aug 2022 15:18:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org, maord@nvidia.com, saeedm@nvidia.com,
        roid@nvidia.com, jiri@nvidia.com
Subject: Re: [PATCH net-next] Revert "net: devlink: add RNLT lock assertion
 to devlink_compat_switch_id_get()"
Message-ID: <YwyuoJI08MVhX2YX@unreal>
References: <20220829121324.3980376-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829121324.3980376-1-vladbu@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 02:13:24PM +0200, Vlad Buslov wrote:
> This reverts commit 6005a8aecee8afeba826295321a612ab485c230e.
> 
> The assertion was intentionally removed in commit 043b8413e8c0 ("net:
> devlink: remove redundant rtnl lock assert") and, contrary what is
> described in the commit message, the comment reflects that: "Caller must
> hold RTNL mutex or reference to dev...".
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> ---
>  net/core/devlink.c | 2 --
>  1 file changed, 2 deletions(-)
> 

Thanks,
Tested-by: Leon Romanovsky <leonro@nvidia.com>
