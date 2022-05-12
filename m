Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E13752524C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356354AbiELQQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346097AbiELQQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE95689B0;
        Thu, 12 May 2022 09:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65DF361F92;
        Thu, 12 May 2022 16:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B536C34116;
        Thu, 12 May 2022 16:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652372205;
        bh=cjSuSNyXsSE81z1/JdoGMtrQ40EUzm3B6PE0A/kBFTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZE3B9EZwR0gk6JdBvsKWcTKdPf0Poqklgp0OSeQAF5nrDjay6wir8HvSilsnmppPv
         oFWnNhL3p62LXLk4HFI5wAF3m3AkgVJJw/Cz7Ye+6jxDHjbpkZN3ELz2QUCt63DP6H
         YwFmyHUaWRGPd987VVytWWY3lOKxJmmtJNXa6f/mCgwSUl4Wi4ZRLpCxW0tEkTHdMp
         dN6fvRpRQ5HLt7Bxq02Yb4Ds6EQTCuLU16TPFkANykTCCpgWVy9Jn01dUriByfvyWh
         76g8auZbMvai+FCRDsitFMh6iFvD62OiyF/ygvLfjfozXbnsQTsjEO4KuCEp4NZfK6
         NSkdgdq/NZo1A==
Date:   Thu, 12 May 2022 09:16:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: tcp: reset 'drop_reason' to
 NOT_SPCIFIED in tcp_v{4,6}_rcv()
Message-ID: <20220512091643.29422149@kernel.org>
In-Reply-To: <20220512123313.218063-5-imagedong@tencent.com>
References: <20220512123313.218063-1-imagedong@tencent.com>
        <20220512123313.218063-5-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 20:33:13 +0800 menglong8.dong@gmail.com wrote:
> Fixes: 1330b6ef3313 ("skb: make drop reason booleanable")
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>

No new lines between tags
