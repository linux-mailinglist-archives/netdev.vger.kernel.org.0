Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34D614371
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiKAC6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 22:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiKAC6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 22:58:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26783558F;
        Mon, 31 Oct 2022 19:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 976BC614C9;
        Tue,  1 Nov 2022 02:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C42C433D6;
        Tue,  1 Nov 2022 02:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667271486;
        bh=pWTbVhJq/jT02LKW0+ZtOBSAv1CFnNOl52B9TK3vTRQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A7LaZsR3PTeO9pbEoUZITAoWTztm4OhfIlk45Jb1iA12a3mTT9mI8NTuNZnrbQE77
         q34OaYTceCxS6X/d+fC7GpN6HPSh9vMEwuYkIY/ZyTRPEKyuyrXnPRo/+IJi0Mk71p
         oK/xwihysZwYq9qTv+LPbIZcdC+4FVB6eaDJ8kvLBrVrzWhjCgxYwlPqCDr20Z25jL
         LtHuuKPsWiNAtnZXNuJeH97cq3pTuaVxUBU+dzGCchZtQ6w4whO+PxNFsCLw6LQHrb
         9h89+LpEUHpPmbvGkkkHOFiy/lUG6M1l7asBqOiQlaISxGWQczCHXPOmd1H+mHl0J8
         eRGXkQJE5evAw==
Date:   Mon, 31 Oct 2022 19:58:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Bin Chen <bin.chen@corigine.com>,
        Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?= <kw@linux.com>,
        Peter Chen <peter.chen@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: hinic: Add control command support for VF PMD
 driver in DPDK
Message-ID: <20221031195805.74e22089@kernel.org>
In-Reply-To: <20221101014917.GA6739@chq-T47>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
        <20221026125922.34080-2-cai.huoqing@linux.dev>
        <20221027110312.7391f69f@kernel.org>
        <20221028045655.GB3164@chq-T47>
        <20221028085651.78408e2c@kernel.org>
        <20221029075335.GA9148@chq-T47>
        <20221031165255.6a754aad@kernel.org>
        <20221101014917.GA6739@chq-T47>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Nov 2022 09:49:17 +0800 Cai Huoqing wrote:
> > Meaning it just forwards it to the firmware?  
> Yes, host driver just forwards it to the firmware.
> Actually the firmware works on a coprocessor MGMT_CPU(inside the NIC)
> which will recv and deal with these commands.

I see, please include this info in the commit message for v2.
