Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E647681BA1
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjA3UhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjA3UhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:37:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C402166EC
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:37:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF8EBCE18C9
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D51BC433D2;
        Mon, 30 Jan 2023 20:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675111031;
        bh=L49cRDx/NtLklbaDlALayT7aMxz68WAOMQanNjinmX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lYXRJIKXt3Ra+6V03IruTcxgW57Th5arIFBlvKeK6ktRk6Btva+2GKTE8jn5nU/ZR
         d7zOuP61bXgEH3ZK87H4/+6YUkWxM+5foicftKiBXjD1cA0wMyJFWJnxSDuSwK/Ob6
         1oVFsji3/Y/+ewJC0qF2PVhobYga/DvMAgAoSHXe5MzaBP5EhSShgKDJrtceqy5CWQ
         9YC9vlgjk4ssK6+rlp2ZfXzgvLodYpwUi5aEnvccoY0kqfi4qseOojNSCc5v07XVqr
         kbHVuZJwLYU27iTO2jYIiQL89a6b1eY1VOa5Nn02eVcaUsiuWXyyOJttI/TkhZwKNp
         M0er+IttGOrIA==
Date:   Mon, 30 Jan 2023 12:37:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        michael.chan@broadcom.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com,
        mailhol.vincent@wanadoo.fr
Subject: Re: [patch net-next 0/3] devlink: fix reload notifications and
 remove features
Message-ID: <20230130123709.2c52f600@kernel.org>
In-Reply-To: <Y9eg4OmDARyDHUFc@nanopsycho>
References: <20230127155042.1846608-1-jiri@resnulli.us>
        <167506861691.21040.7506893085716379938.git-patchwork-notify@kernel.org>
        <Y9eg4OmDARyDHUFc@nanopsycho>
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

On Mon, 30 Jan 2023 11:50:08 +0100 Jiri Pirko wrote:
> The merge commit text is wrong:
>     Merge branch 'devlink-next'
> 
>     Jakub Kicinski says:
> 
>     ====================
>     devlink: fix reload notifications and remove features
> 
>     First two patches adjust notifications during devlink reload.
>     The last patch removes no longer needed devlink features.
> 
> "Jakub Kicinsky says" should be "Jiri Pirko says". I thought this is
> done by a bot? Is the bot buggy?

Hah :D 
It's done locally, not by the bot. Our (Daniel Borkmann's) script
fetches the author from patchwork, but I think DaveM has his own
automation.
