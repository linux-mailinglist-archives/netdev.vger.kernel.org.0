Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DEE5A8B66
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbiIACZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiIACZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:25:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D71AE0961;
        Wed, 31 Aug 2022 19:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF7CB823D5;
        Thu,  1 Sep 2022 02:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141A5C433D7;
        Thu,  1 Sep 2022 02:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661999150;
        bh=iElNJ9fgcawQF6ttn9qkiOFV0JIYR3hleKdKCGrwUXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HhLZo+x/lOlI84vKKwHK5CDYZbyqJRuCT56YZ4xYHqPfEcUhbQBEC1F+lcFpfxYHU
         fxQT2VcEzssgKJmZ+es8v8aTLzPar/SOjwc1FTkYR7XCrFOFiGbnDJQStFXnnpH52u
         3oMpeWnHlC6kIWM2cmueveU0wUqP0vZb1T4K0BZRPL1eTit0ffZHEqbBtkP6IzP0Gx
         FDW9+twfttBuTA0jH9qM7BKhT39azG/DO/KLg6wF7B1tA9ZXwT8D2snynv7MRds83P
         UAunRSPjBcxVuh+QjYQm58W0dB0D5WBIEPlEURJuobr+es9WFJQNgaK8fJZLSBZU//
         swJ2Vy0ldVlRQ==
Date:   Wed, 31 Aug 2022 19:25:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next 0/2] net: sched: remove redundant resource
 cleanup when init() fails
Message-ID: <20220831192549.271770ee@kernel.org>
In-Reply-To: <20220830005638.276584-1-shaozhengchao@huawei.com>
References: <20220830005638.276584-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 08:56:36 +0800 Zhengchao Shao wrote:
> qdisc_create() calls .init() to initialize qdisc. If the initialization
> fails, qdisc_create() will call .destroy() to release resources.

Looks like this set does not apply cleanly, please rebase on top 
of latest net-next/main and repost.
