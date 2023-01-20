Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CFA674CB5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjATFsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjATFsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:48:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A43F17CF9;
        Thu, 19 Jan 2023 21:48:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F71561DF2;
        Fri, 20 Jan 2023 05:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33819C433D2;
        Fri, 20 Jan 2023 05:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674193681;
        bh=xsZyDNfp8xKqmDnOdFjDtZjXdI+0DJE9t61UePFMT00=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oc+UkmGQaR+feradrF1FzV9Yfgo/6WuM9QeBWkHfXbnpVLcPV3VABvs4/dmsr0pF0
         xWzul0tW6PPdi1FoiB4iK6iL2YS6vz/cj9Sk1HF01LwDtl6IMU4Yk5IxIV4+SU1zgq
         cme/1Eng0CRjOAtZ+yvMp7IccGeu0D7xOjhCfBapZsGmmqAWtGy/Vpq/aajbjia9qu
         IhZJ1btc4pmCgTVMy/HeUbOUNxLNpYesPlFxCL1pOkQS64kwbcUmTy6nImKYG+H/IO
         SIeUnR+4tEH7N1ilEDkDb73fv5GYfja0+a9SbBL4ccxAMgcnQ1OmyjI8uTs4QIJfzx
         UgHyHhiFzsrug==
Date:   Thu, 19 Jan 2023 21:48:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <leon@kernel.org>, <leonro@nvidia.com>,
        <anthony.l.nguyen@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>
Subject: Re: [PATCH net-next v4 2/2] net: ethernet: ti: am65-cpsw/cpts: Fix
 CPTS release action
Message-ID: <20230119214800.63b8c63a@kernel.org>
In-Reply-To: <20230120044201.357950-1-s-vadapalli@ti.com>
References: <20230118095439.114222-3-s-vadapalli@ti.com>
        <20230120044201.357950-1-s-vadapalli@ti.com>
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

On Fri, 20 Jan 2023 10:12:01 +0530 Siddharth Vadapalli wrote:
> Changes from v3:
> 1. Rebase patch on net-next commit: cff9b79e9ad5
> 2. Collect Reviewed-by tags from Leon Romanovsky, Tony Nguyen and
>    Roger Quadros.

You need to repost the entire series, and please don't --in-reply-to,
just CC the people who commented.
