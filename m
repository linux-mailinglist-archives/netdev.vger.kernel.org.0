Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CBD5F33CC
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJCQmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiJCQmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:42:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1BC36DE8;
        Mon,  3 Oct 2022 09:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96DC6B81188;
        Mon,  3 Oct 2022 16:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA475C433C1;
        Mon,  3 Oct 2022 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664815330;
        bh=tMAwfYT/nwyR5ky3r0ZvoViF/nSHjENgBx+IN+V/Al4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CcnrN++kyzIOPDmdG4obOx5mT2IODhXmd4upHGGaZ3QZtzv0I+Oe+3ZROoWMn+E0q
         zj8OI/T3+0fNaecjf+43ZprG9kmuRfHVm9pfdq/DqOH6zZl0lvzphWFN/MqD0TmMS+
         3+OX1Wqi7iCreKaI1mZqBG44XC/UTAmNd/vBrKFauLEgGRhVpiYHf8ckf75YZnkDvN
         no0f7Q3KEU6/lJrZnHkSTYf7Tof5CHn2MfWZ4HoR8SyvhYzgRh5ky6t/1C522by7nN
         8OtPE5t+5AQL2piH0uviZYUsP+3Yd2ZgZ7Bbgt80Jiwgd8IS6JwJo8XFlDihm+XWe5
         j3kj2tHfS3GPg==
Date:   Mon, 3 Oct 2022 09:42:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <shayagr@amazon.com>, <akiyano@amazon.com>, <darinzon@amazon.com>,
        <ndagan@amazon.com>, <saeedb@amazon.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <nkoler@amazon.com>,
        <42.hyeyoo@gmail.com>
Subject: Re: [PATCH -next] net: ena: Remove unused variable 'tx_bytes'
Message-ID: <20221003094209.57568a47@kernel.org>
In-Reply-To: <20221010031936.2885327-1-chenzhongjin@huawei.com>
References: <20221010031936.2885327-1-chenzhongjin@huawei.com>
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

On Mon, 10 Oct 2022 11:19:36 +0800 Chen Zhongjin wrote:
> Reported by Clang [-Wunused-but-set-variable]
> 
> 'commit 548c4940b9f1 ("net: ena: Implement XDP_TX action")'
> This commit introduced the variable 'tx_bytes'. However this variable
> is never used by other code except iterates itself, so remove it.

First of all - please fix the date on your system.

Second:

# Form letter - net-next is closed

Linus has released v6.0, we are currently in a merge window
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.1-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
