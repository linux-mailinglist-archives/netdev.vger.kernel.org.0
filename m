Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFEE5BD51E
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 21:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiISTQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 15:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiISTQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 15:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CD03D5AB;
        Mon, 19 Sep 2022 12:16:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2160361F29;
        Mon, 19 Sep 2022 19:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B9BC433C1;
        Mon, 19 Sep 2022 19:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663615013;
        bh=8TwaneWGJxWP0LM3SG4uRokbveZXU5djoN4fNmmd78s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B5M11PHvop/lzK5mnOd9CulaQxsdVJUsbAZnlbcmwdFIytzU7ugTdhei292TSUQnp
         mkd4QIIhDRNANQ3urViMyy77L6zcAqGKzJkXZMxrOJJwh3AawqWxsnGnh1ANC0vEUX
         7FlCRbPm63BsfGvCGYA48PEZmPSPP+p1qhfguRpvINBrq7CTLB3Z5iqq9N8nUrDJvS
         5GoYKPM133I8Knrmh9sMpEL9qMhQNaqtYxmmYWgg5C7k1eZ9H/8YGHqpBe21uQ8X/J
         ga5n69F5tM5SGhAy/wdYrQF5TtqnlXc6H2Y4egrrp9e+KnXOD4OYIxriwEL3iCWLxw
         Kqz8M+ZqSIhdw==
Date:   Mon, 19 Sep 2022 12:16:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jingyu Wang <jingyuwang_vip@163.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: Fix some coding style in ah4.c file
Message-ID: <20220919121652.55c37aee@kernel.org>
In-Reply-To: <20220908111251.70994-1-jingyuwang_vip@163.com>
References: <20220908111251.70994-1-jingyuwang_vip@163.com>
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

On Thu,  8 Sep 2022 19:12:51 +0800 Jingyu Wang wrote:
> Fix some checkpatch.pl complained about in ah4.c
> 
> Signed-off-by: Jingyu Wang <jingyuwang_vip@163.com>

In general we don't take pure "checkpatch cleanups" patches in
networking. Please avoid sending them.
