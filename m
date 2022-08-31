Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CE85A86BD
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiHaTaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiHaTa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:30:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DABE61DB4;
        Wed, 31 Aug 2022 12:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84AB66191A;
        Wed, 31 Aug 2022 19:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED66C433D7;
        Wed, 31 Aug 2022 19:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661974215;
        bh=aT6ggo/5Ti0Z8m/t1rIYUxfcrOx9cy0fnPpo/bgwS3o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eaaZqoiHca2fmpsKl0LehZKI8PhiyWyQ3GJDhH0HNbF94THzt0sFWQwe1xB5nsJde
         yNJlO16Jkqcr+Pc4MLKpNtXHvHFxiatW/TFLJX3fjMem9wLoU6Ry2Kh0PxVs3+wiuu
         6UfF0fL7BhpsHTtMO2fOJmsJHwAlWcHlqtYrEbY37niW3JpQq1xgtLBwd6ZZYqEVXt
         79NsSz4t9dGwNo3x4pxPiI4GS9tTLSH9WR455OzujsoUSChCZZ8dw5t9+tZWhaH+Xn
         5Gx/gp3woPXFVN+FhXSeo+MuGfuJECzw6WILxNPrq3sbcB8jBGdT0aBWOO9oN8hxlN
         ErTmEaUZ6Zznw==
Date:   Wed, 31 Aug 2022 12:30:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next] net/sched: cls_api: remove redundant 0 check
 in tcf_qevent_init()
Message-ID: <20220831123014.18456fa9@kernel.org>
In-Reply-To: <20220829071720.211589-1-shaozhengchao@huawei.com>
References: <20220829071720.211589-1-shaozhengchao@huawei.com>
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

On Mon, 29 Aug 2022 15:17:20 +0800 Zhengchao Shao wrote:
> tcf_qevent_parse_block_index() has been checked the value of block_index.

Please rephrase this:

  tcf_qevent_parse_block_index() never returns a zero block_index.

Took me a while to figure out what you mean.

> Therefore, it is unnecessary to check the value of block_index in
> tcf_qevent_init().
