Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF7B642FD1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiLESWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiLESWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:22:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCD2205F2
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 10:22:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 485AF612F3
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29621C433C1;
        Mon,  5 Dec 2022 18:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670264548;
        bh=RK/+0PlEr7cFSyz8PvMFDqfwdLNxNLs5m5cEyAwT7qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YmdZbNFFcHqtqtiBnChSLfGWLkrNoBowiSfs2hMAKeZyjRlI+2OcRwzRr7fKlE+he
         W89fZwe8ubXDMS42TpV6QH6UuqmAr199wnR+0WqtBBht5AdVTk2QX1D3a+1zyQUzJb
         79Kik3V8u8lssvsSGbZJoggy0Z/VDz0BPLMft6niTuRRWADg+LD0O6dme1Ke70hHaL
         0T58/zEi4G16SYs1FQMIf+vGQF6zxuIfVKnWNttdn7PQzUW/yUgnMUcATnmRyKLkiB
         HMuHKn6MSaf1eQyiddfFs5Gw92fL0p1ts/PRFZQq4ig8LB/bXTRtPXBs2lG9FDLkac
         7nQ5lRP4anpoQ==
Date:   Mon, 5 Dec 2022 20:22:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH net-next 0/2] devlink: add params FW_BANK and
 ENABLE_MIGRATION
Message-ID: <Y4424LOnXn+JXtiS@unreal>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205172627.44943-1-shannon.nelson@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 09:26:25AM -0800, Shannon Nelson wrote:
> Some discussions of a recent new driver RFC [1] suggested that these
> new parameters would be a good addition to the generic devlink list.
> If accepted, they will be used in the next version of the discussed
> driver patchset.
> 
> [1] https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/
> 
> Shannon Nelson (2):
>   devlink: add fw bank select parameter
>   devlink: add enable_migration parameter

You was CCed on this more mature version, but didn't express any opinion.
https://lore.kernel.org/netdev/20221204141632.201932-8-shayd@nvidia.com/

Thanks

> 
>  Documentation/networking/devlink/devlink-params.rst |  8 ++++++++
>  include/net/devlink.h                               |  8 ++++++++
>  net/core/devlink.c                                  | 10 ++++++++++
>  3 files changed, 26 insertions(+)
> 
> -- 
> 2.17.1
> 
