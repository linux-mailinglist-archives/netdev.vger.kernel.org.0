Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF044E353D
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiCUXvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiCUXvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C72C1905AE;
        Mon, 21 Mar 2022 16:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1C6261525;
        Mon, 21 Mar 2022 23:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD330C340E8;
        Mon, 21 Mar 2022 23:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647906539;
        bh=6duSI4qIpnfwmUtP4G8OiGQgO+77Ek6RDsEjjkYUmzk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S1CXu+pWo28N79ImJQ6LxdMFtYq7ekrKUEdZxRJXf998g82yqzd7tBu8a6ecO/Q89
         d2HanXeu/WxDM7bgHgSvOaAA4Njg3w6MdvJyDORWaLC6KPItsEszC4q56A915U81wV
         oyq8a+a/XMCLRLq69uND1LK1wQxZNA14AJnaiszhCMNxkNE9WUkE6seBeOeg7krtiu
         GyNXhoipY2KkHWwxxfo3he7+zRYtxFembznmCko1+fbFGAjtAL2XqghMcRF8WgFCSx
         mXGwCjD2Hd0TbWGRj2uuVNyQYe5yEIW8PHrlPj/y2J7P6hagpko7TCu29p+bWzc9bd
         AR4He6FS1Pv8A==
Date:   Mon, 21 Mar 2022 16:48:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
Cc:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ipv4: update route.c to match coding-style
 guidelines
Message-ID: <20220321164857.6d3de2fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220321015550.11255-1-alexander.vorwerk@stud.uni-goettingen.de>
References: <20220321015550.11255-1-alexander.vorwerk@stud.uni-goettingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 02:55:50 +0100 Alexander Vorwerk wrote:
> The kernel has some code coding-stlye guidelines defined at
> Documentation/process/coding-style.rst
> 
> This patch fixes most of the code-style issues in route.c
> 
> Signed-off-by: Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>

Let's not do that, it'll just make backporting harder.
There's too much code that doesn't comply with checkpatch
to go file by fail and send patches.
