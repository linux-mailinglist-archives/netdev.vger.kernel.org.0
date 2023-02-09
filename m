Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07605690D47
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjBIPm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjBIPm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:42:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745B26465F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:42:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8897ACE251E
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 15:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA64C4339C;
        Thu,  9 Feb 2023 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675957329;
        bh=aRfTtR+4BWzF5irkn84Zl8NAvS8cwDdBEwleEC2p3Ek=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZVcaAXux2TDEbbXUVkeX488z9SLD2JaHYy2nKdtQoqffybGo7wk4I772d+CyUgLcL
         F1pU2jNeMiKeJLttKbeVeu6mJ5/7runp4VFHS1kPbjTBW1ul2dBueBRlVP3F3otx7H
         vWpx3Bdd7W9Z+2ZBugeM6xK0Kp4UFMhrpPLMTcoO07jrgbCg6tdl5K9XZon3Ch+0on
         X8biXmRVMT8nhp8Oo6IwIppvLPd2h4Xvuqfr0g8eELxLcQrhi+O6ztql0fPuBJKlye
         7tbCKxSLvmrE7ZI/L0m3m07i87QcH/DA65p5mOS6FeGnPQXGACOcEZTYkpAqyjJ7vL
         LMlZbwk3+tvWg==
Message-ID: <d704d69a-c83e-95f6-e2aa-4387812c1b60@kernel.org>
Date:   Thu, 9 Feb 2023 08:42:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net 3/3] selftests: fib_rule_tests: Test UDP and TCP
 connections with DSCP rules.
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
References: <cover.1675875519.git.gnault@redhat.com>
 <adc684f239cab31298038362045bd3771c3ee818.1675875519.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <adc684f239cab31298038362045bd3771c3ee818.1675875519.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 10:14 AM, Guillaume Nault wrote:
> Add the fib_rule6_send and fib_rule4_send tests to verify that DSCP
> values are properly taken into account when UDP or TCP sockets try to
> connect().
> 
> Tests are done with nettest, which needs a new option to specify
> the DS Field value of the socket being tested. This new option is
> named '-Q', in reference to the similar option used by ping.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  tools/testing/selftests/net/fib_rule_tests.sh | 128 +++++++++++++++++-
>  tools/testing/selftests/net/nettest.c         |  51 ++++++-
>  2 files changed, 177 insertions(+), 2 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

