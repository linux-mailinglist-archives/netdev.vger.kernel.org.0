Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC1968A803
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 04:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjBDDqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 22:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBDDqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 22:46:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939B01C7E4
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 19:46:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14F4DB829C9
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 03:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CA2C4339B;
        Sat,  4 Feb 2023 03:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675482402;
        bh=GYVDyk137AVRx3mF3z/QJHZl7iFfZl9EQ8tG6LElj3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o3vBD0smJFaLptaqKa/q6n1c1zxeWEPP84gqPSGrHML067NUxrb+c05eCNQLUJEfP
         ZAcSz8bbqZEPVwHyzGYGRgxuq+6JrFUTTiFrtpWdi58tJfp4IGK7gTavBl7DuM+OiZ
         Gm9RXft5Jg301swKwIzKfzTrka9mKH4xu/G/YgoDU3228S+DBLEAQfUeUUbXUuAq+L
         QlohYhGJXf42zFKu++o37GXJZQ0r5oBOcAvTrS5RuCxSY2+za6X22fjTYUd1YBK5ze
         8dFkeVyHSdfv1e5hrmjCOSl34zWyGskXBJIJW1OUcZvWPyMRCHmbRu3RAW+cE7MRXe
         WWlEaT/acQBkg==
Date:   Fri, 3 Feb 2023 19:46:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v11 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
Message-ID: <20230203194639.688d39f6@kernel.org>
In-Reply-To: <20230203132705.627232-4-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
        <20230203132705.627232-4-aaptel@nvidia.com>
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

On Fri,  3 Feb 2023 15:26:43 +0200 Aurelien Aptel wrote:
> This commit adds:
> 
> - 3 new netlink messages:
>   * ULP_DDP_GET: returns a bitset of supported and active capabilities
>   * ULP_DDP_SET: tries to activate requested bitset and returns results
>   * ULP_DDP_NTF: notification for capabilities change
> 
> Rename and export bitset_policy for use in ulp_ddp.c.
> 
> ULP DDP capabilities handling is similar to netdev features
> handling.
> 
> If a ULP_DDP_GET message has requested statistics via the
> ETHTOOL_FLAG_STATS header flag, then statistics are returned to
> userspace.

Acked-by: Jakub Kicinski <kuba@kernel.org>
