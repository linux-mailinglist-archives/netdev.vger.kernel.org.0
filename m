Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E685258D0
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359691AbiELX71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243920AbiELX70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:59:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C52428B684;
        Thu, 12 May 2022 16:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 165716206C;
        Thu, 12 May 2022 23:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C30FC385B8;
        Thu, 12 May 2022 23:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652399964;
        bh=gjvACHtGA2z6GnIxl6laM07IgvWJrXhmBnyL+KjzY1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qtVGdSlskjXFv5UjcDm2Zz5z2cGIvC1SsmOXmbI3/Rwe3Un/8ahnIyUinS08fl1xx
         kRv6AG6TLWl8r6NoYA4N7ORiNZIMi7w4GTgMfb+2yd7EjEF9T7nnda7b7rquSn9ip7
         c1nviacB+QzUqAjafZBRicXxmfFGCAHkK51GCTQtrcS/h9UVtt25s6OUPuhXHohfIm
         W4cVvDVII4hWH3G2KOoiLjkHpf0+tBKYQGPUQkdTIvTIyRz300kUcHUyJnwCnsiiDx
         Mo48P3UjVBETmjla5EWrS8GTayg/grpi/mbZlslIbMiuOghMjyFQSWRR3VVD8jyY7s
         FlOUdbrqS81Dg==
Date:   Thu, 12 May 2022 16:59:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gaochao49@huawei.com>
Subject: Re: [PATCH -next] net: hinic: add missing destroy_workqueue in
 hinic_pf_to_mgmt_init
Message-ID: <20220512165923.1fda4c49@kernel.org>
In-Reply-To: <20220512084148.1027481-1-zhengbin13@huawei.com>
References: <20220512084148.1027481-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 16:41:48 +0800 Zheng Bin wrote:
> hinic_pf_to_mgmt_init misses destroy_workqueue in error path,
> this patch fixes that.
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Please add a Fixes tag and repost. Thanks!
