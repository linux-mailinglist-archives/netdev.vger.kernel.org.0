Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0210C5EFA52
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbiI2QW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiI2QVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08328A1A77;
        Thu, 29 Sep 2022 09:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 280E861AB9;
        Thu, 29 Sep 2022 16:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26019C433D6;
        Thu, 29 Sep 2022 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664468409;
        bh=lKFZVv0+6eRjOWBfDOM+MkCH5/qgv5p8acZHIgeCqXY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jHeXRWE3t5ELl1tCxQbi8mY4YI1bexZCX0byOkgIVmGP41Wf17O9Bss7rkT5dn5dw
         2jW8tTCmSWZ2oQQl+UeexgS/8rNtwSrRALBqHsQJPAKKSNh816BTQqUh643QC+hfCn
         eLQjozG8gm4wSeq2Dfv2kEVy5VMl0csldyx+tXNKHOZcemDjrHUhw4zubaJjvG3Jfn
         MZo+Uy367DOSLSjrGJCC33LkfC/lwF7NmikxWSHeb0jRwRNLjvKTqAPLN8wRaykiR0
         U3yloOitzXGZiSZepL8BNFqQ13Jaw50d5WQw8dqsREpg1P6PjyhkpOm+2f4lSpUrlW
         KvhqztzMwEWfg==
Date:   Thu, 29 Sep 2022 09:20:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: fix potential memory leak in bnx2x_tpa_stop()
Message-ID: <20220929092007.4dba3dcf@kernel.org>
In-Reply-To: <20220929023752.5914-1-niejianglei2021@163.com>
References: <20220929023752.5914-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 10:37:52 +0800 Jianglei Nie wrote:
> Fixes: 07b0f00 ("bnx2x: fix possible panic under memory stress")

sha too short
