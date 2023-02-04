Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2F968A800
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 04:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjBDDnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 22:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBDDnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 22:43:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04088A59
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 19:43:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84BC36203B
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 03:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A16C433D2;
        Sat,  4 Feb 2023 03:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675482181;
        bh=Fql2NQ0xiyvHDXp3y8aTtoOW1LSw01YvzAS0sT1Y9eY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AaJu2yhcFru428vR4nYrjT1NoC+w6iRA1BuKANnUMs+JGEVdmc6c2taBWy+C42HAB
         t6VvLRZIzUbPv8HC0TUqC55eM+RwtkVpbqalvI24v2SywaJ0DkzuTNEkpZd6eMn7c3
         BO3PlA2BGafSTAnla82FnhusiDY8XSplDtwIbDU3XZrvhuraGNZj3RrqtmnIBzBubh
         qIB00OdKa91YEoT/vsa/RzDLexZMBOm0mlpBXUXPK6lA++Ghbe7ZUkKlnhPXbN4wdG
         6MkO7g6lNmVdkA+Wbwrjs1o0Jes+ISSGqAATIftZthWrDjIPcRE2un+7GrJYdJJf+s
         CkoEMZOLMGSeQ==
Date:   Fri, 3 Feb 2023 19:42:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v11 02/25] net/ethtool: add new stringset
 ETH_SS_ULP_DDP_{CAPS,STATS}
Message-ID: <20230203194259.67c08c7a@kernel.org>
In-Reply-To: <20230203132705.627232-3-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
        <20230203132705.627232-3-aaptel@nvidia.com>
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

On Fri,  3 Feb 2023 15:26:42 +0200 Aurelien Aptel wrote:
> This commit exposes ULP DDP capability and statistics names to
> userspace via netlink.
> 
> In order to support future ULP DDP capabilities and statistics without
> having to change the netlink protocol (and userspace ethtool) we add
> new string sets to let userspace dynamically fetch what the kernel
> supports.
> 
> * ETH_SS_ULP_DDP_CAPS stores names of ULP DDP capabilities
> * ETH_SS_ULP_DDP_STATS stores names of ULP DDP statistics.
> 
> These stringsets will be used in later commits when implementing the
> new ULP DDP GET/SET netlink messages.
> 
> We keep the convention of strset.c of having the static_assert()
> right after the array declaration, despite the checkpatch warning.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
