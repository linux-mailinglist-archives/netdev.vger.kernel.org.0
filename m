Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7A251B6E5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 06:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242463AbiEEEGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 00:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiEEEGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 00:06:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8E34AE16
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 21:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CD84B82A86
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 04:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7CDC385A4;
        Thu,  5 May 2022 04:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651723383;
        bh=DBNJ0LFjfWP5ymSq6/1RP3mSZvz2i6c+q2+PPMsMW28=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VogP90FHsc2zjEn7SK41Y+djnUR22VSdTCU2d5ZoofgO1AHaYFUZrBmKZxSqB6Q56
         fX2kIyUWwiKBeOw8XWbz/NvetGbnDYABx6EKWRUwwnj8ANaiKqiabRMDavfARU3VGj
         yEhTmAYQf0ntUEjBPaFhqiim5Gd2yoidNfpQjxTzqgLpLa4He8aIau+toVZbxgC244
         4bDkE3SxfZlHw4mG4i+9LdFDrmxLZkAGqB+ILUKswlPmau3u5OVPhvp9onCtculxmu
         gXksaIGKlKQjrxwhY0dqPQipnejYIXHAOPHtkEILvW4bnaplFV8AN9/qS5uNTutzLx
         iHkUuGYq5zOpg==
Message-ID: <7e574380-a05d-5f52-c068-bf53a9c7147a@kernel.org>
Date:   Wed, 4 May 2022 21:03:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH net v3 2/2] selftests: add ping test with ping_group_range
 tuned
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
References: <1238b102-f491-a917-3708-0df344015a5b@kernel.org>
 <20220504090739.21821-1-nicolas.dichtel@6wind.com>
 <20220504090739.21821-3-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220504090739.21821-3-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 2:07 AM, Nicolas Dichtel wrote:
> The 'ping' utility is able to manage two kind of sockets (raw or icmp),
> depending on the sysctl ping_group_range. By default, ping_group_range is
> set to '1 0', which forces ping to use an ip raw socket.
> 
> Let's replay the ping tests by allowing 'ping' to use the ip icmp socket.
> After the previous patch, ipv4 tests results are the same with both kinds
> of socket. For ipv6, there are a lot a new failures (the previous patch

I'll take a look at those when I get a few minutes.

> fixes only two cases).
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


