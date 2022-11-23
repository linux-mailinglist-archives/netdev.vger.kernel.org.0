Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8FF634F53
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiKWFCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiKWFB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:01:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E88DE0CA4;
        Tue, 22 Nov 2022 21:01:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A42F60916;
        Wed, 23 Nov 2022 05:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5863CC433C1;
        Wed, 23 Nov 2022 05:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179716;
        bh=k68a/G3GQ9o75GfUB0XKtfTQYyzWUYZ7VncGWLyMn+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J15I9YzfSPGmQJabHFmjxRWahHZU+uEd7LFbrn8bk5NCJeC3HqEwo8MjukRLjDIlv
         UGLnkSFipvRuX3GrcZyEj7PimvtVEsD0Ok9nfnnl+h7TKPHgh5BYH1oTSMZYuYsIEd
         hb5E8XxGTNgyFaJm2HKWOjpgqJlkUHLrHF/D4Mq1NRXM5JiPFAbrv8BvL8djFLour5
         4c317QQsVdJSnKTQi+2ZAO5vA0rTA2mEb6VhufWqci96m6ItOdUqz9xprx76Xpgrd1
         XABamSmKi81g2QZDxPIkTuKNLG0ad2pdnyCvX52N+gpNFdkuYBXhyAxhfnWd7BclWx
         EqWv4SigX5Nxw==
Date:   Tue, 22 Nov 2022 21:01:55 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        moshe@nvidia.com, ogerlitz@mellanox.com, eli@mellanox.com,
        jackm@dev.mellanox.co.il, roland@purestorage.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: Fix uninitialized variable bug in
 outlen_write()
Message-ID: <Y32pQ8p+3lb2y5SP@x130.lan>
References: <20221121112204.24456-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221121112204.24456-1-yuehaibing@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21 Nov 19:22, YueHaibing wrote:
>If sscanf() return 0, outlen is uninitialized and used in kzalloc(),
>this is unexpected. We should return -EINVAL if the string is invalid.
>
>Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
>Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>

applied to net-mlx5, thanks !

