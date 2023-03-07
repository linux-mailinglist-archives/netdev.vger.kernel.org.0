Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7B56AD68B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 05:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCGEsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 23:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjCGEsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 23:48:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D8C5D892;
        Mon,  6 Mar 2023 20:47:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 558D7611D1;
        Tue,  7 Mar 2023 04:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4136AC433EF;
        Tue,  7 Mar 2023 04:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678164442;
        bh=/z0KJGRXsoUt7+AZKR3EwyCLvHeOdAzFRZrY+Q2ETCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YsOiGjvsxzF+kwoSc973znR81XGhtNLqgFLqN8a/rhkGCvlumOeHTJhs/EzsKPppU
         Y4qVSDXoqyNBIkvTYyKMEr38bjqZalAxUu1QFxzjrFJGa0lrCpSb8gPb9B9YwdCgPt
         KxsyAxcMMnwIxRvDDdsYqcrrLS8o7ST1nXpsrYTZLHy/OAVI1Y3XBgu0/D/ZuH27Ma
         zREjhHDKfEhlMHVzrpdykrYFWW6aaj6UQ5txcZeNuCwt0hGZgBfORxISTrypxKjlFR
         ArKm/9WfzTipckQZcwOAG2UCNdTQCyVkrHnXITKshIAfyja2ag+uogJ3iGFjpvahZp
         vcIzOy7tIkKVQ==
Date:   Mon, 6 Mar 2023 20:47:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2023-03-06
Message-ID: <20230306204721.23f204ac@kernel.org>
In-Reply-To: <167816372051.12713.8574521202926153502.git-patchwork-notify@kernel.org>
References: <20230307004346.27578-1-daniel@iogearbox.net>
        <167816372051.12713.8574521202926153502.git-patchwork-notify@kernel.org>
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

On Tue, 07 Mar 2023 04:35:20 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Here is the summary with links:
>   - pull-request: bpf-next 2023-03-06
>     https://git.kernel.org/netdev/net/c/757b56a6c7bb

I guess we'll just have to accept the fact that the bot confuses bpf
with bpf-next as a fact of life :) Both pulled..
