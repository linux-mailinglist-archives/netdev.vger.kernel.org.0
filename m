Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB946BBF24
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjCOVdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjCOVdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:33:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845527FD7B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 14:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FC6BB81F6B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C2CC433EF;
        Wed, 15 Mar 2023 21:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678916015;
        bh=nH0XiK4tVl23AzHWXB/Jct+eHDVVPL+i3zlGSAZA3v4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C6MFyCTK3kCZ0kXhqZC7DL6Pm3r7uJg7Odvn7wb0LzVQ0vPqIq/bdzrajUKlfRQXv
         1Q37eDOtTyrlch0jAbgJOY+ZmIovhDfv90HGMeMQjYOvke5kBQZdW1ztnOv+OUT4+R
         ETRLYYV4Zokn4AP/oIqWdgy3NB4Z5sjcEJPGZy/sLWm79M1MHRqrHQANER0T0S+Zdq
         RihSzAA+24zAJKWxnCzrBYNAxQt3Ju0HcsqYQBfkm9ONo6bwiZ7Xenu/WUYupps85T
         3M95Q3LMnomTj4yiZrGVxEHUhGmD6v1Pyfcfssxil6pi4nqtzcJ+t4IcALuS7Viwcz
         rWA+SmvNj89sA==
Date:   Wed, 15 Mar 2023 14:33:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Piotr Raczynski <piotr.raczynski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: Re: [net 03/14] net/mlx5: Fix setting ec_function bit in
 MANAGE_PAGES
Message-ID: <20230315143334.434bbbda@kernel.org>
In-Reply-To: <ZBIz7yxaeDOiV4xk@x130>
References: <20230314174940.62221-1-saeed@kernel.org>
        <20230314174940.62221-4-saeed@kernel.org>
        <ZBHD2J8I1WGf9gnB@nimitz>
        <ZBIv4oGgtWbTGkaS@x130>
        <20230315140454.4329d99e@kernel.org>
        <ZBIz7yxaeDOiV4xk@x130>
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

On Wed, 15 Mar 2023 14:09:03 -0700 Saeed Mahameed wrote:
> When looking from a larger scope of multiple drivers and stack, yes it
> makes total sense.
> 
> Ack, will enforce adding mlx5 prefix to static functions as well..
> 
> Let me know if you want me to fix this series for the time being, 
> I see another comment from leon on a blank line in one of the commit
> messages.
> 
> I can handle both and post v2 at the same time.

It's a long standing problem, we can keep it as is, if you don't have
any other code changes to the series. Just change the recommended style
going forward.
