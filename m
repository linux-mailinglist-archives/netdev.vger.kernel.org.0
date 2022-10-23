Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE2F6091C5
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 10:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJWIQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 04:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiJWIQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 04:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E567F6E2C3;
        Sun, 23 Oct 2022 01:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77FCD60BA5;
        Sun, 23 Oct 2022 08:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F82EC433D6;
        Sun, 23 Oct 2022 08:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666513005;
        bh=E8YJw1nj0m7gn4Iq9pQcMVisIUocJJtTt7S3IUeUSy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lx/QBKoipv5Qhs3IyRvg3nG8pb+dVhZuyr5UuRoxAZXa2LBm6uwj9UKfBitGwzCHh
         S12a7qw3TxVqka0nwWsQP2nqOIhvoT35jasC4RetcZPQIvXF3niPF1X/GUehWhOXbr
         Pe4uHEFf7t6NgofUI7xKtqUXdTV4awLINQyC0pZB4j0bHgaClvu6KhWkrG4oaSaUFC
         Esmez15mj7xr+xMmFw0W5uv0guXmUzDUoFCPeX3pC3FuC7CwMN4q+5RwImcm4KVcJc
         RtFQDMSvGreWEiRwVDU3LmQYN0DBdsPNCmmnQkWjMo5zQQGl+dx3/pM/lxAjVK9FtT
         YLnAcjKSu8HQg==
Date:   Sun, 23 Oct 2022 11:16:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: [PATCH -next] rfkill: replace BUG_ON() with WARN_ON() in core.c
Message-ID: <Y1T4aWIbueaf4jYM@unreal>
References: <20221021135738.524370-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021135738.524370-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 09:57:38PM +0800, Yang Yingliang wrote:
> Replace BUG_ON() with WARN_ON() to handle fault more gracefully.
> 
> Suggested-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/rfkill/core.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)

Please add changelog and version numbers when you set your series.

The same comment as https://lore.kernel.org/all/Y1T3a1y/pWdbt2ow@unreal
or you should delete BUG_ONs completely or simply replace them with WARN_ONs.

There is no need in all these if (...).

Thanks
