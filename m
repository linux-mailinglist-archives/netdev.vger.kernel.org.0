Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26084BAF38
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 02:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiBRBrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 20:47:16 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiBRBrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 20:47:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0189996B8;
        Thu, 17 Feb 2022 17:46:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8305461C67;
        Fri, 18 Feb 2022 01:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958B3C340E8;
        Fri, 18 Feb 2022 01:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645148811;
        bh=H5tA8C/ajRnBTawhBiw8Gaf93X0ThocQAXWJa7tUprA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZMaEwyfj+VrY9W5WOxswQGYftbOjKRFa1AwYNtoPvBKwfp2HMkyLkGfXKnOIMdh/V
         1fm8KVHY9+Q8YkmFRKERyp7KGyEeC95B2yzCZ5Xi7FQCyaeCLB0gnirlz7h25cxVz1
         /qM5h6RYSdbhfd7yy3LCD5Jk+03tSP3ZvZxYr45si6Q04SWvF0B5PfGBKWLQWrLoxH
         9bG0qpnUzX9AZOea3XdddgLQCxfKbgAEMfZFSXpv/rH78NodCVTPgmdLEamUyZhLnT
         LrxGCbWYGh5Nknl2e3/3afSiFAtlpuot1UB/hjv3UVvV7Uoeu9/KmP/stmnfwG2xHi
         hUAgVg9/bNmhw==
Date:   Thu, 17 Feb 2022 17:46:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        ast@kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2022-02-17
Message-ID: <20220217174650.5bcea25a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <164514875640.23246.1698080683417187339.git-patchwork-notify@kernel.org>
References: <20220217232027.29831-1-daniel@iogearbox.net>
        <164514875640.23246.1698080683417187339.git-patchwork-notify@kernel.org>
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

On Fri, 18 Feb 2022 01:45:56 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This pull request was applied to bpf/bpf.git (master)

:/ gave me a scare. No, it's not pushed, yet, still building.
