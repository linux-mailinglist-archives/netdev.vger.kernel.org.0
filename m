Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F325EFA04
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiI2QP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbiI2QPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:15:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6955A3C0;
        Thu, 29 Sep 2022 09:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28C216199B;
        Thu, 29 Sep 2022 16:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47336C433D6;
        Thu, 29 Sep 2022 16:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664468128;
        bh=Lr5Bwe8VTXw9ymJz//fWnPNzMpaU/u/0B7OKy4k+U+k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R5PC+fwbnTG2Eq1gny8hRMLmjfptqsftAqgAhV3XZHRh5qYHvSaaU8C1F3vs6mTaj
         9t0c9kcDKWpt5u8ASczsMlAHZIiL38rDJ+SJfvgmCf7cA3cHB/lIM5/I8Lfzb56UMp
         Q0UzaWO79XfqubO8wPM2Wu8B+OTlqxRawXvsZrpMKMlcsV8wArE7zO68lzP4jw1u13
         bOPf3GAoOZhjdlt3Sw/yioGiLgvkk3gYgwNpVVXvwYvIeOeNkOWlznbOm9DcHZ3Xg2
         YzOrUVjb60IZXLbuKqli/VM87aL2y62kaLY88cmAPb2Rr+7phCwjXUHlBoMeVOTvCt
         f1rwiXnEfoq1A==
Date:   Thu, 29 Sep 2022 09:15:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: prestera: acl: Add check for kmemdup
Message-ID: <20220929091527.370b39a4@kernel.org>
In-Reply-To: <20220928092024.6996-1-jiasheng@iscas.ac.cn>
References: <20220928092024.6996-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 17:20:24 +0800 Jiasheng Jiang wrote:
> As the kemdup could return NULL, it should be better to check the return
> value and return error if fails.
> Moreover, the return value of prestera_acl_ruleset_keymask_set() should
> be checked by cascade.
> 
> Fixes: 604ba230902d ("net: prestera: flower template support")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

You must CC the authors of patch you're fixing. 
get_maintainer will do that for you I don't understand why people can't
simply run that script :/ You CC linux-kernel for no apparent reason
yet you don't CC the guy who wrote the original patch.
If you could please explain what is going on maybe we can improve the
tooling or something.
