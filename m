Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF2362648C
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiKKWU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbiKKWUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:20:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA29814F2;
        Fri, 11 Nov 2022 14:19:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCB62B82819;
        Fri, 11 Nov 2022 22:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6573CC433C1;
        Fri, 11 Nov 2022 22:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668205194;
        bh=bx5xTvY9MoJCJHSjL8yVurWs7PcyO1h51bYzzF5cZ8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hwxLk5lwKCAMeJao3I/jk74XzX03hCWvUw5DhUustTRPFwAIGTWlcD4FPKWo3s4Kq
         1ytJcVd29xR6ogIRCFSolcFxaA524YvQYi8M2NWIXPYPRJRY6T+TEIf43RxssoohUf
         QiDbHyjuAisKTfccJmpsfef7sMqQW5HFIkwi2sljqxzT+GV3SQenRIx8TIUPRfTcWi
         t7jxCdHAwphQdlcP/t4NDyTVvKuGMDUup4DKntjDkKIPWiiE2UeqKR1kg0xZZ/U3PV
         kHqQxSYUn4TH0TsehNOMk00BWr3SY82qbyBj/nwIX+pRDaUeL2UxqgoP5k6OV3dqxo
         HI0+Xn21PFoBQ==
Date:   Fri, 11 Nov 2022 14:19:53 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kliteyn@nvidia.com, mbloch@nvidia.com, erezsh@mellanox.com,
        valex@nvidia.com, roid@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5: DR, Fix uninitialized var warning
Message-ID: <Y27KibkLDsY1z2/i@x130.lan>
References: <20221110134707.43740-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221110134707.43740-1-yuehaibing@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Nov 21:47, YueHaibing wrote:
>Smatch warns this:
>
>drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c:81
> mlx5dr_table_set_miss_action() error: uninitialized symbol 'ret'.
>
>Initializing ret with -EOPNOTSUPP and fix missing action case.
>
>Fixes: 7838e1725394 ("net/mlx5: DR, Expose steering table functionality")

applied to net-mlx5, 
Thanks!
