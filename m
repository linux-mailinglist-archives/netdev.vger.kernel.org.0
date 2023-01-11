Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AAE6664BA
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbjAKUUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbjAKUU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:20:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10AE65DB
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:20:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E1B361E00
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6661AC433EF;
        Wed, 11 Jan 2023 20:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673468426;
        bh=DkelU3m7mbXPhyl4fgwRXrte8wxywGx1W8zlBfs/Xqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z61Bs9d0fl21NMLvlkm+Pa9MrC3vXBvmoveewY36BgrLZFNx6rXcYLbO4opS3gprc
         38ii54pljMjVHWghv6TtaSfo9w3UlG3EGCjVIgSuzcDZzl3G9LvXoigbI600KJQ8bE
         GP1XN0HcNw2HHG4dXtya6UDu9znHgp49yUS/eLQjEBB+91xmdXGqHut6FeMqtm03kd
         yaHa2GbVdWM5XG+6zJhEHOl22UMRkL5Bk6ZmgYNC6QfRlgm5MBJ6h7Bagq6ICgd+yq
         9eH2yo3eI1MDMhlb4V6UoM0smE28tNZ0WVG04FfJwPaBr2EtMxCvICxJndExiNXWL2
         gGOAPSFtT+Umw==
Date:   Wed, 11 Jan 2023 12:20:24 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 05/15] net/mlx5e: kTLS, Add debugfs
Message-ID: <Y78aCH2xZLpFYSYs@x130>
References: <20230111053045.413133-1-saeed@kernel.org>
 <20230111053045.413133-6-saeed@kernel.org>
 <20230111103203.0834b3ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230111103203.0834b3ce@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11 Jan 10:32, Jakub Kicinski wrote:
>On Tue, 10 Jan 2023 21:30:35 -0800 Saeed Mahameed wrote:
>> Add TLS debugfs to improve observability by exposing the size of the tls
>> TX pool.
>
>What is the TLS TX pool?

https://lore.kernel.org/netdev/20220727094346.10540-1-tariqt@nvidia.com/

We recycle HW crypto objects used for tls between old and new connections.

