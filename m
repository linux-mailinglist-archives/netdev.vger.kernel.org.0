Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6735D584459
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiG1QsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbiG1QsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF5874781
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10B7861CDA
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 16:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFB2C433C1;
        Thu, 28 Jul 2022 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659026878;
        bh=/W0I2oNAxnR5wUQ80CzH7yL5fgJvveKje5Tzrrirxvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U+xBsbXlDkXiv7eQaS+HZw021NEDBdJjp5jdhlCw6925kVV/sqPX7MUAAy4MC3tC2
         AjCjxAlPcxVJ3FL00ajmyR0aJsSJtqFQ1DcajXn98E27KbXjOKthhF29uTgTveQ4yn
         5axMOC3uhgR73JKnK1lBXhCg06EgRWQiam6Ls6s6q0hLuhCHQcLXuvzhz3c5MW4rTJ
         XGGzYNRQoN9BYfAUKlOXiLHowaTpldqpiZ25YS2WSg9Q32L05wrTsn0DLx6/52/JpV
         T7gX6uKMweED6XagR2ErbZnqP6fYHeq7V0i/ou6IWKUrS1fB4IIJcB6wS6JxT0Xr7H
         ATpimfS4lozsQ==
Date:   Thu, 28 Jul 2022 09:47:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang He <windhl@126.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linmq006@gmail.com
Subject: Re: [PATCH] of: mdio: Add of_node_put() when breaking out of
 for_each_xx
Message-ID: <20220728094756.51d304ed@kernel.org>
In-Reply-To: <20220727074409.1323592-1-windhl@126.com>
References: <20220727074409.1323592-1-windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 15:44:09 +0800 Liang He wrote:
> In of_mdiobus_register(), we should call of_node_put() for 'child'
> escaped out of for_each_available_child_of_node().
> 
> Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
> Co-authored-by: Miaoqian Lin <linmq006@gmail.com>

The standard tag is Co-developed-by, and the other developer must also
provide their sign-off. When reposting please make sure to CC the
author of the patch under Fixes.

> Signed-off-by: Liang He <windhl@126.com>
