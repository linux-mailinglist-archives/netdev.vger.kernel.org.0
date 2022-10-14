Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD48D5FE7A5
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 05:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJNDjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 23:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJNDjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 23:39:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42B419298C;
        Thu, 13 Oct 2022 20:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A9FCB820BC;
        Fri, 14 Oct 2022 03:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEA2C43140;
        Fri, 14 Oct 2022 03:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665718753;
        bh=KYozkUymmljAF7Z/zt5tiXLnn4emqzGDDUi4SNebNHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fSWV20IrHlHHTBupoOxrTKAFOTl5k4jmN9qMWeOoqZFIL9zNZV8B8jnK/Zb9LfUtY
         oxgXhpbsUYqjvRhgYhMBBcDzQ1mvAt9fqEHi1v78yA5z0fVpZV0OSMr6z4bHCjlvqH
         KZInPjXyiOLVBuaHE7JlyDk902S5uIRswWCDr9x0ryCoq4piHT5fyrUsaj77OWdH8z
         deaf7WTgrJGR0czgTt0oTrfCdGEQxHw4UCgZW+6N5S+G7dBXMz3KKtcHRF72HzkARc
         lfGR51awdOa68d3M7aJ5tZY0Ne9Fgu3vT/XElrffSvXzwFBadxmm+L7heeSWKTl8TE
         buOVnj1viUuow==
Date:   Thu, 13 Oct 2022 20:39:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     guoren@kernel.org
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rasmusvillemoes.dk,
        yury.norov@gmail.com, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
Message-ID: <20221013203911.2705eccc@kernel.org>
In-Reply-To: <20221013203544.110a143c@kernel.org>
References: <20221014030459.3272206-1-guoren@kernel.org>
        <20221014030459.3272206-2-guoren@kernel.org>
        <20221013203544.110a143c@kernel.org>
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

On Thu, 13 Oct 2022 20:35:44 -0700 Jakub Kicinski wrote:
> Can we instead revert 854701ba4c and take the larger rework Yury 
> has posted a week ago into net-next?

Oh, it was reposted today:

https://lore.kernel.org/all/20221013234349.1165689-2-yury.norov@gmail.com/

But we need a revert of 854701ba4c as well to cover the issue back up
for 6.1, AFAIU.
