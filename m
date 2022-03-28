Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BFF4EA20D
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiC1U4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiC1U4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:56:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E1568FB2;
        Mon, 28 Mar 2022 13:54:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56988612A0;
        Mon, 28 Mar 2022 20:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC8BC340ED;
        Mon, 28 Mar 2022 20:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648500872;
        bh=4/RYB9NtJw2jrAOOoPaFvzieYpWUoxCWQgw03Pg2Bh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dhyThEmLZ9m8pkkngN7WF8afIJXYtAcAjxJ7H1BfeKx+avcBkMHcNIX27isEai7Jk
         4hGCA2cTImEV4BfvuarXdHskZZgHTfb38Jtjw/9gNydILjKIRPIY4ZqcJ+IgtY9Jlj
         Ww6/m3yOmMZnvOSZVZxErNgGf0Ou8OU6Jv36tLoEAbbIz4Uf+/TEDSuYhbeYkO0Q+s
         0Sm4n0ZM+G+gBtDoYfKDoy5mtHhH9pngG2sg5+U6QdgXQoAb+UiYF8WMXHa2cdJk/R
         apCqpNLgIDza3aTB9s/DH4KaNWEnBx0Fwa5b5LIVh+T5ciUwWq3cwPQg6+p7OW3Uja
         Uo9anRvxg51uA==
Date:   Mon, 28 Mar 2022 13:54:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH] selftests: net: Add tls config dependency for tls
 selftests
Message-ID: <20220328135430.2ad39326@kernel.org>
In-Reply-To: <20220328134650.72265-1-naresh.kamboju@linaro.org>
References: <20220328134650.72265-1-naresh.kamboju@linaro.org>
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

On Mon, 28 Mar 2022 19:16:50 +0530 Naresh Kamboju wrote:
> selftest net tls test cases need TLS=m without this the test hangs.

The test is supposed to fall back / skip cleanly when TLS is not built.
That's useful to test compatibility with TCP. 

It'd be great if you could reply to questions I asked you on your
report instead of sending out incorrect patches.

> Enabling config TLS solves this problem and runs to complete.
>   - CONFIG_TLS=m
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
