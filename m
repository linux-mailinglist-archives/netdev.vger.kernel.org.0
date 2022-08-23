Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A106859D1EB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240723AbiHWHWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbiHWHWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:22:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F93162A88;
        Tue, 23 Aug 2022 00:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BAD1614FF;
        Tue, 23 Aug 2022 07:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27798C433C1;
        Tue, 23 Aug 2022 07:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661239358;
        bh=KRJJ8fx68qtHY2+LrlLu0/eSUh/OLsKwAs0PdVseMkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NqUaOGdAZ+A9CdryvaBR+hZTlAlB3bdrkVEkyTWOcCRLV/bQQVu6dwSYiYRpxjPV9
         RtF468lQeihD/VeOiLvfsU7zY88Kz7VWhcjUIEpNMQBThz5F3B0StEbV+4CB3S++Sa
         DU1Q8UYBZrETBuxPM/QdD82o1MA2ur/Wsi1MJCOA=
Date:   Tue, 23 Aug 2022 09:22:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanislav Goriainov <goriainov@ispras.ru>
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 0/1] qrtr: Convert qrtr_ports from IDR to XArray
Message-ID: <YwSAO4MfxISeUGDR@kroah.com>
References: <20220819194727.18911-1-goriainov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819194727.18911-1-goriainov@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 10:47:26PM +0300, Stanislav Goriainov wrote:
> Syzkaller reports using smp_processor_id() in preemptible code at
> radix_tree_node_alloc() in 5.10 stable releases. The problem has 
> been fixed by the following patch which can be cleanly applied to 
> the 5.10 branch.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Now queued up, thanks.

greg k-h
