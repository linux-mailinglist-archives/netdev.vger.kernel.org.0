Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B12515974
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 02:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381949AbiD3A72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 20:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240034AbiD3A71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 20:59:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560B99AE55;
        Fri, 29 Apr 2022 17:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D06C862469;
        Sat, 30 Apr 2022 00:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96EDC385A7;
        Sat, 30 Apr 2022 00:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651280166;
        bh=2cf68zIQiXdTtYQoS8iXsz3oRCuXtg/nC0XKIDrC0D8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rdYFj5THUPkBDKiezKc22eHe9dMzf8oxUWpafnP0VSLPhxqmUKTCO4hvGKOVqauuv
         w5coJZMMRtYleaPEhkeaBtPxBMWAD2SIInJXe/n8IkjSB4w+LEuKTQKCVk1xXWGHZ7
         0C+wXocJ41uu+2kA8NXgXjYW8U7F0vWtFJA61D04K6G1KtnPtCGYCOJEKEWuuoCqLk
         Pm/HST2hWMS9uLLgErzb4+Tf8RACXgdSfZV7aWs+QRrAc5DMnUxKbVyqRFyJr3biP9
         4wRk1E1Vs8rD3YXsZkZfnKp5XA8NzD3I5yG2KZy47FZzGAII8UlUvjkc3s0GHfM3R6
         C5tVmWvF6UpAA==
Date:   Fri, 29 Apr 2022 17:56:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        linux-kselftest@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, lkp-owner@lists.01.org
Subject: Re: [PATCH net 0/2] selftests: net: add missing tests to Makefile
Message-ID: <20220429175604.249bb2fb@kernel.org>
In-Reply-To: <20220428044511.227416-1-liuhangbin@gmail.com>
References: <20220428044511.227416-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 12:45:09 +0800 Hangbin Liu wrote:
> When generating the selftests to another folder, the fixed tests are
> missing as they are not in Makefile. The missing tests are generated
> by command:
> $ for f in $(ls *.sh); do grep -q $f Makefile || echo $f; done
> 
> I think there need a way to notify the developer when they created a new
> file in selftests folder. Maybe a bot like bluez.test.bot or kernel
> test robot could help do that?

Our netdev patch checks are here:

https://github.com/kuba-moo/nipa/tree/master/tests/patch

in case you're willing to code it up and post a PR.
