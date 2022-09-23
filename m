Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7595E7AC4
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiIWM3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbiIWM2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:28:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181A1115BEF;
        Fri, 23 Sep 2022 05:25:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC5861F63;
        Fri, 23 Sep 2022 12:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0F0C433C1;
        Fri, 23 Sep 2022 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663935916;
        bh=02nUGk8Mbyb5P5rpSdxYQr7vw+ROB7tTT8IAiCyXraY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QR5aQGTslzMNrc2j9zdogVY4ZcMecJURVt0iYIhAtTIgS3J+FmQ2cc6sEApHEhk0m
         Dw4lhPHs8ULGJusbFosUdXxPrdt8gn87NdNfJ0Uncj+JNihBaX/22zJ2FhAiPiuRLV
         x+lZSGOGcrsEMQZZf/JYDfi7tXOlNUTMniol20rdHARjjgPQ3ABa6d7QeJ/WHj3L4d
         660uQ90O7xITRLrS1tqlBgtH1gaOf9F1OKLVHWf5y8NNF98rM1zYW323VeOyj/V/Y5
         IfDtppseVqkzJRsUBwB2Q5zx0GY26CUdscLGTqRmd7drfk8BpPow82EUmXAwjogKuf
         5n6guHF7GoWGQ==
Date:   Fri, 23 Sep 2022 05:25:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220923052515.3a52d5c4@kernel.org>
In-Reply-To: <1ccfd999-7cb6-3243-20c6-54299bc1b8a1@tessares.net>
References: <20220921110437.5b7dbd82@canb.auug.org.au>
        <2b4722a2-04cd-5e8f-ee09-c01c55aee7a7@tessares.net>
        <20220922125908.28efd4b4@kernel.org>
        <1ccfd999-7cb6-3243-20c6-54299bc1b8a1@tessares.net>
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

On Fri, 23 Sep 2022 10:28:10 +0200 Matthieu Baerts wrote:
> Or maybe because you were again disappointed by Lewandowski's
> performance yesterday when you were resolving the conflicts at the same
> time :-D

:D

> Anyway I just sent a small patch to fix this:
> 
> https://lore.kernel.org/netdev/20220923082306.2468081-1-matthieu.baerts@tessares.net/T/
> https://patchwork.kernel.org/project/netdevbpf/patch/20220923082306.2468081-1-matthieu.baerts@tessares.net/

Thanks!
